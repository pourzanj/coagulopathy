library(shiny)

# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel("MIMIC Patient Viewer"),
    
    #filter patients table
    fluidRow(
      column(4,
             selectInput("mortality",
                         "Mortality Status:",
                         c("All","Died","Survived")
                         )
      )
    ),
    
    # create new for for table
    fluidRow(
      DT::dataTableOutput("mainTable")
    ),
    
    sidebarLayout(
      # get patient chart vars
      sidebarPanel(
        conditionalPanel(
          condition = 'input.mainTable_row_last_clicked != null',
          style = "overflow-y:scroll; max-height: 180px",
          checkboxGroupInput('chartVars', 'Chart Vars To Plot:',c(""))
        ),
        conditionalPanel(
            condition = 'input.mainTable_row_last_clicked != null',
            style = "overflow-y:scroll; max-height: 180px",
            checkboxGroupInput('labVars', 'Lab Vars To Plot:',c(""))
        ),
        conditionalPanel(
            condition = 'input.mainTable_row_last_clicked != null',
            style = "overflow-y:scroll; max-height: 180px",
            checkboxGroupInput('outputVars', 'Output Vars To Plot:',c(""))
        ),
        conditionalPanel(
            condition = 'input.mainTable_row_last_clicked != null',
            style = "overflow-y:scroll; max-height: 180px",
            checkboxGroupInput('inputVars', 'Input Vars To Plot:',c(""))
        ),
        width=2
      ),
      mainPanel(
        verbatimTextOutput('plot will go here')
      )
    )
    
    

  )
)