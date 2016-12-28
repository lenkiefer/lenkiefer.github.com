---
layout: post
title: "Data tables are Viz too"
author: "Len Kiefer"
date: "2016-12-27"
summary: "R statistics data table"
group: navigation
theme :
  name : lentheme
---

THOUGH 2016 IS NOT OVER YET I want to get a jump on my 2017 resolution: make bettter tables.

I've been re-reading [this paper](http://www.jstor.org/stable/2344922?seq=1#page_scan_tab_contents) on the *Rudiments of Numeracy* by A. S. C. Ehrenberg published in the Journal of the Royal Statistical Society in 1977.  Though the paper is nearly 40 years old, it still offers some valuable insights.

This little post makes a simple table displaying monthly averages for 30-year fixed mortgage rates. I use the [htmlTable](https://cran.r-project.org/web/packages/htmlTable/index.html) package for [R](https://www.r-project.org/) to make the table.


## Data

The data I'm going to use are estimates of weekly U.S. average 30-year fixed mortgage rates from the [Primary Mortgage Market Survey](http://www.freddiemac.com/pmms/index.html) from Freddie Mac. These data can be easily downloaded from the St. Louis Fred database [here](http://bit.ly/2hli7Sh).

I have the data saved in a simple text file with a column for data, the mortgage rate, and helper columns week, month, and year, where week is the week number starting with the first week of the year.

## Code for table

Now we'll load the data, do some data manipulations and make our table.  We're going to add some additional styling to the table.


{% highlight r %}
# load libraries
library(tidyverse,quietly=T)
library(xtable,quietly=T)
library(data.table,quietly=T)
library(htmlTable,quietly=T)

# load data on weekly mortgage rates:
pmms30yr <- fread("data/pmms30yr.txt")
pmms30yr$date<-as.Date(pmms30yr$date, format="%m/%d/%Y")

# create month name variable "mname"
pmms30yr[,mname:=as.character(date,format="%b")]

#Compute averages by year/month
pm<-pmms30yr[,list(rate=round(mean(rate,na.rm=T),2)),by=c("year","mname")]

# "spread" rates over month in a wide data frame and coerce to data.frame
pms<-data.frame(spread(pm,mname,rate))

# drop year column
pms2 <- pms[,-1]

# use the first column (year) as rownames 
rownames(pms2) <- pms[,1]

# reorder the columns to by month (Jan, Feb, etc) instead of alphabetically (Apr, Aug, etc.)
pms2<-pms2[,unique(pmms30yr[year>1971]$mname)]

# Compute annual averages
pm.a<-pmms30yr[,list(Avg=round(mean(rate,na.rm=T),2)),by=c("year")]

# Add annual averages to data
pm3<-cbind(pms2,pm.a[,2,with=F])
pm3<-format(pm3,digits=3)

# Apply conditiional formatting to 2016 December and Annual averages to reflect fact that
# data is incomplete for those dates

my.format<-function(x){paste0("<span style='color:darkgray; font-style:italic'>",x,"*</span>")}

# overwrite values with styling using <span> and CSS
pm3[46,12:13]<-lapply(pm3[46,12:13],my.format)

#replace 

#create htmlTable

htmlTable(
  caption= # use CSS styling for title
    "<span style='text-align: left; font-size:x-large; font-weight:bold'>30-year Fixed Mortgage Rates in Percentage Points</span>",pm3, 
  # right align numbers
  align="right",
  # apply zebra striping
  col.rgroup = c("none", "#F7F7F7"),
  # group columns by quarter
  cgroup = c("1st Quarter", "2nd Quarter","3rd Quarter","4th Quarter","Annual"),
  n.cgroup = c(3,3,3,3,1),
  # increase spacing for table
  css.cell = "padding-left: .5em; padding-right: .1em;",
  # group data by decade
  tspanner=c("1970s","1980s","1990s","2000s","2010s"),
  n.tspanner=c(9,rep(10,3),7),
  # add a footnote
  tfoot="Source: Primary Mortgage Market Survey, Average of weekly rates\nData through 12/27/2016, <span style='color:darkgray; font-style:italic'>*based on year-to-date values</span>"
          )
{% endhighlight %}

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<caption style='caption-side: top'>
<span style='text-align: left; font-size:x-large; font-weight:bold'>30-year Fixed Mortgage Rates in Percentage Points</span></caption>
<thead>
<tr>
<th style='border-top: 2px solid grey;'></th>
<th colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>1st Quarter</th><th style='border-top: 2px solid grey;; border-bottom: hidden;'>&nbsp;</th>
<th colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>2nd Quarter</th><th style='border-top: 2px solid grey;; border-bottom: hidden;'>&nbsp;</th>
<th colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>3rd Quarter</th><th style='border-top: 2px solid grey;; border-bottom: hidden;'>&nbsp;</th>
<th colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>4th Quarter</th><th style='border-top: 2px solid grey;; border-bottom: hidden;'>&nbsp;</th>
<th colspan='1' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Annual</th>
</tr>
<tr>
<th style='border-bottom: 1px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Jan</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Feb</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Mar</th>
<th style='border-bottom: 1px solid grey;' colspan='1'>&nbsp;</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Apr</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>May</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Jun</th>
<th style='border-bottom: 1px solid grey;' colspan='1'>&nbsp;</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Jul</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Aug</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Sep</th>
<th style='border-bottom: 1px solid grey;' colspan='1'>&nbsp;</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Oct</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Nov</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Dec</th>
<th style='border-bottom: 1px solid grey;' colspan='1'>&nbsp;</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>Avg</th>
</tr>
</thead>
<tbody>
<tr><td colspan='18' style='font-weight: 900; text-align: left;'>1970s</td></tr>
<tr>
<td style='text-align: left;'>1971</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>   NA</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>   NA</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>   NA</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.31</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.42</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.53</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.60</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.70</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.69</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.63</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.55</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.48</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.54</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1972</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.44</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.32</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.30</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.29</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.37</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.37</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.40</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.40</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.42</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.42</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.43</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.44</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.38</td>
</tr>
<tr>
<td style='text-align: left;'>1973</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.44</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.44</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.46</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.54</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.65</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.73</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.05</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.50</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.81</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.77</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.58</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.54</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.04</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1974</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.54</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.46</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.41</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.58</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.97</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.09</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.28</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.59</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.96</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.98</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.79</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.62</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.19</td>
</tr>
<tr>
<td style='text-align: left;'>1975</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.43</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.11</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.90</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.82</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.91</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.89</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.89</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.94</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.13</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.22</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.14</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.10</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.05</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1976</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.02</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.81</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.75</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.73</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.77</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.85</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.93</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.00</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.98</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.93</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.81</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.79</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.87</td>
</tr>
<tr>
<td style='text-align: left;'>1977</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.72</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.67</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.69</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.75</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.83</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.86</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.94</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.94</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.90</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.92</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.92</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.96</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.85</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1978</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.02</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.14</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.20</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.36</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.57</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.71</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.74</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.79</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.76</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.86</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.11</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.35</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.64</td>
</tr>
<tr>
<td style='text-align: left;'>1979</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.39</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.41</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.43</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.50</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.69</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.04</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.09</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.09</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.30</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.64</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.83</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.90</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.20</td>
</tr>
<tr><td colspan='18' style='font-weight: 900; text-align: left; border-top: 1px solid #BEBEBE;'>1980s</td></tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1980</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>12.88</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.04</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>15.28</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>16.33</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.26</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>12.71</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>12.19</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>12.56</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.20</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.79</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.21</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.79</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.74</td>
</tr>
<tr>
<td style='text-align: left;'>1981</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>14.90</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>15.13</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>15.40</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>15.58</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>16.40</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>16.70</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>16.83</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>17.29</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>18.16</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>18.45</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>17.82</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>16.95</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>16.64</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1982</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>17.48</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>17.60</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>17.16</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>16.89</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>16.68</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>16.70</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>16.82</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>16.27</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>15.43</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.61</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.82</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.62</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>16.04</td>
</tr>
<tr>
<td style='text-align: left;'>1983</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.25</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.04</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.80</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.78</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.63</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.87</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.42</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.81</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.73</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.54</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.44</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.42</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.24</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1984</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.37</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.23</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.39</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.65</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.94</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.42</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.67</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.47</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.35</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>14.13</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.64</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.18</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>13.88</td>
</tr>
<tr>
<td style='text-align: left;'>1985</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.07</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.92</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.17</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>13.20</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.91</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.21</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.03</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.19</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.19</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.13</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.78</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.26</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>12.43</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1986</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.89</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.71</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.08</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.94</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.14</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.68</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.51</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.20</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.01</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.97</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.70</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.31</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.19</td>
</tr>
<tr>
<td style='text-align: left;'>1987</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.20</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.08</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.04</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.83</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.60</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.54</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.28</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.33</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.89</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.26</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.65</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.64</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.21</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1988</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.38</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.89</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.93</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.20</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.46</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.46</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.43</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.60</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.48</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.30</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.27</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.61</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.34</td>
</tr>
<tr>
<td style='text-align: left;'>1989</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.73</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.64</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.03</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>11.05</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.77</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.20</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.88</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.98</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.13</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.95</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.77</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.74</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'>10.32</td>
</tr>
<tr><td colspan='18' style='font-weight: 900; text-align: left; border-top: 1px solid #BEBEBE;'>1990s</td></tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1990</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.89</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.20</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.27</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.37</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.48</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.16</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.04</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.10</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.18</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.18</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.01</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.67</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'>10.13</td>
</tr>
<tr>
<td style='text-align: left;'>1991</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.64</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.37</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.50</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.49</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.47</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.62</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.57</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.24</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.01</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.86</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.71</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.50</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.25</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1992</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.43</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.76</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.94</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.85</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.67</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.51</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.13</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.97</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.92</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.09</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.30</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.21</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.39</td>
</tr>
<tr>
<td style='text-align: left;'>1993</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.99</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.68</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.50</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.47</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.46</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.42</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.21</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.11</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.92</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.83</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.16</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.17</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.31</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1994</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.06</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.15</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.67</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.32</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.60</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.40</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.61</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.51</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.64</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.93</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.17</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 9.20</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.38</td>
</tr>
<tr>
<td style='text-align: left;'>1995</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 9.15</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.83</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.46</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.32</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.96</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.57</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.61</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.86</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.64</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.47</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.38</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.20</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.93</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1996</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.03</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.08</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.62</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.93</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.07</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.32</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.25</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.00</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.23</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.92</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.62</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.60</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.81</td>
</tr>
<tr>
<td style='text-align: left;'>1997</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.82</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.65</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.90</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 8.14</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.94</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.69</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.50</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.48</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.43</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.29</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.21</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.10</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.60</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>1998</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.99</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.04</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.13</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.14</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.14</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.00</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.95</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.92</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.72</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.71</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.87</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.74</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.94</td>
</tr>
<tr>
<td style='text-align: left;'>1999</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.79</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.81</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.04</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.92</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.14</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.55</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.63</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.94</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.82</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.85</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.74</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.91</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.44</td>
</tr>
<tr><td colspan='18' style='font-weight: 900; text-align: left; border-top: 1px solid #BEBEBE;'>2000s</td></tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2000</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.21</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.32</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.24</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.15</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.52</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.29</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.15</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.03</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.91</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.80</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.75</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.38</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 8.05</td>
</tr>
<tr>
<td style='text-align: left;'>2001</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.03</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.05</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.95</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.08</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.14</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.16</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.13</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.95</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.82</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.62</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.66</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 7.06</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.97</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2002</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.00</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.89</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 7.01</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.99</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.81</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.65</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.49</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.29</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.09</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.11</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.07</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.05</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.54</td>
</tr>
<tr>
<td style='text-align: left;'>2003</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.92</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.84</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.75</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.81</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.48</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.23</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.63</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.26</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.15</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.95</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.93</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.88</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.83</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2004</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.71</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.63</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.45</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.83</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.27</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.29</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.06</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.87</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.75</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.72</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.73</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.75</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.84</td>
</tr>
<tr>
<td style='text-align: left;'>2005</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.71</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.63</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.93</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.86</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.72</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.58</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.70</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.82</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.77</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.07</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.33</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.27</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.87</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2006</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.14</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.25</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.32</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.51</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.60</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.68</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.76</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.52</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.40</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.36</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.24</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.13</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.41</td>
</tr>
<tr>
<td style='text-align: left;'>2007</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.22</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.29</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.16</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.18</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.26</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.66</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.70</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.57</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.38</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.38</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.21</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.09</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 6.34</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2008</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.76</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.92</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.97</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.92</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.04</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.32</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.43</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.48</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.04</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.20</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.09</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.29</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 6.03</td>
</tr>
<tr>
<td style='text-align: left;'>2009</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.05</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.13</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.00</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.81</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.86</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.42</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.22</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.19</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.06</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.95</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.88</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.93</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 5.04</td>
</tr>
<tr><td colspan='18' style='font-weight: 900; text-align: left; border-top: 1px solid #BEBEBE;'>2010s</td></tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2010</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.03</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.99</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.97</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 5.10</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.89</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.74</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.56</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.43</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.35</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.22</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.30</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.71</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.69</td>
</tr>
<tr>
<td style='text-align: left;'>2011</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.75</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.95</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.84</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.84</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.64</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.51</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.54</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.27</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.11</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.07</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.99</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.96</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.45</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2012</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.92</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.89</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.95</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.91</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.80</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.67</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.55</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.60</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.50</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.38</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.35</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.34</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.66</td>
</tr>
<tr>
<td style='text-align: left;'>2013</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.41</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.53</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.56</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.45</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.54</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.07</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.37</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.46</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.49</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.19</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.25</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.46</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.98</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2014</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.43</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.30</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.34</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.34</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.19</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.16</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.13</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.12</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.16</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.04</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.00</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 3.86</td>
<td style='background-color: #f7f7f7;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; text-align: right;'> 4.17</td>
</tr>
<tr>
<td style='text-align: left;'>2015</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.67</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.71</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.77</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.67</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.84</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.98</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 4.05</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.91</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.89</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.80</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.94</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.96</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; text-align: right;'> 3.85</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;'>2016</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.87</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.66</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.69</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.60</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.60</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.57</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.44</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.44</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.46</td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.47</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'> 3.77</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'><span style='color:darkgray; font-style:italic'> 4.17*</span></td>
<td style='background-color: #f7f7f7; border-bottom: 2px solid grey;' colspan='1'>&nbsp;</td>
<td style='padding-left: .5em; padding-right: .1em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: right;'><span style='color:darkgray; font-style:italic'> 3.64*</span></td>
</tr>
</tbody>
<tfoot><tr><td colspan='18'>
Source: Primary Mortgage Market Survey, Average of weekly rates<br>
Data through 12/27/2016, <span style='color:darkgray; font-style:italic'>*based on year-to-date values</span></td></tr></tfoot>
</table>

# Data tables are viz too

Data tables are a data visualization too. Artful tables can achieve as much or more than fancy statistical graphs. Check back in this space as I explore more ways to construct tables and deploy them together with other data visualization techniques I've been exploring here..
