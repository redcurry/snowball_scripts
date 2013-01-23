# Get command-line arguments, which must be specified after the '--args' flag
args = commandArgs(T)

if(length(args) < 1)
{
  print('Arguments: input_file output_file')
  q()
}

# First argument is the input file,
# second argument is the output (plot) file
input_path = args[1]
output_path = args[2]

data = read.table(input_path, header = T)

multiplicative = sum(data$Multiplicative)
synergistic = sum(data$Synergistic)
antagonistic = sum(data$Antagonistic)
lethal = sum(data$Lethal)

labels = c('Lethal', 'Synergistic', 'Antagonistic', 'Multiplicative')
data = c(lethal, synergistic, antagonistic, multiplicative)
colors = c('black', 'darkgray', 'lightgray', 'white')

data

# Setup plot file
pdf(file = output_path, width = 8, height = 4)
par(mar = c(2, 2, 2, 2))

pie(data, labels, clockwise = T, col = colors)

dev.off()
