import sys


EPISTASIS_TYPE_MULTIPLICATIVE = 0
EPISTASIS_TYPE_SYNERGISTIC = 1
EPISTASIS_TYPE_ANTAGONISTIC = 2
EPISTASIS_TYPE_LETHAL = 3

ERROR = 0.00000001


def main():
  try:
    anc_fitness = float(sys.argv[1])
  except IndexError:
    print 'Arguments: anc_fitness'
    exit(1)

  counts = [0, 0, 0, 0]

  for line in sys.stdin:
    fitnesses = get_fitnesses(line)
    single_1_fitness = get_relative_fitness(fitnesses[0], anc_fitness)
    single_2_fitness = get_relative_fitness(fitnesses[1], anc_fitness)
    double_mut_fitness = get_relative_fitness(fitnesses[2], anc_fitness)
    epistasis_type = \
      get_epistasis_type(single_1_fitness, single_2_fitness, double_mut_fitness)
    counts[epistasis_type] += 1

  print counts[EPISTASIS_TYPE_MULTIPLICATIVE], \
    counts[EPISTASIS_TYPE_SYNERGISTIC], \
    counts[EPISTASIS_TYPE_ANTAGONISTIC], \
    counts[EPISTASIS_TYPE_LETHAL]


def get_fitnesses(line):
  line_parts = line.strip().split()
  return [float(line_parts[0]), float(line_parts[1]), float(line_parts[2])]


def get_relative_fitness(fitness, anc_fitness):
  return fitness / anc_fitness


def get_epistasis_type(single_1_fitness, single_2_fitness, double_mut_fitness):
  if epistasis_is_lethal(single_1_fitness,single_2_fitness,double_mut_fitness):
    return EPISTASIS_TYPE_LETHAL
  else:
    expected_fitness = single_1_fitness * single_2_fitness
    return get_nonlethal_epistasis_type(double_mut_fitness, expected_fitness)


def epistasis_is_lethal(single_1_fitness, single_2_fitness, double_mut_fitness):
  return (float_is_zero(single_1_fitness) or float_is_zero(single_2_fitness)) \
    and float_is_zero(double_mut_fitness)


def get_nonlethal_epistasis_type(observed_fitness, expected_fitness):
  if floats_are_equal(observed_fitness, expected_fitness):
    return EPISTASIS_TYPE_MULTIPLICATIVE
  elif observed_fitness < expected_fitness:
    return EPISTASIS_TYPE_SYNERGISTIC
  elif observed_fitness > expected_fitness:
    return EPISTASIS_TYPE_ANTAGONISTIC
  else:
    raise Exception, 'Unknown epistasis type'


def floats_are_equal(float_1, float_2):
  return abs(float_1 - float_2) < ERROR


def float_is_zero(x):
  return floats_are_equal(x, 0.0)


main()
