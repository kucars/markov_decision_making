/**\file controller_event_pomdp.h
 *
 * Author:
 * Joao Messias <jmessias@isr.ist.utl.pt>
 * Tarek Taha   <tarek.taha@kustar.ac.ae>
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

#ifndef _CONTROLLER_EVENT_POMDP_H_
#define _CONTROLLER_EVENT_POMDP_H_

#include <string>

#include <mdm_library/controller_decpomdp.h>



namespace mdm_library
{
/**
 * ControllerEventPOMDP implements an asynchronous POMDP controller, driven by incoming observations.
 */
class ControllerEventDecPOMDP : public ControllerPOMDP
{
public:
    /**
     * Constructor. When using this form, the reward function of the MDP model
     * is known to the controller, and so reward can be logged in real-time. Furthermore,
     * the metadata of the model is parsed automatically and passed to the Action Layer.
     * @param problem_file A file defining the MDP, in any MADP-compatible format.
     * @param q_value_function_file A file defining the Q-value function of this MDP, as a
     * whitespace-separated |S|x|A| matrix of floating point numbers.
     * If you have an explicit policy instead, convert it to a matrix where the only non-zero entries
     * exist in the specified (s,a) pairs.
     * @param initial_status (optional) The initial status of this controller.
     */
    ControllerEventDecPOMDP ( const std::string& problem_file,
                           const std::string& value_function_file,
                           const CONTROLLER_STATUS initial_status = STARTED );
    /**
     * Start this controller. This reimplements ControlLayerBase::startController, since
     * it must also reset the belief state of the process to the initial state distribution.
     */
    void startController();

private:
    /**
     * Callback for observation data. A new decision step is taken whenever an observation is received.
     */
    void observationCallback ( const WorldSymbolConstPtr& msg );
};
}

#endif
