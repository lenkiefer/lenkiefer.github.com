---
title: dot plots and distributions
date: 2016-04-06
slug: dot-plots-and-distributions
tags: ["R","dataviz","animation"]
categories: ["economics"]
---
We're going to make this chart (and talk about it) 

<img src="../../../../img/charts_apr_6_2016/metro_ur_dots_feb_2016.gif" alt="metro ur dist" style="width: 450px;"/>

Wait, what is this?  

Let's pause the animation and look at the last frame:

<img src="../../../../img/charts_apr_6_2016/feb2016.png" alt="Metro UR dist 2016" style="width: 450px;"/>

This plot shows the distribution of metro area unemployment. These data are available <a href="http://www.bls.gov/web/metro/laummtrk.htm">here</a>.

Each dot represents a metro area with its unemployment rate depicted on the x axis. The data are bucketed into 0.25 percentage point buckets and stacked when more than one metro falls within that range.  For example, El Centro California had the highest metro area unemployment rate in February 2016 of 18.6.  That's the point out on the far right.

Most of the points are clustered near the national average (5.2% NSA in Feb 2016) with a more or less reasonable distribution around the national average.

All the GIF does is collect a sequence of these images and create a gif out of them as I described <a href="http://lenkiefer.com/2016/03/10/mortgage-rates-gif">here</a>.  Below I describe how I build the GIF and the code necessary. This description includes how you can download and organize the data in a few simple steps.

{% include dotplot.html 


{% include JB/setup 
