
# wic education breakdowns

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
g <- ggplot(data = chn2020,
            mapping = aes(x = pop, y = age)) +
  geom_col() + 
  scale_x_continuous(labels = abs)

g <- last_plot()
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

