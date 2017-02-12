---
layout: post
title: "Hello Ninja! Crafting a browser-based presentation and how I got (re)started with R"
author: "Len Kiefer"
date: "2017-02-04"
summary: "R statistics dataviz plotly housing mortgage data"
group: navigation
theme :
  name : lentheme
---
  

  
  
I GIVE A LOT OF TALKS. Some are formal presentations or keynotes to large groups, while many are in small group settings. Sometimes I get impromptu requests so I have to be ready pretty much at all times to give some sort of talk.

On this blog I've shared many different DATA VISUALIZATIONS which could be part of a talk. Many of the more complex visualizations-probably most of the animated gifs-wouldn't work great in most presentation settings.

In this post I want to put together a particular kind of presentation, a chartbook.  This will enable me to try out [remark.js](https://github.com/gnab/remark) a simple in-browser slideshow tool. We'll construct our presentation as a stand-alone web page using the [xaringan](https://github.com/yihui/xaringan) package for [Rmarkdown](http://rmarkdown.rstudio.com/).

We'll build up a small(ish) chartbook using data we've worked with before.

## How I got (re)started with R

Over the past year I've shared many visualizations made with [R](https://www.r-project.org/).  What you might not realize if you've [been following me](https://twitter.com/lenkiefer) is that up until about a year ago I rarely used R.

Many years ago I used [S-Plus](https://en.wikipedia.org/wiki/S-PLUS), a commercial software that's fallen in popularity in recent years.  Over the past few years I drifted away from S-Plus and started using R more, but only infrequently.  So how did I shift into using R?

It was because I wanted a certain kind of axis.

I've read many books about presentations. There are many good ones.  Someday I'll tell you about them.  One of my favorites is [*Trees, maps and theorems*](http://www.treesmapsandtheorems.com/) by Jean-luc Doumont.  It's a beautiful book with a lot of interesting ideas.  Check out the webpage. Also check out [this Youtube Video](https://www.youtube.com/watch?v=IFu3jaLmse0) of Doumont lecturing at Stanford on communicating science to non-scientists.

*Trees, maps and theorems* is laid out so beautifully. There are many great illustrations. Doumont adopts a [Tufte-like](https://www.edwardtufte.com/tufte/index) minimalism in his charts.  I particularly liked the way he laid out the axes in his chart.  They had few tick marks, sometimes just the min and max of the data.  Much later I would discover that you can (sort of) create these using [`theme_tufte`](http://motioninsocial.com/tufte/) for [ggplot2](http://ggplot2.org/).

### Standard plot and what I wanted

![Comparing axis types](/img/Rfig/feb-4-2017-rangeframe-compare-1.svg)

At the time I was making a lot of charts in <span class="icon-file-excel" style="color:green;">Microsoft Excel</span>.  Don't laugh.  Microsoft Office products get a bad reputation because they are so widely used, not because they are inherently terrible. They certainly can be abused.  But the realities of [corporate life](https://www.linkedin.com/in/leonard-kiefer-51175331) make a certain amount of Office in certain industries inescapable.

But what I was doing was truly laughable.  The results weren't so bad. Here's an example from February of last year:

<!--html_preserve--><blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Mrtg rates headed down. The 30yr FRM lowest since April of last year. <a href="https://t.co/fi42GGuj3P">pic.twitter.com/fi42GGuj3P</a></p>&mdash; Leonard Kiefer (@lenkiefer) <a href="https://twitter.com/lenkiefer/status/697832886003748869">February 11, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script><!--/html_preserve-->

It was the execution that was terrible.  I set up a macro-enabled <span class="icon-file-excel" style="color:green;">Microsoft Excel</span> workbook using [VBA](https://en.wikipedia.org/wiki/Visual_Basic_for_Applications) to draw the axes. To make the chart I suppressed the axis and drew my own using line segments and error bars. 

Each week I would update it. I had some formulas to automate the adjustment of the axis and shift the callouts.  I did this every Thursday for a while, but eventually wised up. Updating the chart wasn't too bad, but exporting the figures sort of a pain. Also, my workbook wasn't completely stable and I'd sometimes lose my work. I realized I needed a scripting language.

[SAS](http://www.sas.com/en_us/home.html), while useful for many tasks, was right out. Though in the past I had made presentation-worthy graphs in that language it wasn't flexible enough for what I wanted. I temporarily fired up S-Plus, but eventually gravitated to [R](https://www.r-project.org/).

# Can we escape Planet PowerPoint with R power?

For certain presentations in certain places I am unable to escape using Microsoft PowerPoint.  But this blog is a perfect place to test out an *html* based presentation.

I didn't get to attend [rstudioconference](https://www.rstudio.com/conference/). But via Twitter I was able to keep up with many of the goings on and found [this useful summary](https://github.com/kbroman/RStudioConf2017Slides). One thing I heard about was a new package for making browser-based presentations with Rmarkdown called [xaringan](https://github.com/yihui/xaringan).  

Let's try it out!

# Craft a presentation

Because this is my first go-around with this software, we won't be building an *excellent* presentation. Instead, we'll go for a functional one that includes graphs with awesome axes. We're going to focus on form and the particulars of each slide and not worry too much (today) about constructing a coherent narrative.

We'll be revisiting the data I track regularly (see e.g. my [2016 housing year-in review]({{ site.url}}/chartbooks/dec2016/index.html)).

## Styles

Being a browser-based presentation, we can easily customize the appearance using *css*.  It's pretty easy in xaringan.  We simply have to save a file in the same directory as the code for our presentation and call it out in the front matter. I called mine *mycss.css*.


{% highlight r %}
---
title: "Housing Market Update"
subtitle: "Recent housing market trends"
author: "Len Kiefer"
date: "2017/02/04"
output:
  xaringan::moon_reader:
    yolo: FALSE     # what do we say to the god of death? http://gameofthrones.wikia.com/wiki/Syrio_Forel
    css: mycss.css  # our .css file
    lib_dir: libs
    nature:
      highlightStyle: github
      highlightLines: true
      countIncrementalSlides: false
---
{% endhighlight %}

I wanted to shift fonts, so *mycss.css* is the same as the default for xaringan except for the following:

```
body { font-family:  'Palatino Linotype', 'Droid Serif','Book Antiqua', Palatino, 'Microsoft YaHei', 'Songti SC', serif; }
h1, h2, h3 {
  font-family: 'Palatino Linotype';
  font-weight: normal;
}
```
All this does is change the font for text and headers to [*Palatino Linotype*](https://en.wikipedia.org/wiki/Palatino#Palatino_Linotype).  I'm not looking to start any font war, I'm really not equipped for that, I just wanted to use a serifed font and Palatino is available.  More importatly, this shows you how to modify the *.css* file, which allows for more customization.

# Make some slides

After our title, let's add a slide showing [mortgage rate trends]({% post_url 2016-12-08-10-ways-to-visualize-rates %}). I'm not actually going to *give* this particular presentation in person, rather it will be read on the web. We'll add some text commentary on the right.

In order to do this, I had to dig into the *.css* file and figure out how to do it.  We have to use `.column-left[]` and `.column-right[]`.  The default *.css* is to have the left column occupy the left 20% of the slide, while the right column will occupy the left 75%.  We could also use `.pull-left[]` and `.pull-right[]` which would split it 47%/47% (for bull `.column` and `.pull` there's a middle buffer). Because I want the graph to occupy more space, we'll used `.column`. Here's how we do it:


{% highlight r %}
class: left, top
### Mortgage rates low by historical standards
.left-column[
Rates remain quite low by historical standards

Rates have been on a 30+ year secular decline
]

.right-column[
  myplot1()
  ]
{% endhighlight %}

Inside `.column-left[]` we insert a list of text.  We could do bullets, but as space is limited we'll ommit them. We don't really miss them.  On the right we'll insert R code for plots.

In order to make our sweet axes, we'll need to draw them. Fortunately it's much easier to do with R than it was in <span class="icon-file-excel" style="color:green;">Microsoft Excel</span>.  We'll need to follow the advice from [this StackOverflow post](http://stackoverflow.com/questions/10808761/r-style-axes-with-ggplot) and build a couple of functions.  

Putting it together we get:


{% highlight r %}
#dt is a data table of rates.  See http://lenkiefer.com/2016/12/08/10-ways-to-visualize-rates


###########################################
#######  Functions for better axis ########
###########################################

################################
# for use with continuous axis
################################
base_breaks_x <- function(x){
  b <- pretty(x)
  d <- data.frame(y=-Inf, yend=-Inf, x=min(b), xend=max(b))
  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), inherit.aes=FALSE),
       scale_x_continuous(breaks=b))
}

################################
# for use with date axis
################################

base_breaks_x_date <- function(x,dd,dd.format="default"){
  #b <- pretty(x)
  b<- c(min(x),max(x))
  b2<- c(min(dd),max(dd))
  if (dd.format != "default") {b2<-as.character(b2,format=dd.format)}
  d <- data.frame(y=-Inf, yend=-Inf, x=min(x), xend=max(x))
  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), 
                    inherit.aes=FALSE),
       scale_x_continuous(breaks=b,labels=b2))
}

################################
# for use on y axis
################################
base_breaks_y <- function(x){
  b <- pretty(x)
  d <- data.frame(x=-Inf, xend=-Inf, y=min(b), yend=max(b))
  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), inherit.aes=FALSE),
       scale_y_continuous(breaks=b))
}


