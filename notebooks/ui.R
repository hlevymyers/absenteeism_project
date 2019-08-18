library(shiny)
library(reticulate)
library(DT)
library(googleVis)
library(stringr)

nums <- read.csv("/Users/flatironschool/Absenteeism_Project/notebooks/grad_num2.csv")

nums <- subset(nums, Chronic_Absent_Rate <= 1)

ylim <- list(
  min = min(nums$Sports_Participant_Rate, na.rm = TRUE),
  max = max(nums$Sports_Participant_Rate, na.rm = TRUE) + 0.25
)

xlim <- list(
  min = min(nums$Chronic_Absent_Rate, na.rm = TRUE),
  max = max(nums$Chronic_Absent_Rate, na.rm = TRUE) + 0.25
)

shinyUI(fluidPage(
  # Use the Google webfont "Source Sans Pro"
  # tags$link(
  #   href=paste0("http://fonts.googleapis.com/css?",
  #               "family=Source+Sans+Pro:300,600,300italic"),
  #   rel="stylesheet", type="text/css"),
  # tags$style(type="text/css",
  #            "body {font-family: 'Source Sans Pro'}"
  # ),
 
  fluidRow(
    column(3,
           selectInput('State', 'Which State?', choices = unique(nums['State']), multiple=FALSE),
           uiOutput('District'),
           #uiOutput('High_School'),
           # actionButton("submit", label = "Submit"),
           # br(),
           # br(),
           # DT::dataTableOutput('df_data_out')),
    )
    # column(9,
    #        fluidRow(
    #          column(width=2, 
    #                 htmlOutput("absentGauge")
    #          ),
    #          column(width=10,
    #                 uiOutput("absentText")
    #          )
    #        )
    # )
  ) 
      
      # #htmlOutput("absentGauge"),
  
      # uiOutput("athleteText"),
      # htmlOutput("athleteGauge"),
      # uiOutput("suspendText"),
      # htmlOutput("suspendGauge"),
      # uiOutput("nonCertText"),
      # htmlOutput("nonCertGauge"),
      # htmlOutput("gradPlot")
))
