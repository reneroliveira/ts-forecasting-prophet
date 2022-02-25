library(prophet)
library(magrittr)
source('functions.R')
df <- read.csv('https://raw.githubusercontent.com/facebook/prophet/main/examples/example_wp_log_peyton_manning.csv')
# m <- prophet(df,changepoint.prior.scale=0.001)
# future <- make_future_dataframe(m, periods = 365)
# forecast <- predict(m, future)
# tail(forecast)#[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])
# 
# plot(m, forecast)
# 
# prophet_plot_components(m, forecast)
# plot(m, forecast) + add_changepoints_to_plot(m)

tau_values = c(0.01,0.1,0.2,0.3,0.4,0.5,0.75)
tau_width = lapply(tau_values,
                   function(tau){
                     get_interval_width(df,h=365,tau)
                     }) %>% as.data.frame()
colnames(tau_width) = tau_values


save(tau_width,file="outputs/tau_width.rda")
