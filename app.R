wd <- getwd()

##########----------------------------
# Load packages
##########----------------------------

if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(DT)) install.packages("DT", repos = "http://cran.us.r-project.org")

library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)

attach(mining)

##########----------------------------
# Download and Reading of the file
##########----------------------------


csvudemy <- tempfile()
download.file("https://att-c.udemycdn.com/2016-12-13_01-49-14-3df32750885cd4e0d78389c106e0ff30/original.csv?response-content-disposition=attachment%3B+filename%3Dcourse_proj_data.csv&Expires=1621437532&Signature=LuvBUJ8CIGw9sizalIUNr6DqJeDln3DDP-8NEtV2OvcHNHHhpCaO8DcwKyYc9kR6YPynh41vkBi~stJ1nASgs8p3hUzqI0WK2QA7bsN9jby-FHBMVAR719S8JenW8Mx7Cfv6n0A7N3VSzPh8ARkfxcPa6-xD6h4Dh-TlkzKYlm3Jmtk78J5zm~FHiPGSHH7q~T~wC1PorNxyPKewALt9LW9uUc~oCbR7--MWNjOqbJxb9~AWSNMT0RWV~q4zRERenUPU~IeIJw9c4~a9jktDB25KOPoI220Q6HUmVyo7JOGN7mCemvegimnns7EGrJwkJx4jFDwTXhCtTAHzE7MHXg__&Key-Pair-Id=APKAITJV77WS5ZT7262A", csvudemy)

mining <- read_csv2(csvudemy)

##########----------------------------
# Server
##########----------------------------
server <- function(input, output, session) {
  
  library(shiny)
  library(shinythemes)
  library(tidyverse)
  library(DT)
  
  mycalculation <- sum(WG1*"G1", WG2*"G2", WG3*"G3")
  
  output$plot <- renderPlot({
    ggplot(mining, aes(mycalculation,marketcap)) +
      geom_smooth(method="lm") +
      xlab("Value calculation result") +
      ylab("Market capitalisation in Million USD")
  })
  
  selection <- reactive({
    user_brush <- input$user_brush
    sel <- brushedPoints(mining, user_brush)
    return(sel)
  })
  
  output$selectedtable <- DT::renderDataTable(DT::datatable(selection()))
  output$rawtable <- DT::renderDataTable(DT::datatable(mining) %>%
                                         formatCurrency("MarketCap in M", "$", digits=0) %>%
                                         formatStyle("Symbol", color = "grey") %>%
                                         formatStyle(c("G3", "G2", "G1"), backgroundColor = "lightblue")   
                                         )
  
  output$my_mining_download = downloadHandler(filename="my_mining_selection.csv",
                                              content = function(file) {
                                                write.csv(selection, file)
                                              })
  output$full_mining_download = downloadHandler(filename="full_mining_table.csv",
                                                content = function(file){
                                                write.csv(mining, file)  
                                                })
}

##########----------------
# UI
##########----------------

ui <- navbarPage(theme = shinytheme("slate"),
                 title = h3("Mining companies stocks"),
                 tabPanel(("Stocks values explorer App"),
                          wellPanel(
                                    sliderInput(inputId = "WG1", label = "Weight on Grade 1", min = 0 , max = 20 , value = 8),
                                    sliderInput(inputId = "WG2", label = "Weight on Grade 2", min = 0 , max = 20 , value = 8),
                                    sliderInput(inputId = "WG3", label = "Weight on Grade 3", min = 0 , max = 6  , value = 2.4, step = 0.2),
                                    ),
                                    plotOutput("plot", brush = "user_brush"),
                                    DT::dataTableOutput("selectedtable"),
                                    downloadButton(outputId = "my_mining_download", label = "Download Table")
                                   
                          ),
                           
                 tabPanel("Documentation",
                          "Documentation sourced from Youtube",
                          tags$iframe(src="https://www.youtube.com/embed/vySGuusQI3Y"),
                          style="height:900px, width:900px"
                        ),
                           
                 tabPanel("Raw Data Table",
                                    DT::dataTableOutput("rawtable"),
                                    downloadButton(outputId = "full_mining_download", label = "Download Table")
                        ),
                
                          
                )


shinyApp(ui = ui, server = server)