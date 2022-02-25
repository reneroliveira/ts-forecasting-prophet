library(prophet)

get_interval_width = function(df,h=365,tau = 0.05){
  m <- prophet(df,changepoint.prior.scale=tau)
  future <- make_future_dataframe(m, periods = h)
  forecast <- predict(m, tail(future,h))
  forecast$width = forecast$yhat_upper-forecast$yhat_lower
  return(forecast$width)
}

phi_prophet = function(y,h){
  df = data.frame('ds'=as.Date(index(y)),'y'=y)
  m = prophet(df)
  future <- make_future_dataframe(m, periods = h,freq='month') %>% tail(1)
  forecast <- predict(m, future)
  return(forecast[,'yhat'])
}
phi_arima = function(y,h){
  m = auto.arima(y,max.p=10,max.q=10,seasonal = F)
  fr = forecast::forecast(m,h=h)
  return(fr)
}
phi_sarima = function(y,h){
  m = auto.msarima(y,orders = list(ar=c(8,8),i=c(2,1),ma=c(3,3),lags=c(1,3),h=20))
}

