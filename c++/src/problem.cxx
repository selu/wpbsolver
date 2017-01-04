#include <cmath>
#include "problem.hxx"

Problem::Problem(int mn) {
  measure_number = mn;
  ball_number = floor(pow(3, measure_number)/6)*3;
}
