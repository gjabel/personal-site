---
title: "A near complete guide for creating population pyramids using ggplot"
# subtitle: More players at the Euros are playing their club football abroad than ever before.
# summary: 👋 We know that first impressions are important
date: '2021-06-06'
draft: true
featured: false
authors:
- admin
# tags:
- Academic
image:
  preview_only: true
categories: 
  - "R"
  - "demography"
  - "population pyramids"
  # - "r-bloggers"
  # - "r-weekly"
# header:
#   image: "headers/euro.png"
#   caption: 'Distribution of player at Euro2020'

toc: true
---

Over the last few years  I have been trying to take notes on different styles of population pyramids and reproducing them using ggplot. In this post I give an overview of my code in case anyone wishes to replicate similar plots.

## Data

For the purpose of this blog I am going to the most up to data data from the UN on population age and sex structures provided in the wpp2019 R package. The data cover all countries, so it should be fairly simple to edit the code to replicate plots for different countries. The wpp2019 does not use a tidy data format, so a little data manipulation is required first to get a the population data in a single column, so that it will play nicely with ggplot.


```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --
```

```
## v ggplot2 3.3.3     v purrr   0.3.4
## v tibble  3.1.2     v dplyr   1.0.6
## v tidyr   1.1.3     v stringr 1.4.0
## v readr   1.4.0     v forcats 0.5.1
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
library(wpp2019)
data(popF)
data(popM)

d <- popM %>%
  mutate(sex = "Male") %>%
  bind_rows(popF) %>%
  replace_na(list(sex = "Female")) %>%
  pivot_longer(cols = "1950":"2020", names_to = "year", values_to = "pop000")
d
```

```
## # A tibble: 156,870 x 6
##    country_code name  age   sex   year   pop000
##           <int> <chr> <chr> <chr> <chr>   <dbl>
##  1          900 World 0-4   Male  1950  172420.
##  2          900 World 0-4   Male  1955  207941.
##  3          900 World 0-4   Male  1960  221606.
##  4          900 World 0-4   Male  1965  244985.
##  5          900 World 0-4   Male  1970  267293.
##  6          900 World 0-4   Male  1975  278289.
##  7          900 World 0-4   Male  1980  280164.
##  8          900 World 0-4   Male  1985  302397.
##  9          900 World 0-4   Male  1990  330649.
## 10          900 World 0-4   Male  1995  319726.
## # ... with 156,860 more rows
```

Before plotting I have made a number of additional columns to make plotting much easier, these include

1. Creating `pop` variable that takes negative male values and positive female values. The new variable will enable the placement of male population figures on the left of the plot and females on the right. To my mind, this is the most important manipulation for creating population pyramids in ggplot, as it facilitates the use of a single geom making it far simpler to extend plotting code for facets or animations to compare populations over time or space.  

2. 


```r
d <- d %>%
  mutate(
    pop_m = pop000/1e3,
    pop = ifelse(test = sex == "Male", yes = -pop_m, no = pop_m),
    age = fct_inorder(age), 
    age_mid = as.numeric(age) * 5 - 2.5,
    sex = fct_rev(sex),
    year = as.integer(year)
  ) %>%
  group_by(age, year, country_code) %>%
  mutate(pop_min = ifelse(test = sex == "Male", 
                          yes = -min(pop_m), no = min(pop_m))) %>%
  group_by(year, country_code) %>%
  mutate(pop_max = ifelse(test = sex == "Male", 
                          yes = -max(pop_m), no = max(pop_m))) %>%
  ungroup()
d
```

```
## # A tibble: 156,870 x 11
##    country_code name  age   sex    year  pop000 pop_m   pop age_mid pop_min
##           <int> <chr> <fct> <fct> <int>   <dbl> <dbl> <dbl>   <dbl>   <dbl>
##  1          900 World 0-4   Male   1950 172420.  172. -172.     2.5   -166.
##  2          900 World 0-4   Male   1955 207941.  208. -208.     2.5   -199.
##  3          900 World 0-4   Male   1960 221606.  222. -222.     2.5   -212.
##  4          900 World 0-4   Male   1965 244985.  245. -245.     2.5   -234.
##  5          900 World 0-4   Male   1970 267293.  267. -267.     2.5   -257.
##  6          900 World 0-4   Male   1975 278289.  278. -278.     2.5   -266.
##  7          900 World 0-4   Male   1980 280164.  280. -280.     2.5   -267.
##  8          900 World 0-4   Male   1985 302397.  302. -302.     2.5   -288.
##  9          900 World 0-4   Male   1990 330649.  331. -331.     2.5   -313.
## 10          900 World 0-4   Male   1995 319726.  320. -320.     2.5   -300.
## # ... with 156,860 more rows, and 1 more variable: pop_max <dbl>
```

