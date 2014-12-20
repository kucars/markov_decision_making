#include <ros/ros.h>
#include <mdm_library/controller_event_mdp.h>
#include <madp/maxplus.h>
//#include <mdm_library/control_layer_base.h>

using namespace std;
using namespace ros;
using namespace mdm_library;

int main ( int argc, char** argv )
{
    init ( argc, argv, "control_layer" );

    if ( argc < 2 )
    {
        ROS_ERROR ( "Usage: rosrun mdm_example demo_control_layer <path to policy file>" );
        abort();
    }

    string policy_path = argv[1];

    ControllerEventMDP cl ( policy_path );
    //ControlLayerBase lp;
    spin();

    return 0;
}
