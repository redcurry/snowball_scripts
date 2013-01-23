errorbars = function(x, y, upper, lower)
{
  arrows(x, upper, x, lower, length = 0.1, angle = 90, code = 3)
}

bootstrap_ci_mean = function(data, n = 10000, lower = 0.025, upper = 0.975)
{
  sample_means = replicate(n, mean(sample(data, replace = T)))
  quantiles = quantile(sample_means, probs = c(lower, upper))
  return(quantiles)
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
pdf(file = output_file, width = 3, height = 4)
par(mar = c(5, 5, 1, 1))

# Read data (no column headers)
data = read.table(input_file)
names(data) = c('Fit', 'FitBuffered', 'Unfit', 'UnfitBuffered')

p_fit_buffered = mean(data$FitBuffered / data$Fit)
#p_fit_unbuffered = 1 - p_fit_buffered
p_unfit_buffered = mean(data$UnfitBuffered / data$Unfit)
#p_unfit_unbuffered = 1 - p_unfit_buffered

ci_fit_buffered = bootstrap_ci_mean(data$FitBuffered / data$Fit)
ci_unfit_buffered = bootstrap_ci_mean(data$UnfitBuffered / data$Unfit)

ci_lower = c(ci_fit_buffered[1], ci_unfit_buffered[1])
ci_upper = c(ci_fit_buffered[2], ci_unfit_buffered[2])

ci_lower
ci_upper

height = matrix(c(p_fit_buffered,   p_unfit_buffered),
                  #p_fit_unbuffered, p_unfit_unbuffered),
#                dimnames = list(c('With buffer', 'Without buffer'),
#                                c('Fit', 'Unfit')),
                nrow = 1, ncol = 2, byrow = T)
height

# Plot things
barx = barplot(height,
  names.arg = c('Fit', 'Unfit'),
  las = 1,
  ylim = c(0, 1),
  xlab = 'Hybrid fitness',
  ylab = 'Proportion of hybrids',
  col = c('white'))#, 'white'))
#  legend.text = rownames(height))
#  args.legend = c(x = 'center', bty = 'n'))

errorbars(barx, c(p_fit_buffered, p_unfit_buffered), ci_lower, ci_upper)

dev.off()
