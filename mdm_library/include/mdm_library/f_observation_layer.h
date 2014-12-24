/**\file f_observation_layer.h
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

#include <string>
#include <ros/ros.h>


namespace mdm_library
{
class FakeObservationLayer
{

public:
    FakeObservationLayer();
    void factionCallback(const std_msgs::String::ConstPtr& msg);

private:

   ros::NodeHandle nh_;

   ros::Subscriber fake_action_sub; //from fake action layer 
   ros::Publisher fake_observation_pub; 

}; //end class FakeObservationLayer
}//end namespace 

