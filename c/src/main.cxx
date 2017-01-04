#include <iostream>
//#include <string>
#include <cstdlib>
#include "problem.hxx"

using namespace std;

int main(int argc, char *argv[]){
  if (argc < 2) {
    cerr << "Usage: " << argv[0] << " <measure number>" << endl;
    return 1;
  }
  Problem p(atoi(argv[1]));

  cout << "WPBSolver: " << p.getMeasureNumber() << "/" << p.getBallNumber() << endl;
  return 0;
}
