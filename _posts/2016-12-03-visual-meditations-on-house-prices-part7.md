---
layout: post
title: "Visual meditations on house prices, Part 7: Don't cross the streams!"
author: "Len Kiefer"
date: "2016-12-03"
summary: "Charts and graphs exploring house price trends"
group: navigation
theme :
  name : lentheme
---
# Introduction

ON FRIDAY I MADE SOME ACCIDENTAL data art. I ended up with something pretty much useless, but kind of pretty.  I shared it on Twitter:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">made an unintentional sorta streamgraph <a href="https://twitter.com/hashtag/graphfail?src=hash">#graphfail</a> <a href="https://t.co/uW4IOnbrcL">pic.twitter.com/uW4IOnbrcL</a></p>&mdash; Leonard Kiefer (@lenkiefer) <a href="https://twitter.com/lenkiefer/status/804448317891457024">December 1, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


We'll see if we can redeem this graphfail in another Visual Meditation on house prices.

## Visual Meditations 

I've been collecting various graphical thoughts about house prices in my Visual Meditations series. For reference, the prior meditations are listed below, and I'll keep an updated list of all of them [here]({% post_url 2016-05-08-visual-meditations-on-house-prices %}).


* [Part 1: data wrangling ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part1 %})
* [Part 2: sparklines and dots (animated) ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part2 %})
* [Part 3: bubbles and bounce ]({% post_url 2016-05-10-visual-meditations-on-house-prices-part3 %})
* [Part 4: graph gallery ]({% post_url 2016-05-14-visual-meditations-on-house-prices-part4 %})
* [Part 5: distributions ]({% post_url 2016-08-13-visual-meditations-on-house-prices-part5 %})
* [Part 6: state recovery ]({% post_url 2016-11-03-visual-meditations-on-house-prices-part6 %})

