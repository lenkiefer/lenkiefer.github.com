---
layout: post
title: "Populous metros are heavy!"
author: "Len Kiefer"
date: "2016-12-19"
summary: "R statistics map animation ggplot2"
group: navigation
theme :
  name : lentheme
---

I WANT TO SHARE WITH YOU a little bit of code to make this whimsical data visualization:

<img src="{{ site.url }}/img/charts_dec_23_2016/populous maps are heavy.gif" alt="Populous metros are heavy!"/>

# Make a simple map

First we can construct a map of the lower 48 U.S. states and add a marker for each city.  These data are available in the *us.cities* data that come with the [maps package](https://cran.r-project.org/web/packages/maps/index.html).


{% highlight r %}
library(tidyverse)
library(maps)

data(us.cities) # get us city data from the package maps

# drop AK and HI to get the lower 48 states:
us.48<-subset(us.cities,! country.etc %in% c("AK","HI"))

# draw a pop map
ggplot(us.48, aes(x = long, y = lat, fill =log(pop),size=pop)) +
  scale_fill_distiller(type = 'seq', palette = "Reds",direction=1)+
  borders("state",  colour = "grey70",fill="lightgray",alpha=0.4)+
  geom_point(alpha=0.82,color="grey70",shape=21)+
  theme_void()+theme(legend.position="none")
{% endhighlight %}

![plot of chunk animation-1-dec23-2016](/img/Rfig/animation-1-dec23-2016-1.svg)

# Add a "dunk tank"

For this example, I was feeling whimsical, so I decided to add a dunk tank, represented by a blue rectangle under the US and have the cities fall into the tank. Then I would allow the metros to rise back up based on how populous the city. New York, the most populous city would remain at the bottom, while smaller cities would get close to the top.

I did this by adding a blue rectangle below the US.  Turns out the [lowest latitude in the continental U.S.](https://en.wikipedia.org/wiki/List_of_extreme_points_of_the_United_States#Southernmost_points) is just above 24, so if we extend the plot down to 0 we can add space. Then we draw a blue rectangle and drop our points there.

To do so, we need to create a couple of datasets where we overwrite latitude with new values.  First we force latitude to zero, and then we allow it to vary from 0 to 24 depending on how close the population is to New York's 8 million.


{% highlight r %}
# create data set where latitude goes to zero
d.x0<-us.48
d.x0$lat<-0

# create a data set where variables float up, based on how far from largestest (NYC) pop they are
d.xpop<-us.48
d.xpop$lat<-24*(1-d.xpop$pop/8124427)
{% endhighlight %}

# Animations with tweenr

Now we can animate.  

We'll use tweenr to create the animation. See this [post about tweenr]({% post_url 2016-05-29-improving-R-animated-gifs-with-tweenr %}) for an introduction to tweenr, and more examples [here]({% post_url 2016-05-30-more-tweenr-animations %}) and [here]({% post_url 2016-06-26-week-in-review %}). 

I've also added a stripped down [example that uses pre-packaged data]({% post_url 2016-12-19-more-tweenr-housing %}) that should be even easier to follow along with.



{% highlight r %}
# create function that takes input data and forces characters to factors (so tweenr doesn't try to interpolate them)
myf<-function(df){
  df[,c("lat","long","state","pop")]
  dt<-df
  dt %>% map_if(is.character, as.factor) %>% as.data.frame -> dt.out
  return(dt.out)
}

my.list<-lapply(list(us.48,d.x0,d.xpop,us.48),myf)


tf <- tween_states(my.list, tweenlength= 7, statelength=1, ease=rep('cubic-in-out',3),
                   nframes=60)

# Create animation

oopt = ani.options(interval = 0.05)
saveGIF({for (i in 1:max(tf$.frame)) {
  g<-
    ggplot(subset(tf,.frame==i), aes(x = long, y = lat, fill =log(pop),size=pop)) +
    scale_fill_distiller(type = 'seq', palette = "Reds",direction=1)+
    borders("state",  colour = "grey70",fill="lightgray",alpha=0.4)+
    theme_void()+theme(legend.position="none")+
    scale_y_continuous(limits=c(0,50))+
    geom_rect(fill="lightblue",alpha=0.15,color="NA",
              size=1,aes(xmin=min(tf$long),xmax=max(tf$long),ymin=0,ymax=24.5))+
    geom_point(alpha=0.82,color="grey70",shape=21)+
    labs(title="Populous metros are heavy!",
         caption="@lenkiefer")+
    theme(plot.caption=element_text(hjust=0))
    print(g)
  print(paste(i,"out of",max(tf$.frame)))
  ani.pause()}
  },movie.name="populous maps are heavy.gif",ani.width = 450, ani.height = 450)
{% endhighlight %}


# What next?

This was a pretty whimsical example.  But we can build on it and do something more interesting, like this animated tour of housing market trends:

<img src="{{ site.url }}/img/charts_dec_23_2016/geo tween 12 22 2016 v4.gif" alt="Populous metros are heavy!"/>

We'll construct this one in a later post.

