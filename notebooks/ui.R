#----------------------------------------------------------
# This ui uses the Shiny Fluid Page for the layout and Google BubbleChart and Gauge for visualizations of
# each high school.
#---------------------------------------------------------

library(shiny)
library(reticulate)
library(DT)
library(googleVis)
library(stringr)

nums <- read.csv("grad_num2.csv")

nums <- subset(nums, Chronic_Absent_Rate <= 1)

ylim <- list(
  min = min(nums$Sports_Participant_Rate, na.rm = TRUE),
  max = max(nums$Sports_Participant_Rate, na.rm = TRUE) + 0.25
)

xlim <- list(
  min = min(nums$Chronic_Absent_Rate, na.rm = TRUE),
  max = max(nums$Chronic_Absent_Rate, na.rm = TRUE) + 0.25
)

ui <- fluidPage(
  # Use the Google webfont "Source Sans Pro"
  # tags$link(
  #   href=paste0("http://fonts.googleapis.com/css?",
  #               "family=Source+Sans+Pro:300,600,300italic"),
  #   rel="stylesheet", type="text/css"),
  # tags$style(type="text/css",
  #            "body {font-family: 'Source Sans Pro'}"
  # ),
  titlePanel(HTML("<h1><center><font size=14> What affects school graduation rates? </font></center></h1>")),
  
  fluidRow(column(3,
                  selectInput('State', 'Which State?', choices = unique(nums['State']), multiple=FALSE),
                  uiOutput('District'),
                  uiOutput('High_School'),
                  actionButton("submit", label = "Submit"),
                  br(),
                  br(),
                  DT::dataTableOutput('df_data_out')
  ),
  
  column(9,
         # Absenteeism
         fluidRow(
           column(width=3,
                  htmlOutput("absentGauge")
           ),
           column(width=9,
                  uiOutput("absentText")
           )
         ),
         
         # Athletics
         fluidRow(
           column(width=3,
                  htmlOutput("athleteGauge")
           ),
           column(width=9,
                  uiOutput("athleteText")
           )
         ),
         
         # Suspension Days
         fluidRow(
           column(width=3,
                  htmlOutput("suspendGauge")
           ),
           column(width=9,
                  uiOutput("suspendText")
           )
         ),
         
         # Non-certified teachers
         fluidRow(
           column(width=3,
                  htmlOutput("nonCertGauge")
           ),
           column(width=9,
                  uiOutput("nonCertText")
           )
         ),
         
         htmlOutput("gradPlot")
  )
  )
)