These visualizations will be made in [R](https://www.r-project.org/), and I'll post code for some of the graphs at the bottom.


## The data

Once [again]({% post_url 2016-05-08-visual-meditations-on-house-prices-part1 %}) we'll use the [Freddie Mac House Price Index](http://www.freddiemac.com/finance/house_price_index.html) for many of these visualizations.  We're going to need a text file organized as described in that post. Just follow those examples to set up the data. Or you can download the two text files below:

1. [*state and national called fmhpi2016q3.txt*]({{ site.url }}/img/charts_nov_3_2016/fmhpi2016q3.txt)
2. [*metro called fmhpi2016q3metro.txt*]({{ site.url }}/img/charts_nov_3_2016/fmhpi2016q3metro.txt)

The code below will load the data and do some manipulations to generate the required variables.  I also use this helper file with region names associated with each state.

3. [*region lookup called region.txt*]({{ site.url }}/img/charts_nov_3_2016/fmhpi2016q3metro.txt)


{% highlight r %}
#Load some packages
library(data.table, warn.conflicts = FALSE, quietly=TRUE)
library(ggplot2, warn.conflicts = FALSE, quietly=TRUE)
library(dplyr, warn.conflicts = FALSE, quietly=TRUE)
library(zoo, warn.conflicts = FALSE, quietly=TRUE)
library(ggthemes, warn.conflicts = FALSE, quietly=TRUE)
library(scales, warn.conflicts = FALSE, quietly=TRUE)

d.metro <- fread("data/fmhpi2016q3metro.txt")
d.metro$date<-as.Date(d.metro$date, format="%m/%d/%Y")

#Now uses some data table caclulations to compute percent changes in house prices by state/metro
d.metro[,hpa12:=c(rep(NA,12),((1+diff(hpi,12)/hpi))^1)-1,by=metro]  

# set up statecode for primary state, first 2 digits after column in metro name
d.metro[,statecode:=substr(regmatches(metro,regexec(", +[A-Z][A-Z]",metro)),3,4)]

#load file with regions 
region<-fread("data/region.txt")
reg.list<-unique(region[order(region),]$region) #list of regions
d.metro<-merge(d.metro,region,by="statecode")

# create quantiles across regions and dates:
d.metro[, hpa12.rmin:=quantile(hpa12,0,na.rm=T),by=c("region","date")]
d.metro[, hpa12.r5:=quantile(hpa12,.05,na.rm=T),by=c("region","date")]
d.metro[, hpa12.r25:=quantile(hpa12,.25,na.rm=T),by=c("region","date")]
d.metro[, hpa12.r50:=quantile(hpa12,.5,na.rm=T),by=c("region","date")]
d.metro[, hpa12.r75:=quantile(hpa12,.75,na.rm=T),by=c("region","date")]
d.metro[, hpa12.r95:=quantile(hpa12,.95,na.rm=T),by=c("region","date")]
d.metro[, hpa12.rmax:=quantile(hpa12,1,na.rm=T),by=c("region","date")]
{% endhighlight %}

Now we're ready to create the plot I tweeted out.  Even with the labels you don't really get a lot out of it, but it's kind of pretty.



{% highlight r %}
ggplot(data=d.metro,aes(x=date,fill=region,color=region))+
  geom_ribbon(aes(ymin=hpa12.rmin,ymax=hpa12.r5),alpha=0.1)+
  geom_ribbon(aes(ymin=hpa12.r5,ymax=hpa12.r25),alpha=0.5)+
  geom_ribbon(aes(ymin=hpa12.r25,ymax=hpa12.r75),alpha=0.75)+
  geom_ribbon(aes(ymin=hpa12.r75,ymax=hpa12.r95),alpha=0.5)+
  geom_ribbon(aes(ymin=hpa12.r95,ymax=hpa12.rmax),alpha=0.1)+
  geom_line(aes(y=hpa12.r50))+ theme_minimal()+
  theme(legend.position="none",plot.caption=element_text(hjust=0),
        plot.subtitle=element_text(face="italic"))+
  scale_y_continuous(label=percent)+
      coord_cartesian(xlim=c(as.Date("1990-01-01"),as.Date("2016-12-31")))+
  labs(x="",y="Annual House Price Percent Change",title="Distribution of year-over-year house price growth across metros", subtitle="Black line median metro, central region 25th to 75th percentiles,\nlighter regions are 5th to 25th (75th to 95th) and min to 5th (95th to max)",
       caption="@lenkiefer Source: Freddie Mac House Price Index (NSA), metros assigned to region based on primary state.")
{% endhighlight %}

![plot of chunk fig-hpimed6-viz1](/img/Rfig/fig-hpimed6-viz1-1.svg)

What I wanted to do with this graph was compare the dispersion across metro areas of house price growth.  By adding a simple facet_wrap() statement we can get something a little more useful:


{% highlight r %}
ggplot(data=d.metro,aes(x=date,fill=region,color=region))+
  geom_ribbon(aes(ymin=hpa12.rmin,ymax=hpa12.r5),alpha=0.1)+
  geom_ribbon(aes(ymin=hpa12.r5,ymax=hpa12.r25),alpha=0.5)+
  geom_ribbon(aes(ymin=hpa12.r25,ymax=hpa12.r75),alpha=0.75)+
  geom_ribbon(aes(ymin=hpa12.r75,ymax=hpa12.r95),alpha=0.5)+
  geom_ribbon(aes(ymin=hpa12.r95,ymax=hpa12.rmax),alpha=0.1)+
  geom_line(aes(y=hpa12.r50))+ theme_minimal()+
  facet_wrap(~region)+
  theme(legend.position="none",plot.caption=element_text(hjust=0),
        plot.subtitle=element_text(face="italic"))+
  scale_y_continuous(label=percent)+
      coord_cartesian(xlim=c(as.Date("1990-01-01"),as.Date("2016-12-31")))+
  labs(x="",y="Annual House Price Percent Change",title="Distribution of year-over-year house price growth across metros", subtitle="Black line median metro, central region 25th to 75th percentiles,\nlighter regions are 5th to 25th (75th to 95th) and min to 5th (95th to max)",
       caption="@lenkiefer Source: Freddie Mac House Price Index (NSA), metros assigned to region based on primary state.")
{% endhighlight %}

![plot of chunk fig-hpimed6-viz2](/img/Rfig/fig-hpimed6-viz2-1.svg)

Now we kind of have something.  What this plot shows is the distribution across metro areas in terms of annual house price appreciation. I've also broken out the metros by [Census Region](http://www.census.gov/econ/census/help/geography/regions_and_divisions.html).  We can see that dispersion is greater in the South and West relative to the Midwest and Northeast Regions.

We can also animated a version using tweenr.See my earlier [post about tweenr]({% post_url 2016-05-29-improving-R-animated-gifs-with-tweenr %}) for an introduction to tweenr, and more examples [here]({% post_url 2016-05-30-more-tweenr-animations %}) and [here]({% post_url 2016-06-26-week-in-review %}). 


{% highlight r %}
#create a function for animation
# if r = all, plot all regions, otherwise only plot region r
myf<-function(r){
  if (r != "All"){
  d.metro2<-copy(d.metro)
  #if region == r keep hpa12
  d.metro2[,yhpa12:=ifelse(region==r,hpa12,0)]
  d.metro3<-d.metro2[,list(yhpa12.min=quantile(yhpa12,0,na.rm=T),
                 yhpa12.5=quantile(yhpa12,.05,na.rm=T),
                 yhpa12.25=quantile(yhpa12,.25,na.rm=T),
                 yhpa12.50=quantile(yhpa12,.5,na.rm=T),
                 yhpa12.75=quantile(yhpa12,.75,na.rm=T),
                 yhpa12.95=quantile(yhpa12,.95,na.rm=T),
                 yhpa12.max=quantile(yhpa12,1,na.rm=T)),by=c("date","region")]
  d.metro3 %>% map_if(is.character, as.factor) %>% as_data_frame -> d.metro3
  return(d.metro3)
}
 else {
  d.metro2<-copy(d.metro)
  d.metro2[,yhpa12:=hpa12]
  d.metro3<-d.metro2[,list(yhpa12.min=quantile(yhpa12,0,na.rm=T),
                           yhpa12.5=quantile(yhpa12,.05,na.rm=T),
                           yhpa12.25=quantile(yhpa12,.25,na.rm=T),
                           yhpa12.50=quantile(yhpa12,.5,na.rm=T),
                           yhpa12.75=quantile(yhpa12,.75,na.rm=T),
                           yhpa12.95=quantile(yhpa12,.95,na.rm=T),
                           yhpa12.max=quantile(yhpa12,1,na.rm=T)),by=c("date","region")]
  
  d.metro3 %>% map_if(is.character, as.factor) %>% as_data_frame -> d.metro3
  #as.data.frame()
  return(d.metro3)
}
}


my.list<-lapply(reg.list,myf)
my.list2<-lapply(c("All",reg.list,"All"),myf)

library(animation)
library(tweenr)
#use tweenr
tf <- tween_states(my.list2, tweenlength= 2, statelength=3, ease=rep('cubic-in-out',50), nframes=60)
tf<-data.table(tf)

#loop through data and animate:
oopt = ani.options(interval = 0.1)
saveGIF({for (i in 1:max(tf$.frame)) {
  g<-
    ggplot(data=tf[.frame==i],aes(x=date,fill=region))+
    geom_ribbon(aes(ymin=yhpa12.min,ymax=yhpa12.5),alpha=0.1)+
    geom_ribbon(aes(ymin=yhpa12.5,ymax=yhpa12.25),alpha=0.5)+
    geom_ribbon(aes(ymin=yhpa12.25,ymax=yhpa12.75),alpha=0.75)+
    geom_ribbon(aes(ymin=yhpa12.75,ymax=yhpa12.95),alpha=0.5)+
    geom_ribbon(aes(ymin=yhpa12.95,ymax=yhpa12.max),alpha=0.1)+
    geom_line(aes(y=yhpa12.50),color="black",size=1.05)+ theme_minimal()+
    scale_fill_discrete(name="")+guides(color="none")+
    coord_cartesian(xlim=c(as.Date("1990-01-01"),as.Date("2016-12-31")))+
    #facet_wrap(~region)+
    theme(legend.position="bottom",plot.caption=element_text(hjust=0),
          plot.subtitle=element_text(face="italic"))+
    scale_y_continuous(label=percent,limits=c(-.5,.5))+
    labs(x="",y="Annual House Price Percent Change",title="Distribution of year-over-year house price growth across metros",
         subtitle="Black line median metro, central region 25th to 75th percentiles,\nlighter regions are 5th to 25th (75th to 95th) and min to 5th (95th to max)",
         caption="@lenkiefer Source: Freddie Mac House Price Index (NSA), metros assigned to region based on primary state.")
  
  print(g)
  ani.pause()
  print(paste(i,"out of",max(tf$.frame)))
}
},movie.name="fmhpi2016Q3 metro fan 1990.gif",ani.width = 650, ani.height = 450)
{% endhighlight %}

<img src="{{ site.url }}/img/charts_dec_3_2016/fmhpi2016Q3 metro fan 1990.gif" alt="fan gifs"/>


