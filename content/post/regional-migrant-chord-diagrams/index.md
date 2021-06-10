---
title: "Regional migrant population changes visualized using animated chord diagrams"
# subtitle: Learn how to build animated chord diagrams in R
# summary: 👋 We know that first impressions are important
date: '2018-11-14'
# lastmod: "2020-12-13T00:00:00Z"
draft: false
featured: false
image:
  preview_only: true
authors:
- admin
categories: 
  - "R"
  - "migration"
  - "chord-diagram"
header:
  image: "headers/regional-migrant-stock-chord-diagrams.png"
  caption: 'Asian bilateral migrant stocks'
toc: true
aliases:
- /post/migrant-stock-chord-digrams/
---

During the last few months I have given some introductory talks on international migration in Asia and Europe. I had a couple of requests to share the animated chord diagrams that I created for others to use in their teaching materials.  These are below, along with some extra plots for Africa, the Americas (Northern, Central and Southern America as well as the Caribbean) and Oceania. Feel free to download the plots using right click over the animation and then `Save Video as` or from [Github](https://github.com/guyabel/personal-site/tree/master/content/post/migrant-stock-chord-digrams).

The chords in the diagrams represent the connection between the places of birth (at the base of the chord) and places of residence (at the arrow head of the chord). The width of based of the chords correspond to the size of the migrant population in millions. Chords are ordered relative to their size, with the largest migrant stocks plotted at the beginning of the country segments. The ordering of chords jumps around over time as the relative rankings of the largest foreign-born populations change in each country. Values for the migrant population sizes are from the ~~2017~~ ~~2019~~ 2020 revision of the United Nations DESA [International Migrant Stock Data](https://www.un.org/development/desa/pd/content/international-migrant-stock). 

Note: you might have to right click, select show controls and hit play to start the animations depending on your browsers - right clicking can also allow you to access controls on the play back speed.

<style>
video {
  /* override other styles to make responsive */
  width: 100%    !important;
  height: auto   !important;
  max-height: 720px
}
h2 {
  color: #fff;
  font-size: 0px;
}
</style>

## Asia
<video loop="loop" width="720" height="720" controls muted playsinline preload="none" poster="ims-abel-asia.png">
  <source src="ims-abel-asia.mp4" type="video/mp4"/>
</video>

<hr>

## Europe
<video loop="loop" width="720" height="720" controls muted playsinline preload="none" poster="ims-abel-europe.png">
  <source src="ims-abel-europe.mp4" type="video/mp4"/>
</video>

<hr>

## Africa
<video loop="loop" width="720" height="720" controls muted playsinline preload="none" poster="ims-abel-africa.png">
  <source src="ims-abel-africa.mp4" type="video/mp4"/>
</video>

<hr>

## Americas
<video loop="loop" width="720" height="720" controls muted playsinline preload="none" poster="ims-abel-america.png">
  <source src="ims-abel-america.mp4" type="video/mp4"/>
</video>

<hr>

## Oceania
<video loop="loop" width="720" height="720" controls muted playsinline preload="none" poster="ims-abel-oceania.png">
  <source src="ims-abel-oceania.mp4" type="video/mp4"/>
</video>

The data in these plots represent migrant population totals, not period migration flows, hence the usual caveats associated with migrant stock data apply:

- Underlying migration flows might form different patterns as migrants might not be moving from their country of birth.
- Migrant populations can decrease from deaths as well as outward migration.

### R code

As in my previous post on [animated chord diagrams](http://guyabel.com/post/animated-directional-chord-diagrams/) I used the [`circlize`](https://cran.r-project.org/web/packages/circlize/index.html) package in R to produce each chord diagrams for each frame of the animation and [`tweenr`](https://cran.r-project.org/web/packages/tweenr/index.html) for the intermediate data. The country flags were added using the `circos.raster()` function in circlize. I used [`magick`](https://cran.r-project.org/web/packages/magick/index.html) to read in the multipage PDF file of plots over time and [`animation`](https://cran.r-project.org/web/packages/animation/index.html) to produce the MP4 file. I am beginning to prefer MP4 files to GIF as the file size are smaller - so quicker loading - and most browsers display MP4 videos with controls.
