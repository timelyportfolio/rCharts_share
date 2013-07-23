require(quantmod)
require(reshape2)
require(rCharts)

#get sp500 prices from Yahoo! Finance
sp500 <- getSymbols("^GSPC", auto.assign = FALSE)
#add 200 day moving average
sp500$ma <- runMean( sp500[,4], n = 200)
#get date, close, and 200day mov avg as a data.frame
sp500.df <- data.frame(index(sp500),coredata(sp500)[,c(4,7)])
colnames(sp500.df) <- c("date","close","200dMovAvg")
#melt to long format
sp500.melt <- melt( sp500.df, id.vars = 1 )
#get dates to a javascript favorite format
sp500.melt$date <- as.numeric(as.POSIXct(sp500.melt$date)) * 1000

#do a NVD3 lineWithFocus chart
n1 <- nPlot(
  value ~ date,
  group = "variable",
  data = sp500.melt,
  type = "lineWithFocusChart",
  height = 400,
  width = 600
)
#set xAxis up to format dates
n1$xAxis(tickFormat = "#!function(d) {return d3.time.format('%b %d, %Y')(new Date(d))}!#")
#xAxis auto sets x2Axis, but I like a different format for x2Axis
n1$x2Axis(tickFormat = "#!function(d) {return d3.time.format('%Y')(new Date(d))}!#")
#set yAxis up to format numbers
n1$yAxis(tickFormat = "#!function(d) {return d3.format('0,.0')(d)}!#")
n1
