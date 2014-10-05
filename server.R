
shinyServer(function(input, output, session){
  
  observe({
    market <- input$Imarket
    isolate({
      updateSelectInput(session, 
                        "Icurrency_pair", 
                        choices = getOption("Rbitcoin.api.dict")[market][!is.na(base),list(currency_pair = paste(base,quote,sep=""))][,currency_pair], 
                        selected = getOption("Rbitcoin.api.dict")[market][!is.na(base),list(currency_pair = paste(base,quote,sep=""))][,currency_pair][1])
    })
  }) # update Icurrency_pair
  observe({
    market <- input$Imarket
    currency_pair <- input$Icurrency_pair
    isolate({
      if(nchar(currency_pair)!=6){
        base <- NA_character_; quote <- NA_character_
      }
      else{
        base <- c(NA_character_,substr(currency_pair,1,3)); quote <- c(NA_character_,substr(currency_pair,4,6))
      }
      iq <- bquote(list(.(market), .(base), .(quote)))
      updateSelectInput(session, 
                        "Iaction", 
                        choices = getOption("Rbitcoin.api.dict")[eval(iq), action], 
                        selected = NULL)
    })
  }) # update Iaction
  
  output$Olast_api_call <- renderDataTable({
    #get("Rbitcoin.last_api_call", envir = package:Rbitcoin)
    # Rbitcoin.last_api_call
    data.table(market = character(), timestamp = as.POSIXct(0, origin="1970-01-01")[-1])
  })
  
  # verbose
  setRbitcoinVerbose <- observe({
    options(Rbitcoin.verbose = input$Rbitcoin.verbose)
  })  
  
  # dynamic input action params
  output$Ireq <- renderUI({
    if(is.null(input$Imarket) | is.null(input$Iaction)) return()
    #if(nrow(api.dict[market == input$market & base == substr(input$currency_pair,1,3) & quote == substr(input$currency_pair,4,6) & action == input$action]) == 0) return()
    switch(input$Iaction,
           "place_limit_order" = list(selectInput("Itype", "type", as.list(c('buy','sell'))),
                                      numericInput("Iprice", "price", value = NA, min = 0),
                                      numericInput("Iamount", "amount", value = NA, min = 0)),
           "cancel_order" = list(textInput("Ioid", "order id")),
           "trades" = list(textInput("Itid", "last tid")))
  })
  
  launch_api_call <- reactive({
    validate(need(input$Iapi_call > 0, ""))
    isolate(expr = {
      r <- perform_call(action = input$Iaction, input = input)
      r
    })
  })
  
  
  output$Omarket_api_result <- renderUI({
    market_api_result()
  })
  
  market_api_result <- reactive({
    validate(need(input$Iapi_call > 0, ""))
    isolate({
      action <- input$Iaction
      x <- perform_call(action = action, input = input)
      if(action %in% c("order_book","trades","wallet")){
        renderPlot(plot(x, ...))
      }
      else if(action %in% c("ticker","cancel_order","place_limit_order")){
        renderDataTable(x)
      }
      else if(action %in% c("open_orders")){
        renderDataTable(x[["open_orders"]])
      }
    })
  })
  
})