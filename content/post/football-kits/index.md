---
title: Animating the evoloution of football kits using R
# subtitle: Learn how to build animated chord diagrams in R

# Summary for listings and search engines
# summary: Welcome 👋 We know that first impressions are important, so we've populated your new site with some initial content to help you get familiar with everything in no time.

# Link this post with a project
projects: []

# Date published
date: '2018-06-05'

# Date updated
# lastmod: "2020-12-13T00:00:00Z"

# Is this an unpublished draft?
draft: false

# Show this page in the Featured widget?
featured: false

# Featured image 
# Place an image named `featured.jpg/png` in this page's folder and customize its options here.
# focal_point options: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight

# if want wide featured images, use header below... and then
# pass the featured image to the posts page

image:
  preview_only: true

authors:
- admin

# tags:
# - Academic

categories: 
  - "R"
  - "r-bloggers"
  - "football"
  
# header:
#   image: "headers/wc1990.png"
#   caption: '[Global Migration Flow Estimates](http://guyabel.com/publication/global-migration-estimates-by-gender/)'

toc: true
---




## Background

I'm loving the [magick](https://cran.r-project.org/web/packages/magick/) package at the moment. Reading through the [vignette](https://cran.r-project.org/web/packages/magick/vignettes/intro.html) I spotted the `image_morph()` function. In this post I experiment with the function to build the GIF below that shows the changes in the England football first kit over time, using images from the excellent [Historical Football Kits](http://www.historicalkits.co.uk/) website.

![ ](abel-england.gif)

## Scraping

