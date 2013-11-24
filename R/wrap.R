wrap <- function(x, width=76, ...) {
  return( paste( strwrap(x, width, ...), collapse="\n" ) )
}