#####################
####  Make Graph ####
#####################


ggplot(data=dt, aes(x=as.numeric(date),y=rate30,label=rate30))+
  geom_line()+theme_bw()+
  #scale_x_date(date_breaks="1 month", date_labels="%b-%y")+
  #scale_y_continuous(limits=c(3,4.4),breaks=seq(3,4.4,.1))+
   labs(x="", y="",
       title="30-year Fixed Mortgage Rate (%)",
       subtitle="weekly average rates",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey")+
  theme(plot.title=element_text(size=18),
        plot.caption=element_text(hjust=0))+
  theme(panel.border = element_blank(),
        panel.grid.major = element_blank(),
                text=element_text(family="Palatino Linotype"),
        panel.grid.minor = element_blank(),
                axis.ticks.length=unit(-0.25,"cm"),
        axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")),
        axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm"))
        ) + 
  ### Use our sweet axis functions:
  base_breaks_x_date(as.numeric(dt$date),dt$date) +
  base_breaks_y(dt$rate30)
{% endhighlight %}

![plot of chunk feb-4-2017-rangeframe-compare3](/img/Rfig/feb-4-2017-rangeframe-compare3-1.svg)

### Adding an annotated chart

For the second slide, we'll modify our chart by adding some annotations.  We'll have to manually add in the additional dates to our axis, but it's not so bad. *(much better than with VBA!)*



{% highlight r %}
dt2<-dt[year(date)>2015]  #subset to 2016 and later
x<-as.numeric(dt2$date)
  b<- as.numeric(c(min(dt2$date),
                   as.Date("2016-06-23"),
                   as.Date("2016-11-08"),max(dt2$date)))
  b2<- c(min(dt2$date), as.Date("2016-06-23"),as.Date("2016-11-08"),max(dt2$date))
    d <- data.frame(y=-Inf, yend=-Inf, x=min(x), xend=max(x))

ggplot(data=dt2, aes(x=as.numeric(date),y=rate30,label=rate30))+
  geom_line()+theme_bw()+
  #scale_x_date(date_breaks="1 month", date_labels="%b-%y")+
  #scale_y_continuous(limits=c(3,4.4),breaks=seq(3,4.4,.1))+
   labs(x="", y="",
       title="30-year Fixed Mortgage Rate (%)",
       subtitle="weekly average rates",
       caption="@lenkiefer Source: Freddie Mac Primary Mortgage Market Survey")+
  theme(plot.title=element_text(size=18),
        plot.caption=element_text(hjust=0))+
  theme(panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
                text=element_text(family="Palatino Linotype"),
        #axis.ticks.length=unit(0.25,"cm"),
                axis.ticks.length=unit(-0.25,"cm"),
        axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")),
        axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm"))
        ) + #geom_rangeframe()
 #base_breaks_x_date(as.numeric(dt2$date),dt$date) +
  base_breaks_y(dt2$rate30)+  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), 
                    inherit.aes=FALSE),
       scale_x_continuous(breaks=b,labels=b2))+
  geom_vline(xintercept=as.numeric(as.Date("2016-11-08")),linetype=2,color="black")+
  annotate(geom="text",x=as.numeric(as.Date("2016-11-08")),y=3.4,hjust=0,label=" U.S.\n election",vjust=0,fontface="italic")+

  geom_vline(xintercept=as.numeric(as.Date("2016-06-23")),linetype=2,color="black")+
  annotate(geom="text",x=as.numeric(as.Date("2016-06-23")),y=3.4,hjust=1,label=" Brexit \n vote ",vjust=0,fontface="italic")
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/img/Rfig/unnamed-chunk-3-1.svg)

### Divider slide

We can use `.inverse` at the slide header to add a black background divider slide.  We specify a new slide with `---` and we can set features of the slide using `class:`.  Then we use a third level heading like so `###`. I wanted smaller header, so I went with `###` instead of a first level heading specified with `#`.

```
---
class: inverse, center, middle
### What might rising rates mean for housing?
```

### Add more slides

We can add a few more slides depicting trends in other areas of the housing market.  For a real presentation I would spend considerably more time thinking about sequencing and the overall structure. 

However, you can see the fruits of me testing out some simple charts within a browser-based presentation below.

Click here for a fullscreen version [here]({{ site.url}}/img/charts_feb_4_2017/feb-2017-update.html). 

<iframe src="{{ site.url}}/img/charts_feb_4_2017/feb-2017-update.html" height="500" width="775"></iframe>

# Next steps

I really enjoyed putting togethere these slides. In future I'll talk more about how I structure a real presentation and how I approach delivery.
