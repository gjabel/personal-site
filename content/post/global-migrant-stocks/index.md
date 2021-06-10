---
title: "Animated chord diagrams for global migrant populations"
# subtitle: Learn how to build animated chord diagrams in R
# summary: 👋 We know that first impressions are important
date: '2020-06-20'
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
  image: "headers/global-migrant-stocks.png"
  caption: 'Chord diagram for global bilateral migrant stocks'
toc: true
---


Over the last year or so I have been playing around with different ways of showing changing global bilateral migrant stocks, adapting the animation code I created for the plots for region to region flows in this estimation [paper](https://www.nature.com/articles/s41597-019-0089-3). I am putting them online here in case they are of interest to anyone else. Feel free to download the plots using right click over the animation and then `Save Video as` or from [Github](https://github.com/guyabel/personal-site/tree/master/static/img/cd-stock-global).

## Global migrant populations from 1990 to 2020

The first plot below shows the change over time in the pattern of global migrant stocks. As with the [regional plots](http://guyabel.com/post/migrant-stock-chord-digrams) in my previous post, the chords in the diagrams represent the connection between the places of birth (at the base of the chord) and places of residence (at the arrow head of the chord). The width of based of the chords correspond to the size of the migrant population in millions. Chords are ordered relative to their size, with the largest migrant stocks plotted at the beginning of the region segments. The ordering of chords jumps around over time as the relative rankings of the largest foreign-born populations change in each region. Values for the migrant population sizes are from the ~~2019~~ 2020 revision of the United Nations DESA [International Migrant Stock Data](https://www.un.org/development/desa/pd/content/international-migrant-stock). 

Note: you might have to right click, select show controls and hit play to start the animations depending on your browsers - right clicking can also allow you to access controls on the play back speed.

<style>
.carousel-indicators {
  bottom:-3%
}
.carousel-indicators > li,
.carousel-indicators > li.active{
    width: 40%;
    height: 2%;
    border-radius: 0;
    border: solid 1px grey;
    background: transparent;
    text-indent: 0;
    text-align: center;
}
.carousel-indicators > li.active {
    background: #4caf50;
}
.carousel-item{
    min-height: "720px";
}
video {
  /* override other styles to make responsive */
  width: 100%    !important;
  height: auto   !important;
  max-height: 720px
}
</style>
<script type="text/javascript">
function PlayVideo(aid,vid){
  document.getElementById(vid).style.display = "block";
  document.getElementById(vid).play();
  document.getElementById(aid).style.display = "none";
}
</script>

<div id="carousel_time" class="carousel slide">
  <ol class="carousel-indicators">
    <li data-target="#carousel_time" data-slide-to="0" class="active">Areas</li>
    <li data-target="#carousel_time" data-slide-to="1">Regions</li>
  </ol>
  <div class="carousel-inner">
    <div class="carousel-item active">
      <a id="carousel_time_a1" onclick="PlayVideo('carousel_time_a1','carousel_time_v1');"><img src="area-time-abel-720.png" alt="trail" /></a>
      <video id="carousel_time_v1" loop="loop" width="720" height="720" controls muted playsinline preload="none" style="display:none" src="area-time-abel.mp4" type="video/mp4" />


</div>
    <div class="carousel-item">
      <a id="carousel_time_a2" onclick="PlayVideo('carousel_time_a2','carousel_time_v2');"><img src="region-time-abel-720.png" alt="trail" /></a>
      <video id="carousel_time_v2" loop="loop" width="720" height="720" controls muted playsinline preload="none" style="display:none" src="region-time-abel.mp4" type="video/mp4" />
    </div>
  </div>
</div>
<br>

