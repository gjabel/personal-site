library(tidyverse)
library(magick)
library(fs)

d <- 
  tibble(p = dir_ls("./content/post/ggplot-population-pyramids/index_files/figure-html/")) %>%
  mutate(n = str_remove(string = p, pattern = "./content/post/ggplot-population-pyramids/index_files/figure-html/unnamed-chunk-"),
         n = str_remove(string = n, pattern = "-1.png"),
         n = as.numeric(n)) %>%
  arrange(n)

d %>%
  pull(p) %>%
  image_read() %>%
  # image_morph() %>%
  image_animate(delay = 50, optimize = TRUE) %>%
  image_write("./content/post/ggplot-population-pyramids/pyramids.gif")