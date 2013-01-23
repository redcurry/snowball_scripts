# Read unfit hybrid data
data = read.table('/home/carlos/avida/work/experiments/snowball/analysis2/hybrid/hybrid_analysis-10000/hybrid_analysis.txt', header = F)
names(data) = c("Update", "Pairwise", "UnfitPairwise", "UnfitOther")

# Get the number of unfit hybrids
unfit_data = data.frame(data$Update, data$UnfitPairwise + data$UnfitOther)
names(unfit_data) = c("Update", "Unfit")

# Scale down updates (otherwise, there are problems estimating parameters)
unfit_data$Update = unfit_data$Update / 10000

unfit_data = unfit_data[unfit_data$Unfit > 0,]

library(bbmle)

linear_model =
  mle2(Unfit ~ dgamma(shape = s * Update,
    scale = (a * Update) / (s * Update)),
  start = list(s = 2, a = 0.2), data = unfit_data, method = 'Nelder-Mead')
linear_model

quadratic_model =
  mle2(Unfit ~ dgamma(shape = s * Update,
    scale = (a * Update^2 + b * Update) / (s * Update)),
  start = list(s = 2, a = 4e-3, b = 0.1),
  data = unfit_data, method = 'Nelder-Mead')
quadratic_model

AICtab(linear_model, quadratic_model, weights = T, base = T)
