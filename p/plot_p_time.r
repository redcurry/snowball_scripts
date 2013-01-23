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
data = read.table(input_file, header = T)

names(data) = c("Update", "p")

# Group the data in updates (averaging pairwise counts)
data = aggregate(data$p, list(data$Update), mean)
names(data) = c("Update", "p")

# Convert updates to generations
generations = data$Update * 0.02033851

# Plot things
plot(generations, data$p / 1e-4, las = 1,
  main = title,
  xlim = c(0, 10000), xaxt = 'n',
  xlab = 'Time (generations)',
  ylim = c(0, 4),
  ylab = expression(paste('Probability (x ', 10 ^ -4, ")", sep = "")))

# Draw x-axis with comma separating thousands
X_AXIS = 1
axis(X_AXIS, at = seq(0, 10000, 2000),
  labels = c('0', '2,000', '4,000', '6,000', '8,000', '10,000'))

dev.off()
