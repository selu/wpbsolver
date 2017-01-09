#include <iostream>
//#include <string>
#include <cstdlib>
#include "problem.hxx"

int main(int argc, char *argv[]){
  if (argc < 2) {
    std::cerr << "Usage: " << argv[0] << " <measure number>" << std::endl;
    return 1;
  }
  Problem p(atoi(argv[1]));
  if (argc > 2) {
    p.setCount(atoi(argv[2]));
  }
  std::cout << "WPBSolver: " << p.getMeasureNumber() << "/" << p.getBallNumber() << std::endl;
  p.generateSolutions();
  return 0;
}
