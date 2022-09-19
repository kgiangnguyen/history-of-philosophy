find_mode <- function(x) {
  u <- unique(x)
  tab <- tabulate(match(x, u))
  u[tab == max(tab)]
}

get_palette <- colorRampPalette(brewer.pal(9, "Set1"))