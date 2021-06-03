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
         year %in% c(1950, 2020)) %>%
  arrange(rev(year)) %>%
  mutate(year = as.character(year)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = year)) +
  geom_col(position = "identity") +
  scale_x_continuous(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Year")

d %>%
  filter(name == "World",
         year %in% c(1950, 2020)) %>%
  arrange(rev(year)) %>%
  mutate(year = as.character(year)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = year)) +
  geom_col(position = "dodge") +
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
  labs(x = "Populaton", y = "Age", fill = "Year")

# cant figure out how to do an outline
pyr_fill <- c("transparent", "grey")
pyr_col <- c("black", "transparent")

d %>%
  filter(name == "China",
         year %in% c(1950, 2020)) %>%
  mutate(year = as.character(year),
         year = fct_rev(year)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = year, colour = year)) +
  geom_col(position = "identity", alpha = 0.5) +
  scale_x_continuous(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Year") +
  scale_color_manual(values = c("1950" = "black", "2020" = "red")) +
  scale_fill_manual(values = c("1950" = NA, "2020" = "red")) 
  # scale_fill_manual(values = pyr_fill) +
  # scale_colour_manual(values = pyr_col)




# control y scale labels
# y_lab <- str_subset(string = levels(d$age), pattern = "0")
# y_lab
# d %>%
#   filter(name == "World",
#          year == 1950) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = sex)) +
#   geom_col() +
#   scale_x_continuous(labels = abs) +
#   scale_y_discrete(breaks = y_lab) +
#   labs(x = "Populaton", y = "Age", fill = "Sex")


library(ADRItools)
levels(d$age)
y_lab <- every_other(levels(d$age))
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

  
# add second axis for ages
d %>%
  filter(name == "World",
         year == 1950) %>%
  mutate(age = as.numeric(age)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = sex)) +
  geom_col(orientation = "y") +
  scale_x_continuous(labels = abs) +
  scale_y_continuous(
    breaks = every_other(1:nlevels(d$age)),
    labels = y_lab,
    sec.axis = dup_axis()) +
  labs(x = "Populaton", y = "Age", fill = "Sex")



d %>%
  filter(name == "World",
         year == 1950) %>%
  mutate(age = as.numeric(age)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age, fill = sex)) +
  geom_col(orientation = "y") +
  scale_x_continuous(labels = abs) +
  scale_y_continuous(
    breaks = every_other(1:nlevels(d$age)),
    labels = every_other(levels(d$age)),
    sec.axis = sec_axis(trans = ~(. * -5 + min(d$year) + 5), 
                        name = "Year of Birth")) +
  labs(x = "Populaton", y = "Age", fill = "Sex")





library(ggpol)
d %>%
  filter(name == "World",
         year == 1950) %>%
  mutate(sex = fct_rev(sex)) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
                       y = age)) +
  geom_col() +
  facet_share(facets = "sex", scales = "free_x") +
  scale_x_continuous(labels = abs) +
  labs(x = "", y = "") +
  theme(axis.text.y = element_text(hjust = 0.5))

# labels just on the right, but use strip text for labels??
# d %>%
#   filter(name == "World",
#          year == 1950) %>%
#   mutate(sex = fct_rev(sex)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age)) +
#   geom_col() +
#   facet_share(facets = "sex", scales = "free_x") +
#   scale_x_continuous(labels = abs) +
#   labs(x = "", y = "") +
#   theme(axis.text.y = element_blank(),
#         # axis.ticks = element_blank(),
#         panel.spacing = unit(0, "lines"))

# # labels just on the right, but use strip text for labels??
# g1 <- d %>%
#   filter(name == "World",
#          year == 1950, 
#          sex == "Male") %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age)) +
#   geom_col() +
#   scale_x_continuous(labels = abs, 
#                      expand = expansion(mult = c(0.05, 0))) +
#   labs(x = "Male", y = "") +
#   theme(plot.margin = unit(c(1, -1, 0.5, 1), "lines"))
# 
# g2 <- d %>%
#   filter(name == "World",
#          year == 1950, 
#          sex != "Male") %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age)) +
#   geom_col() +
#   scale_x_continuous(labels = abs, expand = expansion(mult = c(0, 0.05))) +
#   labs(x = "Female", y = "") +
#   theme(axis.text.y = element_blank(), 
#         axis.ticks.y = element_blank(),
#         plot.margin = unit(c(1, 1, 0.5, -1), "lines"))
# library(patchwork)
# g1 + g2

d %>%
  filter(name == "World",
         year == 1950) %>%
  mutate(sex = fct_rev(sex), 
         pop = ifelse(test = sex == "Male", yes = -pop, no = pop)) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col() +
  scale_x_symmetric(labels = abs) +
  theme_bw() +
  coord_cartesian(clip = 'off', ylim = c(1, length(unique(d$age)))) +
  annotate(geom = "text", x = -Inf, y = -1, label = "Male", hjust = 0) + 
  annotate(geom = "text", x = Inf, y = -1, label = "Female", hjust = 1) +
  labs(x = "")
  

g +
  coord_cartesian(clip = 'off', ylim = c(1, length(unique(d$age)))) +
  annotate(geom = "text", x = -Inf, y = -1, label = "Male", hjust = 0) + 
  annotate(geom = "text", x = Inf, y = -1, label = "Female", hjust = 1) +
  labs(x = "")


# equal male and femal axis
library(lemon)
d %>%
  filter(name == "Qatar", 
         year == 2020) %>%
  ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop), 
                     y = age, fill = sex)) +
  geom_col() + 
  scale_x_symmetric(labels = abs) +
  labs(x = "Populaton", y = "Age", fill = "Sex")

# surpless in different shade...
# https://www.reddit.com/r/dataisbeautiful/comments/lmgy4t/oc_animated_demographic_pyramid_of_sweden_18602019/



# line outline rather than bars?

# adding labels

# wic education breakdowns

# # split labels - if facet_share is working, do we need this
# sex_lab <- d %>%
#   filter(name == "World", 
#          year == 1950) %>%
#   group_by(year, sex) %>%
#   summarise(x = max(pop)) %>%
#   ungroup() %>%
#   mutate(x = max(x) * 0.5 * ifelse(sex == "Male", yes = -1, no = 1))
# 
# d %>%
#   filter(name == "World", 
#          year == 1950) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = sex)) +
#   geom_col() + 
#   labs(x = "", y = "Age") +
#   coord_cartesian(clip = "off") +
#   geom_text(data = sex_lab, mapping = aes(label = sex, x = x), y = -1) +
#   guides(fill = FALSE)
# 
# # or at top
# d %>%
#   filter(name == "World", 
#          year == 1950) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = sex)) +
#   geom_col() + 
#   labs(x = "", y = "Age") +
#   coord_cartesian(clip = "off") +
#   geom_text(data = sex_lab, mapping = aes(label = sex, x = x * 1.8), y = 21) +
#   guides(fill = FALSE)
# 

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



#animation
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

