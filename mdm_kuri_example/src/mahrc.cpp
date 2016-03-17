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
#include <stdio.h>
#include <float.h>
#include <mdm_library/controller_timed_pomdp.h>
#include <string>

//==================== publishCurrentBelief ==============================================
void publishCurrentBelief (boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp,boost::shared_ptr<JointBeliefInterface> belief)
{
    double maxBelief = -1, beliefValue = 0;
    size_t maxIndex  = 0;
    std::cout<<"Current Belief:";
    for ( size_t i = 0; i < belief->Size(); i++ )
    {
        beliefValue = belief->Get ( i );
        if( beliefValue > maxBelief)
        {
            maxBelief = beliefValue;
            maxIndex  = i;
        }
        //std::cout<<"\nState:"<<decpomdp->GetState(i)->GetName()<<" Belief:"<< beliefValue;//this line will print all beliefs now it is commented becasue no space for big map
    }
    std::cout<<"\nOur highest belief is in state:"<< decpomdp->GetState(maxIndex)->GetName()<<" probability:"<<belief->Get (maxIndex );
    std::cout<<"\n";
}

//=================== actionNameToIndex ==================================================
int actionNameToIndex(boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp,std::string actionName)
{
    for ( size_t a = 0; a < decpomdp->GetNrJointActions(); a++ )
    {
        std::size_t found = decpomdp->GetJointAction(a)->SoftPrint().find(actionName);
        if (found!=std::string::npos)
        {
            std::cout<<"\nInital Action:"<<actionName<<" has index:"<<a;
            return a;
        }
    }
}

//=================== stateNameToIndex ===================================================
int stateNameToIndex(boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp, std::string stateName)
{
    for ( uint32_t s = 0; s < decpomdp->GetNrStates(); s++ )
    {
        std::size_t found = decpomdp->GetState(s)->GetName().find(stateName);
        if (found!=std::string::npos)
        {
            std::cout<<"\nMain State:"<<stateName<<" has index:"<<s;
            return s;
        }
    }
}

//=================== observationIndicesFromStrings ======================================
std::vector<int> observationIndicesFromStrings(boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp, std::vector<std::string> observations)
{
    std::vector<int> obs;
    obs.clear();
    //first observation is never used, becasuse we know the initial belief
    obs.push_back(-1);
    for(int i=0;i<observations.size();i++)
    {
        for(int j=0; j < decpomdp->GetNrJointObservations();j++)
        {
            std::size_t found = decpomdp->GetJointObservation(j)->SoftPrint().find(observations[i]);
            if (found!=std::string::npos)
            {
                std::cout<<"\nObservation:"<<i<<" is:"<<decpomdp->GetJointObservation(j)->SoftPrint()<<" and has this index:"<<j;
                obs.push_back(j);
            }
        }
    }
    return obs;
}

//=================== publishExpectedReward ==============================================
void publishExpectedReward ( uint32_t a, boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp_,boost::shared_ptr<JointBeliefInterface> belief_)
{
    double reward;
    std::vector<double> r_vec;
    for ( uint32_t s = 0; s < decpomdp_->GetNrStates(); s++ )
    {
        r_vec.push_back (decpomdp_->GetReward ( s, a )) ; //GetReward(Index sI, Index jaI)
        //std::cout<<"reward:"<<decpomdp_->GetReward ( s, a )<<"\n";
    }
    reward = belief_->InnerProduct ( r_vec );
    std::cout<<"Expected Reward from this action is:"<<reward<<"\n";
}

