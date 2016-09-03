---
layout: post
title: "What we spend: Consumer Expenditures in 2015"
author: "Len Kiefer"
date: "September 2, 2016"
summary: "rstats data visualizations, mortgage data, maps"
group: navigation
theme :
  name : lentheme
---

<style>
.showopt {
  background-color: #004c93;
  color: #FFFFFF; 
  width: 100px;
  height: 20px;
  text-align: center;
  vertical-align: middle !important;
  float: right;
  font-family: sans-serif;
  border-radius: 8px;
}

.showopt:hover {
    background-color: #dfe4f2;
    color: #004c93;
}

pre.plot {
  background-color: white !important;
}
</style>








<script src="{{ site.url }}/img/charts_sep_02_2016/hideOutput.js"></script>

EARLIER THIS WEEK THE U.S. BUREAU OF LABOR STATISTICS [released](http://www.bls.gov/news.release/cesan.nr0.htm) data on consumer expenditures in 2015.  In this post I want to examine these data and make a few visualizations.  *R code for graphs posted below*

One area I pay close attention to is housing.  Housing is the largest single category of expenditure, averaging about 1/3 of total consumer expenditures. The BLS breaks the data out by tenure, so we can see how expenditures vary by owners versus renters.  The chart below looks at this.

![plot of chunk fig-spend-1](/img/Rfig/fig-spend-1-1.svg)

What we see is that housing expenditures (as a share of total expenditures) have fallen in recent years for owners, but have been rising for renters.


### Expenditure shares

The data provide rich detail, but we can break total expenditures down by major category.  The chart below shows this breakdown for 2015.

![plot of chunk fig-spend-2](/img/Rfig/fig-spend-2-1.svg)
 
And as an animated gif:

<img src="{{ site.url }}/img/charts_sep_02_2016/cons share.gif" alt="share gif"/>
 
 
### Or in dollars


![plot of chunk fig-spend-2b](/img/Rfig/fig-spend-2b-1.svg)

And as an animated gif:

<img src="{{ site.url }}/img/charts_sep_02_2016/cons dollars.gif" alt="dollars gif"/>

## Code

Code for all the plots (including importing the data from BLS) is below. See [here](http://download.bls.gov/pub/time.series/cx/cx.txt) for documentation from BLS on how to read the data files.

The animated lollipop charts were made using a combination of the animation and tweenr packages for R. 

*See my earlier [post about tweenr]({% post_url 2016-05-29-improving-R-animated-gifs-with-tweenr %}) for an introduction to tweenr, and more examples [here]({% post_url 2016-05-30-more-tweenr-animations %}) and [here]({% post_url 2016-06-26-week-in-review %}).*

### load libraries and code


{% highlight r %}
#load some libraries
library(data.table)
library(reshape2)
library(stringr)
library(ggplot2)
library(scales)
library(ggthemes)
library(rgeos)
library(maptools)
library(albersusa)
library(dplyr)
library(tidyr)
library(ggalt)
library(viridis)
library(zoo)
library(readxl)
library(htmlTable)
library(viridis)

#get data from BLS:
cex.data<-fread("http://download.bls.gov/pub/time.series/cx/cx.data.1.AllData")
cex.series<-fread("http://download.bls.gov/pub/time.series/cx/cx.series")
cex.item<-fread("http://download.bls.gov/pub/time.series/cx/cx.item")
cex.dem<-fread("http://download.bls.gov/pub/time.series/cx/cx.demographics")
cex.char<-fread("http://download.bls.gov/pub/time.series/cx/cx.characteristics",
                col.names=c("demographics_code","characteristics_code",	"characteristics_text",	"display_level","selectable",	"sort_sequence","BLANK"))
cex.cat<-fread("http://download.bls.gov/pub/time.series/cx/cx.category")
cex.sub<-fread("http://download.bls.gov/pub/time.series/cx/cx.subcategory")


#we want to focus on housing data:
my.series<-unique(cex.series[subcategory_code=="HOUSING"])
hous.data<-cex.data[series_id %in% my.series$series_id,]
my.series<-cex.series[demographics_code =="LB08" & characteristics_code %in% c("01","02","05")]
hous.data<-cex.data[series_id %in% my.series$series_id,]
hous.data<-merge(hous.data,my.series[,list(series_id,series_title,category_code,subcategory_code,characteristics_code)],by="series_id")
test<-hous.data[year==2015 & characteristics_code=="01" & category_code=="EXPEND" & subcategory_code=="HOUSING",]


# Housing series id: CXUHOUSINGLB0801M      
# All:   CXUTOTALEXPLB0801M
# renter:CXUTOTALEXPLB0805M
# owner: CXUTOTALEXPLB0802M
# i had to look these up


my.list2<-c("CXUTOTALEXPLB0801M","CXUTOTALEXPLB0802M","CXUTOTALEXPLB0805M",  "CXUHOUSINGLB0801M","CXUHOUSINGLB0802M" ,"CXUHOUSINGLB0805M")


pdata<-hous.data[series_id %in% my.list2,list(spend=sum(value)),by=list(subcategory_code,series_title,characteristics_code,year)]

pdata<-pdata[,tenure:=ifelse(characteristics_code=="01","All",ifelse(characteristics_code=="02","Owner","Renter"))]
# transpose data

#compute shares:
pdata[,list(subcategory_code,tenure,year,spend)] %>% unite(variable,subcategory_code,tenure) %>%
  spread(variable,spend) -> pdata


p4<-pdata[, list(share_all=HOUSING_All/TOTALEXP_All,
              share_own=HOUSING_Owner/TOTALEXP_Owner,
              share_rent=HOUSING_Renter/TOTALEXP_Renter),by=year  ]
{% endhighlight %}

### Make the first graph

{% highlight r %}
yy<-2015
  ggplot(data=p4[year<=yy],aes(x=year))+
    theme_minimal()+
    geom_line(aes(y=share_all),color=viridis(7)[1],size=1.2)+
    geom_line(aes(y=share_own),color=viridis(7)[4],size=1.2)+
    geom_line(aes(y=share_rent),color=viridis(7)[6],size=1.2)+
    scale_x_continuous(limits=c(1984,2018),breaks=seq(1985,2015,5))+
    scale_y_continuous(limits=c(.29,.4),breaks=seq(.29,.4,.01),label=percent)+
    geom_point(data=p4[year==yy],aes(x=year,y=share_all,label="  All"),color=viridis(7)[1],size=3)+
    geom_point(data=p4[year==yy],aes(x=year,y=share_own,label="  Owners"),color=viridis(7)[4],size=3)+
    geom_point(data=p4[year==yy],aes(x=year,y=share_rent,label="  Renters"),color=viridis(7)[6],size=3)+
    geom_text(data=p4[year==yy],aes(x=year,y=share_all,label="  All"),hjust=0,color=viridis(7)[1])+
    geom_text(data=p4[year==yy],aes(x=year,y=share_own,label="  Owners"),hjust=0,color=viridis(7)[4])+
    geom_text(data=p4[year==yy],aes(x=year,y=share_rent,label="  Renters"),hjust=0,color=viridis(7)[6])+
    labs(x="",y="",title="Housing share of consumer expenditures",
         subtitle="Shares of average annual expenditures by housing tenure",
         caption="@lenkiefer Source: U.S. Bureau of Labor Statistics, Consumer Expenditure Survey")+
    theme(plot.title=element_text(size=14))+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))
{% endhighlight %}

