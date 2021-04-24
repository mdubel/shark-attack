import("shiny")
import("shinyjs")

export("ui", "init_server")

utils <- use("utils/utils.R")
GridManager <- use("logic/GridManager.R")$GridManager
ObjectsManager <- use("logic/ObjectsManager.R")$ObjectsManager

ui <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(ns("ala"), "Click"),
  uiOutput(ns("grid"))
  )
}

init_server <- function(id, dataset) {
   callModule(server, id, dataset)
}

server <- function(input, output, session, dataset) {
  ns <- session$ns
  
  GridManager <- GridManager$new()
  ObjectsManager <- ObjectsManager$new()
  
  output$grid <- renderUI({
    GridManager$grid
  })
  
  observeEvent(input$ala, {
    ObjectsManager$place_objects()
  })
  
  observeEvent(input$move_direction, {
    req(input$move_direction != "clean")
    ObjectsManager$move_object("diver", input$move_direction)
    shinyjs::runjs("cleanKey();")
  })
    
}
