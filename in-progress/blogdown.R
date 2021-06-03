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
