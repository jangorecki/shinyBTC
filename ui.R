stripDOCTYPE <- function(x){
  unwanted_header <- "<p>&lt;!DOCTYPE html&gt;</p>\n\n"
  if(nchar(x) <= nchar(unwanted_header)) return(x)
  if(substr(x,1,30) == unwanted_header) return(substr(x,31,nchar(x)))
  x
}

shinyUI(
  navbarPage(
    "shinyBTC",
    tabPanel("about",
             stripDOCTYPE(includeMarkdown(about.md))),
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
                              p("last API call by market (?antiddos):"),
                              verbatimTextOutput("Olast_api_call"),
                              hr(),
                              actionButton("Iapi_call", label = "API call"),
                              hr(),
                              numericInput("Rbitcoin.verbose","Rbitcoin verbose:", value = 1L, min = 0L, max = 10L, step = 1L)
                 ),
                 mainPanel(
                   htmlOutput("Omarket_api_result")
                 )
               )
             )),
    tabPanel("blockchain API",
             NULL),
    tabPanel("utils",
             NULL),
    tabPanel("options",
             NULL)
  )
)
