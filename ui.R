library(shiny)
shinyUI(fluidPage(
  titlePanel("CryptoCurrency Explorer"),
   mainPanel(
     tabsetPanel(
      tabPanel("Coin List", 
               tags$br(),
               dataTableOutput("coin_table")),
      tabPanel("Algorithms", 
               plotOutput("algorithms_chart"),
               dataTableOutput("algorithms")),
      tabPanel("Proof Type", 
               plotOutput("prooftype_chart"),
               dataTableOutput("prooftype")),
      tabPanel("About",
               tags$p("Data from " , 
                      tags$a(href='https://www.cryptocompare.com', 'https://www.cryptocompare.com'),
                      ". "
               ),
               tags$p("Shiny web app by ezgraphs<AT>gmail<DOT>com.")
      )
     )
  ) 
))
