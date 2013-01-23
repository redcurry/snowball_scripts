#include "avida.h"

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <cstdlib>
using namespace std;

#define ANCESTOR_UPDATE 1

// Define DMI codes
#define PAIRWISE_DMI_ANCESTRAL_1 "A1"
#define PAIRWISE_DMI_ANCESTRAL_2 "A2"
#define PAIRWISE_DMI_PARENTAL    "P"

string get_sequence(string const& path, int update)
{
  ifstream in_file(path.c_str());

  int in_update;
  string sequence;

  while(!in_file.eof())
  {
    in_file >> in_update >> sequence;

    if(in_update == update)
      break;
  }

  in_file.close();

  return sequence;
}

vector<string> split(string const& str)
{
  vector<string> parts;
  istringstream isstream(str);
  while(!isstream.eof())
  {
    string part;
    isstream >> part;
    parts.push_back(part);
  }
  return parts;
}

bool contains(vector<int> const& list, int value)
{
  for(int i = 0; i < list.size(); i++)
    if(list[i] == value)
      return true;
  return false;
}

vector<int> get_mut_order(string const& path, int update)
{
  ifstream in_file(path.c_str());

  vector<int> mut_order;

  while(!in_file.eof())
  {
    string line;
    getline(in_file, line);

    vector<string> const& line_parts = split(line);

    int in_update = atoi(line_parts[0].c_str());

    if(in_update == update)
    {
      for(int i = 1; i < line_parts.size(); i++)
        mut_order.push_back(atoi(line_parts[i].c_str()));
      break;
    }
  }

  in_file.close();

  return mut_order;
}

vector<Genotype*> get_single_mutants(Genotype const* genotype)
{
  vector<Genotype*> mutants;

  Genotype const* ancestor = genotype->getAncestor();
  string ancestor_seq = ancestor->getSequence();

  vector<int> const& mutations = genotype->getMutations();
  for(int i = 0; i < mutations.size(); i++)
  {
    int mut_pos = mutations[i];
    char mut_inst = genotype->getLocus(mut_pos);

    Genotype* mutant = new Genotype(ancestor_seq, ancestor);
    mutant->setLocus(mut_pos, mut_inst);

    mutants.push_back(mutant);
  }

  return mutants;
}

vector<int> get_prev_mutations(vector<int> const& mut_order, int pos)
{
  vector<int> prev_mutations;

  for(int i = 0; i < mut_order.size(); i++)
  {
    int mut_pos = mut_order[i];

    if(mut_pos == pos)
      return prev_mutations;
    else
      prev_mutations.push_back(mut_pos);
  }

  return prev_mutations;
}

vector<Genotype*> get_double_mutants(Genotype const* single_mutant,
  vector<Genotype*> const& single_mutants, vector<int> const& mut_order)
{
  Genotype const* ancestor = single_mutant->getAncestor();

  int first_mutation = single_mutant->getMutations()[0];
  vector<int> const& prev_mutations =
    get_prev_mutations(mut_order, first_mutation);

  vector<Genotype*> double_mutants;

  for(int i = 0; i < single_mutants.size(); i++)
  {
    int second_mutation = single_mutants[i]->getMutations()[0];

    // Skip if the second mutation is the same as the first
    if(second_mutation == first_mutation)
      continue;

    // Skip if the second mutation did not arise before the first
    if(!contains(prev_mutations, second_mutation))
      continue;

    Genotype* double_mutant = new Genotype(single_mutant, ancestor);

    char second_mutation_inst = single_mutants[i]->getLocus(second_mutation);
    double_mutant->setLocus(second_mutation, second_mutation_inst);

    double_mutants.push_back(double_mutant);
  }

  return double_mutants;
}

void count_DMIs_ancestral(int parent_num, Genotype const* parent,
  vector<Genotype*> const& single_mutants, vector<int> const& mut_order)
{
  int count = 0;

  for(int i = 0; i < single_mutants.size(); i++)
  {
    Genotype* single_mutant = single_mutants[i];

    // Get all double mutants in which one mutation is
    // always the single mutation from single_mutant and the
    // other mutation is each mutation from parent (single_mutants)
    // that arose before the single mutation
    vector<Genotype*> const& double_mutants =
      get_double_mutants(single_mutant, single_mutants, mut_order);

    for(int j = 0; j < double_mutants.size(); j++)
      // Count pairwise DMI
      count++;

    // Clean up double_mutants
    for(int j = 0; j < double_mutants.size(); j++)
      delete double_mutants[j];
  }

  string pairwise_DMI_code = parent_num == 1 ?
    PAIRWISE_DMI_ANCESTRAL_1 : PAIRWISE_DMI_ANCESTRAL_2;
  cout << pairwise_DMI_code << " " << count << "\n";
}

void count_DMIs_parental(Genotype const* parent_1, Genotype const* parent_2,
  vector<Genotype*> const& single_mutants_1,
  vector<Genotype*> const& single_mutants_2)
{
  int count = 0;

  Genotype const* ancestor = parent_1->getAncestor();

  vector<Genotype*> hybrids;

  for(int i = 0; i < single_mutants_1.size(); i++)
  {
    for(int j = 0; j < single_mutants_2.size(); j++)
      // Count pairwise DMI
      count++;
  }

  cout << PAIRWISE_DMI_PARENTAL << " " << count << "\n";
}

int main(int argc, char* argv[])
{
  if(argc < 2)
  {
    cout << "Arguments: parent_1_path parent_2_path "
      "mut_order_1_path mut_order_2_path update\n";
    return 1;
  }

  string parent_1_path(argv[1]);
  string parent_2_path(argv[2]);

  string mut_order_1_path(argv[3]);
  string mut_order_2_path(argv[4]);

  int update = atoi(argv[5]);

  // Read ancestral and parental sequences at the specified update
  string const& ancestor_seq = get_sequence(parent_1_path, ANCESTOR_UPDATE);
  string const& parent_1_seq = get_sequence(parent_1_path, update);
  string const& parent_2_seq = get_sequence(parent_2_path, update);

  // Read the mutation orders for each parent at the specified update
  vector<int> const& mut_order_1 = get_mut_order(mut_order_1_path, update);
  vector<int> const& mut_order_2 = get_mut_order(mut_order_2_path, update);

  // Create the ancestral and parental genotype objects
  Genotype* ancestor = new Genotype(ancestor_seq);
  Genotype* parent_1 = new Genotype(parent_1_seq, ancestor);
  Genotype* parent_2 = new Genotype(parent_2_seq, ancestor);

  // Create every single mutant of the parental genotypes
  vector<Genotype*> const& single_mutants_1 = get_single_mutants(parent_1);
  vector<Genotype*> const& single_mutants_2 = get_single_mutants(parent_2);

  // Count DMIs with ancestral state
  count_DMIs_ancestral(1, parent_1, single_mutants_1, mut_order_1);
  count_DMIs_ancestral(2, parent_2, single_mutants_2, mut_order_2);

  // Count DMIs between parents
  count_DMIs_parental(parent_1, parent_2, single_mutants_1, single_mutants_2);

  // Clean up ancestral and parental genotypes
  delete ancestor;
  delete parent_1;
  delete parent_2;

  // Clean up single mutants
  for(int i = 0; i < single_mutants_1.size(); i++)
    delete single_mutants_1[i];
  for(int i = 0; i < single_mutants_2.size(); i++)
    delete single_mutants_2[i];

  return 0;
}
