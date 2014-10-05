
# shiny ---------------------------------------------------------------------

library(data.table)
# data.table(x = 1:10, y = rnorm(10))[,dygraph(xts(y, as.Date(Sys.Date():(Sys.Date()+(length(x)-1)))))]

shiny.dict <- list(
  data.table(action = "ticker", shinyProcess = c(function(x) x)),
  data.table(action = "order_book", shinyProcess = c(function(x) invisible(plot(x, ...)))),
  data.table(action = "trades", shinyProcess = c(function(x) invisible(plot(x, ...)))),
  data.table(action = "wallet", shinyProcess = c(function(x) invisible(plot(x, ...)))),
  data.table(action = "open_orders", shinyProcess = c(function(x) x[["open_orders"]])),
  data.table(action = "place_limit_order", shinyProcess = c(function(x) x)),
  data.table(action = "cancel_order", shinyProcess = c(function(x) x))
  )
shiny.dict <- setkeyv(rbindlist(shiny.dict),"action")

shiny.dict

shinyBTC <- function(){
  runApp("shinyBTC", display.mode = "showcase")
}

runGitHub("jangorecki/shinyBTC", display.mode = "showcase")

unique(api_dict()[!is.na(base)],by=c("market","base","quote")
)[,.(market, currency_pair = paste(base,quote,sep=""))
  ]
