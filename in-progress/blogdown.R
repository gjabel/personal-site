# helpful functions for updating blogdown
library(blogdown)

stop_server()
build_site()
serve_site()


new_site(theme = "wowchemy/starter-hugo-academic")
# would not work when did new_site() and then the following...
# install_theme(theme = "wowchemy/starter-hugo-academic")
# install_theme(theme = "gcushen/hugo-academic")


# check_config()
# check_content()
# check_gitignore()
# check_hugo()
# check_netlify()
check_site()


# library(magick)
# kits$img[31] %>% 
#   image_crop(geometry = "x160") %>%
#   image_write("featured.png")
#
# p <- image_read_pdf("F:\\ADRI\\project\\chord-china\\circ_flow_zh.pdf")
# 
# p %>%
#   image_resize("200x200") %>%
#   image_write("featured.png")
#
# p  <- image_read_pdf("F:\\ADRI\\project\\global-bilat-flow\\v5-plot-cd\\fixed_da_pb_closed.pdf", pages = 51)
# image_write(p, "featured.png")

# resize placeholder image to 720 x 720 
library(magick)
library(fs)
library(tidyverse)
# d <- dir_ls("./content/post/global-migrant-stocks/") %>%
# d <- dir_ls("./content/post/animated-sankey/") %>%
d <- dir_ls("./content/post/migrant-stock-chord-digrams/") %>%
  str_subset(".png") %>%
  tibble(f = .) %>%
  mutate(ff = str_remove(string = f, pattern = ".png")) %>%
  filter(!str_detect(string = f, pattern = "featured"))

for(i in 1:nrow(d)){
  p <- image_read(path = d$f[i]) 
  p %>%
    image_resize("720x720") %>%
    image_write(path = paste0(d$ff[i], ".png"))
    # image_write(path = paste0(d$ff[i], "-720.png"))
}
