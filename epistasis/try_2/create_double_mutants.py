import sys
import random


INST_SET = list('abcdefghijklmnopqrstuvwxyz')


def main():
  try:
    genotype = sys.argv[1]
    n_mutants = int(sys.argv[2])
  except IndexError:
    print 'Arguments: genotype n_mutants'
    exit(1)

  for i in range(n_mutants):
    single_and_double_mutant = get_single_and_double_mutant(genotype)
    single_mutant_1 = single_and_double_mutant[0]
    single_mutant_2 = single_and_double_mutant[1]
    double_mutant = single_and_double_mutant[2]
    print single_mutant_1, single_mutant_2, double_mutant


def get_single_and_double_mutant(genotype):
  random_mutations = get_random_mutations(genotype, 2)
  single_1_mutant = create_single_mutant(genotype, random_mutations[0])
  single_2_mutant = create_single_mutant(genotype, random_mutations[1])
  double_mutant = create_double_mutant(genotype, random_mutations)
  return [single_1_mutant, single_2_mutant, double_mutant]


def create_single_mutant(genotype, mutation):
  locus = mutation[0]
  inst = mutation[1]
  return genotype[:locus] + inst + genotype[locus + 1:]


def create_double_mutant(genotype, mutations):
  single_mutant = create_single_mutant(genotype, mutations[0])
  double_mutant = create_single_mutant(single_mutant, mutations[1])
  return double_mutant


def get_random_mutations(genotype, n):
  genome_length = len(genotype)
  mutant_loci = get_random_loci(n, genome_length)
  mutant_insts = get_random_mutant_insts(genotype, mutant_loci)
  return [(mutant_loci[i], mutant_insts[i]) for i in range(n)]


def get_random_loci(n, length):
  return random.sample(range(length), n)


def get_random_mutant_insts(genotype, mutant_loci):
  return [get_random_inst_except(genotype[locus]) for locus in mutant_loci]


def get_random_inst_except(except_inst):
  random_inst = random.choice(INST_SET)
  while random_inst == except_inst:
    random_inst = random.choice(INST_SET)
  return random_inst

main()
