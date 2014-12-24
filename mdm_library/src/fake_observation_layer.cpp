
/**\file fake_observation_layer.cpp
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


#include <mdm_library/f_observation_layer.h>
#include "ros/ros.h"
#include "std_msgs/String.h"

#include <sstream>

using namespace std;
using namespace mdm_library;

//===========constructor=============== 
FakeObservationLayer::
FakeObservationLayer() :
	fake_action_sub (nh_.subscribe("f_action",10, &FakeObservationLayer::factionCallback,this)),// only prints out what is recieved
	fake_observation_pub (nh_.advertise<std_msgs::String>("f_observation", 1)) // f_observation is name of topic
{}

//=====================================

//prints out the actions subscribed to it from controller  NOTE: there are two actions (1 and 2) 
void 
FakeObservationLayer::
factionCallback(const std_msgs::String::ConstPtr& msg)
{
  ROS_INFO("I heard action: [%s]", msg->data.c_str());
}

//=====================================

  
//Function: pick flames noFlames observations based on certain actions and put in msg
// 1. check the actions (subscribed to it) {if action1 == && action2} for two agents 
// 2. pick obsevration {observation1 = & observation 2 = } for two agents  
// 3. put in msg : is it same message for two agents? 
// 4. publish msg  
 
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    std_msgs::String msg;

    std::stringstream ss;
    // define variable observation1 and observation2 
    // define variable action1 and action2 ( how to get these from the msg? is it 2 messages or from one?)

    ss << "observation is: " << observation;
    msg.data = ss.str();

    ROS_INFO("%s", msg.data.c_str()); //prints message of observation to check if it matches or not (for testing purpose) 
     
    f_observation_pub.publish(msg);

    ros::spinOnce();

 //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

