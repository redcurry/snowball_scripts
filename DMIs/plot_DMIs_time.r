bootstrap_mean_ci = function(x, n = 10000, lower = 0.025, upper = 0.975)
{
  means = replicate(n, mean(sample(x, replace = T)))
  quantile(means, probs = c(lower, upper))
}

get_mean_and_ci = function(update, data)
{
  data = data[data$Update == update,]
  mean = mean(data$DMIs)
  mean_ci = bootstrap_mean_ci(data$DMIs)
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

# Read data (contains column headers)
data = read.table(input_file, header = T)
names(data) = c("Update", "DMIs")

# Get the updates as a list
updates = sort(unique(data$Update))

box = sapply(updates, get_mean_and_ci, data)

lower = box[1,]
means = box[2,]
upper = box[3,]

# Convert updates to generations
generations = updates * 0.02#033851

# Plot things
plot(generations, means,
  las = 1, xaxt = 'n',
  xlim = c(0, 10000),
  ylim = c(0, 18),
  xlab = 'Time (generations)',
  ylab = 'Number of DMIs')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 10000, 2500)
axis(X_AXIS, at = xvalues,
  labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

lines(generations, lower, col = 'gray')
lines(generations, upper, col = 'gray')
#errorbars(generations, means, upper, lower)

# Linear coefficients (from stats) and updates reverted
#a = 0.2477344 * (1/10000)
#expected_DMIs = a * updates
#lines(generations, expected_DMIs, lty="dashed")

# Quadratic coefficients (from stats) and updates reverted
a = 0.004859795 * (1/10000)^2
b = 0.082518083 * (1/10000)
expected_DMIs = a * updates^2 + b * updates
lines(generations, expected_DMIs, lty="solid")

dev.off()
