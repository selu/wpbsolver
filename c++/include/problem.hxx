class Problem {
public:
  Problem(int mn);
  int getMeasureNumber() { return measure_number; }
  int getBallNumber() { return ball_number; }
  void generateSolutions();
private:
  int measure_number;
  int ball_number;
};
