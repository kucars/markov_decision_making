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

int main ( int argc, char** argv )
{
    std::string const& problem_file("dectiger.dpomdp");
    std::string const& value_function_file = "dectiger_value";
    //ControllerPOMDP ( problem_file, initial_status ),
    Index observations = 0;
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
    boost::shared_ptr<DecPOMDPDiscrete> d ( new DecPOMDPDiscrete ( "", "", problem_file ) );
    MADPParser parser ( d.get() );
    //publishStateMetadata ( d );
    //publishInitialStateDistribution ( d );
    decpomdp_ = d;
    prev_action_ =  0;
    try
    {
        boost::shared_ptr<PlanningUnitDecPOMDPDiscrete> np ( new NullPlanner ( decpomdp_.get() ) );
        Q_ = boost::shared_ptr<QAV<PerseusPOMDPPlanner> >
                ( new QAV<PerseusPOMDPPlanner> ( np,
                                                 value_function_file ) );
        bool isSparse = false;
        if ( isSparse )
            belief_ = boost::shared_ptr<JointBeliefSparse>
                    ( new JointBeliefSparse ( decpomdp_->GetNrStates() ) );
        else
            belief_ = boost::shared_ptr<JointBelief>
                    ( new JointBelief ( decpomdp_->GetNrStates() ) );

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
        decision_episode_ = 0;


        // Act in a loop
        observations = 1;
        int observations[10]= {1,0,1,0,0,1,2,3,3,3};
        for(int i=0;i<10;i++)
        {
            double eta = 0; //eta is the probability of the current action-observation trace. It is a by-product of the update procedure.
            if ( decision_episode_ > 0 )
            {
                eta = belief_->Update ( * ( decpomdp_ ), prev_action_, observations[i] );
            }

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

            //std::cout<<"the action is :"<< action << endl;
            //publishExpectedReward ( action );
            //publishCurrentBelief ();
            std::cout<< "\nControllerPOMDP:: Episode " << decision_episode_ << " - Action: "
                     << action << " (" << decpomdp_->GetJointAction ( action )->SoftPrint()
                     << ") - Observation: " << observations[i] << " (" << decpomdp_->GetJointObservation ( observations[i] )->SoftPrint()
                     << ") - P(b|a,o): " << eta;

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
