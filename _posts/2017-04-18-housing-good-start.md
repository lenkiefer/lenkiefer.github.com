---
layout: post
title: "Housing gets off to a good start"
author: "Len Kiefer"
date: "2017-04-18"
summary: "R statistics rstats mortgage rates dataviz"
group: navigation
theme :
  name : lentheme
---

IN 2016 HOUSING IN THE UNITED STATES HAD ITS BEST YEAR IN A DECADE ([see my review]({{ site.url}}/chartbooks/dec2016/index.html) or my [flexdashboard remix]({% post_url 2017-01-14-year-in-review-remix%})) and so far 2017 has gotten off to a good **start**.  Let's take a look at [residential construction](https://www.census.gov/construction/nrc/index.html), particularly housing starts and see how they stack up to prior years.

Per usual we will use [R](https://www.r-project.org/), and the libraries of [data.table()](https://cran.r-project.org/web/packages/data.table/index.html) and the [tidyverse](http://tidyverse.org/) for data management and plotting, and [animation](https://cran.r-project.org/web/packages/animation/index.html) and [tweenr](https://cran.r-project.org/web/packages/tweenr/index.html) for animating.

We'll also try out our [modfied dark theme]({% post_url 2017-04-14-after-dark%}).

# The data

[Today](https://www.census.gov/construction/nrc/pdf/newresconst.pdf) the U.S. Census Bureau joint with the Department of Housing and Urban Development released estimates for new residential construction through March of 2017.

While we could get the data via [FRED](https://fred.stlouisfed.org/) (see my [earlier post]({% post_url 2017-04-11-Fred-plot%}) on how to do it with easily with R) Census makes the data easily assessable  on [this page](https://www.census.gov/econ/currentdata/dbsearch?program=RESCONST&startYear=1959&endYear=2017&categories=APERMITS&dataType=TOTAL&geoLevel=US&adjusted=1&notAdjusted=0&errorData=0). They even recently added a super duper convenient ["Download all data for this report/survey"](Download all data for this report/survey) link.  Follow the link and you'll end up with a pretty handy *.csv* file.

The .csv file is laid out so that the data is encoded at the bottom and some handy lookup tables are also included. **(Do read the README file!)** The data are not exactly [tidy](http://vita.had.co.nz/papers/tidy-data.html), but as these things go pretty close. My code starts assuming that you copy the data into a **.txt** file called *starts.txt*.  The file *starts.txt* corresponds to cells A758:G68988 as of the March 2017 release if you open the *.csv* file in Excel (future releases will probably shift the cells so adjust accordingly).

Starting from here, we'll let R take over.  Let's just load the data and plot a time series.


{% highlight r %}
##################################################################################
## Load libraries we will need
library(tidyverse,quietly=T,warn.conflicts = F)
library(data.table,quietly=T,warn.conflicts = F)
library(extrafont,quietly=T,warn.conflicts = F)
library(gridExtra,quietly=T,warn.conflicts = F)
library(animation,quietly=T,warn.conflicts = F)
library(tweenr,quietly=T,warn.conflicts = F)
library(scales,quietly=T,warn.conflicts = F)
##################################################################################


##################################################################################
## Load the data
dt<-fread("data/starts.txt")
##################################################################################

##################################################################################
# The following information comes straight from the .csv file
# and describes the keys in the data file
##################################################################################

##################################################################################
# CATEGORIES
# cat_idx	cat_code	cat_desc
# 1	APERMITS	Annual Rate for Housing Units Authorized in Permit-Issuing Places
# 2	PERMITS	Housing Units Authorized in Permit-Issuing Places
# 3	AUTHNOTSTD	Housing Units Authorized But Not Started
# 4	ASTARTS	Annual Rate for Housing Units Started
# 5	STARTS	Housing Units Started
# 6	UNDERCONST	Housing Units Under Construction
# 7	ACOMPLETIONS	Annual Rate for Housing Units Completed
# 8	COMPLETIONS	Housing Units Completed
##################################################################################

##################################################################################
#DATA TYPES			
# dt_idx dt_code dt_desc	dt_unit
# 1	TOTAL	Total Units	K
# 2	SINGLE	Single-family Units	K
# 3	MULTI	Units in Buildings with 5 Units or More	K
##################################################################################

##################################################################################
#ERROR TYPES			
# et_idx	et_code	et_desc	et_unit
# 1	E_TOTAL	Relative Standard Error for Total Units	PCT
# 2	E_SINGLE	Relative Standard Error for Single-family Units	PCT
# 3	E_MULTI	Relative Standard Error for Units in Buildings with 5 Units or More	PCT
##################################################################################

##################################################################################
# GEO LEVELS		
# geo_idx	geo_code	geo_desc
# 1	US	United States
# 2	NE	Northeast
# 3	MW	Midwest
# 4	SO	South
# 5	WE	West
##################################################################################

##################################################################################
# Dates are indexed one a month from 1959-01-01 to 2017-03-01
# e. g. 
# TIME PERIODS	
# per_idx	per_name
# 1	1/1/1959
# 2	2/1/1959
# ....
# 699 3/1/2017
##################################################################################


##################################################################################
# Construct a lookup table for dates
dt.lookup<- data.table(per_idx=seq(1,699),
                       date=seq.Date(as.Date("1959-01-01"),
                                     as.Date("2017-03-01"),by="month"))
##################################################################################

##################################################################################
# Merge dates
dt<-merge(dt,dt.lookup,by="per_idx")
dt$date<-as.Date(dt$date, format="%m/%d/%Y")
##################################################################################


##################################################################################
# Create factor variable
dt$dt_idf<-as.factor(dt$dt_idx)
levels(dt$dt_idf)<-c("N/A","Total","Single Family (1 Unit)","Multifamily (5+ Units)")
##################################################################################
{% endhighlight %}

Now that we've loaded the data, let's make a time series plot. Let's plot the history of total housing starts for the United States at a seasonally adjusted annual rate This corresponds to filtering on `dt_id==1` for total, `geo_idx==1` for U.S., and `cat_idx==4` for starts at  a seasonally adjusted annual rate. Let's also add some recession shading.


{% highlight r %}
##################################################################################
# Construct a lookup table for recessions (1959-2017)
# original source see: https://www.r-bloggers.com/use-geom_rect-to-add-recession-bars-to-your-time-series-plots-rstats-ggplot/
recessions.df = read.table(textConnection(
  "Peak, Trough
  1960-04-01, 1961-02-01
  1969-12-01, 1970-11-01
  1973-11-01, 1975-03-01
  1980-01-01, 1980-07-01
  1981-07-01, 1982-11-01
  1990-07-01, 1991-03-01
  2001-03-01, 2001-11-01
  2007-12-01, 2009-06-01"), sep=',',
colClasses=c('Date', 'Date'), header=TRUE)
##################################################################################

ggplot(data=dt[cat_idx==4 & geo_idx==1 & dt_idx==1],
       aes(x=date,y=val))+
  geom_rect(data=recessions.df , inherit.aes = F,
            aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), 
            fill="gray50", alpha=0.5)+
  geom_line(color="#00B0F0",size=1.05)+
  theme_minimal()+
  scale_y_continuous(labels=comma)+
  labs(y="",title="Housing Starts",x="",
       subtitle="Thousands at seasonally adjusted annual rate",
       caption="@lenkiefer Source: U.S. Census Bureau/Department of Housing and Urban Development, NBER.\nShaded regions recessions.")
{% endhighlight %}

![plot of chunk 04-18-2017-plot-1](/img/Rfig/04-18-2017-plot-1-1.svg)

All right, that looks pretty good, but it's after dark in my timezone, so let's apply our [dark theme]({% post_url 2017-04-14-after-dark%}) (defined in the code) to the chart.


{% highlight r %}
##################################################################################
# Define our dark theme, called theme_dark2
theme_dark2 = function(base_size = 12, base_family = "Courier New") {
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
    
    theme(
      # Specify axis options
      axis.line = element_blank(),  
      axis.text.x = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
      axis.text.y = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
      axis.ticks = element_line(color = "white", size  =  0.2),  
      axis.title.x = element_text(size = base_size, color = "white", 
                                  margin = margin(0, 10, 0, 0)),  
      axis.title.y = element_text(size = base_size, color = "white", angle = 90, 
                                  margin = margin(0, 10, 0, 0)),  
      axis.ticks.length = unit(0.3, "lines"),   
      # Specify legend options
      legend.background = element_rect(color = NA, fill = " gray10"),  
      legend.key = element_rect(color = "white",  fill = " gray10"),  
      legend.key.size = unit(1.2, "lines"),  
      legend.key.height = NULL,  
      legend.key.width = NULL,      
      legend.text = element_text(size = base_size*0.8, color = "white"),  
      legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "white"),  
      legend.position = "right",  
      legend.text.align = NULL,  
      legend.title.align = NULL,  
      legend.direction = "vertical",  
      legend.box = NULL, 
      # Specify panel options
      panel.background = element_rect(fill = " gray10", color  =  NA),  
      panel.border = element_rect(fill = NA, color = "white"),  
      panel.grid.major = element_line(color = "grey35"),  
      panel.grid.minor = element_line(color = "grey20"),  
      panel.spacing = unit(2, "lines"),   
      # Specify facetting options
      strip.background = element_rect(fill = "grey30", color = "grey10"),  
      strip.text.x = element_text(size = base_size*0.8, color = "white",
                                  margin=margin(2,2,2,2)),  
      strip.text.y = element_text(size = base_size*0.8, color = "white",
                                  margin=margin(2,2,2,2),   
                                  angle = -90),  
      # Specify plot options
      plot.background = element_rect(color = " gray10", fill = " gray10"),  
      plot.title = element_text(size = base_size*1.5, color = "white",face="bold",
                                hjust=0,lineheight=1.25,
                                margin=margin(2,2,2,2)),  
      plot.subtitle = element_text(size = base_size*1, color = "white",face="italic",
                                   hjust=0,  margin=margin(2,2,2,2)),  
      plot.caption = element_text(size = base_size*0.8, color = "white",hjust=0),  
      plot.margin = unit(rep(1, 4), "lines")
      
    )
  
}

##################################################################################

ggplot(data=dt[cat_idx==4 & geo_idx==1 & dt_idx==1],
       aes(x=date,y=val))+
  geom_rect(data=recessions.df , inherit.aes = F,
            aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), 
            fill="gray80", alpha=0.3)+
  geom_line(color="#00B0F0",size=1.05)+
  facet_wrap(~dt_idf,ncol=1,scales="free_y")+theme_dark2()+

  scale_y_continuous(labels=scales::comma)+
  labs(y="",title="Housing Starts",x="",
       subtitle="Thousands at seasonally adjusted annual rate",
       caption="@lenkiefer Source: U.S. Census Bureau/Department of Housing and Urban Development, NBER.\nShaded regions recessions.")
{% endhighlight %}

![plot of chunk 04-18-2017-plot-2](/img/Rfig/04-18-2017-plot-2-1.svg)

We can see that while housing starts are trending up, they are well below hisotrical averages. Census breaks out construction activity between 1-unit properties (single family), 2 to 4 unit properties and 5+ unit properties (multifamily). Let's see how single family and multifamily starts trends compare:



{% highlight r %}
ggplot(data=dt[cat_idx==4 & geo_idx==1 & dt_idx %in% c(2,3)],
       aes(x=date,y=val))+
  facet_wrap(~dt_idf,ncol=2,scales="free_y")+theme_dark2()+
  geom_rect(data=recessions.df , inherit.aes = F,
            aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), 
            fill="gray80", alpha=0.25)+
    geom_line(color="#00B0F0",size=1.05)+
  scale_y_continuous(labels=scales::comma)+
  labs(y="",title="Housing Starts",x="",
       subtitle="Thousands at seasonally adjusted annual rate",
       caption="@lenkiefer Source: U.S. Census Bureau/Department of Housing and Urban Development, NBER.\nShaded regions recessions.")
{% endhighlight %}

![plot of chunk 04-18-2017-plot-3](/img/Rfig/04-18-2017-plot-3-1.svg)

While there is a lot of noise in each series, we can see that while multifamily starts are back close to hisotrical averages, single family starts have a ways to go.

# Off to a good start

But how does 2017 data compare to prior years?  The media often focuses on the month-over-month changes, but if we look closely at the Census/HUD report we see that even large percentage changes are often within the margin of error (not really different from no change).

By averaging over a few months of data we can get a better signal. Seasonal adjustment is also quite complicated, so we might examine the year-to-date sum of the non seasonally adjusted data.

So let's sum the seasonally unadjusted data for the first three months of 2017 and compare this sum to the same YTD sums for recent years.


{% highlight r %}
#create year factor:
dt<-dt[,year:=year(date)]
dt$yearf<-factor(year(dt$date),levels=seq(2017,1959))
# Compute cumulative YTD totals:
dt<-dt[,val.c:=cumsum(val),by=c("cat_idx","geo_idx","year","dt_idx")]

ggplot(data=dt[cat_idx==5 & geo_idx==1 & 
                 dt_idx==1 &
                 month(date)==3 & year(date)>1999,],
       aes(x=yearf,y=val.c))+
  facet_wrap(~dt_idf,ncol=3)+
  geom_segment(color="#00B0F0",aes(yend=0,xend=yearf),size=1.05)+
  geom_hline(yintercept=dt[cat_idx==5 & geo_idx==1 & 
                 dt_idx==1 &
                 month(date)==3 & year(date)==2017,]$val.c,
             linetype=2,color="white")+
  geom_point(color="#00B0F0",size=3)+theme_dark2()+coord_flip()+
  theme(axis.ticks.y=element_blank(),
        # Note need to shrink the margin to get the axis labels closer to the segments
        axis.text.y = element_text(margin = margin(r = -10)),
        panel.grid.major.y=element_blank(),
        panel.border=element_blank()
        )+
  labs(y="",title="Housing off to a good start",x="",
       subtitle="First quarter total housing starts in thousands, not seasonally adjusted",
       caption="@lenkiefer Source: U.S. Census Bureau/Department of Housing and Urban Development.")
{% endhighlight %}

![plot of chunk 04-18-2017-plot-4](/img/Rfig/04-18-2017-plot-4-1.svg)

This plost shows that housing starts through the first quarter are off to their best start since 2007.

How does it break out between singel family and multifamily starts?



{% highlight r %}
ggplot(data=dt[cat_idx==5 & geo_idx==1 & 
                 dt_idx %in% c(2,3) &
                 month(date)==3 & year(date)>1999,],
       aes(x=yearf,y=val.c))+
  facet_wrap(~dt_idf,ncol=2,scales="free_x")+
  geom_segment(color="#00B0F0",aes(yend=0,xend=yearf),size=1.05)+
  geom_hline(data=dt[cat_idx==5 & geo_idx==1 & 
                 dt_idx %in% c(2,3) &
                 month(date)==3 & year(date)==2017,],aes(yintercept=val.c),
             linetype=2,color="white")+
  geom_point(color="#00B0F0",size=3)+theme_dark2()+coord_flip()+
  theme(axis.ticks.y=element_blank(),
        # Note need to shrink the margin to get the axis labels closer to the segments
        axis.text.y = element_text(margin = margin(r = -10)),
        panel.grid.major.y=element_blank(),
        panel.border=element_blank()
        )+
  labs(y="",title="Housing off to a good start",x="",
       subtitle="First quarter total housing starts in thousands, not seasonally adjusted",
       caption="@lenkiefer Source: U.S. Census Bureau/Department of Housing and Urban Development.")
{% endhighlight %}

![plot of chunk 04-18-2017-plot-5](/img/Rfig/04-18-2017-plot-5-1.svg)

Here we see as above, that while multifamily starts are exceeding pre-recession averages, single family starts are still lagging.  However, starts are on the rise (and note that per the Census report the YTD sum is up 5.9 percent with a range of plus/minus 4.4 percent). So slowly and steadily, housing starts are rebounding.

### Animate it

We can also do our [usual business]({% post_url 2016-12-19-more-tweenr-housing%}) and animate this plot.


{% highlight r %}
# Compute function to overwrite values with 0
myf<-function (y){
  d.out<- dt[cat_idx==5 & geo_idx==1 & 
               dt_idx==1 &
               month(date)==3 & year(date)>1999,]
  d.out[year(date)>y,]$val.c<-0
  d.out %>% map_if(is.character, as.factor) %>% as.data.frame -> d.out
  return(d.out)
}

# Apply our function over a list
my.list<-lapply(c(seq(1999,2017),1999),myf)

#use tweenr to interploate
tf <- tween_states(my.list,tweenlength= 3,
                   statelength=2, ease=rep('cubic-in-out',2),nframes=75)
tf<-data.table(tf) #convert output into data table

# reorder year factor
tf$yearf<-factor(tf$yearf,levels=seq(2017,2000,-1))


#Animate plot

oopt = ani.options(interval = 0.2)
saveGIF({for (i in 1:max(tf$.frame)) { #loop over frames
  g<-
    ggplot(data=tf[.frame==i & year>1999,],
           aes(x=yearf,y=val.c))+
    facet_wrap(~dt_idf,ncol=3)+
    geom_segment(color="#00B0F0",aes(yend=0,xend=yearf),size=1.05)+
    scale_y_continuous(limits=c(0,500))+
    geom_point(color="#00B0F0",size=3)+theme_dark2()+coord_flip()+
    theme(axis.ticks.y=element_blank(),
          axis.text.y = element_text(margin = margin(r = -10)),
          panel.grid.major.y=element_blank(),
          panel.border=element_blank()  )+
    labs(y="",title="Housing off to a good start",x="",
         subtitle="1st quarter total housing starts in thousands, not seasonally adjusted",
         caption="@lenkiefer Source: U.S. Census Bureau/Department of Housing and Urban Development.")
  
  print(g)
  ani.pause()
  print(paste(i,"out of",max(tf$.frame)))}
},movie.name="tween starts YTD total.gif",ani.width = 750, ani.height = 400)
{% endhighlight %}

<img src="{{ site.url }}/img/charts_apr_18_2017/tween starts YTD total.gif" alt="starts ytd 2017q1 gif"/>
