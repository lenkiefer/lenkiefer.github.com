---
layout: post
title: "Of kernels and beeswarms: Comparing the distribution of house values to household income"
author: "Len Kiefer"
date: "2017-04-16"
summary: "R statistics dataviz housing mortgage data"
group: navigation
theme :
  name : lentheme
---

BACK IN [JANUARY]({% post_url 2017-01-31-house-value-distribution%})  WE LOOKED AT HOUSING microdata from the [American Community Survey Public Microdata](https://www.census.gov/programs-surveys/acs/data/pums.html) that we collected from [IPUMS](https://usa.ipums.org/usa/). Let's pick back up and look at these data some more. Glad you could join us.

Be sure to check out my [earlier post]({% post_url 2017-01-31-house-value-distribution%}) for more discussion of the underlying data. Here we'll pick up where we left off and make some more graphs using [R](https://www.r-project.org/).

Just a quick reminder (read the earlier post for all the details), we have a dataset that includes household level observations for the 20 largest metro areas in the United States for 2010 and 2015 (latest data available). 

Below we load the data and check out its structure:

### Load data


{% highlight r %}
library(data.table)
library(tidyverse)
library(ggbeeswarm)
load("data/acs.RData")
str(dt.x)
{% endhighlight %}



{% highlight text %}
## Classes 'data.table' and 'data.frame':	540325 obs. of  6 variables:
##  $ year     :Class 'labelled'  atomic [1:540325] 2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
##   .. ..- attr(*, "label")= chr "census year"
##   .. ..- attr(*, "format.stata")= chr "%8.0g"
##   .. ..- attr(*, "labels")= Named num [1:30] 1850 1860 1870 1880 1900 1910 1920 1930 1940 1950 ...
##   .. .. ..- attr(*, "names")= chr [1:30] "1850" "1860" "1870" "1880" ...
##  $ cbsa.name: chr  "Atlanta-Sandy Springs-Roswell, GA Metro Area" "Atlanta-Sandy Springs-Roswell, GA Metro Area" "Atlanta-Sandy Springs-Roswell, GA Metro Area" "Atlanta-Sandy Springs-Roswell, GA Metro Area" ...
##  $ met2013  :Class 'labelled'  atomic [1:540325] 12060 12060 12060 12060 12060 ...
##   .. ..- attr(*, "label")= chr "metropolitan area, 2013 omb delineations"
##   .. ..- attr(*, "format.stata")= chr "%12.0g"
##   .. ..- attr(*, "labels")= Named num [1:295] 0 10420 10580 10740 10780 ...
##   .. .. ..- attr(*, "names")= chr [1:295] "not in identifiable area" "akron, oh" "albany-schenectady-troy, ny" "albuquerque, nm" ...
##  $ hhincome : atomic  17910 128000 110700 31000 70750 ...
##   ..- attr(*, "label")= chr "total household income"
##   ..- attr(*, "format.stata")= chr "%12.0g"
##  $ valueh   : atomic  85000 150000 230000 78000 120000 300000 100000 70000 135000 150000 ...
##   ..- attr(*, "label")= chr "house value"
##   ..- attr(*, "format.stata")= chr "%12.0g"
##  $ hhwt     : atomic  74 82 87 58 73 279 83 103 113 80 ...
##   ..- attr(*, "label")= chr "household weight"
##   ..- attr(*, "format.stata")= chr "%8.0g"
##  - attr(*, "sorted")= chr "met2013"
##  - attr(*, ".internal.selfref")=<externalptr>
{% endhighlight %}

I've cleaned the data up a bit to only include household level observations for owner households for the largest 20 metro areas. I've saved a [data.table()](https://cran.r-project.org/web/packages/data.table/index.html) called `dt.x` using the data described in the earlier post.

In the prior post we filtered to only the top 12 metro areas. But I've prepared data that filters to the top 20. If you are following along from the earlier post, just replace `dt.x<-dt2[cbsa.name %in% pop.list[order(-pop)]$cbsa.name[1:12] & pernum==1]` with `dt.x<-dt2[cbsa.name %in% pop.list[order(-pop)]$cbsa.name[1:20] & pernum==1]` and everything else should follow.


As before, let's randomly sample 2,000 observations from these 20 large metro areas using the household weights.


{% highlight r %}
# First draw a random sample of 2,000 observations from each year/metro combination
dt.samp<-dt.x[,.SD[sample(.N,min(.N,2000),prob=hhwt)],by = c("year","cbsa.name") ]

#Get our list:
metro.list<-dt.samp[,list(obs=.N),by=c("year","met2013","cbsa.name")]

# check observations:
# obs is number of observations
htmlTable::htmlTable(metro.list,col.rgroup = c("none", "#F7F7F7"))
{% endhighlight %}

<!--html_preserve--><table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>year</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>met2013</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>cbsa.name</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>obs</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>12060</td>
<td style='text-align: center;'>Atlanta-Sandy Springs-Roswell, GA Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>12060</td>
<td style='background-color: #f7f7f7; text-align: center;'>Atlanta-Sandy Springs-Roswell, GA Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>14460</td>
<td style='text-align: center;'>Boston-Cambridge-Newton, MA-NH Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>4</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>14460</td>
<td style='background-color: #f7f7f7; text-align: center;'>Boston-Cambridge-Newton, MA-NH Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>16980</td>
<td style='text-align: center;'>Chicago-Naperville-Elgin, IL-IN-WI Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>6</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>16980</td>
<td style='background-color: #f7f7f7; text-align: center;'>Chicago-Naperville-Elgin, IL-IN-WI Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>7</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>19100</td>
<td style='text-align: center;'>Dallas-Fort Worth-Arlington, TX Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>8</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>19100</td>
<td style='background-color: #f7f7f7; text-align: center;'>Dallas-Fort Worth-Arlington, TX Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>9</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>19740</td>
<td style='text-align: center;'>Denver-Aurora-Lakewood, CO Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>10</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>19740</td>
<td style='background-color: #f7f7f7; text-align: center;'>Denver-Aurora-Lakewood, CO Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>11</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>19820</td>
<td style='text-align: center;'>Detroit-Warren-Dearborn, MI Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>12</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>19820</td>
<td style='background-color: #f7f7f7; text-align: center;'>Detroit-Warren-Dearborn, MI Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>13</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>26420</td>
<td style='text-align: center;'>Houston-The Woodlands-Sugar Land, TX Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>14</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>26420</td>
<td style='background-color: #f7f7f7; text-align: center;'>Houston-The Woodlands-Sugar Land, TX Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>15</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>31080</td>
<td style='text-align: center;'>Los Angeles-Long Beach-Anaheim, CA Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>16</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>31080</td>
<td style='background-color: #f7f7f7; text-align: center;'>Los Angeles-Long Beach-Anaheim, CA Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>17</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>33100</td>
<td style='text-align: center;'>Miami-Fort Lauderdale-West Palm Beach, FL Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>18</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>33100</td>
<td style='background-color: #f7f7f7; text-align: center;'>Miami-Fort Lauderdale-West Palm Beach, FL Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>19</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>33460</td>
<td style='text-align: center;'>Minneapolis-St. Paul-Bloomington, MN-WI Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>20</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>33460</td>
<td style='background-color: #f7f7f7; text-align: center;'>Minneapolis-St. Paul-Bloomington, MN-WI Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>21</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>35620</td>
<td style='text-align: center;'>New York-Newark-Jersey City, NY-NJ-PA Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>22</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>35620</td>
<td style='background-color: #f7f7f7; text-align: center;'>New York-Newark-Jersey City, NY-NJ-PA Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>23</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>37980</td>
<td style='text-align: center;'>Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>24</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>37980</td>
<td style='background-color: #f7f7f7; text-align: center;'>Philadelphia-Camden-Wilmington, PA-NJ-DE-MD Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>25</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>38060</td>
<td style='text-align: center;'>Phoenix-Mesa-Scottsdale, AZ Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>26</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>38060</td>
<td style='background-color: #f7f7f7; text-align: center;'>Phoenix-Mesa-Scottsdale, AZ Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>27</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>40140</td>
<td style='text-align: center;'>Riverside-San Bernardino-Ontario, CA Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>28</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>40140</td>
<td style='background-color: #f7f7f7; text-align: center;'>Riverside-San Bernardino-Ontario, CA Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>29</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>41180</td>
<td style='text-align: center;'>St. Louis, MO-IL Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>30</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>41180</td>
<td style='background-color: #f7f7f7; text-align: center;'>St. Louis, MO-IL Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>31</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>41740</td>
<td style='text-align: center;'>San Diego-Carlsbad, CA Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>32</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>41740</td>
<td style='background-color: #f7f7f7; text-align: center;'>San Diego-Carlsbad, CA Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>33</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>41860</td>
<td style='text-align: center;'>San Francisco-Oakland-Hayward, CA Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>34</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>41860</td>
<td style='background-color: #f7f7f7; text-align: center;'>San Francisco-Oakland-Hayward, CA Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>35</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>42660</td>
<td style='text-align: center;'>Seattle-Tacoma-Bellevue, WA Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>36</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>42660</td>
<td style='background-color: #f7f7f7; text-align: center;'>Seattle-Tacoma-Bellevue, WA Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>37</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>45300</td>
<td style='text-align: center;'>Tampa-St. Petersburg-Clearwater, FL Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>38</td>
<td style='background-color: #f7f7f7; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; text-align: center;'>45300</td>
<td style='background-color: #f7f7f7; text-align: center;'>Tampa-St. Petersburg-Clearwater, FL Metro Area</td>
<td style='background-color: #f7f7f7; text-align: center;'>2000</td>
</tr>
<tr>
<td style='text-align: left;'>39</td>
<td style='text-align: center;'>2010</td>
<td style='text-align: center;'>47900</td>
<td style='text-align: center;'>Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area</td>
<td style='text-align: center;'>2000</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;'>40</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>2015</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>47900</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>Washington-Arlington-Alexandria, DC-VA-MD-WV Metro Area</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: center;'>2000</td>
</tr>
</tbody>
</table><!--/html_preserve-->

As before, we can use a [beeswarm](https://cran.r-project.org/web/packages/ggbeeswarm/index.html) plot to plot the distribution of house values by metro area.  


{% highlight r %}
#make a beewarm plot:
ggplot(data=dt.samp,
         aes(y=factor(year),
             x=valueh,color=log(valueh)))+
  geom_quasirandom(alpha=0.5,size=0.5)+
  theme_minimal()+
  scale_color_viridis(name="House Value\n$,log scale\n",discrete=F,option="D",end=0.95,direction=-1,
                      limits=c(log(10000),log(1.4e6)),
                      breaks=c(log(10000),log(100000),log(1e6)),
                      labels=c("$10k","$100k","$1,000k") ) +
  scale_x_log10(limits=c(10000,1.4e6),breaks=c(10000,100000,1000000),
                labels=c("$10k","$100k","$1,000k") )+
  labs(y="",x="House Value ($, log scale)",
       caption="@lenkiefer Source: Census 1-year American Community Survey (2010 & 2015),\nIPUMS-USA, University of Minnesota, www.ipums.org.",
       title="House value distribution by Metro")+
  theme(axis.text.x = element_text(size=6),
        strip.text.x = element_text(size = 5),
        plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)),
        plot.title=element_text(size=14),
        legend.position = "top"   )+
  facet_wrap(~cbsa.name,ncol=4)+theme()
{% endhighlight %}

![plot of chunk 04-16-2017-swarm-1](/img/Rfig/04-16-2017-swarm-1-1.svg)


We see quite a bit of variation across metro areas.  But how does the distribution of house values compare to the distribution of incomes?  Let's look at Washington D.C. and plot estimates of homeowner household income versus the value of those homeowner's homes. **Note, we've already subsetted on homeowner households, so this metric is different from a more commonly house value to income ratio that uses all households. We are excluding renters from this analysis**


{% highlight r %}
  ggplot(data=dt.x[year==2015 & met2013==47900,], aes(valueh,weight=hhwt))+
  geom_density(alpha=0.5,aes(fill="House Value"))+
  geom_density(aes(hhincome,fill="Household Income"),alpha=0.5)+
  scale_color_manual(name="",values=c("black","black"))+
  scale_fill_viridis(discrete=T,end=0.85,name="")+
  scale_x_log10(label=scales::dollar,limits=c(10000,2e6))+
  theme_minimal()+labs(x="Income and Home Values",y="",
                        title="House value and homeowner income distribution in Washington D.C. in 2015",
                       subtitle="kernel density estimates using household weights",
                       caption="@lenkiefer Source: Census 1-year American Community Survey (2015),\nIPUMS-USA, University of Minnesota, www.ipums.org.")+
    theme(plot.title=element_text(size=14),legend.position="top",
          axis.text.y=element_blank(),
          plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  facet_wrap(~cbsa.name,scales="free_y")
{% endhighlight %}

![plot of chunk 04-16-2017-dens-1](/img/Rfig/04-16-2017-dens-1-1.svg)

And we can construct a small multiple:


{% highlight r %}
  ggplot(data=dt.x[year==2015 & met2013>=4900,], aes(valueh,weight=hhwt))+
  geom_density(alpha=0.5,aes(fill="House Value"))+
  geom_density(aes(hhincome,fill="Household Income"),alpha=0.5)+
  scale_color_manual(name="",values=c("black","black"))+
  scale_fill_viridis(discrete=T,end=0.85,name="")+
  scale_x_log10(label=scales::dollar,limits=c(10000,3e6))+
  theme_minimal()+labs(x="Income and Home Values",y="",
                        title="House value and homeowner income distribution by Metro in 2015",
                       subtitle="kernel density estimates using household weights",
                       caption="@lenkiefer Source: Census 1-year American Community Survey (2015),\nIPUMS-USA, University of Minnesota, www.ipums.org.")+
    theme(plot.title=element_text(size=14),legend.position="top",
          axis.text.y=element_blank(),
          strip.text.x = element_text(size = 5),
          plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  facet_wrap(~cbsa.name,scales="free_y",ncol=4)
{% endhighlight %}

![plot of chunk 04-16-2017-dens-2](/img/Rfig/04-16-2017-dens-2-1.svg)

But how does the income of each homeowner compare to the value of their home? Let's take each homeowner in our sample and construct the ratio of their house value to their income.


{% highlight r %}
dt.x<-dt.x[,pti:=valueh/hhincome]  #price to income ratio
{% endhighlight %}

Now we can plot the distribution of this ratio for Washington D.C.:


{% highlight r %}
  ggplot(data=dt.x[year==2015 & met2013==47900,], aes(pti,weight=hhwt))+
  geom_density(alpha=0.5,aes(fill="House value to income ratio"))+
  #geom_density(aes(hhincome,fill="Household Income"),alpha=0.5)+
  scale_color_manual(name="",values=c("black","black"))+
  scale_fill_viridis(discrete=T,end=0.85,name="")+
  scale_x_continuous(limits=c(0,20),breaks=seq(0,20,2))+
  theme_minimal()+labs(x="House vaue to income ratio",y="",
                        title="Ratio of house value to homeowner income distribution in Washington D.C. in 2015",
                       subtitle="kernel density estimates using household weights",
                       caption="@lenkiefer Source: Census 1-year American Community Survey (2015),\nIPUMS-USA, University of Minnesota, www.ipums.org.")+
    theme(plot.title=element_text(size=14),legend.position="none",
          axis.text.y=element_blank(),
          plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  facet_wrap(~cbsa.name,scales="free_y")
{% endhighlight %}

![plot of chunk 04-16-2017-dens-3](/img/Rfig/04-16-2017-dens-3-1.svg)

The average ratio is about 4 in Washington D.C., but it varies a lot by metro area. Let's create another small multiple.


{% highlight r %}
  ggplot(data=dt.x[year==2015 & met2013>=4900,], aes(pti,weight=hhwt))+
  geom_density(alpha=0.5,aes(fill="House value to income ratio"))+
  #geom_density(aes(hhincome,fill="Household Income"),alpha=0.5)+
  scale_color_manual(name="",values=c("black","black"))+
  scale_fill_viridis(discrete=T,end=0.85,name="")+
  scale_x_continuous(limits=c(0,20),breaks=seq(0,20,2))+
  theme_minimal()+labs(x="House vaue to income ratio",y="",
                        title="Ratio of house value to homeowner income distribution by metro in 2015",
                       subtitle="kernel density estimates using household weights",
                       caption="@lenkiefer Source: Census 1-year American Community Survey (2015),\nIPUMS-USA, University of Minnesota, www.ipums.org.")+
    theme(plot.title=element_text(size=14),legend.position="none",
          axis.text.y=element_blank(),
          strip.text.x = element_text(size = 5),
          plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  facet_wrap(~cbsa.name,scales="free_y",ncol=4)
{% endhighlight %}

![plot of chunk 04-16-2017-dens-4](/img/Rfig/04-16-2017-dens-4-1.svg)

Let's compute the weighted average ratio (excluding any values less than 0 or greater than 20) by metro area in 2010 and 2015:


{% highlight r %}
dt.wsum<-dt.x[pti>0 & pti<20,list(pti.wm=weighted.mean(pti,hhwt,na.rm=T)),by=c("year","cbsa.name")]

ggplot(data=dt.wsum[year==2015,], 
       aes(x=pti.wm,y=reorder(cbsa.name,-pti.wm),
           label=paste("  ",round(pti.wm,1),cbsa.name),
           color=factor(year)))+
  geom_point(size=3)+theme_minimal()+
  geom_text(hjust=0)+
  scale_x_continuous(limits=c(2.5,9),breaks=seq(2,8,1))+
  scale_color_viridis(name="Year",discrete=T,end=0.85)+
  theme(plot.title=element_text(size=14),legend.position="none",
        axis.text.y=element_blank(),
        plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
  labs(x="Weighted average homeowner value to household income ratio",
       y="Metro",
       title="Ratio of house value to homeowner income distribution by metro in 2015",
       caption="@lenkiefer Source: Census 1-year American Community Survey (2015),\nIPUMS-USA, University of Minnesota, www.ipums.org.")
{% endhighlight %}

![plot of chunk 04-16-2017-ratio](/img/Rfig/04-16-2017-ratio-1.svg)

This plot makes clear that there is a pretty wide variation in the average house value to household income ratio.  We can look at the full distributions through an animated gif (using our usual [tweenr]({% post_url 2016-12-19-more-tweenr-housing%}) approach).


{% highlight r %}
library(tweenr)
library(animation)
library(tidyverse)
library(tidyr)



#  Function for use with tweenr
myf<-function (m, yy=2015){
  d.out<-copy(dt.samp)[met2013==m]
  d.out %>% map_if(is.character, as.factor) %>% as.data.frame -> d.out
  return(d.out)
}

# get list of metros from our summay data: metro.list

# Circle back to Atlanta (met2013==12060)
my.list2<-lapply(c(unique(metro.list$met2013),12060),myf)  


#use tweenr to interploate
tf <- tween_states(my.list2,tweenlength= 3,
                   statelength=2, ease=rep('cubic-in-out',2),nframes=200)
tf<-data.table(tf) #convert output into data table

#Animate plot
oopt = ani.options(interval = 0.2)
saveGIF({for (i in 1:max(tf$.frame)) { #loop over frames
  g<-
    ggplot(data=tf[.frame==i & pti<= 20 & hhincome>10000 & valueh > 5000 ],
           aes(y=factor(year),
               x=pti,color=pti))+
    geom_quasirandom(alpha=0.5,size=0.75)+
    theme_minimal()+
    scale_color_viridis(name="House value to\nhousehold income\nratio",
                        discrete=F,option="D",
                        limits=c(0,20),
                        end=0.95,direction=-1  #,
                        ) +
    #scale_x_log10(limits=c(10000,1.4e6),breaks=c(10000,100000,1000000),   
    #  labels=c("$10k","$100k","$1,000k") )+
    scale_x_continuous(limits=c(0,20),breaks=seq(0,20,2.5))+
    theme(plot.title=element_text(size=14))+
    theme(plot.caption=element_text(hjust=0,vjust=1,margin=margin(t=10)))+
    theme(plot.margin=unit(c(0.25,0.25,0.25,0.25),"cm"))+
    theme(legend.position = "top")+
    labs(y="",x="House value to household income ratio",
         caption="@lenkiefer Source: Census 1-year American Community Survey (2010 & 2015),\nIPUMS-USA, University of Minnesota, www.ipums.org.\nTo avoid extreme overplotting, 2000 observations sampled at random (using weights),\nonly includes homeowner households with > $10,000 income and an estimated house value > $5,000 & cases where ratio <= 20",
         title="House value to income ratio distribution by Metro",
         subtitle=head(tf[.frame==i,],1)$cbsa.name)+
    theme(axis.text.x = element_text(size=8))+  #coord_flip()+
    #facet_wrap(~year)+
    theme(strip.text.x = element_text(size = 6))
  print(g)
  ani.pause()
  print(i)}
},movie.name="tween acs value 04 16 2017 v2.gif",ani.width = 750, ani.height = 400)
{% endhighlight %}

Run it and you get:

<img src="{{ site.url }}/img/charts_apr_16_2017/tween acs value 04 16 2017 v2.gif" alt="metro pti ratios"/>

