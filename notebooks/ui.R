library(shiny)
library(reticulate)
library(DT)
library(googleCharts)

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
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?",
                "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
             "body {font-family: 'Source Sans Pro'}"
  ),
  
  googleChartsInit(),
  titlePanel('Actions that Lead to Increases in High School Graduations'),
  sidebarLayout(
    sidebarPanel(
      selectInput('State', 'Which State?', choices = unique(nums['State']), multiple=FALSE),
      uiOutput('District'),
      uiOutput('High_School'),
      actionButton("submit", label = "Submit")
    ),
    mainPanel(
      DT::dataTableOutput('df_data_out'),
      googleBubbleChart("gradPlot",
                        width="100%", height = "475px",
                        # Set the default options for this chart; they can be
                        # overridden in server.R on a per-update basis. See
                        # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                        # for option documentation.
                        options = list(
                          fontName = "Source Sans Pro",
                          fontSize = 13,
                          # Set axis labels and ranges
                          hAxis = list(
                            title = "Chronic Absenteeism Rate",
                            viewWindow = xlim
                          ),
                          vAxis = list(
                            title = "Sports Participation Rate",
                            viewWindow = ylim
                          ),
                          # The default padding is a little too spaced out
                          chartArea = list(
                            top = 50, left = 75,
                            height = "75%", width = "75%"
                          ),
                          # Allow pan/zoom
                          explorer = list(),
                          # Set bubble visual props
                          bubble = list(
                            opacity = 0.4, stroke = "none",
                            # Hide bubble label
                            textStyle = list(
                              color = "none"
                            )
                          ),
                          # Set fonts
                          titleTextStyle = list(
                            fontSize = 16
                          ),
                          tooltip = list(
                            textStyle = list(
                              fontSize = 12
                            )
                          )
                        )
      )
    )
  )
))
