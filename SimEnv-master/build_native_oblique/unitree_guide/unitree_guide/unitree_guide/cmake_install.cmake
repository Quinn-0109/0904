# Install script for directory: /root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/unitree_guide/unitree_guide/unitree_guide

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/unitree_guide/msg" TYPE FILE FILES
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/unitree_guide/unitree_guide/unitree_guide/msg/CustomPoint.msg"
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/unitree_guide/unitree_guide/unitree_guide/msg/CustomMsg.msg"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/unitree_guide/cmake" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/unitree_guide-msg-paths.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/include/unitree_guide")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/share/roseus/ros/unitree_guide")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/share/common-lisp/ros/unitree_guide")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/share/gennodejs/ros/unitree_guide")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/usr/bin/python3" -m compileall "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/lib/python3/dist-packages/unitree_guide")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages" TYPE DIRECTORY FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/devel_native_oblique/lib/python3/dist-packages/unitree_guide")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/unitree_guide.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/unitree_guide/cmake" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/unitree_guide-msg-extras.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/unitree_guide/cmake" TYPE FILE FILES
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/unitree_guideConfig.cmake"
    "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/unitree_guideConfig-version.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/unitree_guide" TYPE FILE FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/src/unitree_guide/unitree_guide/unitree_guide/package.xml")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/unitree_guide" TYPE PROGRAM FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/virtual_joy.py")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/unitree_guide" TYPE PROGRAM FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/keyboard_teleop.py")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/unitree_guide" TYPE PROGRAM FILES "/root/autodl-tmp/code/restore/0803b/overall_l0829/SimEnv-master/build_native_oblique/unitree_guide/unitree_guide/unitree_guide/catkin_generated/installspace/pointcloud2livox.py")
endif()

