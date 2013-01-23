bootstrap_mean_ci = function(x, n = 10000, lower = 0.025, upper = 0.975)
{
  means = replicate(n, mean(sample(x, replace = T)))
  quantile(means, probs = c(lower, upper))
}

get_mean_and_ci_pairwise = function(update, data)
{
  data = data[data$Update == update,]
  mean = mean(data$Pairwise)
  mean_ci = bootstrap_mean_ci(data$Pairwise)
  c(mean_ci[1], mean, mean_ci[2])
}

get_mean_and_ci_unfit_pairwise = function(update, data)
{
  data = data[data$Update == update,]
  mean = mean(data$UnfitPairwise)
  mean_ci = bootstrap_mean_ci(data$UnfitPairwise)
  c(mean_ci[1], mean, mean_ci[2])
}


# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: input_file output_file')
  q()
}

# First argument is the input file,
# second argument is the output (plot) file
input_file = args[1]
output_file = args[2]

# Set up PDF document to output
pdf(file = output_file, width = 4, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Read data (contains column headers)
data = read.table(input_file)

names(data) = c("Update", "Pairwise", "UnfitPairwise", "UnfitOther")

# Group the data in updates (averaging counts)
pairwise_data = aggregate(data$Pairwise, list(data$Update), mean)
names(pairwise_data) = c("Update", "Pairwise")

# Group the data in updates (averaging counts)
unfit_pairwise_data = aggregate(data$UnfitPairwise, list(data$Update), mean)
names(unfit_pairwise_data) = c("Update", "UnfitPairwise")

# Group the data in updates (averaging counts)
unfit_other_data = aggregate(data$UnfitOther, list(data$Update), mean)
names(unfit_other_data) = c("Update", "UnfitOther")

# Convert updates to generations
generations = pairwise_data$Update * 0.02

# Plot things
plot(generations, pairwise_data$Pairwise, las = 1,
  xlim = c(0, 10000), xaxt = 'n',
  xlab = 'Time (generations)',
  ylim = c(0, 3000),
  ylab = 'Number of hybrids')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 10000, 2500)
axis(X_AXIS, at = xvalues,
labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

points(generations, unfit_pairwise_data$UnfitPairwise, pch = 2)
#points(generations, unfit_other_data$UnfitOther, col = 'red')

updates = sort(unique(data$Update))

# Plot CIs
pairwise_ci = sapply(updates, get_mean_and_ci_pairwise, data)
pairwise_lower = pairwise_ci[1,]
pairwise_upper = pairwise_ci[3,]
unfit_pairwise_ci = sapply(updates, get_mean_and_ci_unfit_pairwise, data)
unfit_pairwise_lower = unfit_pairwise_ci[1,]
unfit_pairwise_upper = unfit_pairwise_ci[3,]

lines(updates * 0.02, pairwise_lower, col = 'gray')
lines(updates * 0.02, pairwise_upper, col = 'gray')
lines(updates * 0.02, unfit_pairwise_lower, col = 'gray', lty = 'dashed')
lines(updates * 0.02, unfit_pairwise_upper, col = 'gray', lty = 'dashed')

# Plot legend
legend(x = 'topleft',
  legend = c('All hybrids w/ pwDMIs', 'Unfit hybrids w/ pwDMIs'),
  bty = 'n',
#  col = c('black', 'blue'),#, 'red'),
#  lty = c('solid', 'solid', 'solid'))
  pch = c(1, 2))#, 1))

# Fine-grained generations for plotting
plot_generations = seq(0, 10000)

# Fit and plot polynomials

quad = nls(pairwise_data$Pairwise ~ a * (generations ^ 2) + b * generations, pairwise_data)
coef(quad)
a = coef(quad)[1]
b = coef(quad)[2]
#lines(plot_generations, a * (plot_generations ^ 2) + b * plot_generations, lty="solid", col = 'red')

dev.off()
