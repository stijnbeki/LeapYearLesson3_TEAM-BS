ndvOver <- function(x, y) {
  ndvi <- (y - x) / (x + y)
  return(ndvi)
}