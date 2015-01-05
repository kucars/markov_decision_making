#include <ros/ros.h>
#include <mdm_library/controller_event_decpomdp.h>
#include <madp/NullPlanner.h>
#include <madp/MADPComponentFactoredStates.h>
#include <madp/QAV.h>
#include <madp/PerseusConstrainedPOMDPPlanner.h>
#include <madp/JointBeliefEventDriven.h>
#include <madp/NullPlanner.h>
#include <mdm_library/controller_pomdp.h>
#include <mdm_library/ActionSymbol.h>
#include <mdm_library/common_defs.h>
#include <mdm_library/state_layer.h>
#include <mdm_library/WorldSymbol.h>
#include <std_msgs/Float32.h>

using namespace std;
using namespace ros;
using namespace mdm_library;

void currentBeliefCallback ( const BeliefStateInfo& msg )
{

}

void actionCallback ( const ActionSymbol& msg )
{

}

void expRewardCallback ( const std_msgs::Float32& msg )
{

}
int main ( int argc, char** argv )
{
    init ( argc, argv, "control_layer" );

    if ( argc < 2 )
    {
        ROS_ERROR ( "Usage: rosrun mdm_kuri_example control_layer <path to policy file>" );
        abort();
    }

    string problemFile = argv[1];
    string value_file;
    ControllerEventDecPOMDP cl ( problemFile ,value_file);
/*
    ros::NodeHandle nodeHandler;
    ros::Publisher observationPub;
    ros::Publisher extBeliefEstimatePub;
    // initial_state_distribution
    ros::Publisher isdSubPub;


    ros::Subscriber currentBeliefSub;
    ros::Subscriber actionSub;
    ros::Subscriber expRewardSub;

    observationPub       = nodeHandler.advertise<WorldSymbol>          ( "observation", 1, false );
    extBeliefEstimatePub = nodeHandler.advertise<BeliefStateInfo>      ( "ext_belief_estimate", 1, false );
    isdSubPub            = nodeHandler.advertise<FactoredDistribution> ( "initial_state_distribution", 1, false );

    currentBeliefSub     = nodeHandler.subscribe ( "current_belief", 10, &currentBeliefCallback );
    actionSub            = nodeHandler.subscribe ( "action", 10, &actionCallback);
    expRewardSub         = nodeHandler.subscribe ( "reward", 10, &expRewardCallback );
*/
    spin();
    return 0;
}