### Make the other graphs



{% highlight r %}
test<-hous.data[year==2015 & characteristics_code=="01" & category_code=="EXPEND",]
tmp<-test[order(-value)]

agg.id<-tmp[, .SD[c(1)], by=subcategory_code]$series_id

pdata3<-hous.data[series_id %in% agg.id,list(spend=sum(value)),by=list(subcategory_code,series_title,characteristics_code,year)]

pdata3[,tot.spend:=sum(ifelse(subcategory_code=="TOTALEXP",spend,0)),by=year]
pdata3[,spend.share:=spend/tot.spend]
pdata3[,avg.share:=mean(spend.share),by=subcategory_code]
pdata3<-pdata3[order(avg.share)]
pdata3[,id:=1:.N,by=list(year)]

y.list<-seq(1984,2015,1)
yy<-2015
pdata3[,mylabel:=substr(series_title,1,grep('LB08',series_title)),by=list(year,subcategory_code)]


pdata3[,mylabel:=gsub("-LB08-All Consumer Units*","",series_title),by=list(year,subcategory_code)]
ggplot(data=pdata3[subcategory_code !="TOTALEXP" & year==yy],
           aes(x=spend.share,y=id,color=mylabel))+
  theme_minimal()+
  geom_segment(aes(x=0,xend=spend.share,y=id,yend=id),size=1.25)+
      geom_point(size=4,alpha=0.95)+
  theme(axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  scale_x_continuous(limits=c(0,.4),label=percent)+
  geom_text(aes(label=paste(" ",mylabel,as.character(percent(spend.share)))),hjust=0,size=3)+
  theme(legend.position="none")+
  labs(x="Average Expenditure in Category over Average Total Expenditure", y="",
       title="Consumer Expenditure Shares",
       subtitle=head(tf[.frame==i]$year,1),
       caption="@lenkiefer Source: U.S. Bureau of Labor Statistics, Consumer Expenditure Survey")+
  theme(plot.title=element_text(size=14))+
  theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))