The Historical Football Kits website has a detailed section on England kits spread over six pages, starting from the first outfits used in [1872](http://www.historicalkits.co.uk/international/england/england-1872-1939.html). Each pages includes some interesting discussion - and importantly for this post - images of the kits.

We can use the `read_html()` from the [xml2](https://cran.r-project.org/web/packages/xml2/) package and `map()` from [purrr](https://cran.r-project.org/web/packages/purrr) to read and save the source code of each page.

```r
library(rvest)
library(tidyverse)

htmls <- c( 
  "http://www.historicalkits.co.uk/international/england/england-1872-1939.html",
  "http://www.historicalkits.co.uk/international/england/england-1946-1960.html",
  "http://www.historicalkits.co.uk/international/england/england-1960-1983.html",
  "http://www.historicalkits.co.uk/international/england/england-1984-1997.html",
  "http://www.historicalkits.co.uk/international/england/england-1997-2010.html",
  "http://www.historicalkits.co.uk/international/england/england-2010-2019.html"
) %>%
  map(read_html)
```

From the source code we can then find the URLs of each kit image files using `html_nodes()` and `html_attr()` from [rvest](https://cran.r-project.org/web/packages/rvest/). I used purrr's `map_dfr()` to store the links in a tibble and then dropped rows that do not contain kit image links or are images of away kits, kits used in single game or links to shops to buy replicas. This filtering was based on the image label or image URL and performed with the aid of the `str_detect()` function from [stringr](https://cran.r-project.org/web/packages/stringr/).


```r
scrape_img_url <- function(html){
  html %>%
    html_nodes(".float p , .float img") %>%
    html_attr("src") %>%
    as_tibble() %>%
    set_names("img_url") %>%
    mutate(label = html %>% 
             html_nodes(".float p , .float img") %>%
             html_text() %>%
             c(., NA) %>%
             .[-1])
}

d1 <- htmls %>% 
  map_dfr(scrape_img_url) %>%
  filter(str_detect(string = img_url, pattern = "/international/england"),
         !str_detect(string = label, pattern = "change|alternate|Alternate|Change"),
         !str_detect(string = label, pattern = " v |Third"),
         !str_detect(string = img_url, pattern = "lithuania|italy|yellow|red"))
```




```r
head(d1)
```

```
##                                               img_url     label
## 1      /international/england/images/england-1872.gif      1872
## 2      /international/england/images/england-1882.gif 1879-1900
## 3      /international/england/images/england-1900.gif 1900-1914
## 4 /international/england/images/england-1920-1932.gif 1920-1930
## 5      /international/england/images/england-1921.gif 1930-1934
## 6      /international/england/images/england-1934.gif      1934
```

Given these URLs I then downloaded each of the images which are stored in a single R object `kits`


```r
library(magick)

kits <- d1 %>%
  mutate(img_url = paste0("http://www.historicalkits.co.uk", img_url),
         img_url = str_replace(string =img_url, pattern =" ", replacement = "%20")) %>%
  select(img_url) %>%
  map(image_read) %>%
  set_names("img")
```

Typing `kits` into R will display each kit in the RStudio viewer (it will quickly run through each image). The console displays summary information for each image in the `kits` object.


```r
> kits
$img
   format width height colorspace filesize
1     GIF   170    338       sRGB        0
2     GIF   170    338       sRGB        0
3     GIF   170    338       sRGB        0
4     GIF   170    338       sRGB        0
5     GIF   170    338       sRGB        0
6     GIF   170    338       sRGB        0
7     GIF   170    338       sRGB        0
8     GIF   170    338       sRGB        0
9     GIF   170    338       sRGB        0
10    GIF   170    338       sRGB        0
```

## Annotating Images

Before creating any GIF I wanted add annotations for the year and the copyright information. To do this I first created a border using `image_border()` in magick and then `image_annotate()` to add the text. I wrapped these edits into an `add_text()` function and then applied each to the kit images.


```r
add_text <- function(img, label){
  img %>%
    image_border(geometry = "10x60", color = "white") %>%
    image_chop("0x45") %>%
    image_annotate(text = label, gravity = "north") %>%
    image_annotate(
      text = "Animation by @guyabelguyabel", gravity = "south", location = "+0+45"
    ) %>%
    image_annotate(
      text = "Images are Copyright of Historical\nFootball Kits and reproduced by\nkind permission.",
      gravity = "south"
    )
}

for(i in 1:length(kits$img)){
  kits$img[i] <- add_text(img = kits$img[i], label = d1$label[i])
  # add extra border to make final images square
  kits$img[i] <- image_border(image = kits$img[i], geometry = "85x1", color = "white")
}
```

## Creating a GIF

The final step was to bind together the set of images in an animated GIF with smooth transition images between each frame. To do this I used the `image_morph()` twice. First to repeat the same image so that the GIF would remain stable for a few frames (`kits_morph1` below). Then again to create a set of morphing images between successive kits (`kits_morph0` below). The full set of frames were stored in `kits_ani`


```r
kits_ani <- image_morph(c(kits$img[1], kits$img[1]), frames = 4)
for(i in 2:length(kits$img)){
  kits_morph0 <- image_morph(c(kits$img[i-1], kits$img[i]), frames = 4)
  kits_morph1 <- image_morph(c(kits$img[i], kits$img[i]), frames = 4)
  kits_ani <- c(kits_ani, kits_morph0)
  kits_ani <- c(kits_ani, kits_morph1)
}
```

To create an animation I passed the set of frames in the `kits_morph` object to the `image_animate()` and `image_write()` functions to give the image above. 


```r
kits_ani %>%
  image_animate(fps = 10) %>%
  image_write(path = "england.gif")
```

This bit of code can take a while to execute if the are many frames (see my comments towards the end of the post).

## Club Teams

Similar code as above can be used to create images for club teams. I tried this out for the mighty Reading. As the Reading kits on [Historical Football Kits](http://www.historicalkits.co.uk/Reading/Reading.htm) are on only one page and includes only home kits, finding the image URLs was much easier...


```r
d1 <- read_html("http://www.historicalkits.co.uk/Reading/Reading.htm") %>%
  scrape_img_url() %>%
  filter(str_detect(string = img_url, pattern = "/Reading"),
         !str_detect(string = img_url, pattern = "unknown")) %>%
  mutate(
    label = str_replace_all(string = label,
                            pattern = "[:alpha:]|\\s", 
                            replacement = "")
  )
```

I could then run the same code as above to scrape the images, annotate the year and copyright information and build the GIF. 

![ ](abel-reading.gif)

Ian Holloway - [we had hoops first](https://www.getreading.co.uk/news/reading-berkshire-news/sky-sports-pundit-ian-holloway-12023342).

I did have trouble creating a GIF's when I used more frames to morph images between successive kits, for example when using `frames = 10` in `image_morphi()`. I could not consistently replicate the error, but I suspect it is something related to the memory size - my R session would freeze when passing `image_animate()` or `image_write()` on the `kits_ani` R object when it contained a large number of images.
