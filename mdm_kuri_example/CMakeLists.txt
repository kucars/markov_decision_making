cmake_minimum_required(VERSION 2.8.3)
project(mdm_kuri_example)
SET ( CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../mdm_library/CMakeModules )
find_package(catkin REQUIRED COMPONENTS mdm_library
                                        predicate_manager
                                        topological_tools)
find_package( MADP REQUIRED)
find_package( SDL REQUIRED)
find_package( SDL_image REQUIRED)

if ( NOT_SDLIMAGE_FOUND )
  message(FATAL_ERROR, "SDL_image must be installed in order to run the demo (and topological_tools must be compiled accordingly).")
endif ( NOT_SDLIMAGE_FOUND )

catkin_package(
  CATKIN_DEPENDS mdm_library
                 predicate_manager
                 topological_tools
)

include_directories(include
   ${catkin_INCLUDE_DIRS}
   ${MADP_INCLUDE_DIRS}
   /home/tataha/workspace/madp/include/madp/include
   ${MADP_LOC}/src/base
   ${MADP_LOC}/src/include
   ${MADP_LOC}/src/support
   ${MADP_LOC}/src/planning
   ${MADP_LOC}/src/parser
)

message("======================================== ${topological_tools_LIBRARIES}")

include_directories(include ${catkin_INCLUDE_DIRS})

add_executable(predicates src/predicates.cpp)
target_link_libraries(predicates ${catkin_LIBRARIES} ${topological_tools_LIBRARIES} ${predicate_manager_LIBRARIES})


add_executable(state_layer src/state_layer.cpp)
target_link_libraries(state_layer ${catkin_LIBRARIES})

add_executable(action_layer src/action_layer.cpp)
target_link_libraries(action_layer ${catkin_LIBRARIES})

add_executable(control_layer src/control_layer.cpp)
#-L/home/tataha/workspace/madp-0.3/src/libpomdp-solve/src/lp-solve-old/ ${MADP_LIBRARIES} -lDAI -lMADPBase -lMADPSupport -lMADPPlanning -lMADPParser -lPOMDPSolve -lmdp -llaspack -lm -lxml2
target_link_libraries(control_layer ${MADP_LIBRARIES} ${catkin_LIBRARIES} -lxml2)
set_target_properties(control_layer PROPERTIES COMPILE_FLAGS "-std=c++0x")
