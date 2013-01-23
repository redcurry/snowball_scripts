get_mean = function(update, data)
{
  data = data[data$Update == update,]
  mean = mean(data$DMIs)
}

# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: numbered_pairwise_file output_file')
  q()
}

numbered_pairwise_file = args[1]
output_file = args[2]

# Set up PDF document to output
pdf(file = output_file, width = 4, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Read data (no column headers)
all_data = read.table(numbered_pairwise_file, header = T)

# Get the updates as a list
updates = sort(unique(all_data$Update))

# Convert updates to generations
generations = updates * 0.02 #033851

replicates = unique(all_data$Replicate)

for(replicate in replicates)
{
  data = all_data[all_data$Replicate == replicate,]

  # Plot
  plot(x = generations, y = data$DMIs,
    las = 1, xaxt = 'n',
    xlim = c(0, 10000), xaxt = 'n',
#    ylim = c(0, 30),
    xlab = 'Time (generations)',
    ylab = 'Number of DMIs')

  # Draw x-axis with comma separating thousands
  X_AXIS = 1
  xvalues = seq(0, 10000, 2500)
  axis(X_AXIS, at = xvalues,
    labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))
}

dev.off()
