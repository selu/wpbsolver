#include <vector>

class Problem {
public:
  Problem(int mn);
  int getMeasureNumber() { return measure_number; }
  int getBallNumber() { return ball_number; }
  void generateSolutions();
private:
  void baseSeries(std::vector<int>& series);
  void printSeries(std::vector<int>& series);
  int measure_number;
  int third_number;
  int ball_number;
};
