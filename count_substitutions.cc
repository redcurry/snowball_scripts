// Counts the number of substitutions
// given an ancestor and derived sequence

#include "avida.h"

#include <iostream>
#include <vector>
using namespace std;

int main(int argc, char* argv[])
{
  if(argc < 2)
  {
    cout << "Arguments: ancestor_seq derived_seq\n";
    return 1;
  }

  string ancestor_seq(argv[1]);
  string derived_seq(argv[2]);

  // Create the ancestral and derived genotypes
  Genotype* ancestor = new Genotype(ancestor_seq);
  Genotype* derived = new Genotype(derived_seq, ancestor);

  // Get a list of derived mutations from the genotype
  vector<int> const& mutations = derived->getMutations();

  // Output the count
  cout << mutations.size();

  // Clean up
  delete ancestor;
  delete derived;

  return 0;
}
