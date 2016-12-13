---
layout: post
title: "Ribbon rate chart "
author: "Len Kiefer"
date: "2016-12-12"
summary: "R statistics forecasting house prices housing"
group: navigation
theme :
  name : lentheme
---
# Introduction

LAST WEEK I [SHOWED YOU]({% post_url 2016-12-08-10-ways-to-visualize-rates %}) 10 TASTY WAYS TO VISUALIZE MORTGAGE RATES, but I've got another delicious one for you. Y'all like ribbon candy?

As before we'll create this chart with [R](https://www.r-project.org/). 

## The data

The data I'm going to use are estimates of weekly U.S. average 30-year fixed mortgage rates from the [Primary Mortgage Market Survey](http://www.freddiemac.com/pmms/index.html). See my [earlier post]({% post_url 2016-12-08-10-ways-to-visualize-rates %}) for some additional information on the data we'll use.

Here's the first few rows of our data:

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='6' style='text-align: left;'>
30-year Fixed Mortgage Rate (%)</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>date</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>rate</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>year</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>month</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>week</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>Apr 02,1971</td>
<td style='text-align: center;'>7.33</td>
<td style='text-align: center;'>1971</td>
<td style='text-align: center;'>4</td>
<td style='text-align: center;'>14</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2</td>
<td style='background-color: #f7f7f7; text-align: center;'>Apr 09,1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>7.31</td>
<td style='background-color: #f7f7f7; text-align: center;'>1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>4</td>
<td style='background-color: #f7f7f7; text-align: center;'>15</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>Apr 16,1971</td>
<td style='text-align: center;'>7.31</td>
<td style='text-align: center;'>1971</td>
<td style='text-align: center;'>4</td>
<td style='text-align: center;'>16</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>4</td>
<td style='background-color: #f7f7f7; text-align: center;'>Apr 23,1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>7.31</td>
<td style='background-color: #f7f7f7; text-align: center;'>1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>4</td>
<td style='background-color: #f7f7f7; text-align: center;'>17</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>Apr 30,1971</td>
<td style='text-align: center;'>7.29</td>
<td style='text-align: center;'>1971</td>
<td style='text-align: center;'>4</td>
<td style='text-align: center;'>18</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>6</td>
<td style='background-color: #f7f7f7; text-align: center;'>May 07,1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>7.38</td>
<td style='background-color: #f7f7f7; text-align: center;'>1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>5</td>
<td style='background-color: #f7f7f7; text-align: center;'>19</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>May 14,1971</td>
<td style='text-align: center;'>7.42</td>
<td style='text-align: center;'>1971</td>
<td style='text-align: center;'>5</td>
<td style='text-align: center;'>20</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>8</td>
<td style='background-color: #f7f7f7; text-align: center;'>May 21,1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>7.44</td>
<td style='background-color: #f7f7f7; text-align: center;'>1971</td>
<td style='background-color: #f7f7f7; text-align: center;'>5</td>
<td style='background-color: #f7f7f7; text-align: center;'>21</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'>May 28,1971</td>
<td style='text-align: center;'>7.46</td>
<td style='text-align: center;'>1971</td>
<td style='text-align: center;'>5</td>
<td style='text-align: center;'>22</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;'>10</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>Jun 04,1971</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>7.52</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>1971</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>6</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>23</td>
</tr>
</tbody>
<tfoot><tr><td colspan='6'>
Source: Freddie Mac Primary Mortgage Market Survey</td></tr></tfoot>
</table>

The data are weekly observations on mortgage rates running from April 2, 1971 through December 8, 2016. Now let's take these data and make our visualization.


## Data prep

We need to do a tiny bit of data preparation which is made quite easy by the data.table() structure.


{% highlight r %}
# making rolling 52 week min and max
pmms30yr[, rmax.52:=rollapply(rate,52,max,na.rm=T,fill=NA,align="right")]
pmms30yr[, rmin.52:=rollapply(rate,52,min,na.rm=T,fill=NA,align="right")]

#compute 52-week max & min and rate
pmms30yr[,rup:=min(rate,rmin.52),by=date]
pmms30yr[,rdown:=max(rate,rmax.52),by=date]
{% endhighlight %}

Now that we have the data ready, we can create our lovely ribbon plot:


