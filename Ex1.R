####################
# WD
####################

wd <- getwd()
setwd(wd)

###################
# Libraries
###################
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")
library(shiny)
library(shinythemes)
save.image(file='udemyshiny.R')

#######################
# Creating Input Widgets
#######################

server <- function(input,output, session) {
  }

ui <-   basicPage(
  h1("Using textInput and checkboxInput"),
  textAreaInput("mystring", "Write here", resize = NULL ),
  checkboxInput("mycheckbox", "Factor Y")
)

shinyApp(ui = ui, server = server)

###########################
# Making the app reactive
###########################

server <- function(input, output, session) {
  observe({
    addtext <- paste("your initial input:", input$mystring)
    updateTextInput(session, "mystring2", value=addtext)
  })
  }

ui <-   basicPage(
  h1("Using Observe"),
  textInput("mystring", "Write here"),
  textInput("mystring2", "Full App Output")
)

shinyApp(ui = ui, server = server)


#######################
# Reactive and render in one app
#######################

server <- function(input, output, session) {
 
  data <- reactive({
     (rnorm(50) * input$myslider) / input$myvalue
  })
 
  output$plot <- renderPlot({
    plot(data(), col = "red", pch = 21, bty = "n")
  })
}

ui <- basicPage(
  h1("Using Reactive"),
  sliderInput(inputId = "myslider",
              label = "Slider1",
              value = 1, min = 1, max = 20),
  numericInput("myvalue", label = "Valeur division", value = 1),
  plotOutput("plot")
)

shinyApp(ui = ui, server = server)

########################
## Layouting - basic sidebar layout
#########################

server <- function(input, output, session) {}

ui <- fluidPage(
 
  sidebarLayout(
    
    sidebarPanel(
      "my sidebar"
    ),
    
    mainPanel(
      "my mainpanel"
    )
  )
)

shinyApp(ui = ui, server = server)

#########################
# Layouting - tabsets
#########################

server <- function(input, output, session) {}

ui <- fluidPage(
 
  titlePanel("using Tabsets"), # our title
 
  sidebarLayout(
    
    sidebarPanel(
      sliderInput(inputId = "s1",
                  label = "My Slider",
                  value = 1, min = 1, max = 20)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Tab1", "First Tab"),
        tabPanel("Tab2", "Second Tab"),
        tabPanel("Tab3", "Third Tab")
      )
    )
  )
)

shinyApp(ui = ui, server = server)

####

names(tags)

####
###############################
## Tags - HTML
###############################

server <- function(input, output, session) {}

ui <- fluidPage(
 
  titlePanel(tags$strong("This is the STRONG tag on the Title")), # using strong as a direct tag
 
  sidebarLayout(
    
    sidebarPanel(
      withTags(
      div(
        b("bold text: here you see a line break, a horizontal line and some code"),
          br(),
          hr(),
      code("plot(lynx)")
    ))),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Weblinks with direct tag a", a(href="www.r-tutorials.com", "r-tutorials")),
        tabPanel(tags$b("Using b for bold text"), tags$b("a bold text")),
        tabPanel("Citations with the blockquote tag", tags$blockquote("R is Great", cite = "R Programmer"))
      )
    )
))

shinyApp(ui = ui, server = server)


################################
# Changing the themes
################################

server <- function(input, output, session) {}

library(shinythemes) # adding the shinythemese package

ui <- fluidPage(theme=shinytheme("slate"), # displaying the different themes, replace this line when publishing with theme = shinytheme("darkly")
 
  titlePanel(strong("This is the STRONG tag on the Title")), # using strong as a direct tag
 
  sidebarLayout(
    
    sidebarPanel(
      withTags(
        div(
          b("bold text: here you see a line break, a horizontal line and some code"),
          br(),
          hr(),
          code("plot(lynx)")
        ))),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Weblinks with direct tag a", a(href="www.r-tutorials.com", "r-tutorials")),
        tabPanel(tags$b("Using b for bold text"), tags$b("a bold text")),
        tabPanel("Citations with the blockquote tag", tags$blockquote("R is Great", cite = "R Programmer"))
      )
    )
  ))

shinyApp(ui = ui, server = server)