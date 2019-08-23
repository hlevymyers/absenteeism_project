# -------------------------------------------------
# The server.R builds out the dashboard for each high school and includes the state, district, name, enrollment,
# graduation, chronic absenteeism, and sports participation rate, number of teachers that are non-certified, and
# number of days missed to suspensions as reported to the US Department of Education. The dashboard also shows
# if a school wanted to achieve a higher or better graduation rate what would those rates look like for a 
# school with their enrollment. The gauges show a green improvement range and where the dial where the school
# is currently. There is also a bubble chart showing each state and how all the schools in the state perform.
# ------------------------------------------------
library(shiny)
library(reticulate)
library(DT)
library(dplyr)
library(googleVis)
library(stringr)
library(reshape2)

shinyServer(function(input, output, session) {
  
  nums <- read.csv("grad_num2.csv")
  random_vals <- reactiveValues(df_data = NULL)
  

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
      select(State, District, grad_rate_bin, Chronic_Absent_Rate, Sports_Participant_Rate, Total_Enrollment, 
             High_School, Number_of_Chronically_Absent_Students, Number_of_Student_Athletes, 
             Number_of_Days_Missed_to_Suspensions, Number_of_Non_Certified_Teachers, Level_Up_Graduation_Rate, 
             Level_Up_25th_Percentile_Number_Chronic_Absent_Students, Level_Up_75th_Percentile_Number_Chronic_Absent_Students,
             Level_Up_25th_Percentile_Student_Athletes,Level_Up_75th_Percentile_Student_Athletes,
             Level_Up_25th_Percentile_Days_Missed_due_to_Suspension, Level_Up_75th_Percentile_Days_Missed_due_to_Suspension, 
             Level_Up_25th_Percentile_Non_Certified_Teachers, 
             Level_up_75th_Percentile_Non_Certified_Teachers, Number_of_Total_Teachers) %>% arrange(grad_rate_bin)
    gaugeFrame <- countyFrame
    gaugeFrame <- gaugeFrame %>% filter(gaugeFrame$High_School == input$High_School_dynamic)
    gaugeFrame <- gaugeFrame %>% select(-c(State, District, grad_rate_bin, Chronic_Absent_Rate, 
                                           Sports_Participant_Rate, Level_Up_Graduation_Rate))
    gaugeFrame <- melt(gaugeFrame, id.vars=c("High_School"))
    gaugeFrame$value <- as.numeric(gaugeFrame$value)
    gaugeFrame <- gaugeFrame %>% rename(Label = variable, Value = value)
    gaugeFrame <- gaugeFrame %>% select(Label, Value)
  
    global_val$gaugeFrame <- gaugeFrame
    
    countyFrame$High_School <- paste0(countyFrame$High_School, " (", countyFrame$District, ")")
    countyFrame <- countyFrame %>% select(High_School, Chronic_Absent_Rate, Sports_Participant_Rate, grad_rate_bin, Total_Enrollment)
    countyFrame <- countyFrame %>% rename(Grad_Rate = grad_rate_bin)
    countyFrame$High_School <- as.factor(countyFrame$High_School)
    countyFrame$Grad_Rate <- str_replace_all(countyFrame$Grad_Rate, "100%", "~100%")
    countyFrame <- countyFrame[order(countyFrame$Grad_Rate), ]
    countyFrame$Grad_Rate <- factor(countyFrame$Grad_Rate, levels = c("0-59%", "60-79%", "80-89%", "90-99%", "~100%"))
    countyFrame$Grad_Rate <- as.factor(countyFrame$Grad_Rate)
    global_val$countyFrame <- countyFrame
  })
  
 
  # })
  observeEvent(input$submit, {
    output$gradPlot <- renderGvis({
      gvisBubbleChart(global_val$countyFrame, idvar="High_School", 
                      xvar="Chronic_Absent_Rate", yvar="Sports_Participant_Rate", 
                      colorvar="Grad_Rate", sizevar="Total_Enrollment",
                      options=list(width="100%", height = "550px",
                                   title = paste0("How Sports Participation and Chronic Absenteeism Influence Graduation Rates", 
                                                  "\n", "(School Year 2015-16)", ' - ', input$State),
                                   hAxis='{minValue:-.2, maxValue:1.2, title:"Chronic Absenteeism Rate"}',
                                   vAxis='{minValue:-.2, maxValue:1, title:"Sports Participation Rate"}',
                                   bubble="{textStyle:{color:'transparent'}}",
                                   series = "{'~100%': {color:'#37afa9'},
                                   '90-99%': {color:'#0c695d'},
                                   '80-89%': {color:'#febc38'},
                                   '60-79%': {color:'#da5526'},
                                   '0-59%': {color:'#a11e22'}}"))

    })
  })
#------------------------------------------------
#Gauge Frames
#------------------------------------------------
  #Gauge of Chronic absenteeism
  observeEvent(input$submit, {
    gauge_absent <- global_val$gaugeFrame
    total_enrollment <- gauge_absent$Value[which(gauge_absent$Label == 'Total_Enrollment')]
    lower_green <- gauge_absent$Value[which(gauge_absent$Label == 'Level_Up_25th_Percentile_Number_Chronic_Absent_Students')]
    upper_green <- gauge_absent$Value[which(gauge_absent$Label == 'Level_Up_75th_Percentile_Number_Chronic_Absent_Students')]
    gauge_absent <- gauge_absent[gauge_absent$Label == 'Number_of_Chronically_Absent_Students', ]
    gauge_absent$Label <- as.character(gauge_absent$Label)
    gauge_absent$Label <- str_replace(gauge_absent$Label, 'Number_of_Chronically_Absent_Students', 
                                      "Absenteeism")
   
    output$absentText <- renderUI({
      HTML(paste0("<p style= 'font-size:18px'>", "This high school reported ", "<b>", gauge_absent$Value, "</b>", 
                  " chronically absent students out of a total student enrollment of ",
                  "<b>", total_enrollment, "</b>", " students. Chronic absenteeism is defined here in this US Department of Education dataset as 
                  missing at least 15 days of school for any reason, excused or unexcused. Chronic absenteeism is often associated with lower graduation rates.",
                  "<br>", 
                  "<br>",
                  "Schools that had the next-level up or better graduation rates reported the number of chronically absent students ranged from ", 
                  "<b>", round(lower_green, digits=0), "</b>", " to ", "<b>", upper_green, "</b>", " students.", "</p>"))
    })
    
    output$absentGauge <- renderGvis({
      gvisGauge(gauge_absent,
                options = list(
                  min = 0,
                  max = total_enrollment,
                  width = 200,
                  height = 200, 
                  greenFrom = lower_green, 
                  greenTo = upper_green
                )
                )
    })
  })
  
  #Gauge of Student Athletic participation
  observeEvent(input$submit, {
    gauge_athlete <- global_val$gaugeFrame
    total_enrollment <- gauge_athlete$Value[which(gauge_athlete$Label == 'Total_Enrollment')]
    lower_green <- gauge_athlete$Value[which(gauge_athlete$Label == 'Level_Up_25th_Percentile_Student_Athletes')]
    upper_green <- gauge_athlete$Value[which(gauge_athlete$Label == 'Level_Up_75th_Percentile_Student_Athletes')]
    gauge_athlete <- gauge_athlete[gauge_athlete$Label == 'Number_of_Student_Athletes', ]
    gauge_athlete$Label <- as.character(gauge_athlete$Label)
    gauge_athlete$Label <- str_replace(gauge_athlete$Label, 'Number_of_Student_Athletes', 
                                      "Athletes")
    
    output$athleteText <- renderUI({
      HTML(paste0("<p style= 'font-size:18px'>", "This high school reported ", "<b>", gauge_athlete$Value, "</b>", 
                  " student athletes out of a total student enrollment of ",
                  "<b>", total_enrollment, "</b>", " students. Students participating in team sports are often more engaged in school and 
                  have better attendance. Because of multiple sports seasons, some schools may report individual students multiple times. 
                  More student athletes is often associated with higher graduation rates.",
                  "<br>", 
                  "<br>",
                  "Schools that had the next-level up or better graduation rates reported the number of student athletes ranged from ", 
                  "<b>", round(lower_green, digits=0), "</b>", " to ", "<b>", upper_green, "</b>", " students.", "</p>"))
    })
    
    output$athleteGauge <- renderGvis({
      gvisGauge(gauge_athlete,
                options = list(
                  min = 0,
                  max = total_enrollment,
                  width = 200,
                  height = 200, 
                  greenFrom = lower_green, 
                  greenTo = upper_green
                )
      )
    })
  })

  #This is the gauge of non-certified teachers.  
  observeEvent(input$submit, {
    gauge_nonCert <- global_val$gaugeFrame
    print(gauge_nonCert$Label)
    print(gauge_nonCert$Value)
    total_teachers <- gauge_nonCert$Value[which(gauge_nonCert$Label == 'Number_of_Total_Teachers')]
    lower_green <- gauge_nonCert$Value[which(gauge_nonCert$Label == 'Level_Up_25th_Percentile_Non_Certified_Teachers')]
    upper_green <- gauge_nonCert$Value[which(gauge_nonCert$Label == 'Level_up_75th_Percentile_Non_Certified_Teachers')]
    gauge_nonCert <- gauge_nonCert[gauge_nonCert$Label == 'Number_of_Non_Certified_Teachers', ]
    gauge_nonCert$Label <- as.character(gauge_nonCert$Label)
    gauge_nonCert$Label <- str_replace(gauge_nonCert$Label, 'Number_of_Non_Certified_Teachers', 
                                      "Non-Certifications")
    str(gauge_nonCert)
    
    output$nonCertText <- renderUI({
      HTML(paste0("<p style= 'font-size:18px'>", "This high school reported ", "<b>", gauge_nonCert$Value, "</b>", " non-certified teachers out of a total of ",
            "<b>", total_teachers, "</b>", " teachers. Non-certified teachers often teach required classes for graduation, having
             more non-certified teachers is often associated with lower graduation rates.", "<br>", 
            "<br>",
            "Schools that had the next-level up or better graduation rates reported a range of non-certified teachers from ", 
            "<b>", lower_green, "</b>", " to ", "<b>", upper_green, "</b>", " teachers.", "</p>"))
    })
    
    output$nonCertGauge <- renderGvis({
      gvisGauge(gauge_nonCert,
                options = list(
                  min = 0,
                  max = total_teachers,
                  width = 200,
                  height = 200,
                  greenFrom = lower_green, 
                  greenTo = upper_green
                )
      )
    })
  })
  
  #Gauge of number of days missed to suspensions
  observeEvent(input$submit, {
    gauge_suspend <- global_val$gaugeFrame
    total_enrollment <- gauge_suspend$Value[which(gauge_suspend$Label == 'Total_Enrollment')]
    lower_green <- gauge_suspend$Value[which(gauge_suspend$Label == 'Level_Up_25th_Percentile_Days_Missed_due_to_Suspension')]
    upper_green <- gauge_suspend$Value[which(gauge_suspend$Label == 'Level_Up_75th_Percentile_Days_Missed_due_to_Suspension')]
    gauge_suspend <- gauge_suspend[gauge_suspend$Label == 'Number_of_Days_Missed_to_Suspensions', ]
    gauge_suspend$Label <- as.character(gauge_suspend$Label)
    gauge_suspend$Label <- str_replace(gauge_suspend$Label, 'Number_of_Days_Missed_to_Suspensions', 
                                       "Suspensions")
    output$suspendText <- renderUI({
      HTML(paste0("<p style= 'font-size:18px'>", "This high school reported the total number of days missed to suspensions was ", "<b>", gauge_suspend$Value, "</b>", " days. ",
                  "Missing days of school for any reason, including suspensions, is often associated with lower graduation rates.",
                  "<br>", 
                  "<br>",
                  "Schools that had the next-level up or better graduation rates reported a range of days missed to suspensions from ", 
                  "<b>", lower_green, "</b>", " to ", "<b>", upper_green, "</b>", " days.", "</p>"))
    }) 
    
    output$suspendGauge <- renderGvis({
      gvisGauge(gauge_suspend,
                options = list(
                  min = 0,
                  max = total_enrollment,
                  width = 200,
                  height = 200, 
                  greenFrom = lower_green, 
                  greenTo = upper_green
                )
      )
      
    })
  })
  output$df_data_out <- renderDataTable(random_vals$df_data)
})