---
layout: post
title: "Visual meditations on house prices, Part 3: bubbles and bounce"
author: "Len Kiefer"
date: "2016-05-10"
summary: "Charts and graphs exploring house price trends"
group: navigation
theme :
  name : lentheme
---


IN THIS POST I'm going to describe how to make some additional data visualizations of house prices and discuss a bit about what they mean.  For reference, the prior posts are available at:


* [Part 1: data wrangling ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part1 %})
* [Part 2: sparklines and dots (animated) ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part2 %})

# Meditation 1: Bubbles

Let's start by recreating this visualization:


<img src="{{ site.url }}/img/charts_may_8_2016/hpi_dots2.gif" alt="hpi dots 2"/>

This visualization plots each states (plus the District of Columbia) as a blue dot in a scatterplot.  

The X axis displays how far the house price index in the state is from it's pre-2008 peak.  A vertical line at 100% indicates that the price index for that state is exactly at the pre-2008 peak for that state.  If the value is to the right (left) of the vertical line, then the index is above(below) that peak.

The Y axis displays how far the index is from the post-2007 minimum for that state. The horizontal line at 100% indicates that the state is exactly at that minimum. As states recover from the post-recession bottom, they move further up on the chart.

A value at (75%, 125%) would indicate that the state is only 75% of the pre-2008 maximum, and 125% of the post-2007 minimum.  

You can see that North Dakota (ND) does not fall much during the Great Recession and recovers quickly.

## Making the chart


The data for the charts can be found at the following links:

1. [*state and national called fmhpi.txt*]({{ site.url }}/img/charts_may_8_2016/fmhpi.txt)
2. [*metro called fmhpi2.txt*]({{ site.url }}/img/charts_may_8_2016/fmhpi2.txt)

Constructing this chart is fairly straightforward. We simply have to calculate the pre-2008 peak and post-2007 minimum for each state.  As I mentioned in [Part 1: data wrangling ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part1 %}), I already computed the pre-2008 peak value and post-2007 minimum value for each state and added it as an additional variable. Elegant and efficient? No, but it will get this job done. 




{% highlight r %}
mydata <- fread("fmhpi.txt")
#compute some additional values
mydata[,gmax:=(hpi/pmax)]  #for the x axis
mydata[,gmin:=(hpi/pmin)]  #for the y axis
{% endhighlight %}

Now to make this animation, I set up a function to contain my ggplot code. Because this code is so simple, it's not really necessary. But it could be helpful to have a function down the line.


{% highlight r %}
#load required libraries
library(ggplot2)
library(animation)
library(ggthmes)
library(ggrepel)
library(scales)

mydots2<-function (yy,mm){
g<-
  ggplot(data=mydata[year==yy& month==mm & state != "US"], aes(x=gmax,y=gmin,label=state))+
  geom_point(size=4,alpha=0.75,color="#00B0F0")+
  #Use geom_text_repel from the ggrepel package discussed below
  geom_text_repel()+
  theme_minimal()  +
  #format axis
  scale_x_continuous(label=percent,limits=c(.5,1.5))+
  scale_y_continuous(label=percent,limits=c(.9,2), breaks=seq(1,2,.25))+
  
  #add verticle and horizontal lines
  geom_abline(intercept=1,slope=0,alpha=0.7)+
  geom_vline(xintercept=1, alpha=0.7)  +
  #title and captions
  labs(y="House price relative to post-2007 min (%)", x="House price relative to pre-2008 max (%)",
       title="State house price dynamics",
       subtitle=paste(as.character(mydata[year==yy & month==mm & state=="US"]$date,format="%b-%Y")),
       caption="@lenkiefer Source: Freddie Mac house price index, each dot a state")+
  theme(plot.title=element_text(size=18))+
  theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  theme(plot.margin=unit(c(0.5,0.5,0.5,0.75),"cm"))+
  #add some labels to the graphic
  annotate("text",x=1.01,y=1.95,label="House prices above pre-recession peak",hjust=0)+
  annotate("text",x=0.99,y=1.95,label="House prices below pre-recession peak",hjust=1)+
  annotate("text",x=1.49,y=1.01,label="Y % up from bottom",hjust=1,angle=270,vjust=1)+
  annotate("text",x=0.6,y=0.975,label="At bottom",hjust=0)
  return(g)
}
{% endhighlight %}

