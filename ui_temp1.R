library(shiny)
library(reticulate)
library(DT)
library(googleCharts)

nums = read.csv("/Users/flatironschool/Absenteeism_Project/notebooks/grad_num.csv")

shinyUI(fluidPage(
  googleChartsInit(),
  titlePanel('Actions that Lead to Increases in High School Graduations'),
  sidebarLayout(
    sidebarPanel(
      selectInput('State', 'Which State?', choices = unique(nums['State']), multiple=FALSE),
      uiOutput('District'),
      uiOutput('High_School'),
      actionButton("submit", label = "Submit")
    )
  ),
  
  mainPanel(
    DT::dataTableOutput('df_data_out'),
    googleBubbleChart("gradPlot", width = "100%", height = "475px")
  )
))
