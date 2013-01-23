# Read DMI data
data = read.table('../DMIs/DMIs_type-better/pairwise_counts.txt', header = F)
#data = read.table('../DMIs/DMIs_type-better/pairwise_ancestral_counts.txt', header = F)
#data = read.table('../DMIs/DMIs_type-better/pairwise_parental_counts.txt', header = F)
names(data) = c('Update', 'DMIs')

# Scale down updates (otherwise, there are problems estimating parameters)
data$Update = data$Update / 10000

# Necessary for Gamma distribution
data = data[data$DMIs > 0,]

library(bbmle)

# Note: Starting values obtained by fitting a least squares model in Excel

linear_model =
  mle2(DMIs ~ dgamma(shape = s * Update,
    scale = (a * Update) / (s * Update)),
  #start = list(s = 2, a = 0.2), data = data, method = 'Nelder-Mead')
  start = list(s = 1, a = 1), data = data, method = 'Nelder-Mead')
summary(linear_model)

quadratic_model =
  mle2(DMIs ~ dgamma(shape = s * Update,
    scale = (a * Update^2 + b * Update) / (s * Update)),
  start = list(s = 2, a = 4e-3, b = 0.1),
  data = data, method = 'Nelder-Mead')
quadratic_model

AICtab(linear_model, quadratic_model, weights = T, base = T)
