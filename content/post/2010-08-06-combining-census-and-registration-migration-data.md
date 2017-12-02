---
title: Combining census and registration data to estimate detailed elderly migration flows in England and Wales
author: Guy
date: '2010-08-06'
slug: combining-census-and-registration-migration-data
categories: [migration]
tags: [migration, r]
---

During my MS.c. I worked on methods for combining internal migration data in England and Wales. Migration data is often represented in square tables of origin-destination flows. These are of particular interest to analysing migration patterns when they are disaggregated by age, sex and some other variable such as illness, ethnicity or economic status. In England and Wales the data within these detailed flow table are typically missing in non-census years. However, row and column (origin and destination) totals are regularly provided from the NHS patient registers (see the first two columns of the hypothetical data situation below). I worked on a method to estimate the detailed missing flow data to sum to the provided totals in non-census years (see the third column of the hypothetical data situation below). This method is particularly useful for estimating migration flow tables disaggregated by detailed characteristics of migrants (such as illness, ethnicity or economic status) that are only provided by the ONS for census years.

<em>
Hypothetical Example of Data Set Situation (where migrant origins are labelled on the vertical axis and destinations on the horizontal axis).</em>

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}
.tg .tg-7un6{background-color:#ffffff;color:#000000;text-align:center;vertical-align:top}
.tg .tg-83xr{background-color:#ffffff;color:#000000;text-align:center;vertical-align:top}
.tg .tg-qmcf{background-color:#c0c0c0;color:#000000;text-align:right;vertical-align:top}
.tg .tg-7uzy{vertical-align:top}
.tg .tg-sh4c{text-align:center;vertical-align:top}
.tg .tg-baqh{text-align:center;vertical-align:top}
.tg .tg-x5m0{background-color:#c0c0c0;text-align:right;vertical-align:top}
.tg .tg-aq0u{font-style:italic;background-color:#ffffff;color:#000000;text-align:center;vertical-align:top}
.tg .tg-l9q5{background-color:#c0c0c0;color:#000000;vertical-align:top}
.tg .tg-5qb8{background-color:#ffffff;text-align:right;vertical-align:top}
.tg .tg-pz23{background-color:#c0c0c0;text-align:right;vertical-align:top}
.tg .tg-2de4{background-color:#c0c0c0;color:#000000;text-align:right;vertical-align:top}
.tg .tg-lqy6{text-align:right;vertical-align:top}
.tg .tg-ddj9{background-color:#c0c0c0;color:#000000;text-align:center;vertical-align:top}
.tg .tg-pxng{background-color:#ffffff;color:#000000;vertical-align:top}
.tg .tg-kixb{background-color:#ffffff;color:#000000;vertical-align:top}
.tg .tg-tglc{font-style:italic;background-color:#ffffff;color:#000000;vertical-align:top}
.tg .tg-eiwr{background-color:#ffffff;color:#000000;text-align:right;vertical-align:top}
.tg .tg-yw4l{vertical-align:top}
.tg .tg-q9yg{background-color:#ffffff;color:#000000;text-align:right;vertical-align:top}
.tg .tg-jjut{text-align:right;vertical-align:top}
.tg .tg-tpvx{font-style:italic;background-color:#ffffff;color:#000000;vertical-align:top}
</style>
<table class="tg">
  <tr>
    <th class="tg-ddj9" colspan="5">Auxiliary Data (e.g. 2001 Census)</th>
    <th class="tg-pxng"></th>
    <th class="tg-l9q5" colspan="5">Primary Data (e.g. 2004 NHSCR)   <br></th>
    <th class="tg-pxng"></th>
    <th class="tg-l9q5" colspan="5">Constrained Estimated Data 2004   <br></th>
  </tr>
  <tr>
    <td class="tg-aq0u" colspan="5">Without Limiting Long Term Illness</td>
    <td class="tg-kixb"></td>
    <td class="tg-tglc" colspan="5">Illness Details Unavailable              <br></td>
    <td class="tg-kixb"></td>
    <td class="tg-tglc" colspan="5">Without Limiting Long Term Illness</td>
  </tr>
  <tr>
    <td class="tg-pxng"><br></td>
    <td class="tg-7un6">N<br></td>
    <td class="tg-7un6">M<br></td>
    <td class="tg-7un6">S<br></td>
    <td class="tg-eiwr"><br></td>
    <td class="tg-eiwr"><br></td>
    <td class="tg-pxng"></td>
    <td class="tg-7un6">N</td>
    <td class="tg-7un6">M</td>
    <td class="tg-7un6">S</td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-7un6">N</td>
    <td class="tg-baqh">M</td>
    <td class="tg-baqh">S</td>
    <td class="tg-yw4l"></td>
  </tr>
  <tr>
    <td class="tg-83xr">N<br></td>
    <td class="tg-q9yg">80<br></td>
    <td class="tg-q9yg">20<br></td>
    <td class="tg-q9yg">50<br></td>
    <td class="tg-qmcf">150<br></td>
    <td class="tg-q9yg"><br></td>
    <td class="tg-83xr">N</td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-qmcf">260</td>
    <td class="tg-kixb"><br></td>
    <td class="tg-83xr">N</td>
    <td class="tg-q9yg">88</td>
    <td class="tg-jjut">56</td>
    <td class="tg-jjut">40</td>
    <td class="tg-pz23">183</td>
  </tr>
  <tr>
    <td class="tg-7un6">M<br></td>
    <td class="tg-eiwr">50<br></td>
    <td class="tg-eiwr">100</td>
    <td class="tg-eiwr">50<br></td>
    <td class="tg-2de4">200<br></td>
    <td class="tg-eiwr"><br></td>
    <td class="tg-7un6">M</td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-2de4">320</td>
    <td class="tg-pxng"></td>
    <td class="tg-7un6">M</td>
    <td class="tg-eiwr">29</td>
    <td class="tg-lqy6">145</td>
    <td class="tg-lqy6">21</td>
    <td class="tg-x5m0">195</td>
  </tr>
  <tr>
    <td class="tg-83xr">S<br></td>
    <td class="tg-q9yg">10<br></td>
    <td class="tg-q9yg">30</td>
    <td class="tg-q9yg">110</td>
    <td class="tg-qmcf">150</td>
    <td class="tg-kixb"></td>
    <td class="tg-83xr">S</td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-qmcf">170<br></td>
    <td class="tg-kixb"></td>
    <td class="tg-83xr">S</td>
    <td class="tg-q9yg">7</td>
    <td class="tg-jjut">52</td>
    <td class="tg-jjut">54</td>
    <td class="tg-pz23">113</td>
  </tr>
  <tr>
    <td class="tg-pxng"></td>
    <td class="tg-2de4">140</td>
    <td class="tg-2de4">150</td>
    <td class="tg-2de4">210</td>
    <td class="tg-2de4">500<br></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-2de4">200<br></td>
    <td class="tg-2de4">370</td>
    <td class="tg-2de4">180</td>
    <td class="tg-2de4">750</td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-2de4">124</td>
    <td class="tg-x5m0">252</td>
    <td class="tg-x5m0">115</td>
    <td class="tg-x5m0">491</td>
  </tr>
  <tr>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-7uzy"></td>
    <td class="tg-7uzy"></td>
    <td class="tg-7uzy"></td>
  </tr>
  <tr>
    <td class="tg-tpvx" colspan="5">With Limiting Long Term Illness</td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-tpvx" colspan="5">With Limiting Long Term Illness</td>
  </tr>
  <tr>
    <td class="tg-kixb"></td>
    <td class="tg-83xr">N</td>
    <td class="tg-83xr">M<br></td>
    <td class="tg-83xr">S<br></td>
    <td class="tg-83xr"><br></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-83xr">N</td>
    <td class="tg-sh4c">M</td>
    <td class="tg-sh4c">S</td>
    <td class="tg-7uzy"></td>
  </tr>
  <tr>
    <td class="tg-7un6">N<br></td>
    <td class="tg-eiwr">30</td>
    <td class="tg-eiwr">10</td>
    <td class="tg-eiwr">50</td>
    <td class="tg-2de4">60</td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-7un6">N</td>
    <td class="tg-eiwr">33</td>
    <td class="tg-lqy6">28</td>
    <td class="tg-lqy6">16</td>
    <td class="tg-x5m0">77</td>
  </tr>
  <tr>
    <td class="tg-83xr">M</td>
    <td class="tg-q9yg">40</td>
    <td class="tg-q9yg">50</td>
    <td class="tg-q9yg">70</td>
    <td class="tg-qmcf">160</td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-kixb"></td>
    <td class="tg-83xr">M</td>
    <td class="tg-q9yg">23</td>
    <td class="tg-jjut">73</td>
    <td class="tg-jjut">29</td>
    <td class="tg-pz23">125</td>
  </tr>
  <tr>
    <td class="tg-7un6">S<br></td>
    <td class="tg-eiwr">30</td>
    <td class="tg-eiwr">10</td>
    <td class="tg-eiwr">40<br></td>
    <td class="tg-2de4">80<br></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-pxng"></td>
    <td class="tg-7un6">S</td>
    <td class="tg-eiwr">20</td>
    <td class="tg-lqy6">17</td>
    <td class="tg-lqy6">20</td>
    <td class="tg-x5m0">57</td>
  </tr>
  <tr>
    <td class="tg-5qb8"></td>
    <td class="tg-pz23">100</td>
    <td class="tg-pz23">70</td>
    <td class="tg-pz23">130</td>
    <td class="tg-pz23">300</td>
    <td class="tg-5qb8"></td>
    <td class="tg-5qb8"></td>
    <td class="tg-5qb8"></td>
    <td class="tg-5qb8"></td>
    <td class="tg-5qb8"></td>
    <td class="tg-5qb8"></td>
    <td class="tg-5qb8"></td>
    <td class="tg-5qb8"></td>
    <td class="tg-pz23">76</td>
    <td class="tg-pz23">118</td>
    <td class="tg-pz23">65</td>
    <td class="tg-pz23">259</td>
  </tr>
</table>

The estimated values maintain some properties (various cross product ratios) of the Census data whilst updating marginal totals to more current data. For more details see my MS.c. dissertation (which I have put online <a href="https://docs.google.com/viewer?a=v&pid=explorer&chrome=true&srcid=0B1VTDLs9SzZ0ZDRiNWQ4YTQtZDJjYi00ZWQxLWE3ZGItZjNiNTZjYTVjNWVi&hl=en_US" target="_blank" rel="noopener">here</a>). I also presented the method and some further results at POPFSET 2007, see <a title="POPFEST Conference Presentation Slides" href="http://gjabel.wordpress.com/2010/08/05/popfest-conference-presentation-slides/">here</a> for more details. This contains the R/S-Plus code to conduct the estimation in the Appendix. There is also a published paper based on my MS.c. that uses a slightly modified R code.

**Publication Details:**

Raymer J., Abel G.J. and Smith P.W.F. (2007). <a href="http://onlinelibrary.wiley.com/doi/10.1111/j.1467-985X.2007.00490.x/abstract">Combining census and registration data to estimate detailed elderly migration flows in England and Wales</a>. <em>Journal of the Royal Statistical Society Series A (Statistics in Society)</em> 170 (4) 891--908.

A log-linear model is developed to estimate detailed elderly migration flows by combining data from the 2001 UK census and National Health Services patient register. After showing that the census and National Health Service migration flows can be reasonably combined, elderly migration flows between groupings of local authority districts by age, sex and health status for the 2000–2001 and 2003–2004 periods are estimated and then analysed to show how the patterns have changed. By combining registration data with census data, we can provide recent estimates of detailed elderly migration flows, which can be used for improvements in social planning or policy.