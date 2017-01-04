cmake_minimum_required(VERSION 2.8.9)
project(wpbsolver)

include_directories(include)

file(GLOB SOURCES "src/*.cxx")

add_executable(wpbsolver ${SOURCES})
