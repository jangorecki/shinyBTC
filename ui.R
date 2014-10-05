shinyUI(
  navbarPage(
    "shinyBTC",
    tabPanel("about",
             includeHTML(about.html)),
    tabPanel("market API",
             fluidPage(
               sidebarLayout(
                 sidebarPanel(width = 3,
                              selectInput("Imarket", label = "market:", choices = getOption("Rbitcoin.api.dict")[,unique(market)], selected = getOption("Rbitcoin.api.dict")[,market][1]),
                              selectInput("Icurrency_pair", label = "currency pair:", choices = NULL, selected = NULL),
                              selectInput("Iaction", "action:",  choices = NULL, selected = NULL),
                              p("req args:"),
                              uiOutput("Ireq"),
                              hr(),
                              #p("last API call by market (?antiddos):"),
                              #verbatimTextOutput("Olast_api_call"),
                              #hr(),
                              actionButton("Iapi_call", label = "market API process (+plot)")
                 ),
                 mainPanel(
                   wellPanel(
                     plotOutput("Oplot_market_api_res"),
                     hr(),
                     dataTableOutput("Odt_market_api_res"),
                     hr(),
                     verbatimTextOutput("Ostr_market_api_res")
                     )
                 )
               ),
               wellPanel(
                 verbatimTextOutput("Oprint_market_api_res")
                 )
             )),
    tabPanel("blockchain API",
             NULL),
    tabPanel("utils",
             NULL),
    tabPanel("options",
             fluidPage(
               titlePanel("Rbitcoin options"),
               fluidRow(
                 column(2, numericInput("Rbitcoin.verbose","Rbitcoin verbose:", value = 1L, min = 0L, max = 10L, step = 1L)),
                 column(2, numericInput("Rbitcoin.antiddos.verbose","Rbitcoin antiddos verbose:", value = 1L, min = 0L, max = 1L, step = 1L))
                 ),
               fluidRow(
                 column(2, numericInput("Rbitcoin.antiddos.sec","Rbitcoin antiddos sec:", value = 10, min = 1, max = 60, step = 1)),
                 column(2, checkboxInput("Rbitcoin.plot.mask","Rbitcoin plot mask:", value = FALSE))
               )))
  )
)
