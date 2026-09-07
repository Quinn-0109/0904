# Install script for directory: /root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/building_generator_interfaces

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/building_generator_interfaces/srv" TYPE FILE FILES
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/building_generator_interfaces/srv/CallElevator.srv"
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/building_generator_interfaces/srv/SetDoorState.srv"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/building_generator_interfaces/cmake" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/building_generator_interfaces/catkin_generated/installspace/building_generator_interfaces-msg-paths.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/include/building_generator_interfaces")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/share/roseus/ros/building_generator_interfaces")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/share/common-lisp/ros/building_generator_interfaces")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/share/gennodejs/ros/building_generator_interfaces")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/usr/bin/python3" -m compileall "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/lib/python3/dist-packages/building_generator_interfaces")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/lib/python3/dist-packages/building_generator_interfaces")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/building_generator_interfaces/catkin_generated/installspace/building_generator_interfaces.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/building_generator_interfaces/cmake" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/building_generator_interfaces/catkin_generated/installspace/building_generator_interfaces-msg-extras.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/building_generator_interfaces/cmake" TYPE FILE FILES
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/building_generator_interfaces/catkin_generated/installspace/building_generator_interfacesConfig.cmake"
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/building_generator_interfaces/catkin_generated/installspace/building_generator_interfacesConfig-version.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/building_generator_interfaces" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/building_generator_interfaces/package.xml")
endif()

