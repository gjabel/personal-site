library(tidyverse)
# library(treemap)
library(treemapify)
library(wpp2019)
library(countrycode)
library(emo)


data("pop")
data("popproj")
data("UNlocations")

d <- pop  %>%
  left_join(popproj) %>%
  left_join(UNlocations) %>%
  as_tibble()
d

d <- d %>%
  filter(location_type == 4) %>%
  mutate(
    flag = countrycode(sourcevar = country_code, 
                       origin = "iso3n", 
                       destination = "unicode.symbol"),
    alpha3 = countrycode(sourcevar = country_code, 
                         origin = "iso3n", 
                         destination = "iso3c")
  ) %>%
  select(-contains("code"), -location_type, -tree_level) %>%
  pivot_longer(cols = "1950":"2100", names_to = "year", values_to = "pop")
d

d %>%
  filter(year == 1950) %>%
  ggplot(mapping = aes(area = pop, fill = reg_name, 
                       label = alpha3, subgroup = area_name)) +
  geom_treemap() +
  guides(fill = FALSE) +
  geom_treemap_subgroup_border() +
  # geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5, colour =
  #                              "black", fontface = "italic", min.size = 0) +
  # theme(text=element_text(family="Helvetica")) + 
  geom_treemap_text(colour = "white", place = "topleft", 
                    reflow = T)
family="EmojiOne")

