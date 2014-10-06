# start by folding all the sub processes
shinyServer(function(input, output, session){
  
  ### market api
  
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
  
  # perform api call
  market_api_res <- reactive({
    validate(need(input$Iapi_call > 0, ""))
    isolate({
      action <- input$Iaction
      #message("perform_call")
      invisible(perform_call(input = input))
    })
  })
  
  # render console log
  output$Oprint_market_api_res <- renderPrint({
    input$Iapi_call
    isolate({
      validate(need(input$Iapi_call > 0, ""))
      #message("renderPrintConsole")
      market_api_res()
      })
  })
  # render plot result
  output$Oplot_market_api_res <- renderPlot({
    input$Iapi_call
    isolate({
      validate(need(input$Iapi_call > 0, ""))
      validate(need(input$Iaction %in% c("order_book","trades"), "")) # ,"wallet" TODO
      #message("renderPlot")
      x <- market_api_res()
      if(class(x)[1] %in% c("btc.trades","btc.order_book")) plot(x, verbose = 0) else invisible(NULL)
    })
  })
  # render data table result
  output$Odt_market_api_res <- renderDataTable({
    input$Iapi_call
    isolate({
      validate(need(input$Iapi_call > 0, ""))
      validate(need(!(input$Iaction %in% c("order_book")), ""))
      action <- input$Iaction
      #message("renderDataTable")
      if(action %in% c("trades","wallet","open_orders")){
        market_api_res()[[action]]
      }
      else if(action %in% c("ticker","cancel_order","place_limit_order")){
        market_api_res()
      }
    })
  }, options = list(pageLength = 5, lengthMenu = c(5,10,15,100)))
  # render verbatim str on market response
  output$Ostr_market_api_res <- renderPrint({
    input$Iapi_call
    isolate({
      validate(need(input$Iapi_call > 0, ""))
      #message("renderPrintStr")
      str(market_api_res())
    })
  })
  
  ### blockchain api
  
  ### utils
  
  ### options
  
  setRbitcoinVerbose <- observe(options(Rbitcoin.verbose = input$Rbitcoin.verbose))
  setRbitcoinAntiddosVerbose <- observe(options(Rbitcoin.antiddos.verbose = input$Rbitcoin.antiddos.verbose))
  setRbitcoinAntiddosSec <- observe(options(Rbitcoin.antiddos.sec = input$Rbitcoin.antiddos.sec))
  setRbitcoinPlotMask <- observe(options(Rbitcoin.plot.mask = input$Rbitcoin.plot.mask))
  setRbitcoinPlotLimitPct <- observe(options(Rbitcoin.plot.limit_pct = input$Rbitcoin.plot.limit_pct))
  
})