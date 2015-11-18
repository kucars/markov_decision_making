#include<madp/TimedAlgorithm.h>
#include <madp/QAV.h>
#include <madp/PerseusPOMDPPlanner.h>
#include <madp/JointBelief.h>
#include <madp/JointBeliefSparse.h>
#include <madp/NullPlanner.h>
#include <madp/PlanningUnitDecPOMDPDiscrete.h>
#include <madp/FactoredDecPOMDPDiscrete.h>
#include <madp/DecPOMDPDiscrete.h>
#include <madp/MADPParser.h>


//#include<madp/ParserProbModelXML.h>
//#include <config.h>

#include <stdio.h>
#include <float.h>

#include <mdm_library/controller_timed_pomdp.h>

//#include <madp/MADPComponentFactoredStates.h>

//#include <mdm_library/controller_pomdp.h>
//#include <mdm_library/ActionSymbol.h>
//#include <std_msgs/Float32.h>

#include <string>

void publishCurrentBelief (boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp_,boost::shared_ptr<JointBeliefInterface> belief_)
{
    double maxBelief = -1, belief = 0;
    size_t maxIndex  = 0;
    std::cout<<"Current Belief:";
    for ( size_t i = 0; i < belief_->Size(); i++ )
    {
        belief = belief_->Get ( i );
        if( belief > maxBelief)
        {
            maxBelief = belief;
            maxIndex  = i;
        }
        std::cout<<"\nState:"<<decpomdp_->GetState(i)->GetName()<<" Belief:"<< belief;
    }
    std::cout<<"\nOur highest belief is in state:"<< decpomdp_->GetState(maxIndex)->GetName()<<" probability:"<<belief_->Get (maxIndex );
    std::cout<<"\n";
}

void publishExpectedReward ( uint32_t a, boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp_,boost::shared_ptr<JointBeliefInterface> belief_)
{
    double reward;
    std::vector<double> r_vec;
    for ( uint32_t s = 0; s < decpomdp_->GetNrStates(); s++ )
    {
        r_vec.push_back (decpomdp_->GetReward ( s, a )) ;
    }
    reward = belief_->InnerProduct ( r_vec );
    std::cout<<"Expected Reward from this action is:"<<reward<<"\n";
}

