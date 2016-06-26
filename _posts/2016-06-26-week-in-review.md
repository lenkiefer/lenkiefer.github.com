---
layout: post
title: "Brexit, State of the Nation's Housing, and home sales: the week in charts."
author: "Len Kiefer"
date: "2016-06-26"
summary: "rstats data visualizations of houisng data"
group: navigation
theme :
  name : lentheme
---



IT WAS A BUSY WEEK FOR ECONOMIC AND HOUSING DATA. [Existing](http://www.realtor.org/news-releases/2016/06/existing-home-sales-grow-18-percent-in-may-highest-pace-in-over-nine-years) and [new](https://www.census.gov/construction/nrs/pdf/newressales.pdf) home sales came out, the Joint Center for Housing Studies of Harvard University released their annual [State of the Nation's Housing](http://www.jchs.harvard.edu/research/state_nations_housing), and the U.K. voted to leave the European Union (the Brexit). We'll recap these data and events through charts I've created and shared throughout the week.

In this post, I'll share each of the charts with some commentary, and then below, I'll include the R code I used to generate the charts.

# Home sales catching up to the fastest pace in a decade

Both existing and new home sales for May 2016 came out this month, with Existing home sales released on Wednesday and new home sales on Thursday. Home sales have been picking up steam throughout 2016. Total home sales are likely to reach the highest annual total since 2006.  In order to do that, sales have to outpace 2007.  

## Existing home sales post best monthly sales since 2007

Existing home sales for May 2016 were at the highest level since 2007 and seem to be getting traction.  The graph below compares monthly existing home sales (not seasonally adjusted) across years. This year's pace is running below 2007, but the gap is narrow.  In 2007 home sales slowed in the summer and fall, so if this year's pace maintains its momentum it's likely this year will be the best year for existing home sales since 2006.

<img src="{{ site.url }}/img/charts_jun_26_2016/ehs ytd may 2016.gif" alt="dot plot"/>

## New home sales drop, but estimates uncertain

New home sales had an extremely strong initial reading for April, but the May release revised down the estimates substantially. In May 2016, new home sales were up 8.7 percent year-over-year. The estimates for new home sales are subject to a lot of sampling uncertainty, and Census provides estimates of that uncertainty. In the chart below I plot not only the level of new home sales, but also the 90% confidence interval constructed using [data from Census](https://www.census.gov/econ/currentdata/dbsearch?program=RESSALES&startYear=1963&endYear=2016&categories=ASOLD&dataType=TOTAL&geoLevel=US&adjusted=1&errorData=1&submit=GET+DATA&releaseScheduleId=).

<img src="{{ site.url }}/img/charts_jun_26_2016/newsales_6_25_2016_bands.gif" alt="dot plot"/>

## Total home sales behind 2007, but looking to gain

Through May total home sales (new + existing) are running below 2007 pace, but not by much. The chart below compares monthly total home sales (NSA) since 2007.  In 2007 home sales slowed considerably in the seconed half of the year, leaving room for 2016 to catch up if we can maintain a pace similar to last year.


<img src="{{ site.url }}/img/charts_jun_26_2016/tween sales jun 25 2016.gif" alt="dot plot"/>

# Ahead of Brexit, interest rates already falling.

On Friday after the Brexit leave vote was announced, financial markets roiled, with stocks tumbling and Treasury yields falling. But even before the vote was announced, long-term interest rates had been falling. 

<img src="{{ site.url }}/img/charts_jun_26_2016/rate_6_23_2016_2.gif" alt="pmms 6 23 2016"/>

Will mortgage rates fall even more next week? With 10-year Treasury yields down almost 19 basis points on Friday, we should expect to see mortgage rates trend lower in the next week. But even if the declines in Treasury yields stick next week, in times of volatility some of the declines in Treasury yields do not flow into mortgage rates, instead spreads widen.

![plot of chunk rate-scatter](/img/Rfig/rate-scatter-1.svg)

The chart above shows that in general, the 30-year fixed mortgage rate follows the 10-year Treasury pretty closely. However, in 2012 there were several points below the line. Those weeks correspond to the spring of 2012 when 10-year Treasury yields fell more rapidly than mortgage rates. This was partially due to increased volatility and risk aversion around other European macroeconomic risks.

The chart below shows the time series for the 10-year Treasury and the 30-year mortgage rate, with the spread shaded.

![plot of chunk rate-spread1](/img/Rfig/rate-spread1-1.svg)

The chart below plots the spread, with the 2011-2016 average (about 1.7 percentage points) spreads denoted by the dotted lines.  Periods when the spreads were above average (2011-2012) and again in 2016 were periods with increased macroeconomic risks.

![plot of chunk rate-spread2](/img/Rfig/rate-spread2-1.svg)

While risks may be elevated, it might be helpful to compare to 2008 when spreads were considerably wider:

![plot of chunk rate-spread3](/img/Rfig/rate-spread3-1.svg)

# Visualizing affordability

This week the Joint Center for Housing Studies (JCHS) of Harvard University released their annual [State of the Nation's Housing](http://www.jchs.harvard.edu/research/state_nations_housing). The report is full of useful information about housing markets in the United States. 

One area of concern for analysts of U.S. housing markets is the rising cost burden of housing. In the report the JCHS computes costs burdens using Census data. Cost-burdened households are those that pay more than 30 percent of income for housing, while severely burdened households spend more than 50 percent. The chart below compares the percentage of cost-burdened households by metro area to the U.S. average broken out by household income.

<img src="{{ site.url }}/img/charts_jun_26_2016/jchs 2016 w5b.gif" alt="dot plot"/>


# Code to make selected charts

In this section I'll provide code to make a few of the charts I posed above.

First we'll load the required libraries.


{% highlight r %}
  library(ggplot2)
  library(scales)
  library(animation)
  library(ggthemes)
  library(data.table)
  library(tweenr)  #used for animation
library("viridis")
{% endhighlight %}

## Existing home sales chart

Next, we'll make a static version of the bar chart:


{% highlight r %}
ehs <- fread("data/ehs.txt")  #load data
ehs$date<-as.Date(ehs$date, format="%m/%d/%Y")
ehs[, ehsc:=cumsum(ehs), by=year]  #computer cumulative sales YTD

#Make plot
    ggplot(data=ehs[year>2006 & month<6], aes(x = factor(year), y = ehs,fill=reorder(mname,month),label=mname)) + geom_bar(color = "gray", stat = "identity",alpha=0.75)+
    scale_fill_viridis(discrete=T,end=0.95,direction=1,option="D")+  #use viridis color scale
    theme_minimal()+ 
    geom_text(data=ehs[month==5 & year==2016],aes(y=ehsc),nudge_y=0.25,hjust=-.2)+
    geom_hline(yintercept=ehs[ month==5 & year==2016]$ehsc,linetype=2,color="black")+
    xlab("")+ylab("")+
    labs(title="Existing Home Sales (Ths. NSA)",
         subtitle="dotted line 2016 YTD",
         caption="@lenkiefer Source:NAR")+
    theme(plot.title=element_text(size=14))+
    theme(legend.justification=c(0,0), legend.position="none")+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    scale_y_continuous(limits=c(0,3000))+
    coord_flip()  #flip so that the bars are horizontal rather than vertical
{% endhighlight %}

![plot of chunk ehs-bars](/img/Rfig/ehs-bars-1.svg)

### Animated existing home sales chart

Make the animation with the following code:


{% highlight r %}
ehs$mname<-factor(ehs$mname)  #convert months to factor

#This function will copy the data table, but overwrite months after the cutoff with values of 0
#This way, tweenr will extend out as we add months and fill in the values
myf3<-function(m){
  DT<-copy(ehs)
  DT<-DT[month>m,ehs:=0]
  DT$mm<-m
  as.data.frame(DT)}

my.list3<-lapply(c(seq(1,5,1),0),myf3)  #the animation will loop through each of the first five months of the year an then meet back at 0.


tf <- tween_states(my.list3, tweenlength= 2, statelength=3, ease=rep('cubic-in-out',17),nframes=50)
tf<-data.table(tf)  


oopt = ani.options(interval = 0.125)
saveGIF({for (i in 1:max(tf$.frame)) {
  g<-
    ggplot(data=tf[year>2006 & .frame==i & month<6], aes(x = factor(year), y = ehs,fill=reorder(mname,month),label=mname)) + geom_bar(color = "gray", stat = "identity",alpha=0.75)+
    scale_fill_viridis(discrete=T,end=0.95,direction=1,option="D")+  #use viridis color scale
    theme_minimal()+ 
    geom_text(data=tf[month==mm& year==2016 & .frame==i],aes(y=ehsc),nudge_y=0.25,hjust=-.2)+
    geom_hline(yintercept=tf[.frame==i & month==mm & year==2016]$ehsc,linetype=2,color="black")+
    xlab("")+ylab("")+
    labs(title="Existing Home Sales (Ths. NSA)",
         subtitle="dotted line 2016 YTD",
         caption="@lenkiefer Source:NAR")+
    theme(plot.title=element_text(size=14))+
    theme(legend.justification=c(0,0), legend.position="none")+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    scale_y_continuous(limits=c(0,3000))+coord_flip()
  print(g)
  ani.pause()
}
},movie.name="ehs ytd may 2016.gif",ani.width = 600, ani.height = 450)
{% endhighlight %}

## New home sales chart



{% highlight r %}
mydata <- fread("data/nhs.txt")
mydata$date<-as.Date(mydata$date, format="%m/%d/%Y")
    ggplot(data=mydata, aes(x=date,y=nsales, label = nsales))+geom_line(data=mydata)+
    scale_y_continuous(limits = c(200, 1600), breaks=seq(200,1600,200)) + 
    geom_point(data=tail(mydata,1),colour = plasma(5)[1], size = 3)+
    scale_x_date(labels= date_format("%b-%Y"), limits = as.Date(c('2000-01-01','2016-05-31'))) +
    geom_ribbon(data=mydata,aes(x=date,ymin=down,ymax=up),fill=plasma(5)[5],alpha=0.5)  +
    geom_hline(yintercept=tail(mydata,1)$nsales,linetype=2,color=plasma(5)[1])+
    theme(axis.title.x = element_blank()) +   # Remove x-axis label
    ylab("")+xlab("")+
    theme_minimal()+
    labs(x=NULL, y=NULL,
         title="New Home Sales (Ths. SAAR)",
         subtitle=paste(as.character(tail(mydata,1)$date,format="%b-%Y"),":",tail(mydata,1)$nsales),
         caption="@lenkiefer Source: Census/HUD, shaded area denotes confidence interval")+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.subtitle=element_text(color=plasma(5)[1]))+
    theme(plot.margin=unit(c(0.5,0.5,0.5,0.75),"cm"))+
    coord_cartesian(xlim=c(as.Date("2000-01-01"),as.Date("2016-7-14")), y=c(200,1600))
{% endhighlight %}

![plot of chunk nhs-band](/img/Rfig/nhs-band-1.svg)

### Animated new home sales chart

The animated gif for new sales is pretty straightforward to construct. We won't be using tweenr. Instead, we'll just loop through each row in the data frame, plotting all the points before that row.


{% highlight r %}
oopt = ani.options(interval = 0.15)
saveGIF({for (i in 1:nrow(mydata)) {
  g<-
    ggplot(data=mydata, aes(x=date,y=nsales, label = nsales))+geom_line(data=mydata[1:i,])+
    scale_y_continuous(limits = c(200, 1600), breaks=seq(200,1600,200)) + 
    geom_point(data=mydata[i,],colour = plasma(5)[1], size = 3)+
    scale_x_date(labels= date_format("%b-%Y"), limits = as.Date(c('2000-01-01','2016-05-31'))) +
    geom_ribbon(data=mydata[1:i,],aes(x=date,ymin=down,ymax=up),fill=plasma(5)[5],alpha=0.5)  +
    geom_hline(yintercept=mydata$nsales[i],linetype=2,color=plasma(5)[1])+
    theme(axis.title.x = element_blank()) +   # Remove x-axis label
    ylab("")+xlab("")+
    theme_minimal()+
    labs(x=NULL, y=NULL,
         title="New Home Sales (Ths. SAAR)",
         subtitle=paste(as.character(mydata$date[i],format="%b-%Y"),":",mydata$nsales[i]),
         caption="@lenkiefer Source: Census/HUD, shaded area denotes confidence interval")+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.subtitle=element_text(color=plasma(5)[1]))+
    theme(plot.margin=unit(c(0.5,0.5,0.5,0.75),"cm"))+
    coord_cartesian(xlim=c(as.Date("2000-01-01"),as.Date("2016-7-14")), y=c(200,1600))
  print(g)
  ani.pause()
  print(i)
}

   for (i2 in 1:10) {
    print(g)
    ani.pause()
  }
},movie.name="nhs.gif",ani.width = 600, ani.height = 450)
{% endhighlight %}

## Code for intrest rate charts


{% highlight r %}
rdata <- fread("data/rates.txt")  #load data
rdata$date<-as.Date(rdata$date, format="%m/%d/%Y")


#Make scatterplot: Treasury rates vs Mortgage Rate:

ggplot(data=rdata[year>2010,],aes(x=rate10y,y=mrate,color=factor(year)))+geom_point()+
         scale_color_viridis(name="Year",discrete=T,end=0.95,direction=1,option="D")+  #use viridis color scale    
  stat_smooth(method="lm",color="black",fill=NA,linetype=2)+
  theme(plot.title=element_text(size=14))+
    theme(legend.justification=c(0,0), legend.position="top")+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    labs(x="10-year Treas. Yield (CMT, %)",y="30-year Fixed Mortgage Rate (%)",title="10-year Treasury Yields and Mortgage Rates",
         subtitle="2011-2016",
         caption="@lenkiefer Source: Freddie Mac, Federal Reserve")

#Make line charts with shaded area (ribbon)

ggplot(data=rdata[year>2010,],aes(x=date,y=mrate))+
  geom_line(color=plasma(5)[1])+
  geom_line(aes(y=rate10y),color=plasma(5)[3])+
  geom_ribbon(aes(ymin=rate10y,ymax=mrate),fill=plasma(5)[2],alpha=0.5)+
  theme_minimal()+
  theme(plot.title=element_text(size=14))+
    theme(legend.justification=c(0,0), legend.position="top")+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    labs(x="",y="Rate (%)",title="10-year Treasury Yields and 30-year Fixed Mortgage Rates",
         subtitle="2011-2016",
         caption="@lenkiefer Source: Freddie Mac, Federal Reserve\ntop line mortgage rate, bottom 10-year Treasury, shaded area spread.")

#use data table to compute average spread post-2010
rdata[year>2010,sav:=mean(mrate-rate10y,na.rm=T)]

#Make spread chart:

ggplot(data=rdata[year>2010,],aes(x=date,y=mrate-rate10y))+
  geom_line(color=plasma(5)[1])+
  geom_ribbon(aes(ymin=sav,ymax=mrate-rate10y),fill=plasma(5)[2],alpha=0.5)+
  theme_minimal()+ geom_line(aes(y=sav),color="black",linetype=2,size=1.15)+
  theme(plot.title=element_text(size=14))+
    theme(legend.justification=c(0,0), legend.position="top")+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    labs(x="",y="Rate (%)",title="Spread: 30-year Fixed Mortgage - 10-year Treasury",
         subtitle="2011-2016",
         caption="@lenkiefer Source: Freddie Mac, Federal Reserve dotted line average spread (2011-2016)")
{% endhighlight %}
