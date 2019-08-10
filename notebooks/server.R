library(shiny)
library(reticulate)
library(DT)
library(googleCharts)
library(dplyr)

shinyServer(function(input, output, session) {
  
  nums <- read.csv("/Users/flatironschool/Absenteeism_Project/notebooks/grad_num2.csv")
  random_vals <- reactiveValues(df_data = NULL)
  bins_colors <- c("#a11e22", "#da5526", "#febc38", "#0c695d", "#37afa9")
  
  # Color palette for bins
  # series <- structure(
  #   lapply(bins_colors, function(color) {list(color=color)}),
  #   names=levels(c("0-59%", "60-79%", "80-89%", "90-99%", "100%"))
  # )
  
  series <- structure(
    lapply(bins_colors, function(color) { list(color=color) }),
    names = levels(nums$grad_rate_bin)
  )
  
  output$District <- renderUI({
    selectInput('District_dynamic', 'Which School District?', 
                choices = nums[nums$State == input$State, 'District'])
  })
  
  output$High_School <- renderUI({
    selectInput('High_School_dynamic', 'Which High School?', 
                choices = nums[(nums$State == input$State) & (nums$District == input$District_dynamic), 'High_School'])
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
  
  global_val <- reactiveValues(countryFrame = NULL)
  
  observeEvent(input$submit, {
    countyFrame <- nums %>% filter((nums$State == input$State)) %>% 
      select(State, grad_rate_bin, Chronic_Absent_Rate, Sports_Participant_Rate) %>% arrange(grad_rate_bin)
      # select(State, District, High_School, Graduation_Rate_2015_16, Total_Enrollment, grad_rate_bin,
      #        Number_of_Chronically_Absent_Students, Number_of_Student_Athletes, Chronic_Absent_Rate, 
      #        Sports_Participant_Rate) %>%
      
    
    countyFrame <- countyFrame %>% select(grad_rate_bin, Chronic_Absent_Rate, Sports_Participant_Rate, everything())
    str(countyFrame)
    global_val$countyFrame <- countyFrame
  })
  
  
  # countyData <- reactive({
  #   countyFrame <- nums %>% filter((nums$State == input$State)) %>% 
  #     select('State', 'District', 'High_School', 'Graduation_Rate_2015_16', 'Total_Enrollment', 'grad_rate_bin',
  #            'Number_of_Chronically_Absent_Students', 'Number_of_Student_Athletes', 'Chronic_Absent_Rate', 'Sports_Participant_Rate')
  #   return(countyFrame)
  # })
  
  observeEvent(input$submit, {
    output$gradPlot <- reactive({
      list(
        data = googleDataTable(global_val$countyFrame),
        options = list(
          title = sprintf("How Sports Participation and Chronic Absenteeism Influence Graduation Rates (School Year 2015-16)"),
          series = series
        )
      )
    })
  })
  
  # observeEvent(input$submit, {
  #   print("button clicked")
  #   output$gradPlot <- reactive({
  #     list(
  #       data = googleDataTable(countyData()),
  #       options = list(
  #         title = sprintf("How Sports Participation and Chronic Absenteeism Influence Graduation Rates (School Year 2015-16)"),
  #         series = series
  #       )
  #     )
  #   })
  # })
  #     
  output$df_data_out <- renderDataTable(random_vals$df_data)
})

shinyApp(ui = ui, server = server)
