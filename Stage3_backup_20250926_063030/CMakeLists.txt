cmake_minimum_required(VERSION 3.20)
project(Stage3)

set(CMAKE_CXX_STANDARD 17)

# VESC source
set(VESC_SRC
    VESC/PID.cpp
    VESC/MotorController.cpp
)

add_executable(Stage3_test
    main.cpp
    ${VESC_SRC}
)

target_include_directories(Stage3_test PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)
