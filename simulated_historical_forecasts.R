library(forecasts)
library(fpp)
library(magrittr)
library(lubridate)
library(xts)
library(zoo)
source('functions.R')
data(cafe)
dateindex =  sapply(index(cafe),function(x){as.Date(as.yearqtr(x, format = "Q%q/%y"), frac = 1)}) %>% as.Date()
cafe = xts(cafe,order = dateindex) %>% log() #%>% as.ts()

T = length(cafe)
shf_arima = tsCV(cafe,phi_arima,h=20,initial=40)
shf_arima = apply(shf_arima,2,function(x){sqrt(mean(x^2,na.rm=T))})

shf_ets = tsCV(cafe,function(y,h){forecast::forecast(ets(y),h)},h=20,initial=40)
shf_ets = apply(shf_ets,2,function(x){sqrt(mean(x^2,na.rm=T))})

df = data.frame('ds'=as.Date(index(cafe)),'y'=cafe)
m_prophet = prophet(df,yearly.seasonality = F)

df$ds = seq(df$ds[1],length.out=nrow(df),by='1 day')
df.cv = cross_validation(m_prophet,initial=40,horizon=20,period=1,units='days')
df.p <- performance_metrics(df.cv)
shf_prophet = df.p[,c('horizon','rmse')]

shf = list("auto_arima" = shf_arima,
           "ets" = shf_ets,
           'prophet' = shf_prophet)
save(shf,file = 'outputs/shf.rda')
