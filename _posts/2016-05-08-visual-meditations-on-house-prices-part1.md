---
layout: post
title: "Visual meditations on house prices, Part 1: data wrangling"
author: "Len Kiefer"
date: "2016-05-08"
summary: "Charts and graphs exploring house price trends"
group: navigation
theme :
  name : lentheme
---
# Introduction

THIS POST CONSIDERS recent trends in house prices. Thinking a great deal about house prices, I like to look at many different DATA VISUALIZATIONS of house prices, at the national, state, and metro levels of aggregation. Also, in this post, I will include descriptions of how I built my visualizations, including code.  These meditations as I call them, required some data wrangling and some thinking as to how to construct the charts.

As the post was getting long, I decided to split it up. In this post, I'll handle data wrangling. We'll prepare the data for analysis both in <span class="icon-file-excel" style="color:green;"></span> Excel and R. In following post(s), we'll get into the details of creating the data visualizations. When we're through we'll build something like this:

<img src="{{ site.url }}/img/charts_may_8_2016/hpi_dots_state_redblue2.gif" alt="FMHPI Gif"/>

Let us begin by gathering data.

## The data

We're going to be using the Freddie Mac House Price Index (FMHPI), which is available to the public on [Freddie Mac's webpage](http://www.freddiemac.com/finance/house_price_index.html). This index is available at monthly frequencies for the nation, all 50 states plus the District of Columbia, and over 300 metro areas (CBSA).  The national index is available both seasonally-adjusted (SA), and non-seasonally adjusted (NSA), while the state and metro indices are only available NSA. 

*Disclosure my team at Freddie Mac helped assemble the Tableau data visualization on the Freddie Mac webpage.  This blog posts represents my own view and does not necessarily represent the views of Freddie Mac.* We're using the FMHPI because it's convenient to work with, has broad coverage, and is publicly available.

### FMHPI webpage:
<img src="{{ site.url }}/img/charts_may_8_2016/fmhpi1.PNG" alt="FMHPI 1" style="width: 550px;"/>

We'll need to navigate to the [archive page](http://www.freddiemac.com/finance/fmhpi/archive.html) to download the data we want. The data are in two excel spreadsheets <span class="icon-file-excel" style="color:green;"></span>: [*one for the national and state indices*](http://www.freddiemac.com/finance/fmhpi/current/excel/states.xls) and 
<span class="icon-file-excel" style="color:green;"></span>: [*one for the metro indices*](http://www.freddiemac.com/finance/fmhpi/current/excel/msas_new.xls). We'll need them both for what follows. 

### FMHPI data download:
<img src="{{ site.url }}/img/charts_may_8_2016/fmhpi2.PNG" alt="FMHPI 1" style="width: 550px;"/>

There are R packages that can manipulate data in <span class="icon-file-excel" style="color:green;"></span> .xls or <span class="icon-file-excel" style="color:green;"></span> .xlsx file formats. I'm not planning on getting proficient at that, instead I'm going to open up my excel bag of tricks to handle some data preparation. First, let's consider what we get when we download those house price spreadsheets.

### State file layout
<img src="{{ site.url }}/img/charts_may_8_2016/fmhpi3.PNG" alt="FMHPI 1" style="width: 550px;"/>

### Metro file layout
<img src="{{ site.url }}/img/charts_may_8_2016/fmhpi4.PNG" alt="FMHPI 1" style="width: 550px;"/>

### Comments on file layouts

Now these are not [*tidy data*](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html). Fortunately, the structure can be pretty quickly wrangled within excel to make our R life easier.  My strategy is to employ some <span class="icon-file-excel" style="color:green;"></span> Excel tricks to tidy this data. I've used the gather tools in the tidyr pacakge and they do work well, but as I'm going to write out a .txt file anyway so I can avoid using a <span class="icon-file-excel" style="color:green;"></span> .xls file I might as well use my excel trick to tidy these data.

## An excel trick to tidy data

Our goals is to convert the files to a tidy dataset.


<img src="{{ site.url }}/img/charts_may_8_2016/fmhpi6.PNG" alt="FMHPI 6" style="width: 550px;"/>

And we're going to do it in about 10 seconds:

<img src="{{ site.url }}/img/charts_may_8_2016/tidy1.gif" alt="FMHPI 6" style="width: 550px;"/>

This is one of my favorite  <span class="icon-file-excel" style="color:green;"></span> Excel tricks. You could of course, achieve this just as fast using the gather function in tidyr. But in case you are an <span class="icon-file-excel" style="color:green;"></span> Excel user, you can see the details of what I did in the [*this youtube video*](https://www.youtube.com/watch?v=pUXJLzqlEPk).

Because the metro data is laid out in two worksheets, you'll have to do a little more leg work to get the metro data laid out (and you might have convert the files to .xlsx to handle the extra rows). Also, I'm going to convert the date field, which isn't a date in the  <span class="icon-file-excel" style="color:green;"></span> Excel file to a year, month, and date column. Ultimately, we'll want a file that looks like this:


<img src="{{ site.url }}/img/charts_may_8_2016/fmhpi7.PNG" alt="FMHPI 6" style="width: 550px;"/>

and this for the metros:

<img src="{{ site.url }}/img/charts_may_8_2016/fmhpi8.PNG" alt="FMHPI 6" style="width: 550px;"/>

For the metros I included variables called "states" and "state1", which were created by parsing the metro name.  The variable "states" contains a list of all states that the metro area includes, while "state1" includes the primary state (first one listed by OMB). For example, the New York City metro area (New York-Newark-Jersey City, NY-NJ-PA) includes parts of New York, New Jersey, and Pennsylvania, but the primary state is New York.  This field could be helpful if we want to group the metros.

Then I save these files as .txt files to read into R. You can download the .txt files here (note I only included the NSA national index)

1. [*state and national called fmhpi.txt*]({{ site.url }}/img/charts_may_8_2016/fmhpi.txt)
2. [*metro called fmhpi2.txt*]({{ site.url }}/img/charts_may_8_2016/fmhpi2.txt)




{% highlight r %}
#Load some packages
library(data.table, warn.conflicts = FALSE, quietly=TRUE)
library(ggplot2, warn.conflicts = FALSE, quietly=TRUE)
library(dplyr, warn.conflicts = FALSE, quietly=TRUE)
library(zoo, warn.conflicts = FALSE, quietly=TRUE)
library(ggrepel, warn.conflicts = FALSE, quietly=TRUE)
library(ggthemes, warn.conflicts = FALSE, quietly=TRUE)
library(scales, warn.conflicts = FALSE, quietly=TRUE)
library(animation, warn.conflicts = FALSE, quietly=TRUE)
library(grid, warn.conflicts = FALSE, quietly=TRUE)
library(tidyr, warn.conflicts = FALSE, quietly=TRUE)
{% endhighlight %}

Now we'll need to load and prepare some data. We'll do this using the [*data.table*](https://cran.r-project.org/web/packages/data.table/index.html) package to set up our data.


{% highlight r %}
#load national & state data
statedata <- fread("fmhpi.txt")
statedata$date<-as.Date(statedata$date, format="%m/%d/%Y")

#Now uses some data table caclulations to compute percent changes in house prices by state/metro
statedata<-statedata[,hpa:=c(NA,((1+diff(hpi)/hpi))^12)-1,by=state]  
statedata<-statedata[,hpa12:=c(rep(NA,12),((1+diff(hpi,12)/hpi))^1)-1,by=state]  
statedata<-statedata[,hpa3:=c(rep(NA,12),((1+diff(hpi,3)/hpi))^4)-1,by=state]  

#create lags of state
statedata<-statedata[, hpi12 :=  shift(hpi,12), by=state]

#compute rolling min/max
statedata<-statedata[, hpi12min:=rollapply(hpi, 12, min,fill=NA, na.rm=FALSE,align='right'), by=state]
statedata<-statedata[, hpi12max:=rollapply(hpi, 12, max,fill=NA, na.rm=FALSE,align='right'), by=state]

#Do the same for metro data:

#load metro data:
metrodata <- fread("fmhpi2.txt")
metrodata$date<-as.Date(metrodata$date, format="%m/%d/%Y")

metrodata<-metrodata[,hpa:=c(NA,((1+diff(hpi)/hpi))^12)-1,by=metro]  
metrodata<-metrodata[,hpa12:=c(rep(NA,12),((1+diff(hpi,12)/hpi))^1)-1,by=metro]  
metrodata<-metrodata[,hpa3:=c(rep(NA,12),((1+diff(hpi,3)/hpi))^4)-1,by=metro]  

#create lags of metros
metrodata<-metrodata[, hpi12 :=  shift(hpi,12), by=metro]

#compute 12-month rolling min/max
metrodata<-metrodata[, hpi12min:=rollapply(hpi, 12, min,fill=NA, na.rm=FALSE,align='right'), by=metro]
metrodata<-metrodata[, hpi12max:=rollapply(hpi, 12, max,fill=NA, na.rm=FALSE,align='right'), by=metro]
{% endhighlight %}

In the code above we take advantage of the data table structure and some functions to compute some time series calculations that will be helpful for the plots we'll make later. For example, the diff function is used together with some exponentiation to calculate the monthly, quarterly, and annual house price appreciation (all annualized). I also used the rollapply function to caclulate a rolling 12-month min and max (backward looking by using align='right').

Before we close out this data preparation blog post, let's at least make one plot from the data.  The code below generates a time series plot for the national index from January 2000 to March 2016.


{% highlight r %}
#Plot the data using only the US index  
ggplot(data=statedata[state == "US"  & year>1999 ], aes(x=date,y=hpi))+
  #Use a minimal theme from the ggthemes() package
  theme_minimal()+
  #use a log y axis
  scale_y_log10(limits=c(90,200), breaks=c(100,125,150,175,200))+
  #format the date axis
  scale_x_date(labels= date_format("%y"),date_breaks="1 year",
               limits = as.Date(c('2000-01-01','2016-03-30'))) +
  #Add a line for the data
  geom_line(color="black",size=1.2)   +  
  #Add a red circle for the last data point
  geom_point(data=statedata[state =='US'  & year==yy & month==mm], color="red", alpha=0.7,size=3)+

  #Add a horizontal line at the last data point
  geom_hline(data = statedata[year==2016 & month==3 & state =="US"], aes(yintercept = hpi), color="red",alpha=0.7,linetype=2)+
  #Modify some styles
  theme(plot.title=element_text(face="bold",size=14))+
  theme(plot.caption=element_text(hjust=0,size=8))+
  xlab("")+ylab("House price index, log scale")+
  #use the development ggplot caption feature
  labs(caption="@lenkiefer Source: Freddie Mac House Price Index (Dec 2000 = 100, NSA)",
       subtitle="",
       title="U.S. house price trends")
{% endhighlight %}

![plot of chunk fig-main1](/img/Rfig/fig-main1-1.svg)

The chart shows the rise, fall, and recovery of national house prices. In this index house prices are still a little below their nominal peak, but trending higher. In the follow-up posts, we'll get creative with the data visualizations.

[Click here for Part 2: sparklines and dots (animated) ]({% post_url 2016-05-08-visual-meditations-on-house-prices-part2 %})
