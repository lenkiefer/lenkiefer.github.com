---
layout: post
title: "House price visualizations"
author: "Len Kiefer"
date: "2017-05-02"
summary: "R statistics dataviz plotly housing mortgage data"
group: navigation
theme :
  name : lentheme
---

I AM JUST GOING TO DROP OFF A COUPLE OF housing data animated gifs here. *And add a little bit of code for data wrangling.*

In earlier posts I described how to make these using [R](https://www.r-project.org/) in greater detail. We're going to be visualizing the [Freddie Mac House Price Index](http://www.freddiemac.com/finance/house_price_index.html).

## Updated geo tour

We talked about how to build something like this in our  [Grand Tour of House Prices post]({% post_url 2017-02-20-house-price-tour %})

<img src="{{ site.url}}/img/charts_may_02_2017/geo tween 05 02 2017.gif" >

## Dot chart

And for this one, you have to go way back to my [Visual Meditation on House Prices Part 2]({% post_url 2016-05-08-visual-meditations-on-house-prices-part2 %}). *But I've updated the code for this below.*

<img src="{{ site.url}}/img/charts_may_02_2017/geo tween 05 02 2017 dotrace.gif" >

### A little bit of data manipulation

Oh all right, I'll post a little bit of code. Last month we [talked about]({% post_url 2017-04-20-global-hpi-readxl %}) using [readxl](http://readxl.tidyverse.org/index.html) to wrangle some data in Excel spreadsheets.

Last year [we saw]({% post_url 2016-05-08-visual-meditations-on-house-prices-part1 %}) how to manipulate data in Excel. Below, we'll use readxl to get our data read for plotting.

You can download the Excel spreadsheet with state house price index values [here](http://www.freddiemac.com/finance/fmhpi/current/excel/states.xls).  Note that this code is based on the release with data through March, 2017, future releases may shift the exact location of the cells.  Using the `range` argument of readxl we can reach into the spreadsheet and get our data ready.  Let's try it:


{% highlight r %}
library(zoo,quietly=T,warn.conflicts = F)      # used for rolling window operations
library(readxl,quietly=T,warn.conflicts=F)
library(ggplot2,quietly=T,warn.conflicts=F)
library(tidyr,quietly=T,warn.conflicts=F)
library(dplyr,quietly=T,warn.conflicts=F)
library(lubridate,quietly=T,warn.conflicts=F)
library(data.table,quietly=T,warn.conflicts=F) # for the shift function
library(viridis,quietly=T,warn.conflicts=F)    # for the colors
library(scales,quietly=T,warn.conflicts=F)    # for labels
###############################################################################
#### Read in HPI data  
###############################################################################

df<-read_excel("data/states.xls", 
               sheet = "State Indices",  # name of sheet
               range="B6:BB513" )        # range where data lives

###############################################################################
#### Set up dates from January 1975 to March 2017
###############################################################################

df$date<-seq.Date(as.Date("1975-01-01"),as.Date("2017-03-01"),by="1 month")
df.state<-df %>% gather(geo,hpi,-date) %>% mutate(type="state")
{% endhighlight %}

Now that our data is loaded we can do some manipulations

{% highlight r %}
###############################################################################
#### Transform data
#### Needs library zoo for the rolling window operations
###############################################################################
df.state<-
  df.state %>% group_by(geo) %>% 
  mutate(hpa=hpi/shift(hpi,12)-1,
         hpilag12=shift(hpi,12,fill=NA),
         hpimax12=zoo::rollmax(hpi,13,align="right",fill=NA),
         hpimin12=-zoo::rollmax(-hpi,13,align="right",fill=NA)) %>% ungroup()

# Get a list of dates
dlist<-unique(filter(df.state,year(date)>1999)$date)

###############################################################################
#### Plotting function
###############################################################################
myplot1 <- function (i) {
  g<-
    ggplot(data=filter(df.state,date==dlist[i] & 
                         !(geo %in% 
                         c("United States not seasonally adjusted",
                            "United States seasonally adjusted" ))),
         aes(x=hpi, y=geo, label=paste(" ",geo,""),
             color=hpa,hjust=ifelse(hpa>0,0,1)))+
    geom_text() +
    geom_point()+
    scale_x_log10(limits=c(70,352), breaks=c(75,100,125,150,200,250,350))+
    geom_segment(aes(xend=hpimin12,x=hpimax12,y=geo,yend=geo),alpha=0.7)+
    theme_minimal()  +
    theme(legend.position="bottom",
          axis.text.y=element_blank(),
          legend.key.width=unit(4,"line"),
          panel.grid.major.y=element_blank(),
          plot.caption=element_text(hjust=0),
          plot.title=element_text(face="bold",size=18))+
    scale_color_viridis(end=0.85,option="C",limits=c(-.4,.4),
                        name="12-month % change     \nin house price index     \n",
                        label=percent)+
    labs(y="", x="House price index (log scale, Dec 2000 =100, NSA)",
       title="State house price dynamics",
       subtitle=as.character(dlist[i],format="%B, %Y"),
       caption="@lenkiefer Source: Freddie Mac house price index, each dot a state, lines trailing 12-month min-max")
  return(g)
  }

N<-length(dlist)  #get number of observations in filtered data
myplot1(N)
{% endhighlight %}

![plot of chunk 05-02-2017-readxl-plot1](/img/Rfig/05-02-2017-readxl-plot1-1.svg)

### Add animation

With our function, we can easily add some animation and create gif.


{% highlight r %}
oopt = ani.options(interval = 0.15)
saveGIF({for (i in seq(3,N,1)) {
  g<-myplot1(i)
  print(g)
  print(paste(i,"out of",N))
  ani.pause()}
  for (i in 1:5)
  {print(g)
    print(i)}
},movie.name="geo tween 05 02 2017 dotrace.gif",ani.width = 550, ani.height = 550)
{% endhighlight %}




