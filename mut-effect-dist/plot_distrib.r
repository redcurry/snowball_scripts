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

data = read.table(input_path)

# Setup plot file
pdf(file = output_path, width = 5, height = 4)
par(mar = c(5, 5, 1, 1))

hist(data$V1, breaks = 10,
  main = '', las = 1,
  xlab = 'Relative fitness of mutant')

dev.off()
