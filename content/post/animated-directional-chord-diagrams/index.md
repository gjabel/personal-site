---
title: R code for animated directional chord diagrams
# subtitle: Learn how to build animated chord diagrams in R

# Summary for listings and search engines
# summary: Welcome 👋 We know that first impressions are important, so we've populated your new site with some initial content to help you get familiar with everything in no time.

# Link this post with a project
projects: []

# Date published
date: '2018-04-18'

# Date updated
# lastmod: "2020-12-13T00:00:00Z"

# Is this an unpublished draft?
draft: false

# Show this page in the Featured widget?
featured: false

# Featured image
# Place an image named `featured.jpg/png` in this page's folder and customize its options here.

# if want wide featured images, use header below... and then
# pass the featured image to the posts page

# focal_point options: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight

image:
  # placement: 3
  # focal_point: ""
  # caption: '[Global Migration Flow Estimates](http://guyabel.com/publication/global-migration-estimates-by-gender/)'
  preview_only: true

authors:
- admin

tags:
- Academic

categories: 
  - "R"
  - "migration"
  - "chord diagram"
  - "r-bloggers"
  
header:
  image: "headers/animated-directional-chord-diagrams.png"
  caption: '[Global Migration Flow Estimates](http://guyabel.com/publication/global-migration-estimates-by-gender/)'

toc: true
---



## Background

