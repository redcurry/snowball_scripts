# Generate distribution of epistatic effects

from genotype import *

# Number of single mutants to create
N_SINGLE_MUTANTS = 10000

# Number of double mutants to create from random single mutants
N_DOUBLE_MUTANTS = 10000

ERROR = 0.00000001

genotype = Genotype('hwjaclcunuonxlwoosiayawgczukrylesokuumjkycywumerbbxfmnjrdsidyplujnbxufnaabcewqxodkiduqlxbrfoytlxarmmeaizicfkalokqepneqzqjaiuuwpxylbjjbnxlmnzrxhitlzlboeocxsienpwzcalysqyxrlqfdoyuorkafdbeedmsyuunwwowryksxstzxehudhxducdsndbeebqaslqpbrjtnozhzyftjwxhcdnpsoztcdseckjzofpcledzxypftwruesktjcfmpbxfberduccoyuywulkuixkcyjujerrfqjalyqtxzmcpryuysawysskipnqwcnierwxiefzrzdbxdjinptbtzzldieenwixspojozjkpsmhuoyfxejdkkboymlczmmrjqrzhsuwzcsermyennddcdpwnyazyqwrbmpajsmoyuaiozmyrcouucordynusaxdspaeckyuylmksezvvfcafgab')
measureFitness(genotype)

# Create many single mutants
mutants = getMutants(genotype, N_SINGLE_MUTANTS, 1)
measureFitness(mutants)

double_mutants = []

for double_mutant in range(N_DOUBLE_MUTANTS):
  muts = random.sample(mutants, 2)
  mut_pos_1 = muts[0].mutations()[0]
  mut_pos_2 = muts[1].mutations()[0]
  if mut_pos_1 == mut_pos_2:
    continue

  double_mutant = HybridGenotype(genotype, parents = muts)
  double_mutant.mutate(muts[0][mut_pos_1], mut_pos_1)
  double_mutant.mutate(muts[1][mut_pos_2], mut_pos_2)
  double_mutants.append(double_mutant)

measureFitness(double_mutants)

multiplicative_count = 0
synergistic_count = 0
antagonistic_count = 0
lethal_count = 0

for double_mutant in double_mutants:

  parent_1_fitness = double_mutant.parents[0].relativeFitness()
  parent_2_fitness = double_mutant.parents[1].relativeFitness()
  expected_fitness = parent_1_fitness * parent_2_fitness
  double_mutant_fitness = double_mutant.relativeFitness()

  if (parent_1_fitness < ERROR or parent_2_fitness < ERROR) \
      and double_mutant_fitness < ERROR:
    lethal_count += 1
  elif abs(double_mutant_fitness - expected_fitness) < ERROR:
    multiplicative_count += 1
  elif double_mutant_fitness < expected_fitness:
    synergistic_count += 1
  elif double_mutant_fitness > expected_fitness:
    antagonistic_count += 1
  else:
    print parent_1_fitness, parent_2_fitness, double_mutant_fitness
#  print parent_1_fitness, parent_2_fitness, expected_fitness, double_mutant_fitness

print multiplicative_count, synergistic_count, antagonistic_count, lethal_count
