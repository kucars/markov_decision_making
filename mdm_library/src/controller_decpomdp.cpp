/**\file controller_pomdp.cpp
 *
 * Author:
 * Joao Messias <jmessias@isr.ist.utl.pt>
 * Tarek Taha   <tarek.taha@kustar.ac.ae>
 * Hend Al-Tair <hend.altair@kustar.ac.ae>
 *
 * Markov Decision Making is a ROS library for robot decision-making based on MDPs.
 * Copyright (C) 2014 Instituto Superior Tecnico, Instituto de Sistemas e Robotica
 *
 * This file is part of Markov Decision Making.
 *
 * Markov Decision Making is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Markov Decision Making is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <float.h>

#include <madp/NullPlanner.h>

#include <madp/MADPComponentFactoredStates.h>

#include <mdm_library/controller_decpomdp.h>
#include <mdm_library/ActionSymbol.h>
#include <std_msgs/Float32.h>



using namespace std;
using namespace mdm_library;


//===============constructor======================
ControllerDecPOMDP::
ControllerDecPOMDP ( const string& problem_file,
                  const CONTROLLER_STATUS initial_status ) :
    ControlLayerBase ( initial_status ),
    loader_ ( new DecPOMDPLoader ( problem_file ) ),
    belief_ (),
    prev_action_ ( 0 ),
    observation_sub_ ( nh_.subscribe ( "observation", 10, &ControllerDecPOMDP::observationCallback, this ) ),
    ext_belief_estimate_sub_ ( nh_.subscribe ( "ext_belief_estimate", 10, &ControllerDecPOMDP::extBeliefCallback, this ) ),
    isd_sub_ ( nh_.subscribe ( "initial_state_distribution", 10, &ControllerDecPOMDP::isdCallback, this ) ),
    current_belief_pub_ ( nh_.advertise<BeliefStateInfo> ( "current_belief", 1, false ) ),
    action_pub_ ( nh_.advertise<ActionSymbol> ( "action", 0, true ) ),
    exp_reward_pub_ ( nh_.advertise<std_msgs::Float32> ( "reward", 0, true ) ),
   
    //---------fake--------
    fake_action_pub (nh_.advertise<std_msgs::String>("f_action", 1)),
    fake_observation_sub (nh_.subscribe("f_observation",10, &ControllerDecPOMDP::fobservationCallback, this))//prints out what is recieved
    //---------------------
{}
//=====================================

// function prints observation subscribed to.. NOTE: there are two observations (1 and 2) 
void 
ControllerDecPOMDP::
fobservationCallback(const std_msgs::String::ConstPtr& msg)
{
  ROS_INFO("I heard observation: [%s]", msg->data.c_str());
}

//=====================================

// function load problem file and policy file (policy file is GMAA-ICE) make sure it exists in MADP. 
// function publish action1 and action2 picked in a message (to be read by obsevration layer) . 

//=====================================
void
ControllerDecPOMDP::
act ( const uint32_t observation )
{
    if ( getStatus() == STOPPED )
    {
        return;
    }

    double eta = 0; //eta is the probability of the current action-observation trace. It is a by-product of the update procedure.

    if ( getDecisionEpisode() > 0 )
    {
        eta = belief_->Update ( * ( loader_->GetDecPOMDP() ), prev_action_, observation );
    }

    uint32_t action = INT_MAX;
    double q, v = -DBL_MAX;
    for ( size_t a = 0; a < getNumberOfActions(); a++ )
    {
        q = Q_->GetQ ( *belief_, a );
        if ( q > v )
        {
            v = q;
            action = a;
        }
    }

    if ( action == INT_MAX )
    {
        ROS_ERROR_STREAM ( "ControllerDecPOMDP:: Could not get joint action for observation " << observation
                           << " at belief state: " << endl << belief_->SoftPrint() );
        abort();
    }
    prev_action_ = action;
    publishAction ( action );
    publishExpectedReward ( action );
    publishCurrentBelief ();
    ROS_INFO_STREAM ( "ControllerDecPOMDP:: Episode " << getDecisionEpisode() << " - Action: "
                      << action << " (" << loader_->GetDecPOMDP()->GetJointAction ( action )->SoftPrint()
                      << ") - Observation: " << observation << " (" << loader_->GetDecPOMDP()->GetJointObservation ( observation )->SoftPrint()
                      << ") - P(b|a,o): " << eta );

    if ( getDecisionEpisode() > 0 && eta <= Globals::PROB_PRECISION )
    {
        ROS_WARN ( "ControllerDecPOMDP:: Impossible action-observation trace! You should check your model for the probabilities of the preceding transitions and observations!" );
    }

    incrementDecisionEpisode();
}



void
ControllerDecPOMDP::
publishAction ( uint32_t a )
{
    ActionSymbol aInfo;
    aInfo.action_symbol = a;
    aInfo.decision_episode = getDecisionEpisode();
    action_pub_.publish ( aInfo );
}



void
ControllerDecPOMDP::
publishExpectedReward ( uint32_t a )
{
    std_msgs::Float32 reward;
    vector<double> r_vec;
    for ( uint32_t s = 0; s < getNumberOfStates(); s++ )
    {
        r_vec.push_back ( loader_->GetDecPOMDP()->GetReward ( s, a ) );
    }

    reward.data = belief_->InnerProduct ( r_vec );
    exp_reward_pub_.publish ( reward );
}



void
ControllerDecPOMDP::
publishCurrentBelief ()
{
    BeliefStateInfo b;
    for ( size_t i = 0; i < belief_->Size(); i++ )
    {
        b.belief.push_back ( belief_->Get ( i ) );
    }
    current_belief_pub_.publish ( b );
}



size_t
ControllerDecPOMDP::
getNumberOfActions ()
{
    return loader_->GetDecPOMDP()->GetNrJointActions();
}



size_t
ControllerDecPOMDP::
getNumberOfStates ()
{
    return loader_->GetDecPOMDP()->GetNrStates();
}



size_t
ControllerDecPOMDP::
getNumberOfObservations ()
{
    return loader_->GetDecPOMDP()->GetNrJointObservations();
}



void
ControllerDecPOMDP::
extBeliefCallback ( const BeliefStateInfoConstPtr& msg )
{
    belief_->Set ( msg->belief );
    if ( ! ( belief_->SanityCheck() ) )
    {
        normalizeBelief ( belief_ );
    }
}



void
ControllerDecPOMDP::
isdCallback ( const FactoredDistributionConstPtr& msg )
{
    if ( ISD_ == 0 )
    {
        MADPComponentFactoredStates state_factor_description;
        for ( size_t k = 0; k < msg->factors.size(); k++ )
        {
            state_factor_description.AddStateFactor();
            for ( size_t x = 0; x < msg->factors[k].belief.size(); x++ )
            {
                state_factor_description.AddStateFactorValue ( k );
            }
        }
        state_factor_description.SetInitialized ( true );
        if ( state_factor_description.GetNrStates() != getNumberOfStates() )
        {
            ROS_WARN_STREAM ( "ControllerDecPOMDP:: Received an initial state distribution with an incorrect number of states ("
                              << state_factor_description.GetNrStates() << ", should be " << getNumberOfStates() << ") . Ignoring." );
            return;
        }
        ISD_ = boost::shared_ptr<FSDist_COF> ( new FSDist_COF ( state_factor_description ) );
    }

    for ( size_t k = 0; k < msg->factors.size(); k++ )
    {
        for ( size_t x = 0; x < msg->factors[k].belief.size(); x++ )
        {
            double p = msg->factors[k].belief[x];
            ISD_->SetProbability ( k, x, p );
        }
    }

    ISD_->SanityCheck(); ///handles normalization internally.
}



void
ControllerDecPOMDP::
normalizeBelief ( boost::shared_ptr<JointBeliefInterface> b )
{
    vector<double> one_vec ( getNumberOfStates(), 1.0 );
    float sum = b->InnerProduct ( one_vec );
    if ( sum > 0 )
    {
        for ( size_t s = 0; s < getNumberOfStates(); s++ )
        {
            float p = b->Get ( s ) / sum; ///normalizing belief to 1
            b->Set ( s, p );
        }
    }
    else
    {
        ROS_WARN ( "ControllerDecPOMDP:: Failed to normalize. Setting belief to default ISD." );
        b->Set ( * ( loader_->GetDecPOMDP()->GetISD() ) );
    }
}
