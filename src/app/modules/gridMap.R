import("shiny")
import("shinyjs")
import("shiny.fluent")

export("ui", "init_server")

utils <- use("utils/utils.R")

gameOver <- use("modules/gameOver.R")

GridManager <- use("logic/GridManager.R")$GridManager
ObjectsManager <- use("logic/ObjectsManager.R")$ObjectsManager

ui <- function(id) {
  ns <- NS(id)
  tagList(
    actionButton(ns("ala"), "Click"),
    uiOutput(ns("grid")),
    gameOver$ui(ns("gameOver"))
  )
}

init_server <- function(id, dataset) {
  callModule(server, id, dataset)
}

server <- function(input, output, session, dataset) {
  ns <- session$ns
  
  # PREPARE GRID ----
  GridManager <- GridManager$new()
  ObjectsManager <- ObjectsManager$new()
  
  output$grid <- renderUI({
    GridManager$grid
  })
  
  # START GAME ----
  observeEvent(input$ala, {
    ObjectsManager$place_objects()
  })
  
  # MOVE OBJECTS ----
  observeEvent(input$diver_direction, {
    req(input$diver_direction != "clean")
    ObjectsManager$move_object("diver", input$diver_direction)
    shinyjs::runjs("cleanObject('diver');")
  })
  
  observeEvent(input$shark_direction, {
    req(input$shark_direction != "clean")
    ObjectsManager$move_object("shark", input$shark_direction)
    
    if(ObjectsManager$check_shark_bite()) {
      session$userData$isBiteModalOpen(TRUE)
    }
    
    shinyjs::runjs("cleanObject('shark');")
  })
  
  # GAME OVER ----
  session$userData$isBiteModalOpen <- reactiveVal(FALSE)
  session$userData$isChestModalOpen <- reactiveVal(FALSE)
  
  gameOver$init_server("gameOver", ObjectsManager)
  
}
