---
layout: post
title: "Converting a Tableau dashboard to a Flexdashboard"
author: "Len Kiefer"
date: "2017-01-26"
summary: "R statistics dataviz remix flexdashboard"
group: navigation
theme :
  name : lentheme
---

IN THIS POST WE WILL CONVERT a data visualization dashboard I made some time ago using [Tableau](https://www.tableau.com) into a [flexdashboard](http://rmarkdown.rstudio.com/flexdashboard/index.html) using [R.](https://www.r-project.org/)

On Monday, the Census [posted](http://www.census.gov/newsroom/blogs/random-samplings/2017/01/mover-rate.html) a blog summarizing recent mobility trends. According to the CPS ASEC, 11.2 percent of the U.S. population age 1 and over moved between 2015 and 2016, the lowest since the CPS ASEC began in 1948. This post reminded me a visualization [I made](https://public.tableau.com/profile/leonard.kiefer#!/vizhome/State-to-statemigrationin2014/Mobilitygraphic) some time ago showing state-to-state migration using Census data.

As I have been on a kick making R flexdashboards (see [this]({% post_url 2017-01-08-mortgage-rate-viewer %}), [this]({% post_url 2017-01-14-year-in-review-remix %}), [this]({% post_url 2017-01-16-cross-talk-dashboard %}) and [this]({% post_url 2017-01-20-flexin-friday %}) for examples and [this post for a guide on building a flexdashboard]({% post_url 2017-01-22-build-flex %}) I figured it would be fun to convert this viz into a flexdashboard.

This would also give me a chance to explore maps with [plotly](https://plot.ly/r/).

### The orginal

First take a look at the [original viz](https://public.tableau.com/views/State-to-statemigrationin2014/Mobilitygraphic?:embed=y&:display_count=yes):

<iframe src="https://public.tableau.com/views/State-to-statemigrationin2014/Mobilitygraphic?:embed=y&:display_count=yes" height="800" width="1200"></iframe>

This dashboard is relatively simple. It's a single page with two linked maps and two linked tables.

The maps depict state-to-state migration in 2014.  For any selected state the top map shows outmigration, the number of people (over age 1) who migrated out of the selected state to another state in 20114. The bottom map shows in migration, or the number of people who migrated into each state from another state. There's also two tables showing stats for the top 10 states in terms of in migration and out migration respectively.

There's a filter box to select states.  Go ahead and give it a try if you haven't.

# A Flexdashboard version

We can recreate many of these features in a flexdashboard.

## The data

The data for this dashboard come from the U.S. Census Bureau, available [here](http://www.census.gov/data/tables/time-series/demo/geographic-mobility/state-to-state-migration.html). The data show state-to-state migration.  I've saved the data in a text file called *mig2015.txt* [(click here to download)]({{ site.url}}/chartbooks/jan2017/data/mig2015.txt).

I organized these data (mainly deleting irrelevant columns and unmerging cells) in Excel.  Let's take a look:


{% highlight r %}
df<-fread("data/mig2015.txt")

htmlTable(head(df %>% map_if(is.Date, as.character,format="%b %d,%Y") %>% map_if(is.numeric, round,2) %>% as.data.frame() ,5), col.rgroup = c("none", "#F7F7F7"),caption="2015 State to State Migration Data",
          tfoot="Source: U.S. Census Bureau")
{% endhighlight %}

<table class='gmisc_table' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='6' style='text-align: left;'>
2015 State to State Migration Data</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey;'> </th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>state.to</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>state.from</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>total</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>statecode.to</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>statecode.from</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: left;'>1</td>
<td style='text-align: center;'>Alabama</td>
<td style='text-align: center;'>Alabama</td>
<td style='text-align: center;'>0</td>
<td style='text-align: center;'>AL</td>
<td style='text-align: center;'>AL</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>2</td>
<td style='background-color: #f7f7f7; text-align: center;'>Alabama</td>
<td style='background-color: #f7f7f7; text-align: center;'>Alaska</td>
<td style='background-color: #f7f7f7; text-align: center;'>767</td>
<td style='background-color: #f7f7f7; text-align: center;'>AL</td>
<td style='background-color: #f7f7f7; text-align: center;'>AK</td>
</tr>
<tr>
<td style='text-align: left;'>3</td>
<td style='text-align: center;'>Alabama</td>
<td style='text-align: center;'>Arizona</td>
<td style='text-align: center;'>1865</td>
<td style='text-align: center;'>AL</td>
<td style='text-align: center;'>AZ</td>
</tr>
<tr style='background-color: #f7f7f7;'>
<td style='background-color: #f7f7f7; text-align: left;'>4</td>
<td style='background-color: #f7f7f7; text-align: center;'>Alabama</td>
<td style='background-color: #f7f7f7; text-align: center;'>Arkansas</td>
<td style='background-color: #f7f7f7; text-align: center;'>2329</td>
<td style='background-color: #f7f7f7; text-align: center;'>AL</td>
<td style='background-color: #f7f7f7; text-align: center;'>AR</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: left;'>5</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>Alabama</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>California</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>3397</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>AL</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>CA</td>
</tr>
</tbody>
<tfoot><tr><td colspan='6'>
Source: U.S. Census Bureau</td></tr></tfoot>
</table>

These data show migration across states based on the Census tables.  The variable *state.to* is the destination state while *state.from* is the state of residence one year prior. I've excluded migration from outside the U.S. and from Puerto Rico and U.S. island territories. Also, migration within the same state is set equal to zero for this exercise (e.g. from Alabama to Alabama set equal to zero).

## Getting the data to talk

Like in my [guide on building a flexdashboard]({% post_url 2017-01-22-build-flex %}) we are going to use [crosstalk](https://github.com/rstudio/crosstalk) to get the graphs to respond to a filter select box.  And like before, we'll use [plotly](https://plot.ly/r/) to make the graphs.  We'll also use [DT](https://rstudio.github.io/DT/) to add an interactive data table.

Our plan is to be able to use a single filter box to filter two maps and a data table. The tricky part is that in one map we want to filter on *state.to* to show all the in migration by state, while on another map we want to filter on *state.from* to show out migration. We can do this by setting using *ShareData* with groups:


{% highlight r %}
sd.from <- SharedData$new(df.from, ~state.from,group="state")
sd.to <- SharedData$new(df, ~state.to,group="state")
{% endhighlight %}

We use `SharedData$new` to create both *sd.from* and *sd.new* and use `group="state"` to indicate that these are part of a common group.  Then, when we filter on state using the *state* group, we'll filter both *sd.from* and *sd.to*.

Then we us the *bs_cols* function from crosstalk to set up a filter:


{% highlight r %}
bscols(
  filter_select("state", "Select State", sd.to, ~state.to,multiple=F)
)
{% endhighlight %}

We only want to filter on one state at a time so we set `multiple=FALSE`.

Then, it's just a matter of laying out the flexdashboard and setting up our widgets.  For comparison, we embedded the original Tableau dashboard in our flexdashboard. *How meta!*

You can see a fullscreen version [here]({{ site.url}}/chartbooks/migration_flex2.html). 

You can get the code by clicking on the source button on the top right.

<iframe src="{{ site.url}}/chartbooks/jan2017/migration_flex2.html" height="800" width="1200"></iframe>


