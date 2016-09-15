---
layout: post
title: "Industry-specific Beveridge Curves"
author: "Len Kiefer"
date: "September 14, 2016"
summary: "R rstats data visualizations, mortgage data, maps"
group: navigation
theme :
  name : lentheme
---



IN MY [PREVIOUS POST]({% post_url 2016-09-10-job-openings-and-hires %}) we looked at the [Job Openings and Labor Turnover Survey (JOLTS)](http://www.bls.gov/jlt/home.htm) data and plotted a [Beveridge Curve](https://en.wikipedia.org/wiki/Beveridge_curve). In this post I want to add some more code that allows us to plot Beveridge Curves by industry.

For more on the analysis of industry-specific Beveridge Curves, see [this paper](http://www.bls.gov/opub/mlr/2012/06/art2full.pdf) published in the June 2012 [Monthly Labor Review](http://www.bls.gov/opub/mlr/about.htm) that decomposes shifts in the Beveridge Curve and looks at it by industry. Analyzing data through March 2012, the authors found that Construction alone shifted the total market Beveridge Curve by a full percentage point (see Table 4 in the paper).

## The data

While the data is all available from the Bureau of Labor Statistics (BLS) [webpage](bls.gov) it required some looking through the available files to find the right series. In the handy code I post below, we can grab the right data from BLS and produce our plots.

We're going to pull our data from two sources, the JOLTS data, and the [Current Population Survey (CPS)](http://www.bls.gov/cps/).  You can access flat files from BLS [here for JOLTS](http://download.bls.gov/pub/time.series/jt/) and [here for CPS](http://download.bls.gov/pub/time.series/ln/). Unfortunately the industry codes available in the flat files are not identical, but I hunted down (what I think are) the proper codes and combined them.  You can read more [here](http://www.bls.gov/cps/cpsoccind.htm).

The relevant passages are quoted below

### JOLTS

> The Job Openings and Labor Turnover Survey (JOLTS) publishes industry estimates based on the 2012 North American Industry Classification System (NAICS). NAICS-based estimates are available for December 2000 to the present

### CPS

> The Current Population Survey currently uses the 2010 Census occupational classification and, beginning with data for January 2014, the 2012 Census industry classification. These classifications were derived from the 2010 Standard Occupational Classification (SOC) and the 2012 North American Industry Classification System (NAICS), respectively, to meet the special classification needs of demographic household surveys. The Census classifications use the same basic structure as the SOC and NAICS, but are generally less detailed.


A crosswalk between the codes are available [here](http://www.bls.gov/cps/cenind2012.htm). For example, construction has the Census code 0770 while the corresponding NAICS code is 23.  

I'm going to rely on the fact that the industry names are identical in the BLS data and merge on the industry names rather than use the crosswalk. You can confirm this works by comparing [this table](http://www.bls.gov/news.release/jolts.t01.htm) for JOLTS to [this table](http://www.bls.gov/news.release/empsit.t14.htm) for the unemployment rate from CPS.  

### Setup files

The code below merges the industry names and codes for JOLTS to (the same) industry name and (different) codes for CPS.


{% highlight r %}
# load libraries
library(ggplot2)
library(animation)
library(stringr)
library(data.table)
library(tweenr)
library(purrr)
library(dplyr)
library(viridis)

#get unemployment data
# These are the major sectors in BLS table 14: http://www.bls.gov/news.release/empsit.t14.htm

#i saved these in a .txt file called incodelu.txt

#indy_code	indy_text
# 0000	All Industries	
# 0169	Agriculture, forestry, fishing, and hunting	
# 0368	Nonagriculture industries	
# 0369	Mining, quarrying, and oil and gas extraction	
# 0569	Utilities	
# 0770	Construction	
# 1068	Nondurable goods manufacturing	
# 2467	Manufacturing	
# 2468	Durable goods manufacturing	
# 4067	Wholesale and retail trade	
# 4068	Wholesale trade	
# 4669	Retail trade	
# 6068	Transportation and utilities	
# 6069	Transportation and warehousing	
# 6468	Information	
# 6469	Publishing, except Internet	
# 6569	Motion pictures and sound recording industries	
# 6670	Radio and television broadcasting and cable subscriptions programming	
# 6679	Telecommunications	
# 6769	Other information services	
# 6867	Financial activities	
# 6868	Finance and insurance	
# 6869	Finance	
# 6990	Insurance carriers and related activities	
# 7069	Real estate and rental and leasing	
# 7268	Professional and business services	
# 7269	Professional and technical services	
# 7569	Management, administrative, and waste services	
# 7858	Education and health services	
# 7859	Educational services	
# 7968	Health care and social assistance	
# 8558	Leisure and hospitality	
# 8559	Arts, entertainment, and recreation	
# 8658	Accommodation and food services	
# 8659	Accommodation	
# 8679	Food services and drinking places	
# 8767	Other services	
# 8768	Other services, except private households	
# 9290	Other services, private households

#read file:
my.indy<-fread("data/indcodeslu.txt")

#I also got the JOLTS codes 
#saved in a file  indcodesjolts.txt

# industry_code	industry_text	display_level	selectable	sort_sequence	blank
# 000000	Total nonfarm	0	T	1	
# 100000	Total private	1	T	2	
# 110099	Mining and logging	2	T	3	
# 230000	Construction	2	T	4	
# 300000	Manufacturing	2	T	5	
# 320000	Durable goods manufacturing	3	T	6	
# 340000	Nondurable goods manufacturing	3	T	7	
# 400000	Trade, transportation, and utilities	2	T	8	
# 420000	Wholesale trade	3	T	9	
# 440000	Retail trade	3	T	10	
# 480099	Transportation, warehousing, and utilities	3	T	11	
# 510000	Information	2	T	12	
# 510099	Financial activities	2	T	13	
# 520000	Finance and insurance	3	T	14	
# 530000	Real estate and rental and leasing	3	T	15	
# 540099	Professional and business services	2	T	16	
# 600000	Education and health services	2	T	17	
# 610000	Educational services	3	T	18	
# 620000	Health care and social assistance	3	T	19	
# 700000	Leisure and hospitality	2	T	20	
# 710000	Arts, entertainment, and recreation	3	T	21	
# 720000	Accommodation and food services	3	T	22	
# 810000	Other services	2	T	23	
# 900000	Government	1	T	24	
# 910000	Federal	2	T	25	
# 920000	State and local	2	T	26	
# 923000	State and local government education	3	T	27	
# 929000	State and local government, excluding education	3	T	28	

my.indy2<-fread("data/indcodesjolts.txt")


#merge together industry names
my.indy3<-merge(my.indy2,my.indy,by.x="industry_text",by.y="indy_text")
{% endhighlight %}

### Prepare data

Now that we have the codes we can read the data from the BLS and use the industry codes to merge the data.


{% highlight r %}
# read in unemployment rated
ln.series<-fread("http://download.bls.gov/pub/time.series/ln/ln.series")
ln.data<-fread("http://download.bls.gov/pub/time.series/ln/ln.data.1.AllData")
ln.indy<-fread("http://download.bls.gov/pub/time.series/ln/ln.indy")

# find series named unemployment rate:
my.series<-ln.series[grepl("Unemployment Rate",series_title) & indy_code !=0,]
my.series<-ln.series[(grepl("Unemployment Rate",series_title) & indy_code !=0 & indy_code %in% my.indy3$indy_code
                     & ages_code==0 & periodicity_code=="M" &  sexs_code==0) | series_id=="LNU04000000",]

 

ln.data2<-ln.data[year>1999 & series_id %in% my.series$series_id,]
ln.data2<-merge(ln.data2,my.series[,list(series_id,indy_code)],by="series_id",all.x=T)
ln.data2 <-merge(ln.data2,my.indy3[,list(indy_code,industry_text),],by="indy_code",all.x=T)
ln.data2<-dplyr::rename(ln.data2,ur=value)

#get jolts data

jolts.dt<-fread("http://download.bls.gov/pub/time.series/jt/jt.data.1.AllItems")
jolts.series<-fread("http://download.bls.gov/pub/time.series/jt/jt.series")
jolts.ind<-fread("http://download.bls.gov/pub/time.series/jt/jt.industry",
                 col.names=c("industry_code","industry_text",	"display_level",	"selectable","sort_sequence","blank"))
jolts.element<-fread("http://download.bls.gov/pub/time.series/jt/jt.dataelement",
                     col.names=c("dataelement_code","dataelement_text","display_level","selectable","sort_sequence","blank"                     ))


#we want job openeings: dataelement=JO, not seasonally adjusted, rates (ratelevel_code=R) and U.S. (region_code=00)
# we also want the aggregate series, whos id is JTU00000000JOR (I found it manually)

my.series<-jolts.series[( industry_code %in% my.indy3$industry_code & 
                            dataelement_code=="JO" &
                            seasonal=="U"  & ratelevel_code=="R" & region_code=="00") | series_id=="JTU00000000JOR", ]

jolts.dt2<-jolts.dt[series_id %in% my.series$series_id,]
jolts.dt2<-merge(jolts.dt2,my.series[,list(series_id,industry_code),],by="series_id")
jolts.dt2 <-merge(jolts.dt2,my.indy3[,list(industry_code,industry_text),],by="industry_code",all.x=T)
jolts.dt2<-dplyr::rename(jolts.dt2,jo=value)


all.dt<-merge(ln.data2[,list(year,period,ur,industry_text,indy_code)],
              jolts.dt2[,list(year,period,jo,industry_text,industry_code)],
              by=c("year","period","industry_text"))

# merge data:
all.dt$ur<-as.numeric(all.dt$ur)
all.dt[industry_code==0,industry_text:="All Industries"]
all.dt[,month:=as.numeric(substr(period,2,3))]
all.dt[,date:= as.Date(ISOdate(year,month,1))]

#We want to distinguish between recession and expansions using NBER recession dates

#Turning Point Date	Peak or Trough	Announcement Date with Link
#June 2009	Trough	September 20, 2010
#December 2007	Peak	December 1, 2008
#March 2001	Peak	November 26, 2001

#create recessions

all.dt[, recession:="Expansion"]
all.dt[ (date>"2001-02-28" & date<="2001-12-01") |
        (date>"2007-10-31" & date<="2009-06-30"),
        recession:="Recession" ]
{% endhighlight %}

### Check Data
Now we should have data in a format that we can use.


{% highlight r %}
library(htmlTable) #make a table
htmlTable(all.dt[ date=="2016-07-01", list(year,period,industry_text,indy_code,industry_code,ur,jo)], col.rgroup = c("none", "#F7F7F7"),caption="Merged Table",
           header = c("Year ","Period ","industry","Industry\ncode (CPS)","Industry\ncode (JOLTS)","Unemployment\nRate ","Job Openings\nRate"),
          tfoot="Source: U.S. Bureau of Labor Statistics\ndata are not seasonally adjusted")
{% endhighlight %}

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='8' style='text-align: left;'>
Merged Table</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Year </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Period </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>industry</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Industry
code (CPS)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Industry
code (JOLTS)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Unemployment
Rate </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Job Openings
Rate</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>All Industries</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>5.1</td>
<td style='text-align: center;'>4.1</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Accommodation and food services</td>
<td style='background-color: #f7f7f7; text-align: center;'>8658</td>
<td style='background-color: #f7f7f7; text-align: center;'>720000</td>
<td style='background-color: #f7f7f7; text-align: center;'>6.2</td>
<td style='background-color: #f7f7f7; text-align: center;'>4.8</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Arts, entertainment, and recreation</td>
<td style='text-align: center;'>8559</td>
<td style='text-align: center;'>710000</td>
<td style='text-align: center;'>5.2</td>
<td style='text-align: center;'>3.7</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>4</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Construction</td>
<td style='background-color: #f7f7f7; text-align: center;'>770</td>
<td style='background-color: #f7f7f7; text-align: center;'>230000</td>
<td style='background-color: #f7f7f7; text-align: center;'>4.5</td>
<td style='background-color: #f7f7f7; text-align: center;'>3</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Durable goods manufacturing</td>
<td style='text-align: center;'>2468</td>
<td style='text-align: center;'>320000</td>
<td style='text-align: center;'>4.6</td>
<td style='text-align: center;'>2.9</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>6</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Education and health services</td>
<td style='background-color: #f7f7f7; text-align: center;'>7858</td>
<td style='background-color: #f7f7f7; text-align: center;'>600000</td>
<td style='background-color: #f7f7f7; text-align: center;'>3.7</td>
<td style='background-color: #f7f7f7; text-align: center;'>4.8</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Educational services</td>
<td style='text-align: center;'>7859</td>
<td style='text-align: center;'>610000</td>
<td style='text-align: center;'>5.7</td>
<td style='text-align: center;'>3.5</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>8</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Finance and insurance</td>
<td style='background-color: #f7f7f7; text-align: center;'>6868</td>
<td style='background-color: #f7f7f7; text-align: center;'>520000</td>
<td style='background-color: #f7f7f7; text-align: center;'>2.3</td>
<td style='background-color: #f7f7f7; text-align: center;'>3.9</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Financial activities</td>
<td style='text-align: center;'>6867</td>
<td style='text-align: center;'>510099</td>
<td style='text-align: center;'>2.4</td>
<td style='text-align: center;'>3.8</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>10</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Health care and social assistance</td>
<td style='background-color: #f7f7f7; text-align: center;'>7968</td>
<td style='background-color: #f7f7f7; text-align: center;'>620000</td>
<td style='background-color: #f7f7f7; text-align: center;'>3.2</td>
<td style='background-color: #f7f7f7; text-align: center;'>5</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Information</td>
<td style='text-align: center;'>6468</td>
<td style='text-align: center;'>510000</td>
<td style='text-align: center;'>5.7</td>
<td style='text-align: center;'>2.7</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>12</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Leisure and hospitality</td>
<td style='background-color: #f7f7f7; text-align: center;'>8558</td>
<td style='background-color: #f7f7f7; text-align: center;'>700000</td>
<td style='background-color: #f7f7f7; text-align: center;'>6</td>
<td style='background-color: #f7f7f7; text-align: center;'>4.7</td>
</tr>
<tr>
<td style='text-align: left;'>13</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Manufacturing</td>
<td style='text-align: center;'>2467</td>
<td style='text-align: center;'>300000</td>
<td style='text-align: center;'>4.3</td>
<td style='text-align: center;'>3</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>14</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Nondurable goods manufacturing</td>
<td style='background-color: #f7f7f7; text-align: center;'>1068</td>
<td style='background-color: #f7f7f7; text-align: center;'>340000</td>
<td style='background-color: #f7f7f7; text-align: center;'>3.6</td>
<td style='background-color: #f7f7f7; text-align: center;'>3.2</td>
</tr>
<tr>
<td style='text-align: left;'>15</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Other services</td>
<td style='text-align: center;'>8767</td>
<td style='text-align: center;'>810000</td>
<td style='text-align: center;'>4.4</td>
<td style='text-align: center;'>3.5</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>16</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Professional and business services</td>
<td style='background-color: #f7f7f7; text-align: center;'>7268</td>
<td style='background-color: #f7f7f7; text-align: center;'>540099</td>
<td style='background-color: #f7f7f7; text-align: center;'>4.7</td>
<td style='background-color: #f7f7f7; text-align: center;'>5.9</td>
</tr>
<tr>
<td style='text-align: left;'>17</td>
<td style='text-align: center;'>2016</td>
<td style='text-align: center;'>M07</td>
<td style='text-align: center;'>Real estate and rental and leasing</td>
<td style='text-align: center;'>7069</td>
<td style='text-align: center;'>530000</td>
<td style='text-align: center;'>2.7</td>
<td style='text-align: center;'>3.3</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>18</td>
<td style='background-color: #f7f7f7; text-align: center;'>2016</td>
<td style='background-color: #f7f7f7; text-align: center;'>M07</td>
<td style='background-color: #f7f7f7; text-align: center;'>Retail trade</td>
<td style='background-color: #f7f7f7; text-align: center;'>4669</td>
<td style='background-color: #f7f7f7; text-align: center;'>440000</td>
<td style='background-color: #f7f7f7; text-align: center;'>5.5</td>
<td style='background-color: #f7f7f7; text-align: center;'>4.2</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>19</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>2016</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>M07</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>Wholesale trade</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>4068</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>420000</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>3.9</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>2.7</td>
</tr>
</tbody>
<tfoot><tr><td colspan='8'>
Source: U.S. Bureau of Labor Statistics<br>
data are not seasonally adjusted</td></tr></tfoot>
</table>

### Create Panel Plot

Now we can create a panel plot.


{% highlight r %}
# turn industry text into factors so we can get All industries in first position
all.dt$ind.textf<-factor(all.dt$industry_text,levels=unique(all.dt$industry_text))

ggplot(data=all.dt,aes(x=ur,y=jo,color=recession))+geom_point(alpha=0.25)+facet_wrap(~ind.textf,ncol=4)+
  theme_minimal()+
  theme(plot.caption=element_text(hjust=0,size=7))+
  theme(legend.position="none")+
  theme(legend.position = c(0.85, 0.075) )+
  #Let's circle the last available point:
  geom_point(data=all.dt[ date=="2016-07-01"],shape=21,size=3,color=viridis(3)[1])+
  geom_text(data=all.dt[  date=="2016-07-01"],size=2,color=viridis(3)[1],label="July, 2016\n\n")+
   theme(strip.text.x = element_text(size = 7))+
  scale_color_manual(name="Recession or\nExpansion",values=c(viridis(5)[4],magma(5)[3]))+
  labs(x="Unemployment Rate (%, NSA)",y="Job Openings Rate (%, NSA)",
       title="The Beveridge Curve",
       subtitle="job openings rate vs unemployment rate (NSA)",
       caption="@lenkiefer Source: U.S. Bureau of Labor Statistics, Current Population Survey and Job Openings and Labor Turnover Survey")
{% endhighlight %}

![plot of chunk fig-bv-grahp1](/img/Rfig/fig-bv-grahp1-1.svg)

### Add animation


If we wish, we can add animation through the following code.

*See my earlier [post about tweenr]({% post_url 2016-05-29-improving-R-animated-gifs-with-tweenr %}) for an introduction to tweenr, and more examples [here]({% post_url 2016-05-30-more-tweenr-animations %}) and [here]({% post_url 2016-06-26-week-in-review %}).*



{% highlight r %}
#make a function to prepare data for tweening
myf<-function(m){
  DT<-copy(all.dt)
  DT<-DT[industry_text==m,]
  DT %>% map_if(is.character, as.factor) %>% as.data.frame() ->DT 
  as.data.frame(DT)}

ind.list<-unique(all.dt$industry_text) # get list of industries

my.list<-lapply(c(ind.list,ind.list[1]),myf)  #the animation will loop through each of the first five months of the year an then meet back at 0.
tf <- tween_states(my.list, tweenlength= 2, statelength=3, ease=rep('cubic-in-out',17),nframes=300)
tf<-data.table(tf)  
N<-max(tf$.frame)

oopt = ani.options(interval = 0.2)
saveGIF({for (i in 1:N) {
  g<-
    ggplot(data=tf[.frame==i,],aes(x=ur,y=jo,color=recession,group=recession))+geom_point(alpha=0.65)+facet_wrap(~industry_text)+
    theme_minimal()+
    theme(plot.caption=element_text(hjust=0,size=9))+
    geom_point(data=tf[.frame==i & date=="2016-07-01"],shape=21,size=3,color=viridis(3)[1])+
    geom_text(data=tf[.frame==i & date=="2016-07-01"],color=viridis(3)[1],label="July, 2016\n\n")+
    coord_cartesian(ylim=c(0,8),xlim=c(0,28))+
    theme(legend.position="bottom")+
    scale_color_manual(name="Recession or Expansion",values=c(viridis(5)[4],magma(5)[3]))+
    labs(x="Unemployment Rate (%, NSA)",y="Job Openings Rate (%, NSA)",
         title="The Beveridge Curve",
         subtitle="job openings rate vs unemployment rate (NSA)",
         caption="@lenkiefer Source: U.S. Bureau of Labor Statistics, Current Population Survey and Job Openings and Labor Turnover Survey")
  
  print(g)
  ani.pause()
  print(i) }
},movie.name="bv tween3.gif",ani.width = 650, ani.height = 500)
{% endhighlight %}

<img src="{{ site.url }}/img/charts_sep_14_2016/bv tween3.gif" alt="animated beveridge curve"/>
