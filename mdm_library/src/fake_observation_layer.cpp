
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

//===========constructor========================
//the names of the topics for each action and each observation
//
FakeObservationLayer::
FakeObservationLayer() :
    fake_action1_sub (nh_.subscribe("f_action1",10, &FakeObservationLayer::factionCallback,this)),
    fake_action2_sub (nh_.subscribe("f_action2",10, &FakeObservationLayer::factionCallback,this)),
    fake_observation1_pub (nh_.advertise<std_msgs::String>("f_observation1", 1)),
    fake_observation2_pub (nh_.advertise<std_msgs::String>("f_observation2", 1))
{}

//=============factionCallback===================

//Purpose: prints out the actions subscribed to it from controller  NOTE: there are two actions (1 and 2)
// NOTE:it is not practical to pass each action of an agent in a message maybe it should be 1 array in message better
void 
FakeObservationLayer::
factionCallback(const std_msgs::String::ConstPtr& action1_msg, const std_msgs::String::ConstPtr& action2_msg )
{
  ROS_INFO("I heard action1: [%s]", action1_msg->data.c_str());
  ROS_INFO("I heard action2: [%s]", action2_msg->data.c_str());

  fObservationPublish(action1_msg->data.c_str(),action2_msg->data.c_str());//pass the actions
} //end factionCallback

//==============fObservationPublish=======================

  
//Function: pick flames noFlames observations based on certain actions and put in msg
// 1. check the actions (subscribed to it) {if action1 == && action2} for two agents 
// 2. pick obsevration {observation1 = & observation 2 = } for two agents  
// 3. put in msg : is it same message for two agents? 
// 4. publish msg  
 
void
FakeObservationLayer::
fObservationPublish(const std::string action1, const std::string action2)
{
    //define megs
    //NOTE: it should be array of observations to be sent in one message not two messages for each agent observation
    std_msgs::String observation1_msg;
    std_msgs::String observation2_msg;

    std::string observation1;
    std::string observation2;

    //conditions for action 1
    //which action leads to what observation *scenario?*
    //in case of two observations then f_observation_pub should be two also to not cause conflict
    if (action1.compare(""))
    {
        observation1 = "flame";
        observation1_msg.data = observation1.str();
        ROS_INFO("%s", observation1_msg.data.c_str()); //prints message of observation to check if it matches or not (for testing purpose)
        f_observation_pub.publish(observation1_msg);

    }else if (action1.compare(""))
    {
        observation1 = "noFlame";
        observation1_msg.data = observation1.str();
        ROS_INFO("%s", observation1_msg.data.c_str()); //prints message of observation to check if it matches or not (for testing purpose)
        f_observation_pub.publish(observation1_msg);
    }

    //conditions for action 2
    //which action leads to what observation *scenario?*
    if (action2.compare(""))
    {
        observation2 = "flame";
        observation2_msg.data = observation2.str();
        ROS_INFO("%s", observation2_msg.data.c_str()); //prints message of observation to check if it matches or not (for testing purpose)
        f_observation_pub.publish(observation2_msg);

    }else if (action2.compare(""))
    {
        observation2 = "noFlame";
        observation2_msg.data = observation2.str();
        ROS_INFO("%s", observation2_msg.data.c_str()); //prints message of observation to check if it matches or not (for testing purpose)
        f_observation_pub.publish(observation2_msg);
    }

    ros::spinOnce();
}//end fObservationPublish

