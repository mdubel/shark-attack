fluentPage(
  tags$head(
    tags$link(rel = "icon", type = "image/png", href = "assets/shark.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/sass.min.css"),
    tags$script(src = "js/key-capture.js"),
    tags$script(src = "js/select-difficulty.js"),
    tags$script(src = "js/timer.js"),
    tags$script(src = "js/tutorial.js")
  ),
  useShinyjs(),
  withReact(
    Persona(className = "score_board", imageInitials = "0", primaryText = "1:00", initialsColor = consts$colors$success),
    gameStart$ui("gameStart"),
    uiOutput("grid"),
    gameOver$ui("gameOver")
  )
)
