library(tidyverse)
library(wpp2019)
data(popF)
data(popM)

d <- popM %>%
  mutate(sex = "Male") %>%
  bind_rows(popF) %>%
  replace_na(list(sex = "Female")) %>%
  pivot_longer(cols = "1950":"2020", names_to = "year", values_to = "pop") %>%
  mutate(age = fct_inorder(age), 
         pop = pop/1e3,
         year = as.integer(year))
d

# w <- d %>%
#   filter(name == "World")
# 
# w1950 <- w %>%
#   filter(year == 1950)
# 
# w2020 <- w %>%
#   filter(year == 2020)

d %>%
  filter(name == "World", 
         year == 1950) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop), 
                     y = age, fill = sex)) +
  geom_col() + 
  scale_x_continuous(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Sex")



# ifelse allows display of timme series in facet / every other age label
d %>%
  filter(name == "World", 
         year %in% c(1950, 1985, 2020)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop), 
                       y = age, fill = sex)) +
  facet_wrap(facets = "year") +
  geom_col() + 
  scale_x_continuous(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Sex")


# add an outline of historical structure
d %>%
  filter(name == "World",
         year %in% c(1950, 1985, 2020)) %>%
  arrange(rev(year)) %>%
  mutate(year = as.character(year)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = year)) +
  geom_col(position = "identity") +
  scale_x_continuous(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Year")


# d %>%
#   filter(name == "World", 
#          year %in% c(1950, 1985, 2020)) %>%
#   # mutate(year = as.character(year)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, alpha = year)) +
#   geom_col(position = "identity") +
#   scale_alpha_continuous(range = c(0.8, 0.4), breaks = c(1950, 1985, 2020)) +
#   scale_x_continuous(labels = abs) +
#   labs(x = "Populaton", y = "Age", fill = "Sex")


#Even more colours where there is continuous expansion in all ages.
#Work out population expansion at each time point
# only works for countries with positive increases in all pop age groups 
# between all periods
d %>%
  filter(name == "Kenya",
         year %in% seq(from = 1950, to = 2020, by = 10)) %>%
  arrange(rev(year)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = year)) +
  geom_col(position = "identity") +
  scale_fill_viridis_c() +
  scale_x_continuous(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Sex")


# control y scale labels
y_lab <- str_subset(string = levels(d$age), pattern = "0")
y_lab

d %>%
  filter(name == "World",
         year == 1950) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = sex)) +
  geom_col() +
  scale_x_continuous(labels = abs) +
  scale_y_discrete(breaks = y_lab) +
  labs(x = "Populaton", y = "Age", fill = "Sex")

  
# add second axis for birth year
y_pos <- str_which(string =  levels(d$age), pattern = "0")
y_pos

d %>%
  filter(name == "World",
         year == 1950) %>%
  mutate(age = as.numeric(age)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = sex)) +
  geom_col() +
  scale_x_continuous(labels = abs) +
  scale_y_continuous(breaks = y_pos,
                     labels = y_lab, 
                     sec.axis = dup_axis()) +
  labs(x = "Populaton", y = "Age", fill = "Sex")

d %>%
  filter(name == "World",
         year == 1950) %>%
  mutate(age = as.numeric(age)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = sex)) +
  geom_col() +
  scale_x_continuous(labels = abs) +
  scale_y_continuous(breaks = y_pos,
                     labels = y_lab, 
                     sec.axis = sec_axis(trans = ~ . * -5 + 1955, 
                                         name = "Year of Birth")) +
  labs(x = "Populaton", y = "Age", fill = "Sex")


# library(ggpol) #facet_share is no longer working
# d %>%
#   filter(name == "World",
#          year == 1950) %>%
#   mutate(sex = fct_rev(sex)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age)) +
#   geom_col() +
#   facet_share(facets = "sex", scales = "free") +
#   scale_x_continuous(labels = abs) +
#   labs(x = "", y = "") +
#   theme(axis.text.y = element_text(hjust = 0.5))



library(lemon)
d %>%
  filter(name == "Qatar", 
         year == 2020) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop), 
                     y = age, fill = sex)) +
  geom_col() + 
  scale_x_symmetric(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Sex")


# split labels
sex_lab <- d %>%
  filter(name == "World", 
         year == 1950) %>%
  group_by(year, sex) %>%
  summarise(x = max(pop)) %>%
  ungroup() %>%
  mutate(x = max(x) * 0.5 * ifelse(sex == "Male", yes = -1, no = 1))

d %>%
  filter(name == "World", 
         year == 1950) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = sex)) +
  geom_col() + 
  labs(x = "", y = "Age") +
  coord_cartesian(clip = "off") +
  geom_text(data = sex_lab, mapping = aes(label = sex, x = x), y = -1) +
  guides(fill = FALSE)

# or at top
d %>%
  filter(name == "World", 
         year == 1950) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = sex)) +
  geom_col() + 
  labs(x = "", y = "Age") +
  coord_cartesian(clip = "off") +
  geom_text(data = sex_lab, mapping = aes(label = sex, x = x * 1.8), y = 21) +
  guides(fill = FALSE)


# plotly
library(plotly)
g <- d %>%
  filter(name == "World", 
         year == 1950) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop), 
                       y = age, fill = sex)) +
  geom_col() + 
  scale_x_continuous(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Sex")

ggplotly(g)


#
d %>%
  filter(name == "World", 
         year == 1950) %>%
  ggplot(mapping = aes(xmin = -male, 
                       xmax = female,
                       ymin = -male, 
                       ymax = female, 
                       fill = as.numeric(fct_inorder(age)))) +
  geom_rect() +
  facet_geo(facets = "name", grid = africa) +
  coord_equal() +
  labs(fill = "age") +
  scale_fill_viridis_c() +
  scale_x_continuous(labels = abs) +
  scale_y_continuous(labels = abs) 
# theme(panel.background = element_rect(fill = NA),
#       panel.ontop = TRUE)

render_snapshot(clear = TRUE)
plot_gg(gg, width = 8, height = 8,  multicore = TRUE, windowsize = c(1000, 1200))

