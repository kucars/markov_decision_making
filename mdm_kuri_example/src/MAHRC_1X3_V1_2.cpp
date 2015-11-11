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
    std::string const& problem_file("MAHRC_1x3_v1_9.dpomdp");
    std::string const& value_function_file = "value_fun_file_MAHRC_1x3_v1_9";
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
    // 10 is JA10_stop_stop: it's just an initial condition for P(O|a,S')
    prev_action_ =  6;
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

	std::cout<<"Number of states:"<<decpomdp_->GetNrStates()<<"\n";
    std::vector<double> init_belief;
	// Index 32 = c_c_a_b
	int mainStateIndex=32;
	double beliefInMainState = 0.8;
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
	
    //-------This will print the intial belief and the initial action to check where we are starting from -----------------------
        //std::cout<<"Initial Belief is:"<<belief_->SoftPrint()<<"\n";
        std::cout<<"Inital Action is:"<<decpomdp_->GetJointAction ( prev_action_ )->SoftPrint()<<"\n";

        decision_episode_ = 0;


        // Act in a loop
	//observations:
	//vic_dan vic_noDan noVic_dan noVic_noDan 
	//vic_dan vic_noDan noVic_dan noVic_noDan 
	// i removed the vic_dan so the index will change now 

        observations = 1;
        int observations[2]= {8,5};
        for(int i=0;i<2;i++)
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
            float maxb=0.0;
            int ind_b;
            for(int v=0;v<belief_->Size();v++)
            {
                if (belief_->Get(v)>maxb)
                {
                    maxb=belief_->Get(v);
                    ind_b=v;
                }
            }
            std::cout<< "\nControllerPOMDP:: Episode " << decision_episode_ << " - Action: "
                     << action << " (" << decpomdp_->GetJointAction ( action )->SoftPrint()
                     << ") - Observation: " << observations[i] << " (" << decpomdp_->GetJointObservation ( observations[i] )->SoftPrint()
                     << ") - P(b|a,o): " << eta << " maxBelief: "<< maxb<<" index is: "<<ind_b<<std::endl;


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
