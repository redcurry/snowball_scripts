bootstrap_mean_ci = function(x, n = 10000, lower = 0.025, upper = 0.975)
{
  means = replicate(n, mean(sample(x, replace = T)))
  quantile(means, probs = c(lower, upper))
}

get_mean_and_ci = function(update, data)
{
  data = data[data$Update == update,]
  mean = mean(data$Unfit)
  mean_ci = bootstrap_mean_ci(data$Unfit, n = 5000)
  c(mean_ci[1], mean, mean_ci[2])
}

errorbars = function(x, y, upper, lower)
{
  arrows(x, upper, x, lower, length = 0.025, angle = 0, code = 3)
}

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
pdf(file = output_file, width = 4, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Read data (no column headers)
data = read.table(input_file)
names(data) = c('Replicate','Update', 'Pairwise', 'UnfitPairwise', 'UnfitOther')

data = data.frame(cbind(data$Replicate, data$Update,
  data$UnfitPairwise + data$UnfitOther))
names(data) = c('Replicate', 'Update', 'Unfit')

# Get the updates as a list
updates = sort(unique(data$Update))

# Convert updates to generations
generations = updates * 0.02#033851

replicates = unique(sort(data$Replicate))

for(replicate in replicates)
{
  subdata = data[data$Replicate == replicate,]

  # Plot things
  plot(generations, subdata$Unfit,
    las = 1, xaxt = 'n',
    xlim = c(0, 10000),
#    ylim = c(0, 1500),
    xlab = 'Time (generations)',
    ylab = 'Number of unfit hybrids (of 10,000)')

  # Draw x-axis with comma separating thousands
  X_AXIS = 1
  xvalues = seq(0, 10000, 2500)
  axis(X_AXIS, at = xvalues,
    labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))
}

dev.off()
