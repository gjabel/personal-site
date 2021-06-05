library(tidyverse)
library(wpp2019)
data(popF)
data(popM)

d <- popM %>%
  mutate(sex = "Male") %>%
  bind_rows(popF) %>%
  replace_na(list(sex = "Female")) %>%
  pivot_longer(cols = "1950":"2020", names_to = "year", values_to = "pop000")

d <- d %>%
  mutate(year = as.integer(year), 
         age = fct_inorder(age), 
         age_mid = as.numeric(age) * 5 - 2.5,
         sex = fct_rev(sex),
         pop_m = pop000/1e3,
         pop = ifelse(test = sex == "Male", yes = -pop_m, no = pop_m)) %>%
  group_by(age, year, country_code) %>%
  mutate(pop_min = ifelse(test = sex == "Male", yes = -min(pop_m), no = min(pop_m))) %>%
  group_by(year, country_code) %>%
  mutate(pop_max = ifelse(test = sex == "Male", yes = -max(pop_m), no = max(pop_m))) %>%
  ungroup()
d


# initial
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col() + 
  scale_x_continuous(labels = abs)


# when x is numeric then need to set orientation = "y"
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age_mid)) +
  geom_col(orientation = "y") + 
  scale_x_continuous(labels = abs)

# outline
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col(fill = "transparent", colour = "black") + 
  scale_x_continuous(labels = abs)


# geom_step need to use coord_flip, numeric age and include group
# -2.5 to get first age group to rest on horzontal axis
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(y = pop, x = age_mid - 2.5, group = sex)) +
  geom_step() +
  coord_flip() 

# geom_path, need to include group, and make sure data is order
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age_mid - 2.5, group = sex)) +
  geom_path() +
  scale_x_continuous(labels = abs) 

## 
## axis 
##

# every other label
library(wcde)
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col() + 
  scale_x_continuous(labels = abs) +
  scale_y_discrete(breaks = every_other(levels(d$age)))

# add second axis for ages
# dup_axis can not be used for scale_y_discrete, so have to use
# numeric y
d %>%
  filter(name == "China",
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age_mid)) +
  geom_col(orientation = "y") + 
  scale_x_continuous(labels = abs) +
  scale_y_continuous(sec.axis = dup_axis())

# secondary axis as year of birth 
d %>%
  filter(name == "China",
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age_mid)) +
  geom_col(orientation = "y") + 
  scale_x_continuous(labels = abs) +
  scale_y_continuous(
    sec.axis = sec_axis(trans = ~(2020 - . ), 
                        name = "Year of Birth")) 

# share age axis using facet_share in ggpol
# need to reverse factor order to put males on left
# need to set scales to free_x so x limits in each male (female)
# facet do not cover positive (negative) values
# not sure what the fix is for the age label straying so far away
library(ggpol)
d %>%
  filter(name == "China",
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col() +
  facet_share(facets = "sex", scales = "free_x") +
  scale_x_continuous(labels = abs) 


# labelling axis
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col() + 
  scale_x_continuous(labels = abs) +
  labs(x = "Population", y = "Age")



##
## labeling sex
##
# use fill
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age, fill = sex)) +
  geom_col() + 
  scale_x_continuous(labels = abs)

# facets for each sex
# set panel.spacing.x to zero to join facets together
# set expand in scale_x_continuous to c(0, 0) to remove
#  space between facet window and data
# add geom_vline to show split between male and female clearly
# add geom_blank to add some extra space between biggest population 
#  group and y-axis -- the expand in scale_x_continous revoved the
#  excess space
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col() +
  geom_vline(xintercept = 0, colour = "black") +
  geom_blank(mapping = aes(x = pop_max * 1.05)) +
  scale_x_continuous(labels = abs, expand = c(0, 0)) +
  facet_wrap(facets = "sex", scales = "free_x") +
  theme(panel.spacing.x = unit(0, "pt"))

