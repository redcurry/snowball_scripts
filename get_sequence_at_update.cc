// Gets the sequence at the specified update
// given the run data as stdin

#include <iostream>
#include <cstdlib>
using namespace std;

int main(int argc, char* argv[])
{
  if(argc < 2)
  {
    cout << "Arguments: update < run_path\n";
    return 1;
  }

  int update = atoi(argv[1]);

  while(true)
  {
    int in_update;
    string in_sequence;

    cin >> in_update >> in_sequence;

    if(cin.eof())
      break;

    if(in_update == update)
    {
      cout << in_sequence;
      break;
    }
  }

  return 0;
}
