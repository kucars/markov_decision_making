#include <ros/ros.h>
#include <mdm_library/controller_event_decpomdp.h>

using namespace std;
using namespace ros;
using namespace mdm_library;

int main ( int argc, char** argv )
{
    init ( argc, argv, "control_layer" );

    if ( argc < 2 )
    {
        ROS_ERROR ( "Usage: rosrun mdm_kuri_example control_layer <path to policy file>" );
        abort();
    }

    string policy_path = argv[1];
    string value_file;
    ControllerEventDecPOMDP cl ( policy_path ,value_file);

    spin();

    return 0;
}
