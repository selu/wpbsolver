#include <iostream>
#include <iomanip>
#include <cmath>
#include "problem.hxx"

using namespace std;

Problem::Problem(int mn) {
  measure_number = mn;
  third_number = pow(3, measure_number)/6;
  ball_number = third_number*3;
}

void Problem::generateSolutions() {
  int series[ball_number*measure_number];
  int i, pos = 1;
  for (i=0; i<measure_number; i++) {
    series[i] = 1;
  }
  while (pos < ball_number) {
    for (i=0; i<measure_number; i++) {
      series[measure_number*pos+i] = series[measure_number*(pos-1)+i];
    }
    bool ok;
    do {
      i = measure_number-1;
      while (i>=0) {
        series[measure_number*pos+i] = (series[measure_number*pos+i]+2)%3-1;
        if (series[measure_number*pos+i] != 1) {
          break;
        }
        i--;
      }
      i = 0;
      ok = true;
      while (i<measure_number) {
        if (series[measure_number*pos+i] == 1) {
          break;
        } else if (series[measure_number*pos+i] == -1) {
          ok = false;
          break;
        }
        i++;
      }
      if (ok && series[measure_number*pos] == 1) {
        ok = false;
        for (i=1; i<measure_number; i++) {
          if (series[measure_number*pos+i] != -1) {
            ok = true;
            break;
          }
        }
      }
    } while (!ok);
    pos++;
  }
  for (i=0; i<measure_number; i++) {
    cout << setw(3) << i+1 << ": ";
    for (pos=0; pos<ball_number; pos++) {
      cout << setw(3) << series[pos*measure_number+i];
    }
    cout << endl;
  }
}