The function takes a year value **yy** and a month value **mm** and creates the bubble plot for that year and month combination. 

### Labels for scatterplot

My favorite part of this plot was using the [*ggrepel*](https://cran.r-project.org/web/packages/ggrepel/index.html) package to create the labels for the scatterplot. If you've ever tried to label a scatterplot or bubble chart with lots of points you should really appreciate this package, which handles labels automatically. It's an incredible time saver preventing you from having to manually adjust the point labels. And in an animation, it's would consume enormous time to try to move all the labels for each image. Unless you have an intern or RA, then this package is a must-use.

### Add animation

Adding animation should be familiar [*from my previous posts*]({% post_url 2016-05-08-visual-meditations-on-house-prices-part2 %}), but I include it here for completeness.



{% highlight r %}
oopt = ani.options(interval = 0.3)
saveGIF({for (yy in 2008:2016) for(mm in seq(1,12,1)) {   {
  if (yy==2016) {mm<-3}
  g<-
    mydots2(yy=yy, mm=mm) #if you want to do more elaborate things with the animation, the function could be useful
  print(g)
  ani.pause()
}
}
  #This is included at the end of the loop to pause at the final image.
  for (i2 in 1:2) {
  
    print(g)
    ani.pause()
  }
},movie.name="hpi_dots2.gif",ani.width = 950, ani.height = 650)
{% endhighlight %}

# Bounce


Now we're going to use the metro data to analyze seasonality in house prices:

<img src="{{ site.url }}/img/charts_may_10_2016/metro_season.gif" alt="redblue dots"/>

## Explaining the plot

I think this animation does a good job of displaying seasonality in house prices. I've color coded the dots so that they fade from blue in January to red in June back to blue in December.  As housing markets heat up and prices rise, the colors shift redder and fade bluer as prices rise.  The dots bounce up and down in fairly close unison, but like popcorn in a popper, some jump up more than others.

## The code 

The code for this one is pretty straightforward if you've been following along:


{% highlight r %}
metrodata <- fread("fmhpi2.txt")
metrodata$date<-as.Date(metrodata$date, format="%m/%d/%Y")
#Compute monthly house price appreciation
metrodata<-metrodata[,hpa1:=c(NA,((1+diff(hpi)/hpi)))-1,by=metro]  


oopt = ani.options(interval = 0.1)
saveGIF({for (yy in 2000:2016) for(mm in seq(1,12,1)) {  {
  if (yy>=2016 & mm>3) {mm<-3}
  g<-
    ggplot(data=metrodata[(year==yy) & month==mm ], aes(x=metro, y=hpa1,color=month, label=date,group=metro))+
    geom_point(alpha=0.6,size=2)   +
    scale_y_continuous(limits=c(-.052,.052), labels=percent, breaks=seq(-.05,.05,.01))+
    theme_minimal()  +
    geom_abline(intercept=0,slope=0, alpha=0.5)+
    scale_colour_gradient2(low="blue",mid="red", high="blue", limits=c(1,12)) +
    labs(y="House price index (Dec 2000 =100, NSA), Monthly % Change", x="",
         title="Metro house price dynamics",
         subtitle=paste(as.character(metrodata[year==yy & month==mm]$date,format="%b-%Y")),
         caption="@lenkiefer Source: Freddie Mac house price index, each dot a metro, colored by month")+
    theme(plot.title=element_text(size=14))+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10),size=9))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+ 
    theme(legend.justification=c(0,0),
          legend.position=c(.7,.2),
          text=element_text(size=10))+
    theme(legend.position="none")+
    theme( axis.text.x=element_blank(),axis.ticks=element_blank())+
    theme(panel.grid.major.x=element_blank())+
    theme(axis.text=element_text(size=6))
  
  print(g)
  ani.pause()
}
}
  for (i2 in 1:2) {print(g)
    ani.pause()  }
},movie.name="metro_seasons.gif",ani.width = 650, ani.height = 650)
{% endhighlight %}

### Wrapping up

That's it for today's meditations, but we'll have more in the future.  Up next:  **SWOOOSH!!!**

<img src="{{ site.url }}/img/charts_may_10_2016/rbswirl2.gif" alt="Swoosh"/>



