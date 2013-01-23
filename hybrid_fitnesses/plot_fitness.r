get_box = function(x)
{
  s = sample(x, size = 10000, replace = T)
  ci = quantile(s, probs = c(0.025, 0.975))
  c(ci[1], mean(s), ci[2])
}

get_fitness_box = function(update, data)
{
  get_box(data[data$Update == update,]$Fitness)
}

errorbars = function(x, y, upper, lower)
{
  arrows(x, upper, x, lower, length = 0.025, angle = 90, code = 3)
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

initial_fitness = 5.4953

# Read data
data = read.table(input_file, header = T)

# Take means of hybrid fitnesses per update per replicate
data = aggregate(data$Fitness, by = list(data$Replicate, data$Update), mean)
names(data) = c('Replicate', 'Update', 'Fitness')

# Set up PDF document to output
pdf(file = output_file, width = 4, height = 4, useDingbats = F)
par(mar = c(5, 5, 1, 1))

# Set up general plot
plot(0, 0,
  type = 'n', las = 1, xaxt = 'n',
  xlim = c(0, 10000),
  ylim = c(0.9, 1.0),
  xlab = 'Time (generations)',
  ylab = 'Fitness (relative to initial)')

# Draw x-axis with comma separating thousands
X_AXIS = 1
xvalues = seq(0, 10000, 2500)
axis(X_AXIS, at = xvalues,
labels = prettyNum(xvalues, big.mark = ',', preserve.width = 'individual'))

updates = sort(unique(data$Update))

fitness_box = sapply(updates, get_fitness_box, data) / initial_fitness
fitness_lower = fitness_box[1,]
fitness_mean  = fitness_box[2,]
fitness_upper = fitness_box[3,]

fitness_lower
fitness_mean
fitness_upper

lines(updates * 0.02, fitness_mean)

lines(updates * 0.02, fitness_lower, col = 'gray')
lines(updates * 0.02, fitness_upper, col = 'gray')

dev.off()
