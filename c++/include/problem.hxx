#include <vector>

class Problem {
public:
  Problem(unsigned int mn);
  unsigned int getMeasureNumber() { return measure_number; }
  unsigned int getBallNumber() { return ball_number; }
  void generateSolutions();
private:
  void baseSeries(std::vector<char>& series);
  void printSeries(std::vector<char>& series);
  bool verify(std::vector<unsigned int>& measures);
  unsigned int measure_number;
  unsigned int third_number;
  unsigned int ball_number;
};