int main ( int argc, char** argv )
{
    if (argc != 3)
    {
        std::cout<<"\nExpecting model name and value function file as input: mahrc <modelname.dpomdp> <value_fun_file>\n";
        return 1;
    }
    std::string modelName    = argv[1];
    std::string valueFunFile = argv[2];
    
    /** Pointer to the internal belief state.*/
    boost::shared_ptr<JointBeliefInterface> belief_;
    /** Pointer to this problem's Q-Value function.*/
    boost::shared_ptr<QFunctionJointBeliefInterface> Q_;
    /** Previous action. Needed for belief updates.*/
    uint32_t prev_action_;
    /** Initial State Distribution.*/
    boost::shared_ptr<FSDist_COF> ISD_;

    /** The decision step number. */
    uint32_t decision_episode_ = 0;
    /** The decision horizon. While, typically, infinite-horizon policies are used for robotic agents,
     * MDM also contemplates the possibility of using finite-horizon controllers.
     */
    uint32_t decision_horizon_ = 50;
    boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp_;
    boost::shared_ptr<DecPOMDPDiscrete> d ( new DecPOMDPDiscrete ( "", "", modelName ) );
    MADPParser parser ( d.get() );

    decpomdp_ = d;
    // 10 is JA10_stop_stop: it's just an initial condition for P(O|a,S')
    prev_action_ =  10;
    try
    {
        boost::shared_ptr<PlanningUnitDecPOMDPDiscrete> np ( new NullPlanner ( decpomdp_.get() ) );
        Q_ = boost::shared_ptr<QAV<PerseusPOMDPPlanner> >  ( new QAV<PerseusPOMDPPlanner> ( np, valueFunFile ) );
        bool isSparse = false;
        if ( isSparse )
            belief_ = boost::shared_ptr<JointBeliefSparse> ( new JointBeliefSparse ( decpomdp_->GetNrStates() ) );
        else
            belief_ = boost::shared_ptr<JointBelief> ( new JointBelief ( decpomdp_->GetNrStates() ) );

        std::vector<double> init_belief;
        // Index 32 = c_c_a_b
        int mainStateIndex = 8;
        double beliefInMainState = 1.0;
        double beliefInMinorStates = (1.0 - beliefInMainState)/double(decpomdp_->GetNrStates()-1);

        for(int i=0;i<decpomdp_->GetNrStates();i++)
        {
            if(i==mainStateIndex)
            {
                init_belief.push_back(beliefInMainState);
            }
            else
                init_belief.push_back(beliefInMinorStates);
        }

        belief_ = boost::shared_ptr<JointBelief>(new JointBelief ( init_belief ) );
        /*
        if ( belief_ == 0 )
        {
            std::cout<< ( "\nControllerTimedPOMDP:: Attempted to start controller, but the belief state hasn't been initialized." );
            return 0;
        }
        if ( ISD_ != 0 )
        {
            belief_->Set ( ISD_->ToVectorOfDoubles() );
        }
        else
        {
            belief_->Set ( * ( decpomdp_->GetISD() ) );
        }
        */

        decision_episode_ = 0;

        for(int i=0; i < decpomdp_->GetNrJointObservations();i++)
        {
            std::cout<<"\nObservation:"<<decpomdp_->GetJointObservation(i)->SoftPrint()<<" has this index:"<<i;
        }
        // Act in a loop
        //observations:
        //vic_dan vic_noDan noVic_dan noVic_noDan
        //vic_dan vic_noDan noVic_dan noVic_noDan
        // i removed the vic_dan so the index will change now
        // S -> O -> A -> S -> O -> A ...

        int observations[5]= {-1,2,5,6,8};
        double eta = 0;

        for(int i=0;i<sizeof(observations)/sizeof(int);i++)
        {
            std::cout<<"\nIterating through a new S->O->A Episode";
            if( decision_episode_ > 0 )
                eta = belief_->Update ( * ( decpomdp_ ), prev_action_, observations[i] );
            else
                eta = beliefInMainState;
            publishCurrentBelief(decpomdp_,belief_);

            uint32_t action = INT_MAX;
            double q, v = -DBL_MAX;
            for ( size_t a = 0; a < decpomdp_->GetNrJointActions(); a++ )
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
                std::cout<< "\nControllerPOMDP:: Could not get joint action for observation " << observations[i] << " at belief state: " << belief_->SoftPrint() ;
                return 0;
            }
            prev_action_ = action;
            publishExpectedReward( action,decpomdp_,belief_);

            if( decision_episode_ == 0)
            {
                std::cout<< "\nEpisode " << decision_episode_ << " - Action: " << action << " (" << decpomdp_->GetJointAction ( action )->SoftPrint()<< ")"<<std::endl;
            }
            else
            {
                std::cout<< "\nEpisode " << decision_episode_ << " - Action: "
                         << action << " (" << decpomdp_->GetJointAction ( action )->SoftPrint()
                         << ") - Observation: " << observations[i] << " (" << decpomdp_->GetJointObservation ( observations[i] )->SoftPrint()<<")"<<std::endl;
            }

            if ( decision_episode_ > 0 && eta <= Globals::PROB_PRECISION )
            {
                std::cout  << "\nControllerPOMDP:: Impossible action-observation trace! You should check your model for the probabilities of the preceding transitions and observations!";
            }

            if ( ( decision_episode_ + 1 ) >= decision_horizon_ )
            {
                decision_episode_ = 0;
            }
            else
                ++decision_episode_;
        }
    }
    catch ( E& e )
    {
        e.Print();
        return 0;
    }
    return 0;
}
