import("shiny")
import("shinyjs")
import("shiny.fluent")

export("ui", "init_server")

utils <- use("utils/utils.R")

gameOver <- use("modules/gameOver.R")
gameStart <- use("modules/gameStart.R")

GridManager <- use("logic/GridManager.R")$GridManager
ObjectsManager <- use("logic/ObjectsManager.R")$ObjectsManager

ui <- function(id) {
  ns <- NS(id)
  tagList(
    gameStart$ui(ns("gameStart")),
    uiOutput(ns("grid")),
    gameOver$ui(ns("gameOver"))
  )
}

init_server <- function(id, consts) {
  callModule(server, id, consts)
}

server <- function(input, output, session, consts) {
  ns <- session$ns
  
  # PREPARE GRID ----
  GridManager <- GridManager$new()
  ObjectsManager <- ObjectsManager$new()
  
  output$grid <- renderUI({
    GridManager$grid
  })
  
  # START GAME ----
  session$userData$isStartModalOpen <- reactiveVal(TRUE)
  gameStart$init_server("gameStart", ObjectsManager, consts)
  
  observeEvent(input$level, {
    req(input$level != "clean")
    session$userData$isStartModalOpen(FALSE)
    session$userData$level <- input$level
    ObjectsManager$place_objects(input$level)
    shinyjs::runjs("cleanObject('level');")
  })
  
  # MOVE OBJECTS ----
  observeEvent(input$diver_direction, {
    req(input$diver_direction != "clean")
    ObjectsManager$move_object("diver", input$diver_direction)
    
    if(ObjectsManager$check_shark_bite()) {
      session$userData$isBiteModalOpen(TRUE)
    }
    
    ObjectsManager$check_collect()
    if(ObjectsManager$check_success()) {
      session$userData$isChestModalOpen(TRUE)
    }
    
    shinyjs::runjs("cleanObject('diver_direction');")
  })
  
  observeEvent(input$shark_direction, {
    req(input$shark_direction != "clean")
    ObjectsManager$move_object("shark", input$shark_direction)
    
    if(ObjectsManager$check_shark_bite()) {
      session$userData$isBiteModalOpen(TRUE)
    }
    
    shinyjs::runjs("cleanObject('shark_direction');")
  })
  
  # GAME OVER ----
  # TODO modify to one reactiveValues
  session$userData$isBiteModalOpen <- reactiveVal(FALSE)
  session$userData$isChestModalOpen <- reactiveVal(FALSE)
  
  gameOver$init_server("gameOver", ObjectsManager, consts)
  
}
