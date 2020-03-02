#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

pr <- readRDS("../pr.RDS")
library(DT)



ui <- basicPage(
  h2("SeqDB View"),
  DT::dataTableOutput("mytable")
)

server <- function(input, output) {
  output$mytable = DT::renderDataTable({
    pr
  })
}

shinyApp(ui, server)