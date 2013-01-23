# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: input_file output_file')
  q()
}

input_file = args[1]
output_file = args[2]

# Read data
data = read.table(input_file, header = T)

# Set up PDF document to output
pdf(file = output_file, width = 5, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Set up general plot
plot(0, 0,
  type = 'n', las = 1, xaxt = 'n',
  xlim = c(0, 10000),
  ylim = c(0, 225),
  xlab = 'Time (generations)',
  ylab = 'Number of substitutions')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 10000, 2500)
axis(X_AXIS, at = xvalues,
labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

updates = sort(unique(data$Update))
replicates = sort(unique(data$Replicate))

for(replicate in replicates)
{
  lines(updates * 0.02,
    data[data$Replicate == replicate,]$Substitutions, col = 'gray')
}

mean_data = aggregate(data$Substitutions, by = list(data$Update), mean)
names(mean_data) = c('Update', 'Substitutions')
lines(updates * 0.02, mean_data$Substitutions)

dev.off()
