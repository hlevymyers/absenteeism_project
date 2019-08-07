library(shiny)
library(reticulate)
library(DT)

nums = read.csv("/Users/flatironschool/Absenteeism_Project/notebooks/grad_num.csv")

ui <- pageWithSidebar(
      headerPanel('Actions that Lead to Increases in High School Graduations'),
      sidebarPanel(
        
        selectInput('State', 'Which State?', choices = unique(nums['State']), multiple=FALSE),
        uiOutput('District'),
        uiOutput('High_School'),
        actionButton("submit", label = "Submit")
      ),
      mainPanel(
        DT::dataTableOutput('df_data_out')
      )
    )

# Define server logic for inputs ----
server <- function(input, output) {
    nums = read.csv("/Users/flatironschool/Absenteeism_Project/notebooks/grad_num.csv")
    random_vals <- reactiveValues(df_data = NULL)
   
    output$District <- renderUI({
        selectInput('District_dynamic', 'Which School District?', choices = nums[nums$State == input$State, 'District'])
    })
    
    output$High_School <- renderUI({
        selectInput('High_School_dynamic', 'Which High School?', choices = nums[(nums$State == input$State) & (nums$District == input$District_dynamic), 'High_School'])
    })
    
 observeEvent(input$submit, {
    random_vals$df_data <- DT::datatable(t(nums[(nums$State == input$State) & (nums$District == input$District_dynamic) & (nums$High_School == input$High_School_dynamic), 
                                       c('State', 'District', 'High_School', 'Graduation_Rate_2015_16', 'Total_Enrollment', 'Number_of_Chronically_Absent_Students', 
                                         'Number_of_Student_Athletes', 'Number_of_Days_Missed_to_Suspensions', 'Number_of_Non_Certified_Teachers', 'Level_Up_Graduation_Rate', 
                                         'Level_Up_25th_Percentile_Number_Chronic_Absent_Students','Level_Up_75th_Percentile_Number_Chronic_Absent_Students',
                                         'Level_Up_25th_Percentile_Student_Athletes','Level_Up_75th_Percentile_Student_Athletes','Level_Up_25th_Percentile_Days_Missed_due_to_Suspension',
                                         'Level_Up_75th_Percentile_Days_Missed_due_to_Suspension', 'Level_Up_25th_Percentile_Non_Certified_Teachers', 
                                         'Level_up_75th_Percentile_Non_Certified_Teachers')]))
})
    
 output$df_data_out <- renderDataTable(random_vals$df_data)
}

shinyApp(ui = ui, server = server)