# Dollar plot:

ggplot(data=pdata3[subcategory_code !="TOTALEXP" & year==yy],
           aes(x=spend,y=id,color=mylabel))+
  theme_minimal()+
  geom_segment(aes(x=0,xend=spend,y=id,yend=id),size=1.25)+
      geom_point(size=4,alpha=0.95)+
  theme(axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  scale_x_log10(limits=c(100,5e4),breaks=c(100,1000,5000,10000,20000),label=dollar)+
  geom_text(aes(label=paste(" ",mylabel,as.character(dollar(round(spend,0))))),hjust=0,size=3)+
  theme(legend.position="none")+
  labs(x="Average Expenditure ($, log scale)", y="",
       title="Averaged Consumer Expenditures",
       subtitle=head(tf[.frame==i]$year,1),
       caption="@lenkiefer Source: U.S. Bureau of Labor Statistics, Consumer Expenditure Survey")+
  theme(plot.title=element_text(size=14))+
  theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))
{% endhighlight %}

### Make the animations


{% highlight r %}
y.list<-seq(1984,2015,1)
myf <- function (yy){
  
  my.out<-pdata3[subcategory_code !="TOTALEXP" & year==yy,]
  my.out %>% map_if(is.character, as.factor) %>% as.data.frame() ->my.out 
  my.out$year<-factor(my.out$year)
  return(my.out)
  }

my.list<-lapply(c(2015,y.list),myf)

tf <- tween_states(my.list,tweenlength= 3, statelength=2, ease=rep('cubic-in-out',2),nframes=23*8)
tf<-data.table(tf) #data.table useful for subsetting
N<-max(tf$.frame)  #number of frames

#create the animation 

#gif for shares 
oopt = ani.options(interval = 0.15)
saveGIF({for (i in 1:N) {
  g<-
    ggplot(data=tf[.frame==i,],
           aes(x=spend.share,y=id,color=mylabel))+
  theme_minimal()+
     geom_segment(aes(x=0,xend=spend.share,y=id,yend=id),size=1.25)+
      geom_point(size=4,alpha=0.95)+
  theme(axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  scale_x_continuous(limits=c(0,.4),label=percent)+
  geom_text(aes(label=paste(" ",mylabel,as.character(percent(spend.share)))),hjust=0)+
  theme(legend.position="none")+
  labs(x="Average Expenditure in Category over Average Total Expenditure", y="",
       title="Consumer Expenditure Shares",
       subtitle=head(tf[.frame==i]$year,1),
       caption="@lenkiefer Source: U.S. Bureau of Labor Statistics, Consumer Expenditure Survey")+
  theme(plot.title=element_text(size=14))+
  theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))
  print(g)
  print(i)
  ani.pause()  }
  },movie.name="cons share.gif",ani.width = 640, ani.height = 350)


#Make the gif in absolute $

oopt = ani.options(interval = 0.15)
saveGIF({for (i in 1:N) {
  g<-
    ggplot(data=tf[.frame==i,],
           aes(x=spend,y=id,color=mylabel))+
  theme_minimal()+
    #scale_color_viridis(direction=-1,end=0.85,limits=c(0,.35),option="B")+
  geom_segment(aes(x=0,xend=spend,y=id,yend=id),size=1.25)+
      geom_point(size=4,alpha=0.95)+
  theme(axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  scale_x_log10(limits=c(100,5e4),breaks=c(100,250,500,1000,2500,5000,10000,20000),label=dollar)+
  geom_text(aes(label=paste(" ",mylabel,as.character(dollar(round(spend,0))))),hjust=0)+
  theme(legend.position="none")+
  labs(x="Average Expenditure ($, log scale)", y="",
       title="Average Annual Consumer Expenditures",
       subtitle=head(tf[.frame==i]$year,1),
       caption="@lenkiefer Source: U.S. Bureau of Labor Statistics, Consumer Expenditure Survey")+
  theme(plot.title=element_text(size=14))+
  theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))
  print(g)
  print(i)
  ani.pause()  }
  },movie.name="cons dollars.gif",ani.width = 640, ani.height = 350)
{% endhighlight %}
