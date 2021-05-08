server <- function(input, output, session) {

  # PREPARE GRID ----
  GridManager <- GridManager$new()
  ScoreManager <- ScoreManager$new()
  ObjectsManager <- ObjectsManager$new(ScoreManager)
  
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
  
  # TIMES UP ----
  observeEvent(input$stop_game, {
    req(isTRUE(input$stop_game))
    shinyjs::runjs("stopMove();")
    session$userData$isBiteModalOpen(TRUE)
    shinyjs::runjs("cleanObject('stop_game');")
  })
  
  # MOVE OBJECTS ----
  observeEvent(input$diver_direction, {
    req(input$diver_direction != "clean")
    ObjectsManager$set_diver_side(input$diver_direction)
    ObjectsManager$move_object("diver", input$diver_direction, extra_content = glue("<p class=timer>{input$time_left}</p>"))
    
    if(ObjectsManager$check_shark_bite()) {
      session$userData$isBiteModalOpen(TRUE)
    }
    
    if(ObjectsManager$check_success()) {
      session$userData$isSuccessModalOpen(TRUE)
    }
    
    ObjectsManager$check_collect()
    
    shinyjs::runjs("cleanObject('diver_direction');")
  })
  
  observeEvent(input$shark_direction, {
    req(input$shark_direction != "clean")
    purrr::iwalk(input$shark_direction, ~ObjectsManager$move_object("shark", .x, index = .y))
    
    # Move trash on average on 1/4 shark move.
    if(input$shark_direction[1] == "up") {
      ObjectsManager$move_all_trash()
    }
    
    # Move boat on 1/2 shark speed and only left or right.
    if(input$shark_direction[1] %in% c("left", "right")) {
      ObjectsManager$move_object("boat", input$shark_direction[1])
    }
    
    if(ObjectsManager$check_shark_bite()) {
      session$userData$isBiteModalOpen(TRUE)
    }
    
    shinyjs::runjs("cleanObject('shark_direction');")
  })
  
  # GAME OVER ----
  # TODO modify to one reactiveValues
  session$userData$isBiteModalOpen <- reactiveVal(FALSE)
  session$userData$isSuccessModalOpen <- reactiveVal(FALSE)
  
  gameOver$init_server("gameOver", ObjectsManager, consts)
}
