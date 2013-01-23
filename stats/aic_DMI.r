# Read DMI data
data = read.table('../DMIs/DMIs_type-better/pairwise_counts.txt', header = F)
#data = read.table('../DMIs/DMIs_type-better/pairwise_ancestral_counts.txt', header = F)
#data = read.table('../DMIs/DMIs_type-better/pairwise_parental_counts.txt', header = F)
names(data) = c('Update', 'DMIs')

# Scale down updates (otherwise, there are problems estimating parameters)
data$Update = data$Update / 10000

#data = data[data$Update > 25,]

library(bbmle)

# Note: Starting values obtained by fitting a least squares model in Excel

linear_model =
  mle2(DMIs ~ dpois(lambda = a * Update),
  start = list(a = 0.1), data = data, method = 'Nelder-Mead')
summary(linear_model)

quadratic_model =
  mle2(DMIs ~ dpois(lambda = a * Update^2 + b * Update),
  start = list(a = 4e-3, b = 0.1),
  data = data, method = 'Nelder-Mead')
quadratic_model

AICtab(linear_model, quadratic_model, weights = T, base = T)
