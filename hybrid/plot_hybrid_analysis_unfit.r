# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: input_file output_file')
  q()
}

# First argument is the input file,
# second argument is the output (plot) file,
# third argument is the title
input_file = args[1]
output_file = args[2]
title = args[3]

# Set up PDF document to output
pdf(file = output_file, width = 5, height = 5.5)

# Read data (contains column headers)
data = read.table(input_file)

names(data) = c("Update", "Pairwise", "UnfitPairwise", "UnfitOther")

# Group the data in updates (averaging counts)
unfit_pairwise_data = aggregate(data$UnfitPairwise, list(data$Update), mean)
names(unfit_pairwise_data) = c("Update", "UnfitPairwise")

# Group the data in updates (averaging counts)
unfit_other_data = aggregate(data$UnfitOther, list(data$Update), mean)
names(unfit_other_data) = c("Update", "UnfitOther")

# Convert updates to generations
generations = unfit_pairwise_data$Update * 0.02033851

# Plot things
plot(generations, unfit_pairwise_data$UnfitPairwise,
  las = 1, col = 'blue',
  main = title,
  xlim = c(0, 10000), xaxt = 'n',
  xlab = 'Time (generations)',
  ylim = c(0, 700),
  ylab = 'Number of hybrids (of 10,000)')

points(generations, unfit_other_data$UnfitOther, col = 'red')

legend(x = 'topleft',
  legend = c('With pairwise DMIs', 'With non-pairwise DMIs'),
  bty = 'n', col = c('blue', 'red'), pch = c(1, 1))

# Draw x-axis with comma separating thousands
X_AXIS = 1
axis(X_AXIS, at = seq(0, 10000, 2000),
  labels = c('0', '2,000', '4,000', '6,000', '8,000', '10,000'))

dev.off()
