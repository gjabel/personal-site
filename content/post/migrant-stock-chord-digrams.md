---
title: "Regional Migrant Stock Chord Diagrams"
author: "Guy Abel"
date: '2018-11-14'
tags:
- migration
- chord diagram
header:
  image: "headers/stocks-ani-cd0.png"
---

During the last few months I have given some introductory talks on international migration in Asia and Europe. I had a couple of requests to share the animated chord diagrams that I created for others to use in their teaching materials. These are below, along with some extra plots for Africa, the Americas (Northern, Central and Southern America as well as the Caribbean) and Oceania.

The chords in the diagrams represent the connection between the places of birth (at the base of the chord) and places of residence (at the arrow head of the chord). The width of based of the chords correspond to the size of the migrant population in millions. Chords are ordered relative to their size, with the largest migrant stocks plotted at the beginning of the country segments. The ordering of chords jumps around over time as the relative rankings of the largest foreign-born populations change in each country. Values for the migrant population sizes are from the ~~2017~~ ~~2019~~ 2020 revision of the United Nations DESA [International Migrant Stock Data](https://www.un.org/development/desa/pd/content/international-migrant-stock). 

Note: you might have to right click, select show controls and hit play to start the animations depending on your browsers - right clicking can also allow you to access controls on the play back speed.

<!-- ![ ](/img/anigif_original-14120-1449691023-4-2.mp4) -->

<video loop="loop" width="720" height="720" poster="/img/ims-abel-asia.png" controls>
  <source src="/img/ims-abel-asia.mp4" type="video/mp4" />
</video>

<video loop="loop" width="720" height="720" poster="/img/ims-abel-europe.png" controls>
  <source src="/img/ims-abel-europe.mp4" type="video/mp4" />
</video>

<video loop="loop" width="720" height="720" poster="/img/ims-abel-africa.png" controls>
  <source src="/img/ims-abel-africa.mp4" type="video/mp4" />
</video>

<video loop="loop" width="720" height="720" poster="/img/ims-abel-america.png" controls>
  <source src="/img/ims-abel-america.mp4" type="video/mp4" />
</video>
  
<video loop="loop" width="720" height="720" poster="/img/ims-abel-oceania.png" controls>
  <source src="/img/ims-abel-oceania.mp4" type="video/mp4" />
</video>
  
<!-- ![ ](/img/abel-asia-ani10.gif) -->

<!-- ![ ](/img/abel-europe-ani10.gif) -->

<!-- ![ ](/img/abel-africa-ani10.gif) -->

<!-- ![ ](/img/abel-americas-ani10.gif) -->

The data in these plots represent migrant population totals, not period migration flows, hence the usual caveats associated with migrant stock data apply:

- Underlying migration flows might form different patterns as migrants might not be moving from their country of birth.
- Migrant populations can decrease from deaths as well as outward migration.

As in my previous post on [animated chord diagrams](http://guyabel.com/post/animated-directional-chord-diagrams/) I used the [`circlize`](https://cran.r-project.org/web/packages/circlize/index.html) package in R to produce each chord diagrams for each frame of the animation and [`tweenr`](https://cran.r-project.org/web/packages/tweenr/index.html) for the intermediate data. The country flags were added using the `circos.raster()` function in circlize. I used [`magick`](https://cran.r-project.org/web/packages/magick/index.html) to read in the multipage PDF file of plots over time and [`animation`](https://cran.r-project.org/web/packages/animation/index.html) to produce the MP4 file. I am beginning to prefer MP4 files to GIF as the file size are smaller - so quicker loading - and most browsers display MP4 videos with controls.
