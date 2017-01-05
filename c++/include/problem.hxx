class Problem {
public:
  Problem(int mn);
  int getMeasureNumber() { return measure_number; }
  int getBallNumber() { return ball_number; }
  void generateSolutions();
private:
  void baseSeries(int *series);
  void printSeries(int *series);
  int measure_number;
  int ball_number;
  int third_number;
};
