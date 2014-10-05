library(data.table)
library(Rbitcoin)
library(shiny)

about.html <- render("about.Rmd",quiet=TRUE)

perform_call <- function(input){
  market <- input$Imarket
  currency_pair <- input$Icurrency_pair
  action <- input$Iaction
  # auth
  if(action %in% c('wallet','open_orders','place_limit_order','cancel_order')){
    key <- input$Ikey
    secret <- input$Isecret
    client_id <- input$Iclient_id # bitstamp only
  }
  
  # split "BTCUSD" to c("BTC","USD")
  split_cp <- function(currency_pair) c(substr(currency_pair,1,3),substr(currency_pair,4,6))
  
  # launch call
  switch(
    action,
    "ticker"= market.api.process(market, split_cp(currency_pair),action),
    "order_book" = market.api.process(market, split_cp(currency_pair),action),
    "wallet" = {
      if(market=='bitstamp') market.api.process(market, action, key = key, secret = secret, client_id = client_id)
      else market.api.process(market, action, key = key, secret = secret)
    },
    "open_orders" = {
      if(market=='bitstamp') market.api.process(market, action, key = key, secret = secret, client_id = client_id)
      else market.api.process(market, action, key = key, secret = secret)
    },
    "place_limit_order" = {
      if(is.null(input$Itype)) stop("missing 'type' param to place_limit_order action")
      if(is.na(input$Iprice)) stop("missing 'price' param to place_limit_order action")
      if(is.na(input$Iamount)) stop("missing 'amount' param to place_limit_order action")
      req <- list(type = input$Itype, amount = input$Iamount, price = input$Iprice)
      if(market=='bitstamp') market.api.process(market, split_cp(currency_pair), action, req = req, key = key, secret = secret, client_id = client_id)
      else market.api.process(market, split_cp(currency_pair), action, req = req, key = key, secret = secret)
    },
    "cancel_order" = {
      if(input$Ioid=="") stop("missing 'oid' (order id) param to cancel_order action")
      req <- list(oid = input$Ioid)
      if(market=='bitstamp') market.api.process(market, action, req = req, key = key, secret = secret, client_id = client_id)
      else market.api.process(market, action, req = req, key = key, secret = secret)
    },
    "trades" = {
      if(input$Itid=="") market.api.process(market, split_cp(currency_pair), action)
      else market.api.process(market, split_cp(currency_pair), action, req = list(tid = input$Itid))
    }
  )
}

