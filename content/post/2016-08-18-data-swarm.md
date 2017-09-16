---
title: 'Data swarms: Your firearms are useless against them!'
author: Len Kiefer
date: '2016-08-18'
slug: data-swarm
tags: ["dataviz","economy","R","data wrangling"]
---

AUGUST IS ALMOST OVER, and it's nearly back to school season.  And that means one thing.  No, not that we're about to get a chance to watch the [#1 NCAA football program of all time](http://www.ncaa.com/news/football/article/2016-08-02/college-football-ohio-state-tops-aps-all-time-top-100) dominate the gridiron (though that's awesome too). No, it's data release season!  A data swarm is on its way.

From [American Community Survey](http://www.census.gov/programs-surveys/acs/news/data-releases/2015/release-schedule.html) to the [American Housing Survey](http://www.census.gov/programs-surveys/ahs/news/2015-data-release.html) to the annual [Home Mortgage Disclosure Act Data](https://www.ffiec.gov/hmda/faqtech.htm#p3) many statistical data releases come out in September and October.

In preparation for all these data releases I've been firing up the viz terminal and getting my statistical software all stretched out.  Good news is, there's all kind of great innovations coming out to help me. Bad news is there's so much to keep up with.  In this post I'm going to try out some new techniques and work on some fundamentals. 

# Data wrangling with R

Out of expediency I've often used Excel for mundane data wrangling tasks ([see here for an example](../../../../2016/05/08/visual-meditations-on-house-prices-part1 )), but I've been meaning to use R more.

Fortunately I've gotten some help to jump start me. [@jkregenstein](https://twitter.com/jkregenstein), who works at [Rstudio](https://www.rstudio.com/) reached out to me and offered me some R code (see [here for house prices example](https://beta.rstudioconnect.com/content/1341/Freddie_Data_Notebook.nb.html) and  [here for credit panel example](https://beta.rstudioconnect.com/content/1445/ConsumerCreditDataNotebook.nb.html) from Jonathan) to accomplish what I was doing with Excel.  

I'm going to try to build from Jonathan's examples and work out my data wrangling skills with an example using negative equity estimates from Zillow.

## Wrangling some data

Zillow publishes a [negative equity report](http://www.zillow.com/research/methodology-negative-equity-3180/) that tracks what proportion of homeowners currently are "underwater" or owe more on their mortgage than what their home is currently worth.  See a write-up of their latest release from Zillow Chief Economist [@SvenjaGudell ](https://twitter.com/SvenjaGudell) [here](http://www.zillow.com/research/q2-2016-negative-equity-report-13046/). Note that the firm [CoreLogic also has a report](http://www.corelogic.com/about-us/researchtrends/homeowner-equity-report.aspx). The two reports are slightly different due to different underlying data and different, but similar, methodologies.  Because the Zillow data is available in a handy .csv format [downloadable](http://www.zillow.com/research/data/#additional-data) from their website I'm going to use the Zillow data. 

The Zillow data is not [tidy](http://vita.had.co.nz/papers/tidy-data.pdf), but it's not too far from it. It's a good version to practice on. Downloading the [data](http://files.zillowstatic.com/research/public/NegativeEquity_2016Q1_Public.csv) you get a .csv file that looks like this when viewed in Excel. **Note Zillow released the 2016Q2 [report today](http://www.zillow.com/research/q2-2016-negative-equity-report-13046/), but the latest available data at time of writing is the 2016Q1 report**

<img src="../../../../img/charts_aug_18_2016/zillow ne report.PNG" alt="zillow data" style="width: 550px;"/>

In the data file there are several descriptive columns and then the actual data showing the proportion of homeowners underwater according to Zillow's calculations starting in the 13th column (M in the spreadsheet). We'll want to tidy this column by gathering all the data columns (from columns 13 to 32 or column M to AF).

My standard approach with this would be to use the Excel pivot table wizard to gather the columns like so (from my [house price data wrangling post](../../../../2016/05/08/visual-meditations-on-house-prices-part1 )):

<img src="../../../../img/charts_may_8_2016/tidy1.gif" alt="FMHPI 6" style="width: 550px;"/>

But tidying these data in R is pretty easy.

Here's how I would have gone about it:





{% highlight r 
#load libraries
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(readxl)
library(ggplot2)
library(ggrepel)
library(ggthemes)
library(scales)
library(zoo)
library(data.table)

#zdata<-fread("http://files.zillowstatic.com/research/public/NegativeEquity_2016Q1_Public.csv")

# Here's how I would have done it by brut(ish) force
z2<-data.table(gather(zdata,dateq,"neg",13:32))
z2[,year:=as.numeric(substring(dateq,1,4))]
z2[,month:=as.numeric(substring(dateq,6,6))]
z2$date<- as.Date(ISOdate(z2$year,z2$month,1) )  #this converts year and month characters to R dates
{% endhighlight 

But after reading Jonathan's code examples I see that I can try a slightly different approach to get to the same place.

{% highlight r 
##manipulate and create new variables
zdata_wrangled <-zdata  %>% 
  gather(dateq,"neg",13:32) %>%
  #create a column called year and month by separating the zillow date column
  separate(dateq,into=c("year","quarter"),sep="Q",convert=T,remove=F) %>%
  #create dates
  mutate(
    date= as.Date(ISOdate(year,quarter*3,1) )
  ) %>% data.table()
{% endhighlight 

### Okay let's use these data for something

Let's examine trends in negative equity by state using these data. Once again we'll use the R packaged tweenr and animate to make an animated gif. See my earlier [post about tweenr](../../../../2016/05/29/improving-R-animated-gifs-with-tweenr ) for an introduction to tweenr, and more examples [here](../../../../2016/05/30/more-tweenr-animations ) and [here](../../../../2016/06/26/week-in-review ).




{% highlight r 
USID<-unique(z3[RegionType=="Country"]$RegionID)   #get the US region ID
regions<-unique(z3[RegionType=="State"]$RegionID)  #get a list of state IDs

#add the "US" at the top and the bottomw of the list of states 
r2<-c(USID,regions,USID)

# function to create list of data sets from our data (by state)
myf<-function(r){
  z.out<-z3[RegionType %in% c("Country","State") & RegionID==r, list(RegionName,date,neg)]
  z.out %>% map_if(is.character, as.factor) %>% as.data.frame() ->z.out
  return(z.out)
  }
myf(regions[1])
# use lapply to generate the list of data sets:
my.list2<-lapply(r2,myf)

# Apply tweenr:
tf <- tween_states(my.list2, tweenlength= 2, statelength=3, ease=rep('cubic-in-out',51),nframes=300)
dtf<-data.table(tf)  # Make tweenr output a data table 

oopt = ani.options(interval = 0.15)
saveGIF({for (i in 1:max(tf$.frame)) {
# create the animation
g<-
  ggplot(data=dtf,aes(x=date,y=neg,group=RegionName,label=RegionName))+
  geom_path(data=z3[RegionID %in% r2,],aes(x=date,y=neg),color="gray",alpha=0.3)  +
  scale_y_continuous(labels=percent)+
  geom_line(data=dtf[.frame==i,],color="red",size=1.1)+
  #add % at end
  geom_text(data=dtf[date==max(dtf$date) & .frame==i],aes(label=percent(neg)),
            nudge_y=.025,nudge_x=10, color="red")+
  #add point at line end:
  geom_point(data=dtf[date==max(dtf$date) & .frame==i],size=2, color="red")+
  #style:
  theme_minimal()+  theme(plot.title=element_text(face="bold",size=12))+
  theme(plot.caption=element_text(hjust=0))+
  theme(plot.subtitle=element_text(color="red"))+
  #labels:
  labs(y="Percent of homeowners underwater", x="",
       caption="@lenkiefer Source: Zillow Negative Equity Report (2016Q1)",
       subtitle=unique(dtf[.frame==i]$RegionName),
       title="Negative Equity by State")
print(g)
ani.pause()
print(i)
}
},movie.name="zillow neg equity 2016Q1.gif",ani.width = 500, ani.height = 350)
{% endhighlight 

Which yields:


<img src="../../../../img/charts_aug_18_2016/zillow neg equity 2016Q1.gif" alt="neg equity gif"/>


# Swarms and swarms

I spend a lot of time looking at the annual Home Mortgage Disclosure Act (HMDA) data. The publicly available data is a great source of information for what's happened in the mortgage market in the past year. The data are only available with a lag.  In September/October we'll get the 2015 data.

The data are housed over at the Consumer Financial Protection Bureau [webpage](http://www.consumerfinance.gov/data-research/hmda/explore). They have a public [API](http://www.consumerfinance.gov/data-research/hmda/api), but I haven't seen anything written on using R with it. But they do have a nice summary file generator, which can be quite handy. But for this exercise we'll work with the loan level data.

For this exercise we're going to work with mortgage loan origination records from the 2014 HMDA data.

Every year there are a lot of mortgages originated. [Some](https://twitter.com/lenkiefer/status/765204080604147712) have even said that this year (2016) the total market will top $2 Trillion in originated mortgages. In 2014 there were over 5 million mortgage loans originated for 1-4 family dwellings and manufactured housing. For the following examples I downloaded a loan-level file including all 5 million + observations from the CFPB website. To make things marginally faster I restricted myself to conventional loans, bringing the raw count down to about 4 million loans.


## Beeswarm plots

Yesterday [@hadleywickham](https://twitter.com/hadleywickham) [commented](https://twitter.com/hadleywickham/status/765893450172473344) on how he was enjoying the [ggbeeswarm package](https://github.com/eclarke/ggbeeswarm) which allows you to make beeswarm plots (or column scatter plots or violin scatter plots) in R with ggplot2.

I like to look at distributions in different ways, so I thought I would try them out. I was not disappointed, especially when I combined it with tweenr.

For this example, I'm going to use the beeswarm package to generate beeswarm plots shows the distribution of loan amount across states broken out by purchase and refinance loans. And we'll use tweenr to animate the transitions.

<img src="../../../../img/charts_aug_18_2016/HMDA loan amounts v3.gif" alt="HMDA Swarm"/>

## Making the plot

I've pulled down a .csv file from the CFPB website that containes all the conventional purchase and refinance 1-4 family dwelling and manufactured housing mortgage originations in 2014. [This link](http://www.consumerfinance.gov/data-research/hmda/explore#!/as_of_year=2014&property_type=1,3&action_taken=1&loan_purpose=1,3&loan_type=1&section=filters) will take you to the CFPB webpage where you can download the file. It is about 2.6 GB so I wouldn't recommend opening in Excel. *Though I have done such a thing in the past.*

But I'm not here to talk about the past (that's a story for another post). I'm here to talk about beeswarms.



{% highlight r 
library('ggbeeswarm')  #load the ggbeeswarm package
library('viridis')     # viridis for colors
mydata <- fread("~/data/hmda/hmda_lar.csv")  #load the .csv file data tables do well.


#let's only keep important columns
mydata<-mydata[,list(state_name,loan_purpose_name,loan_type_name,loan_amount_000s)]
mydata$upb<-as.numeric(mydata$loan_amount_000s)*1000

#subset data for smaller version:
mydata2<-mydata[ loan_type_name %in% c("Conventional") & state_name !="", ]  #my original query included non-conventional (e.g. FHA, VA, or RHS loans)

rm(mydata)  #drop unecessary data

#convert characters to factors for tweenr

mydata2 %>% map_if(is.character, as.factor) %>% as_data_frame -> mydata2

myf <- function(mystate){
  my.out<-mydata2[state_name==mystate,list(upb,loan_purpose_name,loan_type_name,state_name)][sample(.N,3000)]
  #The data is huge, so I only want to sample 3000 loans.  Plotting millions of points isn't very useful.

    my.out %>% map_if(is.character, as.factor) %>% as.data.frame() ->my.out  #need to convert characters to factors for tweenr
  return(data.frame(my.out))}

#I want to order states by total loan origination Unpaid Principal Balance (upb)
#Calinfornia goes first
st.sums1<-mydata2[, list(upb=sum(as.numeric(loan_amount_000s))/1e6),by=state_name] 

st.list<-as.character(unique(st.sums1[order(-upb)]$state_name))  #unique list of states
my.list<-lapply(c(st.list[1:51],st.list[1]),myf) 

# tween
tf <- tween_states(my.list, tweenlength= 3, statelength=2, ease=rep('cubic-in-out',24),nframes=300)
tf<-data.table(tf)

#a plot for the function
myplot<-function(i){
  g<-
    ggplot(tf[.frame==i & upb>0],
           aes(y=loan_purpose_name,x=upb/1000,color=loan_purpose_name))+
    theme_minimal()+    
    theme(plot.title=element_text(size=14))+theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    geom_quasirandom(alpha=0.35,size=.7)+  #I like the quasirandom beeswarm option
    scale_color_viridis(discrete=T,option="D",end=0.5)+  #use viridis color package, it's great!
    theme(legend.justification=c(0,0), legend.position="none")+
    # use a log scale
    scale_x_log10(limits=c(10,2500),label=dollar,breaks=c(10,25,50,100,250,500,1000,2000))+ 
    #labels
    labs(x="Loan Amount (Ths $, log scale)",
         y="Loan Purpose",title="Distribution of conventional mortgage loan amount",
         subtitle=paste(unique(tf[.frame==i]$state),"in 2014"),
        caption="@lenkiefer Source: CFPB, FFIEC, Home Mortgage Disclosure Act (HMDA) data\nEach dot represents one originated loan. (3,000 loans randomly sampled for plot)\nIncludes only Conventional purchase and refinance loans for 1-4 family dwellings and manufactured housing.")
   return(g)  }

# make the movie

library(animation)
oopt = ani.options(interval = 0.2)
saveGIF({for (i in 1:max(tf$.frame)) {
  g<-myplot(i)
  print(g)
  ani.pause()
  print(i)
}
},movie.name="HMDA loan amounts v3.gif",ani.width = 740, ani.height = 450)
{% endhighlight 



