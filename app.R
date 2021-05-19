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


##########----------------------------
# Download and Reading of the file
##########----------------------------
file_url <- "https://github.com/gregmansio/udemyshiny/raw/master/mining.RData"
mining <- "./mining.RData"
download.file(file_url, mining)
load("./mining.RData")

mining <- rename(mining, MarketCap = "MarketCap in M")

attach(mining)

##########----------------------------
# Server
##########----------------------------
server = function(input, output, session) {
  
  library(shiny)
  library(shinythemes)
  library(tidyverse)
  library(DT)
  
  mycalculation = reactive(
    cbind(mining,
          xcalc = input$WG1 * G1 + input$WG2 * G2 + input$WG3 * G3)
    )
  
  output$plot = renderPlot({
    ggplot(mycalculation(), aes(xcalc,MarketCap)) +
      geom_point() +
      geom_smooth(method="lm") +
      xlab("Value calculation result") +
      ylab("Market capitalisation in Million USD")
    })
  
  selection = reactive({
    user_brush <- input$user_brush
    sel <- brushedPoints(mycalculation(), user_brush)
    return(sel)
    })
  
  output$selectedtable = DT::renderDataTable(DT::datatable(selection()))
  output$rawtable = DT::renderDataTable(DT::datatable(mining) %>%
                                         formatCurrency("MarketCap", "$", digits=0) %>%
                                         formatStyle("Symbol", color = "grey") %>%
                                         formatStyle(c("G3", "G2", "G1"), backgroundColor = "lightblue")   
                                         )
  
  output$my_mining_download = downloadHandler(filename="my_mining_selection.csv",
                                              content = function(file) {
                                                write.csv(selection(), file)
                                              })
  output$full_mining_download = downloadHandler(filename="full_mining_table.csv",
                                                content = function(file){
                                                write.csv(mining, file)  
                                                })
}

##########----------------
# UI
##########----------------

ui = navbarPage(theme = shinytheme("slate"), title = h2("Mining companies stocks"),
                 tabPanel(
                   ("Stocks values explorer App"),
                 wellPanel(
                     sliderInput(inputId = "WG1", label = "Weight on Grade 1", value = 8, min = 0 , max = 20),
                                   
                     sliderInput(inputId = "WG2", label = "Weight on Grade 2", value = 8, min = 0 , max = 20),
                                   
                     sliderInput(inputId = "WG3", label = "Weight on Grade 3", value = 2.4, min = 0 , max = 6, step = 0.2)
                  ),
                  plotOutput("plot", brush = "user_brush"),
                  DT::dataTableOutput("selectedtable"),
                  downloadButton(outputId = "my_mining_download", label = "Download Table")
                 ),
                                             
                 tabPanel("Documentation",
                          h4("Documentation sourced from Youtube"),
                          tags$iframe(style="height:900px, width:900px",
                                      src="https://www.youtube.com/embed/vySGuusQI3Y")
                          
                        ),
                           
                 tabPanel("Raw Data Table",
                                    DT::dataTableOutput("rawtable"),
                                    downloadButton(outputId = "full_mining_download", label = "Download Full Table")
                        )
                
                          
                )


shinyApp(ui = ui, server = server)