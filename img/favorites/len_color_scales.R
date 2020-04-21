# Function for colors ----
# adapted from https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2
#####################################################################################
## Make Color Scale ----  ##
#####################################################################################
my_colors <- c(
  "green"      = rgb(103,180,75, maxColorValue = 256),
  "green2"      = rgb(147,198,44, maxColorValue = 256),
  "lightblue"  =  rgb(9, 177,240, maxColorValue = 256),
  "lightblue2" = rgb(173,216,230, maxColorValue = 256),
  'blue'       = "#00aedb",
  'red'        = "#d11141",
  'orange'     = "#f37735",
  'yellow'     = "#ffc425",
  'gold'       = "#FFD700",
  'light grey' = "#cccccc",
  'purple'     = "#551A8B",
  'dark grey'  = "#8c8c8c")


my_cols <- function(...) {
  cols <- c(...)
  if (is.null(cols))
    return (my_colors)
  my_colors[cols]
}


my_palettes <- list(
  `main`  = my_cols("blue", "green", "yellow"),
  `cool`  = my_cols("blue", "green"),
  `cool2hot` = my_cols("lightblue2","lightblue", "blue","green", "green2","yellow","gold", "orange", "red"),
  `hot`   = my_cols("yellow", "orange", "red"),
  `mixed` = my_cols("lightblue", "green", "yellow", "orange", "red"),
  `mixed2` = my_cols("lightblue2","lightblue", "green", "green2","yellow","gold", "orange", "red"),
  `mixed3` = my_cols("lightblue2","lightblue", "green", "yellow","gold", "orange", "red"),
  `mixed4` = my_cols("lightblue2","lightblue", "green", "green2","yellow","gold", "orange", "red","purple"),
  `mixed5` = my_cols("lightblue","green", "green2","yellow","gold", "orange", "red","purple","blue"),
  `mixed6` = my_cols("green", "gold", "orange", "red","purple","blue"),
  `grey`  = my_cols("light grey", "dark grey")
)


my_pal <- function(palette = "main", reverse = FALSE, ...) {
  pal <- my_palettes[[palette]]
  
  if (reverse) pal <- rev(pal)
  
  colorRampPalette(pal, ...)
}


scale_color_mycol <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- my_pal(palette = palette, reverse = reverse)
  
  if (discrete) {
    discrete_scale("colour", paste0("my_", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}



scale_fill_mycol <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- my_pal(palette = palette, reverse = reverse)
  
  if (discrete) {
    discrete_scale("fill", paste0("my_", palette), palette = pal, ...)
  } else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}