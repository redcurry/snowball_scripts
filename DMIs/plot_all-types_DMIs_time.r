get_mean = function(update, data)
{
  data = data[data$Update == update,]
  mean = mean(data$DMIs)
}

# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: all_pairwise_file ancestral_pairwise_file parental_pairwise_file output_file')
  q()
}

all_pairwise_file = args[1]
ancestral_pairwise_file = args[2]
parental_pairwise_file = args[3]
output_file = args[4]

# Set up PDF document to output
pdf(file = output_file, width = 4, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Read data (no column headers)
all_data = read.table(all_pairwise_file)
ancestral_data = read.table(ancestral_pairwise_file)
parental_data = read.table(parental_pairwise_file)

names(all_data) = c("Update", "DMIs")
names(ancestral_data) = c("Update", "DMIs")
names(parental_data) = c("Update", "DMIs")

# Get the updates as a list
updates = sort(unique(all_data$Update))

all_means = sapply(updates, get_mean, all_data)
ancestral_means = sapply(updates, get_mean, ancestral_data)
parental_means = sapply(updates, get_mean, parental_data)

# Convert updates to generations
generations = updates * 0.02#033851

# Setup plot
plot(0, 0,
  las = 1, xaxt = 'n',
  xlim = c(0, 10000), xaxt = 'n',
  ylim = c(0, 20),
  xlab = 'Time (generations)',
  ylab = 'Number of DMIs')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 10000, 2500)
axis(X_AXIS, at = xvalues,
  labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

# Draw legend
legend(x = 'topleft', bty = 'n',
  legend = c('All pairwise DMIs',
    'Derived-ancestral DMIs',
    'Derived-derived DMIs'),
  pch = c(1, 2, 0),
  lty = c('solid', 'solid', 'solid'))

points(generations, all_means)
points(generations, ancestral_means, pch = 2)
points(generations, parental_means, pch = 0)

# Quadratic coefficients (from stats) and updates reverted

# All pairwise DMIs
a = 0.004728714 * (1/10000)^2
b = 0.082328304 * (1/10000)
expected_DMIs = a * updates^2 + b * updates
lines(generations, expected_DMIs)

# Derived-ancestral DMIs
a = 0.003156985 * (1/10000)^2
b = 0.021575878 * (1/10000)
expected_DMIs = a * updates^2 + b * updates
lines(generations, expected_DMIs)

# Derived-derived DMIs
a = 0.001548841 * (1/10000)^2
b = 0.061482565 * (1/10000)
expected_DMIs = a * updates^2 + b * updates
lines(generations, expected_DMIs)

dev.off()
