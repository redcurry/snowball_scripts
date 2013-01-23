# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: input_file output_file')
  q()
}

input_file = args[1]
output_file = args[2]

# Set up PDF document to output
pdf(file = output_file, width = 6, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Read data
data = read.table(input_file, header = T)

max_generation = max(data$Generation)
final_fitness = data[data$Generation == max_generation,]$MeanFitness
relative_fitnesses = data$MeanFitness / final_fitness

# Plot things
plot(data$Generation, relative_fitnesses,
  type = 'l', las = 1, xaxt = 'n',
  xlim = c(0, 1.5e6),
  xlab = 'Time (millions of generations)',
  ylab = 'Fitness (relative to final)')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 1.5, 0.25)
axis(X_AXIS, at = xvalues * 1e6,
labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

dev.off()
