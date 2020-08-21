library(tidyverse)
library(wpp2019)
library(ISOcodes)
data("popF")
data("popM")
data("UNlocations")
data("ISO_3166_1")

as_tibble(ISO_3166_1)

d <- popM %>%
  mutate(sex = "Male") %>%
  bind_rows(popF) %>%
  replace_na(list(sex = "Female")) %>%
  pivot_longer(cols = "1950":"2020", names_to = "year", values_to = "pop") %>%
  mutate(age = fct_inorder(age), 
         name = fct_inorder(name),
         pop = pop/1e3,
         year = as.integer(year)) %>%
  group_by(name, country_code, year, age) %>%
  summarise(pop = sum(pop)) %>%
  group_by(name, country_code, year) %>%
  mutate(pop_prop = pop/sum(pop)) %>%
  left_join(UNlocations) %>%
  filter(location_type == 4, 
         year == 2020) %>%
  select(-contains("agcode")) %>%
  ungroup() %>%
  # mutate(Numeric = formatC(x = country_code, width = 3, flag = "0")) %>%
  # left_join(ISO_3166_1) %>%
  mutate(reg_name = ifelse(area_name == "Oceania", area_name, reg_name), 
         reg_name = ifelse(area_name == "Northern America", area_name, reg_name), 
         #Alpha_3 = fct_inorder(Alpha_3)
         reg_name = fct_inorder(reg_name))

#tfr
# d <- tfr %>%
#     pivot_longer(cols = "1950-1955":"2015-2020", names_to = "period", values_to = "tfr") %>%
#     filter(location_type == 4)
#   mutate(country_code = formatC(countr)) %>%
#     group_by(country_code, name, year, sex)
#   left_join(UNlocations) %>%
#     filter(location_type == 4, 
#            year == 2020) %>%
    
  


d %>% 
  pull(name) %>%
  unique() %>%
  abbreviate(minlength = 15) 

ISO_3166_1 %>%
  pull(Common_name) %>%

library(ggforce)
g <- ggplot(data = d, 
       mapping = aes(x = age, y = fct_rev(name), fill = pop_prop)) +
  geom_tile(colour = "black") + 
  facet_col(facets = "reg_name", scales = "free", space = "free", strip.position = "right") +
            # labeller = label_wrap_gen(width = 10)) +
  scale_fill_viridis_c() +
  labs(fill = "Proportion of\nPopulation") + 
  # theme_bw(base_size = 3) + 
  theme(strip.text.y = element_text(angle = 0), 
        axis.text.x = element_text(angle = 45, hjust = 1), 
        axis.title = element_blank()) 

# g <- last_plot()
ggsave("temp.pdf", g, width = 2, height = 10, units = "in")
ggsave("temp.pdf", g, width = 2, height = 10, units = "in", scale = 4)
file.show("temp.pdf")

library(rayshader)
library(rayrender)
plot_gg(ggobj = g, multicore=TRUE, width=8, height=40, zoom = 0.25)
render_camera(theta = 0, phi = -45, zoom = 0.25)
render_movie("temp")