# labels below the x-axis
# set strip.position = "bottom"
# set strip.background to transparent
# set margins of strip text to zero
d %>%
  filter(name == "China", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  geom_col() +
  geom_vline(xintercept = 0, colour = "black") +
  geom_blank(mapping = aes(x = pop_max * 1.05)) +
  scale_x_continuous(labels = abs, expand = c(0, 0)) +
  facet_wrap(facets = "sex", scales = "free_x", strip.position = "bottom") +
  theme(panel.spacing.x = unit(0, "pt"),
        strip.placement = "outside",
        strip.background = element_rect(fill = "transparent"),
        strip.text.x = element_text(margin = margin( b = 0, t = 0)))


##
## sex balances
##
# https://www.reddit.com/r/dataisbeautiful/comments/lmgy4t/oc_animated_demographic_pyramid_of_sweden_18602019/
d %>%
  filter(name == "China", 
         year == 2020) %>%
  select(-pop000, -pop_m, -pop_max) %>%
  pivot_longer(cols = contains("pop"), names_to = "part", values_to = "pop", names_prefix = "pop_") %>%
  mutate(part = ifelse(part == "mod", "Surpluss", part)) %>%
  ggplot(mapping = aes(x = pop, y = age, fill = part)) +
  geom_col(position = "identity") +
  scale_x_continuous(labels = abs) +
  scale_fill_manual(breaks = "Excess", 
                    values = c( "darkgrey", "grey50"),
                    name = "")

# use qatar to illustrate symmettic axis
library(lemon)
d %>%
  filter(name == "Qatar", 
         year == 2020) %>%
  ggplot(mapping = aes(x = pop, y = age, fill = sex)) +
  geom_col() + 
  scale_x_symmetric(labels = abs)

##
## multiple pyramids
##

# using pop allows display of time series in facet
# a lot more complicated if use geom_col or geom_bar for subsets
# for each sex
d %>%
  filter(name == "China", 
         year %in% c(1950, 1985, 2020)) %>%
  ggplot(mapping = aes(x = pop, y = age)) +
  facet_wrap(facets = "year") +
  geom_col() + 
  scale_x_continuous(labels = abs)

# d %>%
#   filter(name == "World", 
#          year == 1950) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop), 
#                      y = age, fill = sex)) +
#   geom_col() + 
#   scale_x_continuous(labels = abs) +
#   labs(x = "Populaton", y = "Age", fill = "Sex")


# # ifelse allows display of timme series in facet / every other age label
# d %>%
#   filter(name == "World", 
#          year %in% c(1950, 1985, 2020)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop), 
#                        y = age, fill = sex)) +
#   facet_wrap(facets = "year") +
#   geom_col() + 
#   scale_x_continuous(labels = abs) +
#   labs(x = "Populaton", y = "Age", fill = "Sex")

d %>%
  filter(name == "China", 
         year %in% c(1950, 1985, 2020)) %>%
  arrange(rev(year)) %>%
  mutate(year = as.character(year)) %>%
  ggplot(mapping = aes(x = pop, y = age, fill = year)) +
  geom_col(position = "identity", alpha = 0.6) +
  scale_x_continuous(labels = abs)

# adding shading for more than a few years can be difficult
# to view when some population age groups shrink
# but can work well for countries where age groups are 
# are continuously growing
d %>%
  filter(name == "Kenya",
         year %% 10 == 0) %>%
  arrange(rev(year)) %>%
  ggplot(mapping = aes(x = pop, y = age, fill = year)) +
  geom_col(position = "identity") +
  scale_x_continuous(labels = abs) +
  scale_fill_viridis_c(direction = -1) +
  labs(x = "Populaton", y = "Age", fill = "Year")

# dodge bars, not a particular fan
d %>%
  filter(name == "China", 
         year %in% c(1950, 1985, 2020)) %>%
  arrange(rev(year)) %>%
  mutate(year = as.character(year)) %>%
  ggplot(mapping = aes(x = pop, y = age, fill = year)) +
  geom_col(position = "dodge") +
  scale_x_continuous(labels = abs)

# outlines
d %>%
  filter(name == "China", 
         year %in% c(1950, 1985, 2020)) %>%
  arrange(rev(year)) %>%
  mutate(year = as.character(year)) %>%
  ggplot(mapping = aes(y = pop, x = age_mid - 2.5, 
                       group = interaction(sex, year),
                       # group = sex, 
                       colour = year
                       )) +
  geom_step() +
  coord_flip() 



# do not fill latest data
f <- c("1950" = "transparent", "1985" = "transparent", "2020" = "grey50")
d %>%
  filter(name == "China", 
         year %in% c(1950, 1985, 2020)) %>%
  arrange(rev(year)) %>%
  mutate(year = as.character(year)) %>%
  ggplot(mapping = aes(y = pop, x = age_mid, 
                       fill = year, colour = year,
                       group = interaction(sex, year))) +
  geom_col(position = "identity", colour = "transparent") +
  geom_step(mapping = aes(x = age_mid - 2.5)) +
  coord_flip() +
  scale_fill_manual(values = f) +
  scale_x_continuous(labels = abs)



# add an outline of historical structure
# d %>%
#   filter(name == "World",
#          year %in% c(1950, 2020)) %>%
#   arrange(rev(year)) %>%
#   mutate(year = as.character(year)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = year)) +
#   geom_col(position = "identity") +
#   scale_x_continuous(labels = abs) +
#   labs(x = "Populaton", y = "Age", fill = "Year")

# d %>%
#   filter(name == "World",
#          year %in% c(1950, 2020)) %>%
#   arrange(rev(year)) %>%
#   mutate(year = as.character(year)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = year)) +
#   geom_col(position = "dodge") +
#   scale_x_continuous(labels = abs) +
#   labs(x = "Populaton", y = "Age", fill = "Year")

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


# #Even more colours where there is continuous expansion in all ages.
# #Work out population expansion at each time point
# # only works for countries with positive increases in all pop age groups 
# # between all periods
# d %>%
#   filter(name == "Kenya",
#          year %in% seq(from = 1950, to = 2020, by = 10)) %>%
#   arrange(rev(year)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = year)) +
#   geom_col(position = "identity") +
#   scale_fill_viridis_c() +
#   scale_x_continuous(labels = abs) +
#   labs(x = "Populaton", y = "Age", fill = "Year")

# cant figure out how to do an outline
# pyr_fill <- c("transparent", "grey")
# pyr_col <- c("black", "transparent")

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


# library(ADRItools)
# levels(d$age)
# y_lab <- every_other(levels(d$age))
# y_lab
# 
# d %>%
#   filter(name == "World",
#          year == 1950) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = sex)) +
#   geom_col() +
#   scale_x_continuous(labels = abs) +
#   scale_y_discrete(breaks = (n = 11)) +
#   labs(x = "Populaton", y = "Age", fill = "Sex")
# 
#   
# # add second axis for ages
# d %>%
#   filter(name == "World",
#          year == 1950) %>%
#   mutate(age = as.numeric(age)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = sex)) +
#   geom_col(orientation = "y") +
#   scale_x_continuous(labels = abs) +
#   scale_y_continuous(
#     breaks = every_other(1:nlevels(d$age)),
#     labels = y_lab,
#     sec.axis = dup_axis()) +
#   labs(x = "Populaton", y = "Age", fill = "Sex")

# 
# 
# d %>%
#   filter(name == "World",
#          year == 1950) %>%
#   mutate(age = as.numeric(age)) %>%
#   ggplot(mapping = aes(x = ifelse(test = sex == "Male", yes = -pop, no = pop),
#                        y = age, fill = sex)) +
#   geom_col(orientation = "y") +
#   scale_x_continuous(labels = abs) +
#   scale_y_continuous(
#     breaks = every_other(1:nlevels(d$age)),
#     labels = every_other(levels(d$age)),
#     sec.axis = sec_axis(trans = ~(. * -5 + min(d$year) + 5), 
#                         name = "Year of Birth")) +
#   labs(x = "Populaton", y = "Age", fill = "Sex")
# 




# library(ggpol)
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
#   theme(axis.text.y = element_text(hjust = 0.5))

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
# library(lemon)
# d %>%
#   filter(name == "Qatar",
#          year == 2020) %>%
#   mutate(sex = fct_rev(sex), 
#          pop = ifelse(test = sex == "Male", yes = -pop, no = pop)) %>%
#   ggplot(mapping = aes(x = pop, y = age)) +
#   geom_col() +
#   scale_x_symmetric(labels = abs) +
#   theme_bw() +
#   coord_cartesian(clip = 'off', ylim = c(1, length(unique(d$age)))) +
#   annotate(geom = "text", x = -Inf, y = 20, label = "Male", hjust = 0) + 
#   annotate(geom = "text", x = Inf, y = 20, label = "Female", hjust = 1) +
#   labs(x = "")
#   


# # separate male and female labels
# qat2020 <- d %>%
#   filter(name == "Qatar",
#          year == 2020) %>%
#   mutate(sex = fct_rev(sex), 
#          pop = ifelse(test = sex == "Male", 
#                           yes = -pop, 
#                           no = pop),
#          pop_max = ifelse(test = sex == "Male", 
#                           yes = -max(pop), 
#                           no = max(pop)))
# 
# qat2020_lim <- qat2020 %>%
#   group_by(sex) %>%
#   summarise(m = max(pop)) %>%
#   mutate(m_tot = max(m))

# # geom_blank as facet_wrap and 
# ggplot(data = qat2020, 
#        mapping = aes(x = pop, y = age)) +
#   geom_col() +
#   geom_vline(xintercept = 0, colour = "black") +
#   geom_blank(mapping = aes(x = pop_max * 1.05)) +
#   scale_x_continuous(labels = abs, expand = c(0, 0)) +
#   facet_wrap(~ sex, scales = "free_x") +
#   theme(panel.spacing.x = unit(0, "pt"), 
#         strip.background = element_rect(colour = "black"))


# ggplot(data = qat2020, 
#        mapping = aes(x = pop, y = age)) +
#   geom_col() +
#   geom_vline(xintercept = 0, colour = "black") +
#   geom_blank(mapping = aes(x = pop_max * 1.05)) +
#   scale_x_continuous(labels = abs, expand = c(0, 0)) +
#   facet_wrap(~ sex, scales = "free_x", strip.position = "bottom") +
#   theme(panel.spacing.x = unit(0, "pt"), 
#         strip.background = element_rect(fill = "transparent"),
#         strip.placement = "outside") +
#   labs(x = "")


# equal male and femal axis

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