A little while ago my paper in *International Migration Review* on global migration flow estimates came out [online](http://guyabel.com/publication/global-migration-estimates-by-gender/). The paper includes a number of directional chord diagrams to visualize the estimates.

Recently I have been playing around `tweenr` and the `magick` packages for animated population pyramids. In this post I attempt to show how to use these packages to produce animated directional chord diagrams of global migration flow estimates


## Data

The first step is to read into R two data frames (these are in my `migest` R package if you wish to replicate the code below). 

  1. Time series of bilateral migration flow estimates:

```r
# install.packages("migest")
library(tidyverse)
d0 <- read_csv(system.file("imr", "reg_flow.csv", package = "migest"))
d0 
```

```
## # A tibble: 891 x 4
##    year0 orig_reg     dest_reg                         flow
##    <dbl> <chr>        <chr>                           <dbl>
##  1  1960 Africa       Africa                        1377791
##  2  1960 Africa       Eastern Asia                     5952
##  3  1960 Africa       Eastern Europe & Central Asia    7303
##  4  1960 Africa       Europe                         919252
##  5  1960 Africa       Latin America & Caribbean       15796
##  6  1960 Africa       Northern America                82463
##  7  1960 Africa       Oceania                         32825
##  8  1960 Africa       Southern Asia                   35603
##  9  1960 Africa       Western Asia                   106580
## 10  1960 Eastern Asia Africa                          37301
## # ... with 881 more rows
```

  2. Some regional meta data for chord diagram plots:

```r
d1 <- read_csv(system.file("vidwp", "reg_plot.csv", package = "migest"))
d1
```

```
## # A tibble: 9 x 5
##   region                        order1 col1    reg1           reg2          
##   <chr>                          <dbl> <chr>   <chr>          <chr>         
## 1 Northern America                   1 #40A4D8 Northern       America       
## 2 Africa                             2 #33BEB7 Africa         <NA>          
## 3 Europe                             3 #B2C224 Europe         <NA>          
## 4 Eastern Europe & Central Asia      4 #FECC2F Eastern Europe & Central Asia
## 5 Western Asia                       5 #FBA127 Western        Asia          
## 6 Southern Asia                      6 #F66320 Southern       Asia          
## 7 Eastern Asia                       7 #DB3937 Eastern        Asia          
## 8 Oceania                            8 #A463D7 Oceania        <NA>          
## 9 Latin America & Caribbean          9 #0C5BCE Latin America  & Caribbean
```

## Tween

The next step is to tween the data by migration corridor. 


```r
library(tweenr)

d2 <- d0 %>%
  mutate(corridor = paste(orig_reg, dest_reg, sep = " -> ")) %>%
  select(corridor, year0, flow) %>%
  mutate(ease = "linear") %>%
  tween_elements(time = "year0", group = "corridor", ease = "ease", nframes = 100) %>%
  tbl_df()
```

```
## Warning: `tbl_df()` was deprecated in dplyr 1.0.0.
## Please use `tibble::as_tibble()` instead.
```

```r
d2
```

```
## # A tibble: 8,181 x 4
##    year0    flow .frame .group                                 
##    <dbl>   <dbl>  <int> <chr>                                  
##  1  1960 1377791      0 Africa -> Africa                       
##  2  1960    5952      0 Africa -> Eastern Asia                 
##  3  1960    7303      0 Africa -> Eastern Europe & Central Asia
##  4  1960  919252      0 Africa -> Europe                       
##  5  1960   15796      0 Africa -> Latin America & Caribbean    
##  6  1960   82463      0 Africa -> Northern America             
##  7  1960   32825      0 Africa -> Oceania                      
##  8  1960   35603      0 Africa -> Southern Asia                
##  9  1960  106580      0 Africa -> Western Asia                 
## 10  1960   37301      0 Eastern Asia -> Africa                 
## # ... with 8,171 more rows
```

This creates larger data frame `d2`, with 100 observations for each corridor, one for each frame in the animation. In the original data `d0` there are only 11 observations for each corridor, one for each five-year period. 

Then some further minor data wrangling is required to ready the data for plotting using the `chordDiagram` function; namely the first three columns in the data must correspond to the origin, destination and flow.


```r
d2 <- d2 %>%
  separate(col = .group, into = c("orig_reg", "dest_reg"), sep = " -> ") %>%
  select(orig_reg, dest_reg, flow, everything()) %>%
  mutate(flow = flow/1e06)
d2
```

```
## # A tibble: 8,181 x 5
##    orig_reg     dest_reg                         flow year0 .frame
##    <chr>        <chr>                           <dbl> <dbl>  <int>
##  1 Africa       Africa                        1.38     1960      0
##  2 Africa       Eastern Asia                  0.00595  1960      0
##  3 Africa       Eastern Europe & Central Asia 0.00730  1960      0
##  4 Africa       Europe                        0.919    1960      0
##  5 Africa       Latin America & Caribbean     0.0158   1960      0
##  6 Africa       Northern America              0.0825   1960      0
##  7 Africa       Oceania                       0.0328   1960      0
##  8 Africa       Southern Asia                 0.0356   1960      0
##  9 Africa       Western Asia                  0.107    1960      0
## 10 Eastern Asia Africa                        0.0373   1960      0
## # ... with 8,171 more rows
```


## Plots for Each Frame

Now the data is in the correct format, chord diagrams can be produced for each frame of the eventual GIF. To do this, I used a `for` loop to cycle through the tweend data. The arguments I used in the `circos.par`, `chordDiagram` and `circos.track` functions to produce each plot are explained in more detail in the comments of the `migest` [demo](https://github.com/guyabel/migest/blob/master/demo/cfplot_reg2.R).


```r
# create a directory to store the individual plots
dir.create("./plot-gif/")

library(circlize)
for(f in unique(d2$.frame)){
  # open a PNG plotting device
  png(file = paste0("./plot-gif/globalchord", f, ".png"), height = 7, width = 7, 
      units = "in", res = 500)
  
  # initialise the circos plot
  circos.clear()
  par(mar = rep(0, 4), cex=1)
  circos.par(start.degree = 90, track.margin=c(-0.1, 0.1), 
             gap.degree = 4, points.overflow.warning = FALSE)

  # plot the chord diagram
  chordDiagram(x = filter(d2, .frame == f), directional = 1, order = d1$region,
               grid.col = d1$col1, annotationTrack = "grid",
               transparency = 0.25,  annotationTrackHeight = c(0.05, 0.1),
               direction.type = c("diffHeight", "arrows"), link.arr.type = "big.arrow",
               diffHeight  = -0.04, link.sort = TRUE, link.largest.ontop = TRUE)
  
  # add labels and axis
  circos.track(track.index = 1, bg.border = NA, panel.fun = function(x, y) {
    xlim = get.cell.meta.data("xlim")
    sector.index = get.cell.meta.data("sector.index")
    reg1 = d1 %>% filter(region == sector.index) %>% pull(reg1)
    reg2 = d1 %>% filter(region == sector.index) %>% pull(reg2)
    
    circos.text(x = mean(xlim), y = ifelse(is.na(reg2), 3, 4),
                labels = reg1, facing = "bending", cex = 1.1)
    circos.text(x = mean(xlim), y = 2.75, labels = reg2, facing = "bending", cex = 1.1)
    circos.axis(h = "top", labels.cex = 0.8
                labels.niceFacing = FALSE, labels.pos.adjust = FALSE)
  })
  
  # close plotting device
  dev.off()
}
```

## Creating a GIF

Using the `magick` package a GIF can be created by using the code below to 

 1. Read in an initial plot and then combine together all other images created above.
 2. Scale the combined images.
 3. Animate the combined images and save as a `.gif`.
 

```r
library(magick)

img <- image_read(path = "./plot-gif/globalchord0.png")
for(f in unique(d2$.frame)[-1]){
  img0 <- image_read(path = paste0("./plot-gif/globalchord",f,".png"))
  img <- c(img, img0)
  message(f)
}

img1 <- image_scale(image = img, geometry = "720x720")

ani0 <- image_animate(image = img1, fps = 10)
image_write(image = ani0, path = "./plot-gif/globalchord.gif")
```

This gives an output much like this minus the additional details in the corners:

![ ](abel-ani10-gf-dist.gif)


(might take a few seconds to fully load)

## Fixing Scales in Chord Diagrams

Whilst the plot above allows comparisons of the distributions of flows overtime it is more difficult to compare volumes. For such comparisons, Zuguang Gu [suggests](http://zuguang.de/circlize_book/book/advanced-usage-of-chorddiagram.html#compare-two-chord-diagrams) scaling the gaps between the sectors on the outside of the chord diagram. I wrote a little function that can do this for flow data arranged in a tidy format;


```r
scale_gap <- function(flow_m, flow_max, gap_at_max = 1, gaps = NULL) {
  p <- flow_m / flow_max
  if(length(gap_at_max) == 1 & !is.null(gaps)) {
    gap_at_max <- rep(gap_at_max, gaps)
  }
  gap_degree <- (360 - sum(gap_at_max)) * (1 - p)
  gap_m <- (gap_degree + sum(gap_at_max))/gaps
  return(gap_m)
}
```
where 

* `flow_m` is the size of total flows in the matrix for the given year being re-scaled.
* `flow_max` is the maximum size of the flow matrix over all years
* `gap_at_max` is the size in degrees of the gaps in the flow matrix in the year where the flows are at their all time maximum.
* `gaps` is the number of gaps in the chord diagram (i.e. the number of regions).
  
  
The function can be used to derive the size of gaps in each frame for a new animated GIF.

```r
d3 <- d2 %>%
  group_by(.frame) %>%
  summarise(flow = sum(flow)) %>%
  mutate(gaps = scale_gap(flow_m = flow, flow_max = max(.$flow), 
                          gap_at_max = 4, gaps = 9))

d3
```

```
## # A tibble: 101 x 3
##    .frame  flow  gaps
##     <int> <dbl> <dbl>
##  1      0  17.6  25.9
##  2      1  17.8  25.7
##  3      2  18.1  25.6
##  4      3  18.3  25.4
##  5      4  18.5  25.2
##  6      5  18.7  25.1
##  7      6  18.9  24.9
##  8      7  19.1  24.7
##  9      8  19.3  24.6
## 10      9  19.6  24.4
## # ... with 91 more rows
```

The calculations in `d3` can then be plugged into the `for` loop above, where the `circos.par()` function is replaced by


```r
circos.par(start.degree = 90, track.margin = c(-0.1, 0.1),
           gap.degree = filter(d3, .frame == f)$gaps, 
           points.overflow.warning = FALSE)
```

Once the for loop has produced a new set of images, the same code to produce the GIF file can be run to obtain the animated chord diagrams with changing gaps;

![ ](abel-ani10-gf-gap.gif)

Whilst the sector axes are now fixed, I am not convinced that changing the relative gaps is the best way to compare volumes when using animated chord diagrams. The sectors of all regions - bar Northern America - are rotating making it hard follow their changes over time. 

Fortunately there is new `xmax` option in `chordDiagram` that can be used to fix the lengths of the x-axis for each sector using a named vector. In the context of producing an animation, the historic maximum migration flows (of combined immigration and emigration flows) in each region can be used, calculated from the original data `d0`


```r
library(magrittr)

reg_max <- d0 %>%
  group_by(year0, orig_reg) %>%
  mutate(tot_out = sum(flow)) %>%
  group_by(year0, dest_reg) %>%
  mutate(tot_in = sum(flow)) %>%
  filter(orig_reg == dest_reg) %>%
  mutate(tot = tot_in + tot_out) %>%
  mutate(reg = orig_reg) %>%
  group_by(reg) %>%
  summarise(tot_max = max(tot)/1e06) %$%
  'names<-'(tot_max, reg)

reg_max
```

```
##                        Africa                  Eastern Asia 
##                     17.429942                     14.805479 
## Eastern Europe & Central Asia                        Europe 
##                      8.361300                     15.536978 
##     Latin America & Caribbean              Northern America 
##                      7.697638                     10.416927 
##                       Oceania                 Southern Asia 
##                      2.968412                     15.067631 
##                  Western Asia 
##                     15.072561
```

The `reg_max` object can then be used in the `chordDiagram` function in the `for` loop above, replacing the original call with 


```r
chordDiagram(x = filter(d2, .frame == f), directional = 1, order = d1$region,
             grid.col = d1$col1, annotationTrack = "grid",
             transparency = 0.25,  annotationTrackHeight = c(0.05, 0.1),
             direction.type = c("diffHeight", "arrows"), link.arr.type = "big.arrow",
             diffHeight  = -0.04, link.sort = TRUE, link.largest.ontop = TRUE, 
             xmax = reg_max)
```

Running the complete code - the adapted `for` loop to produce the images and then the `magick` functions to compile the GIF - results in the following animation:

![ ](abel-ani10-gf-fix.gif)

