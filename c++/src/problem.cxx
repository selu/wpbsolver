#include <iostream>
#include <iomanip>
#include <cmath>
#include <algorithm>
#include "problem.hxx"

#define OUTCOME_NUMBER 3
#define PLACE_NUMBER 3

Problem::Problem(unsigned int mn) : measure_number(mn), third_number(pow(OUTCOME_NUMBER, measure_number)/6), ball_number(third_number*PLACE_NUMBER), result_number(0) {
}

void Problem::setCount(unsigned int count) {
  result_number = count;
}

void Problem::generateSolutions() {
  std::vector<char> series(ball_number*measure_number);
  baseSeries(series);

  std::vector<unsigned int> ones_start(measure_number), ones_end(measure_number);
  unsigned int result_count=0;
  unsigned int i=1, pos;
  int level=0;
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
  std::vector<char> result(ball_number*measure_number);
  bool comb[measure_number];
  for (i=0; i<measure_number; i++) {
    result[i] = series[i];
    comb[i] = false;
  }
  std::vector<unsigned int> counts(PLACE_NUMBER*measure_number);
  std::vector<bool> mirror(ball_number);
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
      std::fill(mirror.begin()+ones_start[level], mirror.end(), false);
      std::fill(mirror.begin()+ones_end[level]-third_number+counts[0], mirror.begin()+ones_end[level], true);
      comb[level] = true;
    } else {
      wrong = !std::next_permutation(mirror.begin()+ones_start[level], mirror.begin()+ones_end[level]);
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
      if (std::all_of(counts.begin()+(level+1)*PLACE_NUMBER, counts.end(), [this](unsigned int v){return v<=third_number;})) {
        break;
      } else {
        if (!std::next_permutation(mirror.begin()+ones_start[level], mirror.begin()+ones_end[level])) {
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
      if ((unsigned int)level == measure_number) {
        result_count++;
        if (result_count % 1000000 == 0) {
          std::cout << "   >>> " << result_count << " <<<" << std::endl;
        }
        if (result_number>0) {
          if (result_number < 10000) {
            printSeries(result);
          }
          if (result_count == result_number) {
            break;
          }
        }
        level--;
      }
    }
  }
  std::cout << "Result count: " << result_count << std::endl;
}

void Problem::baseSeries(std::vector<char>& series) {
  unsigned int i, pos = 1;
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

void Problem::printSeries(std::vector<char>& series) {
  unsigned int i, pos;
  std::vector<unsigned int> measures(measure_number*third_number*2);
  int digits = floor(log10(ball_number))+2;

  for (i=0; i<measure_number; i++) {
    int left = 0, right = 0;
    std::cout << std::setw(3) << i+1 << ":  ";
    for (pos=0; pos<ball_number; pos++) {
      switch (series[pos*measure_number+i]) {
        case 1:
          measures[i*third_number*2+left++] = pos+1;
          break;
        case -1:
          measures[i*third_number*2+third_number+right++] = pos+1;
          break;
      }
      std::wcout << " " << "R-L"[series[pos*measure_number+i]+1];
    }
    std::cout << std::endl;
  }

  std::cout << std::endl;
  for(i=0; i<measure_number; i++) {
    std::cout << std::setw(3) << i+1 << ": ";
    for(pos=0; pos<third_number*2; pos++) {
      if (pos == third_number) {
        std::cout << " |";
      }
      std::cout << std::setw(digits) << measures[i*third_number*2+pos];
    }
    std::cout << std::endl;
  }
  if (verify(measures)) {
    std::cout << "OK" << std::endl;
  } else {
    std::cout << "error!!!" << std::endl;
  }
}

bool Problem::verify(std::vector<unsigned int>& measures) {
  unsigned int outcomes = pow(OUTCOME_NUMBER, measure_number);
  std::vector<unsigned char> results(ball_number*pow(OUTCOME_NUMBER, measure_number));
  std::fill(results.begin(), results.begin()+ball_number, 3);
  unsigned int increment = outcomes;
  for (unsigned int level=0; level<measure_number; level++) {
    unsigned int next_increment = increment/OUTCOME_NUMBER;
    std::vector<unsigned int> left(third_number), right(third_number), remaining(ball_number);
    std::vector<unsigned int>::iterator left_it = left.begin(), right_it = right.begin();
    unsigned int num=1;
    std::generate(remaining.begin(), remaining.end(), [&num](){return num++;});
    for (unsigned int i=0; i<2*third_number; i++) {
      num = measures[level*2*third_number+i];
      *(i<third_number ? left_it : right_it)++ = num;
      std::remove(remaining.begin(), remaining.end(), num);
    }
    for (unsigned int i=0; i<outcomes; i+=increment) {
      for (unsigned int j=0; j<ball_number; j++) {
        unsigned char p = results[ball_number*i+j];
        if(std::find(left.begin(), left.end(), j+1) != left.end()) {
          results[ball_number*(i+next_increment)+j] = p & 1;
          results[ball_number*(i+2*next_increment)+j] = p & 2;
          results[ball_number*i+j] = 0;
        } else if(std::find(right.begin(), right.end(), j+1) != right.end()) {
          results[ball_number*(i+next_increment)+j] = p & 2;
          results[ball_number*(i+2*next_increment)+j] = p & 1;
          results[ball_number*i+j] = 0;
        } else {
          results[ball_number*(i+next_increment)+j] = 0;
          results[ball_number*(i+2*next_increment)+j] = 0;
        }
      }
    }
    increment = next_increment;
  }
  return std::all_of(results.begin(), results.end(), [](unsigned char v){return v<3;});
}
