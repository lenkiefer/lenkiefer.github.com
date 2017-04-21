---
layout: post
title: "Gather round and spread the word: Wrangling global house price data"
author: "Len Kiefer"
date: "2017-04-20"
summary: "R statistics rstats mortgage rates dataviz"
group: navigation
theme :
  name : lentheme
---

IN THIS POST I WANT TO SHARE SOME [R](https://www.r-project.org/) data wrangling strategy and use it to prepare an update to some global house price plots I shared [last year]({% post_url 2016-12-10-global-house-price-trends%}).

In last year's post I did some data manipulation by hand and mouse in Excel before getting into R.  In this post I'm going to use the newly updated [readxl](http://readxl.tidyverse.org/index.html) library to do the data manipulations entirely in R.  If you follow along, then you should be able to use this code to recreate my graphs.

This should prove to be a major improvement over my previous workflows.  Because of the realities of my [professional life](https://www.linkedin.com/in/leonard-kiefer-51175331/) I cannot escape Excel. Actually, I probably wouldn't want to escape it even if I could. Despite its limitations and frequent misuse it is still my favorite application. 

However, while I've gotten pretty fast at doing some fairly complex manipulations in Excel (see [this post]({% post_url 2016-05-08-visual-meditations-on-house-prices-part1 %}) from last year for an example) it isn't exactly reproducible.  Using a scripting language in R should help with making the workflow more reproducible. Also, by using a scripting language you can automate tasks and easily scale to larger problems.  I often encounter situations where I would need to work with hundreds of workbooks/worksheets.

I'm going to lean heavily on the ideas in [this post](http://readxl.tidyverse.org/articles/articles/readxl-workflows.html) on the readxl workflow to prepare our data.

# Some data

Let's update our global house price charts and make a couple new ones.

First we're going to need to gather some data on house prices.  Fortunately, the [Dallas Federal Reserve Bank](http://www.dallasfed.org/index.cfm) has compiled statistics on [international house price trends](http://www.dallasfed.org/institute/houseprice/). Fed researchers have gone through the hard work of collecting data for many countries and harmonizing the series so they are more easily comparable.  Read about their hard work and the details [here.](http://www.dallasfed.org/assets/documents/institute/wpapers/2011/0099.pdf)

The data are available in a convenient spreadsheet ([2016Q4 data](http://www.dallasfed.org/assets/documents/institute/houseprice/hp1604.xlsx)). We're going to proceed assuming that the [*hp1604.xlsx*](http://www.dallasfed.org/assets/documents/institute/houseprice/hp1604.xlsx) spreadsheet is saved in a *data* folder.

## Using readxl

I began this update attempting to read the data in the following manner (which works). In this example, which we will improve upon, I first read in each separate sheet and then do some data manipulations.

First load our libraries:


{% highlight r %}
library(tidyverse)
library(data.table)
library(ggthemes,quietly=T,warn.conflicts=F)
{% endhighlight %}

Now we could do things this way:


{% highlight r %}
###############################################################################
#### Read in HPI data  ##########################################
df<-read_excel("hp1604.xlsx", sheet = "HPI")
colnames(df)[1]<-"cycle"  # rename first column
df$year<-substr(df$cycle,1,4) #create a year
df$month<-substr(df$cycle,7,7) #create a
df$date<-as.Date(ISOdate(df$year,df$month,1))
df %>% select(-X__2,-cycle,-year,-month) %>% 
  gather(country,hpi,-date) ->hpi.df
###############################################################################

###############################################################################
#### Read in Real HPI data  ##########################################
df<-read_excel("hp1604.xlsx", sheet = "RHPI")
colnames(df)[1]<-"cycle"
df$year<-substr(df$cycle,1,4)
df$month<-substr(df$cycle,7,7)
df$date<-as.Date(ISOdate(df$year,df$month,1))
df %>% select(-X__2,-cycle,-year,-month) %>% 
  gather(country,rhpi,-date) ->rhpi.df
###############################################################################

###############################################################################
#### Read in Disposable Income data  ############################
df<-read_excel("hp1604.xlsx", sheet = "PDI")
colnames(df)[1]<-"cycle"
df$year<-substr(df$cycle,1,4)
df$month<-substr(df$cycle,7,7)
df$date<-as.Date(ISOdate(df$year,df$month,1))
df %>% select(-X__2,-cycle,-year,-month) %>% 
  gather(country,pdi,-date) ->pdi.df
###############################################################################

###############################################################################
#### Read in Rea Disposable Income data  ############################
df<-read_excel("hp1604.xlsx", sheet = "RPDI")
colnames(df)[1]<-"cycle"
df$year<-substr(df$cycle,1,4)
df$month<-substr(df$cycle,7,7)
df$date<-as.Date(ISOdate(df$year,df$month,1))
df %>% select(-X__2,-cycle,-year,-month) %>% 
  gather(country,rpdi,-date) ->rpdi.df
###############################################################################

###############################################################################
#### Merge data together data  ############################
###  Requires data.table() package ************************
dt<-merge(hpi.df,rhpi.df,by=c("date","country"))
dt<-merge(dt,pdi.df,by=c("date","country"))
dt<-merge(dt,rpdi.df,by=c("date","country"))
dt<-data.table(dt)[year(date)>0,]
###############################################################################
{% endhighlight %}

While this works, and isn't too bad, it could get really old if we had 10s or hundreds of worksheets to chew through.  Fortunately, we have a better alternatively using the readxl workflow combined with **map_df** from the [purrr](http://purrr.tidyverse.org/) library (available in the [tidyverse](http://tidyverse.org/)).



{% highlight r %}
# path to data
path <-"data/hp1604.xlsx"

###########################################################################
#  We'll omit this step, hard coding instead

#  xl.list<-path %>% excel_sheets()   #get a list of sheet names
###########################################################################

df <- c("HPI","RHPI","PDI","RPDI") %>%   #iterate over four sheets
      set_names() %>% 
  
      # Now for something magical!
  
      map_df(~ read_excel(path = path, sheet = .x), .id = "sheet")

# print a table using the htmlTable library, round numeric to 0 digits for readability 
# Note we won't round in analysis)

htmlTable::htmlTable(rbind(head(df %>% 
                                  map_if(is_numeric,round,0) %>% 
                                  data.frame() %>% as.tbl())))
{% endhighlight %}

<!--html_preserve--><table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>sheet</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>X__1</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Australia</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Belgium</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Canada</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Switzerland</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Germany</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Denmark</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Spain</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Finland</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>France</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>UK</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Ireland</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Italy</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Japan</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>S..Korea</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Luxembourg</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Netherlands</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Norway</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>New.Zealand</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Sweden</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>US</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>S..Africa</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Croatia</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Israel</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>X__2</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Aggregate</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
<td style='text-align: center;'></td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975:Q1</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>15</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>49</td>
<td style='text-align: center;'>52</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>9</td>
<td style='text-align: center;'>13</td>
<td style='text-align: center;'>11</td>
<td style='text-align: center;'>6</td>
<td style='text-align: center;'>3</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>60</td>
<td style='text-align: center;'>9</td>
<td style='text-align: center;'>7</td>
<td style='text-align: center;'>15</td>
<td style='text-align: center;'>13</td>
<td style='text-align: center;'>7</td>
<td style='text-align: center;'>15</td>
<td style='text-align: center;'>17</td>
<td style='text-align: center;'>3</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>22</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975:Q2</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>48</td>
<td style='text-align: center;'>53</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>10</td>
<td style='text-align: center;'>14</td>
<td style='text-align: center;'>12</td>
<td style='text-align: center;'>6</td>
<td style='text-align: center;'>4</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>60</td>
<td style='text-align: center;'>9</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>13</td>
<td style='text-align: center;'>7</td>
<td style='text-align: center;'>15</td>
<td style='text-align: center;'>18</td>
<td style='text-align: center;'>3</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>23</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975:Q3</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>17</td>
<td style='text-align: center;'>17</td>
<td style='text-align: center;'>48</td>
<td style='text-align: center;'>53</td>
<td style='text-align: center;'>17</td>
<td style='text-align: center;'>10</td>
<td style='text-align: center;'>14</td>
<td style='text-align: center;'>12</td>
<td style='text-align: center;'>6</td>
<td style='text-align: center;'>4</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>61</td>
<td style='text-align: center;'>10</td>
<td style='text-align: center;'>9</td>
<td style='text-align: center;'>17</td>
<td style='text-align: center;'>14</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>18</td>
<td style='text-align: center;'>3</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>23</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975:Q4</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>18</td>
<td style='text-align: center;'>17</td>
<td style='text-align: center;'>47</td>
<td style='text-align: center;'>54</td>
<td style='text-align: center;'>17</td>
<td style='text-align: center;'>11</td>
<td style='text-align: center;'>14</td>
<td style='text-align: center;'>12</td>
<td style='text-align: center;'>6</td>
<td style='text-align: center;'>4</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>61</td>
<td style='text-align: center;'>10</td>
<td style='text-align: center;'>10</td>
<td style='text-align: center;'>18</td>
<td style='text-align: center;'>14</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>18</td>
<td style='text-align: center;'>3</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>23</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>6</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>HPI</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>1976:Q1</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>9</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>19</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>18</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>46</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>55</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>18</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>11</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>14</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>13</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>6</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>4</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>8</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>61</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>11</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>10</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>19</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>14</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>8</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>17</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>18</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>3</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>0</td>
<td style='border-bottom: 2px solid grey; text-align: center;'></td>
<td style='border-bottom: 2px solid grey; text-align: center;'>24</td>
</tr>
</tbody>
</table><!--/html_preserve-->


Now we have data.  The first column *sheet* has values of `c("HPI","RHPI","PDI","RPDI")` corresponding to the four sheets we read in. We also have the date variable stored in the `X__1` column.  It's not a date, so let's correct that.


{% highlight r %}
df$year<-substr(df$X__1,1,4)
df$month<-substr(df$X__1,7,7)

#quarterly data so multiply month by 3
df$date<-as.Date(ISOdate(df$year,as.numeric(df$month)*3,1)) 

# Now we don't need year, month or X__1 any more, let's drop them
# we also don't need X__2 which corresponds to a blank column so let's drop it
df<-select(df,-year,-month,-X__1,-X__2)
str(df)
{% endhighlight %}



{% highlight text %}
## Classes 'tbl_df', 'tbl' and 'data.frame':	676 obs. of  26 variables:
##  $ sheet      : chr  "HPI" "HPI" "HPI" "HPI" ...
##  $ Australia  : num  NA 7.6 7.74 8.04 8.29 ...
##  $ Belgium    : num  NA 15.2 15.9 16.7 17.7 ...
##  $ Canada     : num  NA 16.2 16.4 17.1 17.3 ...
##  $ Switzerland: num  NA 48.8 48.2 47.7 47.1 ...
##  $ Germany    : num  NA 52 52.7 53.3 54.1 ...
##  $ Denmark    : num  NA 15.8 16.2 17 17.1 ...
##  $ Spain      : num  NA 8.71 9.75 9.96 10.7 ...
##  $ Finland    : num  NA 13.5 13.6 13.8 14.2 ...
##  $ France     : num  NA 11.1 11.5 11.9 12.4 ...
##  $ UK         : num  NA 5.92 6.03 6.15 6.25 ...
##  $ Ireland    : num  NA 3.42 3.65 3.87 4.08 ...
##  $ Italy      : num  NA 8.19 8.06 7.97 7.91 ...
##  $ Japan      : num  NA 60.1 60.3 60.5 60.7 ...
##  $ S. Korea   : num  NA 8.7 9.23 9.82 10.43 ...
##  $ Luxembourg : num  NA 7.49 8.19 8.87 9.53 ...
##  $ Netherlands: num  NA 14.9 15.8 16.8 18 ...
##  $ Norway     : num  NA 13.4 13.5 13.7 14.1 ...
##  $ New Zealand: num  NA 7.42 7.43 7.54 7.71 ...
##  $ Sweden     : num  NA 14.6 15.1 15.6 16.2 ...
##  $ US         : num  NA 17.3 17.6 17.6 18 ...
##  $ S. Africa  : num  NA 3.23 3.28 3.29 3.37 ...
##  $ Croatia    : num  NA 6.88e-05 7.22e-05 7.57e-05 7.97e-05 ...
##  $ Israel     : num  NA 0.00342 0.00344 0.00357 0.00387 ...
##  $ Aggregate  : num  NA 22.5 22.8 23.1 23.4 ...
##  $ date       : Date, format: NA "1975-03-01" ...
{% endhighlight %}

Now we have a data.frame() (or tbl) that has 26 columns.  The first column correspons to the sheet in the original *.xlsx* file and the last column is our date variable.

## Gather the data

Now let's tidy the data by gathering the country columns:


{% highlight r %}
df2<-df %>% gather(country, value, 2:25) # I happen to know data is in colums 2:25

# same business for printing
htmlTable::htmlTable(head(df2 %>% map_if(is_numeric,round,0) %>% data.frame() %>% as.tbl()))
{% endhighlight %}

<!--html_preserve--><table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>sheet</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>date</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>country</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>value</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'></td>
<td style='text-align: center;'>Australia</td>
<td style='text-align: center;'></td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975-03-01</td>
<td style='text-align: center;'>Australia</td>
<td style='text-align: center;'>8</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975-06-01</td>
<td style='text-align: center;'>Australia</td>
<td style='text-align: center;'>8</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975-09-01</td>
<td style='text-align: center;'>Australia</td>
<td style='text-align: center;'>8</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>HPI</td>
<td style='text-align: center;'>1975-12-01</td>
<td style='text-align: center;'>Australia</td>
<td style='text-align: center;'>8</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>6</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>HPI</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>1976-03-01</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>Australia</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>9</td>
</tr>
</tbody>
</table><!--/html_preserve-->

This dataset is pretty tidy, but for the analysis we want to do not the easiest to work with.  

## Spread the data

We have the variable names stored in the *sheet* column, but we'd like to spread those variables out.  Let's spread it out:


{% highlight r %}
df3<-df2 %>% spread(sheet,value)

# same business for printing
htmlTable::htmlTable(head(df3 %>% map_if(is_numeric,round,0) %>% data.frame() %>% as.tbl()))
{% endhighlight %}

<!--html_preserve--><table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>date</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>country</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>HPI</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PDI</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>RHPI</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>RPDI</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>1975-03-01</td>
<td style='text-align: center;'>Aggregate</td>
<td style='text-align: center;'>22</td>
<td style='text-align: center;'>19</td>
<td style='text-align: center;'>66</td>
<td style='text-align: center;'>60</td>
</tr>
<tr>
<td style='text-align: left;'>2</td>
<td style='text-align: center;'>1975-03-01</td>
<td style='text-align: center;'>Australia</td>
<td style='text-align: center;'>8</td>
<td style='text-align: center;'>14</td>
<td style='text-align: center;'>39</td>
<td style='text-align: center;'>73</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>1975-03-01</td>
<td style='text-align: center;'>Belgium</td>
<td style='text-align: center;'>15</td>
<td style='text-align: center;'>23</td>
<td style='text-align: center;'>45</td>
<td style='text-align: center;'>66</td>
</tr>
<tr>
<td style='text-align: left;'>4</td>
<td style='text-align: center;'>1975-03-01</td>
<td style='text-align: center;'>Canada</td>
<td style='text-align: center;'>16</td>
<td style='text-align: center;'>19</td>
<td style='text-align: center;'>59</td>
<td style='text-align: center;'>71</td>
</tr>
<tr>
<td style='text-align: left;'>5</td>
<td style='text-align: center;'>1975-03-01</td>
<td style='text-align: center;'>Croatia</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>73</td>
<td style='text-align: center;'>8</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>6</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>1975-03-01</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>Denmark</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>16</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>19</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>57</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>70</td>
</tr>
</tbody>
</table><!--/html_preserve-->

Now we have a dataset that will be easy to work with in near future.  We've got a date variable and a country indicator.  We also have four columns corresponding to the four spreadsheets:

* HPI : nominal house price index (not adjusted for inflation)
* RHPI : real house price index
* PDI : nominal personal disposable income (not adjusted for inflation)
* RPDI : real personal disposable income

Now we can create some plots!

# Global house price trends

Let's construct a small multiple showing how nominal and real house prices look across countries since 2005.


{% highlight r %}
#create a caption for attribution to source

mycaption<-"Mack, A., and E. Martinez-Garcia. 2011. 'A Cross-Country Quarterly Database of Real House Prices: A Methodological Note.' Globalization and Monetary Policy Institute Working Paper No. 99, Federal Reserve Bank of Dallas."
mycaption<-str_wrap(mycaption,width=90) #wrap the caption
mycap1<-"@lenkiefer Source: Dallas Federal Reserve International House Price Database  http://www.dallasfed.org/institute/houseprice/"  #caption part 2
#######################################################################
### Plot nominal house prices ###
#######################################################################
ggplot(data=filter(df3,year(date)>2004),
       aes(x=date,y=HPI,color=country,label=country))+
  geom_line(size=1.1)+
  scale_x_date(date_breaks="2 year",date_labels="%y")+
  facet_wrap(~country)+
  theme_minimal()+ geom_hline(yintercept=100,linetype=2)+
  scale_y_log10(breaks=seq(50,200,25),limits=c(50,225))+ 
  theme_fivethirtyeight()+
  theme(legend.position="none",plot.caption=element_text(hjust=0,size=7),
        plot.subtitle=element_text(face="italic"),
        axis.text=element_text(size=7.5))+
  labs(x="",y="",title="Comparing house prices",
       caption=paste0(mycap1,"\n",mycaption),
       subtitle="Seasonally adjusted index (2005=100, log scale)")
{% endhighlight %}

![plot of chunk 04-20-2017-readxl-6](/img/Rfig/04-20-2017-readxl-6-1.svg)

Compare to real house prices.


{% highlight r %}
#######################################################################
### Plot real house prices ###
#######################################################################
ggplot(data=filter(df3,year(date)>2004),
       aes(x=date,y=RHPI,color=country,label=country))+
  geom_line(size=1.1)+
  scale_x_date(date_breaks="2 year",date_labels="%y")+
  facet_wrap(~country)+
  theme_minimal()+ geom_hline(yintercept=100,linetype=2)+
  scale_y_log10(breaks=seq(50,200,25),limits=c(50,225))+ 
  theme_fivethirtyeight()+
  theme(legend.position="none",plot.caption=element_text(hjust=0,size=7),plot.subtitle=element_text(face="italic"),
        axis.text=element_text(size=7.5))+
  labs(x="",y="",title="Comparing real (inflation-adjusted) house prices",
       caption=paste0(mycap1,"\n",mycaption),
       subtitle="Seasonally adjusted index (2005=100, log scale)")
{% endhighlight %}

![plot of chunk 04-20-2017-readxl-7](/img/Rfig/04-20-2017-readxl-7-1.svg)

We also might want to compare nominal/real house prices to estimates of nominal/real house prices.  Let's just do it for nominal house prices:


{% highlight r %}
ggplot(data=filter(df3,year(date)>2004),
       aes(x=date,y=HPI,color=country,label=country))+
  geom_line(size=1.1,aes(color="House Prices"))+
  geom_line(size=1.1,aes(y=PDI,color="Disposable Income"),linetype=2)+
  scale_color_fivethirtyeight("Nominal index (2005=100)")+
  scale_x_date(date_breaks="2 year",date_labels="%y")+
  facet_wrap(~country)+
  theme_minimal()+ geom_hline(yintercept=100,linetype=2)+
  scale_y_log10(breaks=seq(50,200,25),limits=c(50,225))+ 
  theme_fivethirtyeight()+
  theme(legend.position="top",plot.caption=element_text(hjust=0,size=7),plot.subtitle=element_text(face="italic"),
        axis.text=element_text(size=7.5))+
  labs(x="",y="",title="Comparing nominal house prices to disposable income",
       caption=paste0(mycap1,"\n",mycaption),
       subtitle="Seasonally adjusted index (2005=100, log scale)")
{% endhighlight %}

![plot of chunk 04-20-2017-readxl-8](/img/Rfig/04-20-2017-readxl-8-1.svg)

While the small multiples are useful, let's restrict our attention to comparing just Canada and the United States which allows us to zoom in more:


{% highlight r %}
ggplot(data=filter(df3,year(date)>2004 & country %in% c("Canada","US")),
       aes(x=date,y=HPI,color=country,label=country))+
  geom_line(size=1.1,aes(color="House Prices"))+
  geom_line(size=1.1,aes(y=PDI,color="Disposable Income"),linetype=2)+
  scale_color_fivethirtyeight(name="Nominal index (2005=100)")+
  scale_x_date(date_breaks="2 year",date_labels="%y")+
  facet_wrap(~country)+
  theme_minimal()+ geom_hline(yintercept=100,linetype=2)+
  scale_y_log10(breaks=seq(50,200,25),limits=c(50,225))+ 
  theme_fivethirtyeight()+
  theme(legend.position="top",plot.caption=element_text(hjust=0,size=7),plot.subtitle=element_text(face="italic"),
        axis.text=element_text(size=7.5))+
  labs(x="",y="",title="Comparing nominal house prices to disposable income",
       caption=paste0(mycap1,"\n",mycaption),
       subtitle="Seasonally adjusted index (2005=100, log scale)")
{% endhighlight %}

![plot of chunk 04-20-2017-readxl-9](/img/Rfig/04-20-2017-readxl-9-1.svg)

Since 2005, house prices in Canada have outpaced incomes, while the United States the opposite is true.  Of course, we should use caution when interpreting these lines, as the U.S. housing market peaked in 2006 so 2005 might distort the comparison. Also, differences in inflation could drive some of the differences.

Let's instead compute the rate of real house price growth and real income growth and compare.




{% highlight r %}
pct <- function(x) {(x/lag(x,4))-1}

# usually do this with data.table(), but can with dplyr
# Thanks Stackoverflow!  http://stackoverflow.com/questions/31352685/how-can-i-calculate-the-percentage-change-within-a-group-for-multiple-columns-in
df3 %>% group_by(country) %>% 
  mutate_each(funs(pct), c(HPI, PDI, RHPI,RPDI)) ->df4

ggplot(data=filter(df4,year(date)>1989 & country %in% c("Canada","US")),
       aes(x=date,y=RHPI,color=country,label=country))+
  geom_line(size=1.1,aes(color="House Prices"))+
  geom_line(size=1.1,aes(y=RPDI,color="Disposable Income"),linetype=2)+
  scale_color_fivethirtyeight(name="4-qtr % change in real ")+
  scale_x_date(date_breaks="2 year",date_labels="%y")+
  facet_wrap(~country)+
  theme_minimal()+ 
  scale_y_continuous(label=scales::percent,  #need scales library for % formatting
                     breaks=seq(-.1,.15,.05))+  
  theme_fivethirtyeight()+
  theme(legend.position="top",plot.caption=element_text(hjust=0,size=7),
        plot.subtitle=element_text(face="italic"),
        axis.text=element_text(size=7.5))+
  labs(x="",y="",title="Real house price and real disposable income growth",
       caption=paste0(mycap1,"\n",mycaption),
       subtitle="Four quarter percent change in seasonally adjusted index (2005=100, log scale)")
{% endhighlight %}

![plot of chunk 04-20-2017-readxl-10](/img/Rfig/04-20-2017-readxl-10-1.svg)

Here we see that real house prices have been outpacing incomes by a fairly wide margin in Canada over the past couple years.

# Data Wrangling

Using readxl and the tidyverse I was able to do some nifty data wrangling. In the past I have been able to do these things in Excel or through brute force with some repetitive code.  The functions of the tidyverse, particularly from readxl and purrr enable us to get these data into shape in a compact, easily readable, reproducible, and elegant fashion. 

Next time I face a thorny Excel problem I can modify this approach and apply it. How could it work for you?


# Bonus: Some gifs

Below, without additional commentary, I leave a few animated gifs.

<img src="{{ site.url }}/img/charts_apr_20_2017/hpi compare international 04 19 2017.gif" alt="global hpi gif"/>

<img src="{{ site.url }}/img/charts_apr_20_2017/hpi compare international 04 19 2017 v2.gif" alt="global hpi gif"/>


<img src="{{ site.url }}/img/charts_apr_20_2017/hpi bars 04 19 2017 dark2.gif" alt="global hpi gif"/>


<img src="{{ site.url }}/img/charts_apr_20_2017/hpi bars 04 19 2017 dark3.gif" alt="global hpi gif"/>