{% highlight r %}
#create plot:
ggplot(data=pmms30yr,aes(x=date,y=rate))+
  geom_ribbon(aes(ymin=rup,ymax=rate),fill=viridis(10)[2],alpha=0.6)+
  geom_ribbon(aes(ymin=rdown,ymax=rate),fill=viridis(10)[8],alpha=0.6)+
  geom_line(size=1.05)+
  theme_minimal()+
  geom_rug(sides="b",aes(color=(rate-rmin.52)/(rmax.52-rmin.52)))+
  scale_color_viridis(name="Rate as %\nof min/max\n0% at min,\n50%=halfway,\n100% at max",
                      direction=-1,label=percent,end=0.8)+
    theme(legend.position=c(0.22,0.15),legend.direction="horizontal")+
  labs(x="", y="",
       title="30-year fixed mortgage rate (%)",
       subtitle="Shaded area 52-week trailing min/max, purple from 52-week min to current, green from current to 52-week max.\nStrip at bottom shows weekly rate as percent of 52-week min/max (0% at min, 100% at max).",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey")+
  theme(plot.title=element_text(size=16),
        plot.subtitle=element_text(face="italic",size=8))+
  theme(plot.caption=element_text(hjust=0))+
  theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
  scale_x_date(limits=c(as.Date("1972-01-01"),as.Date("2016-12-08")))+
  coord_cartesian(ylim=c(02.5,20))
{% endhighlight %}

![plot of chunk rate-viz1-dec-12-2016,](/img/Rfig/rate-viz1-dec-12-2016,-1.svg)

## What is this?

This is a composite chart consisting of:

1. A line
2. Two ribbons
3. A marginal rugplot at the bottom

### The line

The line is just a standard time series line created with *geom_line()* showing weekly average mortgage rates. There's nothing particularly special about it, but it's the anchor that lets us make sense of the rest of the plot.

### Two ribbons

The ribbons, shaded purple and green, show a trailing 52-week min and max for the interest rate.  Together they show the range for the interest rate in the past year. Let's look at just the last row of our data set:

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='10' style='text-align: left;'>
30-year Fixed Mortgage Rate (%)</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>date</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>rate</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>year</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>month</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>week</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>rmax.52</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>rmin.52</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>rup</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>rdown</th>
</tr>
</thead>
<tbody>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>2385</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>Dec 08,2016</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>4.13</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>2016</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>12</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>49</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>4.13</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>3.41</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>3.41</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>4.13</td>
</tr>
</tbody>
<tfoot><tr><td colspan='10'>
Source: Freddie Mac Primary Mortgage Market Survey</td></tr></tfoot>
</table>

Here we see that for the week of December 8, 2016 the average mortgage rate was 4.13 percent.  The 52-week max was also 4.13 percent.  The 52-week min was 3.41 percent.  This means that over the 52-week window ending December 8, 2016 mortgage rates ranged as low as 3.41 percent and as high as 4.13 percent. Because the last observation is equal to the 52-week max there's no green shaded area for this week, but it's all purple in the plot, extending down from 4.13 percent to 3.41 percent.

We can plot just the line and ribbons for the weeks in 2016:

![plot of chunk rate-viz2-dec-12-2016,](/img/Rfig/rate-viz2-dec-12-2016,-1.svg)

We see a lot of green for most of 2016, indicating that for much of the year mortgage rates were substantially below where they were 52-weeks ago.

### The rug really ties the whole plot together.

What's the point of the rug?  Well, it really ties the plot together.

Consider the plot below which shows just rates for 2016, but adds in the rug plot:

![plot of chunk rate-viz3-dec-12-2016,](/img/Rfig/rate-viz3-dec-12-2016,-1.svg)

The rug is colored to correspond to the where the black line is in relation to the edges of the shaded areas.  If the current rate (black line) is at the max so that there is no green area, then the tick will be dark purple. If the current rate is at the 52-week min so that there is no purple area then the tick will be yellow. 

Zooming out, we can see that the rug shows us at a glance how rates have been trending on a year-over-year basis.

![plot of chunk rate-viz4-dec-12-2016,](/img/Rfig/rate-viz4-dec-12-2016,-1.svg)

Now we've triple-encoded the range of rates in this chart.  The line captures the trend, the purple ribbon indicates rates are rising relative to a year ago, while green shading indicates rates have been falling over the past year.  Likewise the ribbon at the bottom, which is conveniently placed near the x axis, displays the current rate relative to 52-week min and max.   
