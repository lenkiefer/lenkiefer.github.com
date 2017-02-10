base_breaks_x <- function(x){
  b <- pretty(x)
  d <- data.frame(y=-Inf, yend=-Inf, x=min(b), xend=max(b))
  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), inherit.aes=FALSE),
       scale_x_continuous(breaks=b))
}

base_breaks_x_date <- function(x,dd){
  #b <- pretty(x)
  b<- c(min(x),max(x))
  b2<- c(min(dd),max(dd))
  
  d <- data.frame(y=-Inf, yend=-Inf, x=min(x), xend=max(x))
  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), 
                    inherit.aes=FALSE),
       scale_x_continuous(breaks=b,labels=b2))
}


base_breaks_y <- function(x){
  b <- pretty(x)
  d <- data.frame(x=-Inf, xend=-Inf, y=min(b), yend=max(b))
  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), inherit.aes=FALSE),
       scale_y_continuous(breaks=b))
}

base_breaks_y0 <- function(x){
  b <- c(0,pretty(x))
  d <- data.frame(x=-Inf, xend=-Inf, y=min(b), yend=max(b))
  list(geom_segment(data=d, aes(x=x, y=y, xend=xend, yend=yend), inherit.aes=FALSE),
       scale_y_continuous(breaks=b))
}


