---
title: 'A comparison of official population projections with Bayesian time series forecasts for England and Wales'
author: Guy
date: '2012-05-20'
slug: bayesian-population-forecasts
categories: [forecast,R,BUGS]
tags: [forecastr,BUGS]
---

A paper based on my some work I did with colleagues in the <a href="http://www.cpc.ac.uk/">ESRC Centre for Population Change</a> was published in the the <em>Population Trends</em>. We fitted a range of time series models (including some volatility models) to population change data for England and Wales, calculated the posterior model probabilities and then projected from the model averaged posterior predictive distributions. We found our volatility models were heavily supported. Our median matches very closely the Office of National Statistics mid scenario. It's a tad surprising that projections based on forecasts of a single annual growth rate per year give a similar forecast to the ONS cohort component projection which are based on hundreds of future age-sex specific fertility, mortality and net migration rates. The ONS do not provide any form probabilistic uncertainty, instead the give a expert based high and low scenario, which roughly calibrated to our 50% prediction interval in 2033. I ran all the models in BUGS and did the fan chart plots in R. 

**Publication Details:**

Abel, G.J., Bijak, J. and Raymer J. (2010). <a href="http://www.palgrave-journals.com/pt/journal/v141/n1/pdf/pt201023a.pdf">A comparison of official population projections with Bayesian time series forecasts for England and Wales</a>. <em>Population Trends</em>, 141, 95–114.

We compare official population projections with Bayesian time series forecasts for England and Wales. The Bayesian approach allows the integration of uncertainty in the data, models and model parameters in a coherent and consistent manner. Bayesian methodology for time-series forecasting is introduced, including autoregressive (AR) and stochastic volatility (SV) models. These models are then fitted to a historical time series of data from 1841 to 2007 and used to predict future population totals to 2033. These results are compared to the most recent projections produced by the Office for National Statistics. Sensitivity analyses are then performed to test the effect of changes in the prior uncertainty for a single parameter. Finally, in-sample forecasts are compared with actual population and previous official projections. The article ends with some conclusions and recommendations for future work.