//=================== main ===============================================================
int main ( int argc, char** argv )
{    
    ros::init(argc, argv, "mdm_kuri_example");
    ros::NodeHandle nh;

    std::string pomdp_model,policy_file;

    if (nh.getParam("/pomdp_model", pomdp_model))
    {
        std::cout<<"\nModel file is:"<<pomdp_model;
    }
    else
    {
        std::cout<<"\nModel file name must be provided on the rosparameter server";
        return 1;
    }

    if (nh.getParam("/policy_file", policy_file))
    {
        std::cout<<"\nPolicy file is:"<<policy_file;
    }
    else
    {
        std::cout<<"\nPolicy file name must be provided on the rosparameter server";
        return 1;
    }

    int decision_horizon;
    std::string initial_action, initial_state;
    double initial_state_belief;

    nh.param<std::string>("/initial_action", initial_action, "0");
    nh.param<std::string>("/initial_state", initial_state, "0");
    nh.param<int>("/decision_horizon", decision_horizon, 50);
    nh.param<double>("/initial_state_belief", initial_state_belief, 1.0);
    std::vector<std::string> observationStrings;
    nh.getParam("/observations", observationStrings);

    /** Pointer to the internal belief state.*/
    boost::shared_ptr<JointBeliefInterface> belief;
    /** Pointer to this problem's Q-Value function.*/
    boost::shared_ptr<QFunctionJointBeliefInterface> Q_;
    /** Previous action. Needed for belief updates.*/
    uint32_t prev_action_;
    /** Initial State Distribution.*/
    boost::shared_ptr<FSDist_COF> ISD;

    /** The decision step number. */
    uint32_t decision_episode = 0;
    /** The decision horizon. While, typically, infinite-horizon policies are used for robotic agents,
     * MDM also contemplates the possibility of using finite-horizon controllers.
     */
    boost::shared_ptr<DecPOMDPDiscreteInterface> decpomdp;
    boost::shared_ptr<DecPOMDPDiscrete> d ( new DecPOMDPDiscrete ( "", "", pomdp_model ) );
    MADPParser parser ( d.get() );
    decpomdp = d;

    std::vector<int> observations = observationIndicesFromStrings(decpomdp,observationStrings);
    std::cout<<"\nNumber of Observations:"<<observations.size();

    prev_action_ = actionNameToIndex(decpomdp,initial_action);

    try
    {
        boost::shared_ptr<PlanningUnitDecPOMDPDiscrete> np ( new NullPlanner ( decpomdp.get() ) );
        Q_ = boost::shared_ptr<QAV<PerseusPOMDPPlanner> >  ( new QAV<PerseusPOMDPPlanner> ( np, policy_file ) );
        bool isSparse = false;
        if ( isSparse )
            belief = boost::shared_ptr<JointBeliefSparse> ( new JointBeliefSparse ( decpomdp->GetNrStates() ) );
        else
            belief = boost::shared_ptr<JointBelief> ( new JointBelief ( decpomdp->GetNrStates() ) );

        std::vector<double> init_belief;
        int mainStateIndex = stateNameToIndex(decpomdp, initial_state);
        double beliefInMainState = initial_state_belief;
        double beliefInMinorStates = (1.0 - beliefInMainState)/double(decpomdp->GetNrStates()-1);
        for(int i=0;i<decpomdp->GetNrStates();i++)
        {
            if(i==mainStateIndex)
            {
                init_belief.push_back(beliefInMainState);
            }
            else
                init_belief.push_back(beliefInMinorStates);
        }

        belief = boost::shared_ptr<JointBelief>(new JointBelief ( init_belief ) );
        if ( belief == 0 )
        {
            std::cout<< ( "\nControllerTimedPOMDP:: Attempted to start controller, but the belief state hasn't been initialized." );
            return 0;
        }
        /*
        if ( ISD_ != 0 )
        {
            belief_->Set ( ISD_->ToVectorOfDoubles() );
        }
        else
        {
            belief_->Set ( * ( decpomdp_->GetISD() ) );
        }
        */

        decision_episode = 0;
        // Act in a loop
        //observations:
        //vic_dan vic_noDan noVic_dan noVic_noDan
        //vic_dan vic_noDan noVic_dan noVic_noDan
        // i removed the vic_dan so the index will change now
        // S -> O -> A -> S -> O -> A ...

        double eta = 0;

        for(int i=0;i<observations.size();i++)
        {
            std::cout<<"\nIterating through a new S->O->A Episode";
            if( decision_episode > 0 )
                eta = belief->Update ( * ( decpomdp ), prev_action_, observations[i] );
            else
                eta = beliefInMainState;
            publishCurrentBelief(decpomdp,belief);

            uint32_t action = INT_MAX;
            double q, v = -DBL_MAX;
            for ( size_t a = 0; a < decpomdp->GetNrJointActions(); a++ )
            {
                q = Q_->GetQ ( *belief, a );
                if ( q > v )
                {
                    v = q;
                    action = a;
                }
            }

            if ( action == INT_MAX )
            {
                std::cout<< "\nControllerPOMDP:: Could not get joint action for observation " << observations[i] << " at belief state: " << belief->SoftPrint() ;
                return 0;
            }
            prev_action_ = action;
            publishExpectedReward( action,decpomdp,belief);

            if( decision_episode == 0)
            {
                std::cout<< "\nEpisode " << decision_episode << " - Action: " << action << " (" << decpomdp->GetJointAction ( action )->SoftPrint()<< ")"<<std::endl;
            }
            else
            {
                std::cout<< "\nEpisode " << decision_episode << " - Action: "
                         << action << " (" << decpomdp->GetJointAction ( action )->SoftPrint()
                         << ") - Observation: " << observations[i] << " (" << decpomdp->GetJointObservation ( observations[i] )->SoftPrint()<<")"<<std::endl;
            }

            if ( decision_episode > 0 && eta <= Globals::PROB_PRECISION )
            {
                std::cout  << "\nControllerPOMDP:: Impossible action-observation trace! You should check your model for the probabilities of the preceding transitions and observations!";
            }

            if ( ( decision_episode + 1 ) >= decision_horizon )
            {
                decision_episode = 0;
            }
            else
                ++decision_episode;
        }
    }
    catch ( E& e )
    {
        e.Print();
        return 0;
    }
    return 0;
}
