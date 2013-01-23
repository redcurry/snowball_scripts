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

MAX_UPDATE = 500000

# Mean of pop. fitness at update 1000 because don't have at 0
# (assume this is the 'ancestral' fitness -- which is very close to it)
FIRST_FITNESS = 5.517

# Reduce data to what's needed
data = data[data$Update <= MAX_UPDATE & data$Update %% 50000 == 0,]

# Make fitnesses relative
data$MeanFitness = data$MeanFitness / FIRST_FITNESS

replicates = sort(unique(data$Replicate))

# Set up general plot
plot(0, 0,
  type = 'n', las = 1, xaxt = 'n',
  xlim = c(0, 10000),
  ylim = c(0.925, 1.075),
  xlab = 'Time (generations)',
  ylab = 'Fitness (relative to ancestor)')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 10000, 2500)
axis(X_AXIS, at = xvalues,
labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

for(replicate in replicates)
{
  subdata = data[data$Replicate == replicate,]

  # First data point should be (0, 1.0)
  lines(c(0, subdata$Update * 0.02), c(1, subdata$MeanFitness))
}

dev.off()
