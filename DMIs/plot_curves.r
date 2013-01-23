# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: output_file')
  q()
}

output_file = args[1]

# Set up PDF document to output
pdf(file = output_file, width = 5, height = 5.5)

x = seq(0, 100)

# Plot things
plot(x, x ^ 2, las = 1, type = 'l', col = 'blue',
  xlim = c(0, 100), xaxt = 'n',
  xlab = 'Time (generations)',
  ylab = 'Number of DMIs')

lines(x, 0.013 * x ^ 3, col = 'red')

legend(x = 'topleft', bty = 'n',
  legend = c('Quadratic', 'Cubic'),
  col = c('blue', 'red'),
  lty = c('solid', 'solid'))

dev.off()
