#include <iostream>
#include <iomanip>
#include <cmath>
#include <vector>
#include <algorithm>
#include "problem.hxx"

using namespace std;

#define OUTCOME_NUMBER 3
#define PLACE_NUMBER 3

Problem::Problem(int mn) {
  measure_number = mn;
  third_number = pow(OUTCOME_NUMBER, measure_number)/6;
  ball_number = third_number*PLACE_NUMBER;
}

void Problem::generateSolutions() {
  int series[ball_number*measure_number];
  baseSeries(series);

  int ones_start[measure_number], ones_end[measure_number];
  int result_count = 0;
  int i=1, level=0, pos;
  ones_start[level] = i;
  while (i<ball_number) {
    if (series[measure_number*i+level] == 1) {
      i++;
    } else {
      ones_end[level] = i;
      level++;
      ones_start[level] = i;
    }
  }
  ones_end[level] = i;

  level = 0;
  int result[ball_number*measure_number];
  bool comb[measure_number];
  for (i=0; i<measure_number; i++) {
    result[i] = series[i];
    comb[i] = false;
  }
  int counts[PLACE_NUMBER*measure_number];
  vector<bool> mirror(ball_number);
  while (level>=0) {
    for (i=0; i<PLACE_NUMBER; i++) {
      counts[i] = 0;
    }
    for (pos=0; pos<ones_start[level]; pos++) {
      counts[result[measure_number*pos+level]+1]++;
    }
    bool wrong = false;
    for (i=0; i<PLACE_NUMBER; i++) {
      if (counts[i] > third_number) {
        level--;
        wrong = true;
        break;
      }
    }
    if (wrong) {
      continue;
    }
    wrong = false;
    if (!comb[level]) {
      fill(mirror.begin()+ones_start[level], mirror.end(), false);
      fill(mirror.begin()+ones_end[level]-third_number+counts[0], mirror.begin()+ones_end[level], true);
      comb[level] = true;
    } else {
      wrong = !next_permutation(mirror.begin()+ones_start[level], mirror.begin()+ones_end[level]);
    }
    do {
      if (wrong) {
        break;
      }
      for(pos=ones_start[level]; pos<ones_end[level]; pos++) {
        for(i=0; i<measure_number; i++) {
          result[measure_number*pos+i] = series[measure_number*pos+i] * (mirror[pos] ? -1 : 1);
        }
      }
      for (i=0; i<PLACE_NUMBER*measure_number; i++) {
        counts[i] = 0;
      }
      for (i=level+1; i<measure_number; i++) {
        for (pos=0; pos<ones_end[level]; pos++) {
          counts[i*PLACE_NUMBER+result[measure_number*pos+i]+1]++;
        }
      }
      for (i=(level+1)*PLACE_NUMBER; i<measure_number*PLACE_NUMBER; i++) {
        if (counts[i] > third_number) {
          break;
        }
      }
      if (i == measure_number*PLACE_NUMBER) {
        break;
      } else {
        if (!next_permutation(mirror.begin()+ones_start[level], mirror.begin()+ones_end[level])) {
          wrong = true;
          break;
        }
      }
    } while(true);
    if (wrong) {
      comb[level] = false;
      level--;
    } else {
      level++;
      if (level == measure_number) {
        result_count++;
        if (result_count % 1000000 == 0) {
          cout << "   >>> " << result_count << " <<<" << endl;
        }
        //printSeries(result);
        level--;
      }
    }
  }
  cout << "Result count: " << result_count << endl;
}

void Problem::baseSeries(int *series) {
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
        series[measure_number*pos+i] = (series[measure_number*pos+i]+2)%PLACE_NUMBER-1;
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
}

void Problem::printSeries(int *series) {
  int i, pos;
  for (i=0; i<measure_number; i++) {
    cout << setw(3) << i+1 << ": ";
    for (pos=0; pos<ball_number; pos++) {
      cout << setw(3) << series[pos*measure_number+i];
    }
    cout << endl;
  }
}
