ON <- read.table(header=TRUE, text="Ordinal Number
first 1
second 2
  third 3
  fourth 4
  fifth 5
  sixth 6
  seventh 7
  eighth 8
  nineth 9
  tenth 10
  eleventh 11
  twelveth 12
  thirteenth 13
  fourteenth 14
  fifteenth 15
  sixteenth 16
  seventeenth 17
  eighteenth 18
  nineteenth 19
  twentyth 20
  twentyfirst 21
  twentysecond 22
  twentythird 23
  twentyfourth 24
  twentyfifth 25
  twentysixth 26
  twentyseventh 27
  twentyeighth 28
  twentyninth 29
  thirtyth 30
  thirtyfirst 31
")

ordinal_swap <- function(x, adj=0) {
  x <- gsub("(?<=[0-9])st$|(?<=[0-9])nd$|(?<=[0-9])rd$|(?<=[0-9])th$", "", x, perl=TRUE)
  for (i in 1:nrow(ON)) {
    x <- gsub(ON$Ordinal[i], ON$Number[i] + adj, x)
  }
  return (x)
}
