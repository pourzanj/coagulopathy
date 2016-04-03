library(shiny)
library(ggplot2)

# load dataset
load("../../../data/traumaAd.Rdata")
#load("../../../data/traumaChartEvents.Rdata")
load("../../../data/traumaChartsMini.Rdata")
load("../../../data/dItems.Rdata")

# Define a server for the Shiny app
shinyServer(function(input, output,session) {
  
  # Filter data based on selections
  output$mainTable <- DT::renderDataTable({
    DT::datatable(traumaAdmissions,selection='single')
  },server=FALSE)

  #whole chart for patient
  chartEvents <- eventReactive(input$mainTable_row_last_clicked, {
    rowIndex <- input$mainTable_row_last_clicked
    id <- traumaAdmissions[rowIndex,] %>%
      select(subject_id,hadm_id)
    traumaChartsMini %>%
      filter(subject_id==id$subject_id, hadm_id==id$hadm_id)
  })
  
  #number of events recorded for each chart item
  chartEventsSummary <- reactive({
      chartEvents()  %>%
      group_by(itemid) %>%
      summarize(numEvents=n()) %>%
      inner_join(dItems) %>%
      select(label,numEvents) %>%
      arrange(desc(numEvents))
  })
  
  observe({
    sum <- chartEventsSummary()
    labels <- sum$label
    numEventsStr <- paste0("(",sum$numEvents,")")
    
    chartVarStr <- paste0(labels,numEventsStr)
    
    updateCheckboxGroupInput(session,'chartVars',choices=chartVarStr)
    updateCheckboxGroupInput(session,'labVars',choices=chartVarStr)
    updateCheckboxGroupInput(session,'outputVars',choices=chartVarStr)
    updateCheckboxGroupInput(session,'inputVars',choices=chartVarStr)
  })
  
  output$main <- renderPrint({ "foo" })

  
})