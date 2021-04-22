import("shiny")

export("ui", "init_server")

utils <- use("utils/utils.R")
GridManager <- use("logic/GridManager.R")$GridManager

ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("grid"))
}

init_server <- function(id, dataset) {
   callModule(server, id, dataset)
}

server <- function(input, output, session, dataset) {
  ns <- session$ns
  
  GridManager <- GridManager$new()
  
  output$grid <- renderUI({
    GridManager$grid
  })
    
}