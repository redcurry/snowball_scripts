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
pdf(file = output_file, width = 5, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Read data
data = read.table(input_file, header = T)

# Set up blank plot
plot(0, 0,
  type = 'n', las = 1, xaxt = 'n',
  xlim = c(0, 10000),
  ylim = c(0.6, 1),
  xlab = 'Time (generations)',
  ylab = 'Fitness (relative to initial)')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 10000, 2500)
axis(X_AXIS, at = xvalues,
labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

replicates = sort(unique(data$Replicate))

for(replicate in replicates)
{
  subdata = data[data$Replicate == replicate,]

  meandata = aggregate(subdata, by = list(subdata$Update), mean)
  first_fitness = meandata[meandata$Update == 1,]$Fitness

  # Print fitness at last update
  print(meandata[meandata$Update == max(meandata$Update),]$Fitness / first_fitness)

  # Plot
#  plot(meandata$Update * 0.02, meandata$Fitness / first_fitness,
#    type = 'l', las = 1, xaxt = 'n',
#    xlim = c(0, 10000),
#    ylim = c(0, 1.075),
#    xlab = 'Time (generations)',
#    ylab = 'Fitness (relative to initial)')
  lines(meandata$Update * 0.02, meandata$Fitness / first_fitness, col = 'gray')
}

# Plot overall mean
meandata = aggregate(data$Fitness, by = list(data$Update), mean)
summary(meandata)
names(meandata) = c('Update', 'Fitness')
first_fitness = meandata[meandata$Update == 1,]$Fitness
lines(meandata$Update * 0.02, meandata$Fitness / first_fitness)

dev.off()
