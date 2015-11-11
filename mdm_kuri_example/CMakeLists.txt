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
   ${MADP_INCLUDE_DIRS}/madp
   ${Boost_INCLUDE_DIRS}
)

include_directories(include ${catkin_INCLUDE_DIRS})

add_executable(predicates src/predicates.cpp)
target_link_libraries(predicates ${catkin_LIBRARIES} ${topological_tools_LIBRARIES} ${predicate_manager_LIBRARIES})

add_executable(state_layer src/state_layer.cpp)
target_link_libraries(state_layer ${catkin_LIBRARIES})

add_executable(action_layer src/action_layer.cpp)
target_link_libraries(action_layer ${catkin_LIBRARIES})

add_executable(observation_layer src/observation_layer.cpp)
target_link_libraries(observation_layer ${catkin_LIBRARIES})

add_executable(control_layer src/control_layer.cpp)
target_link_libraries(control_layer ${MADP_LIBRARIES} ${catkin_LIBRARIES} -lxml2)
set_target_properties(control_layer PROPERTIES COMPILE_FLAGS "-std=c++0x")

add_executable(test_node src/test_node.cpp)
target_link_libraries(test_node ${MADP_LIBRARIES} ${catkin_LIBRARIES} -lxml2)
set_target_properties(test_node PROPERTIES COMPILE_FLAGS "-std=c++0x")

add_executable(tiger_demo_test src/tiger_demo_test.cpp)
target_link_libraries(tiger_demo_test ${catkin_LIBRARIES})

add_executable(firefighter_demo_test src/firefighter_demo_test.cpp)
target_link_libraries(firefighter_demo_test ${catkin_LIBRARIES})

add_executable(MAHRC_1X3_V1_2 src/MAHRC_1X3_V1_2.cpp)
target_link_libraries(MAHRC_1X3_V1_2 ${catkin_LIBRARIES})

add_executable(mahrc src/mahrc.cpp)
target_link_libraries(mahrc ${catkin_LIBRARIES})

