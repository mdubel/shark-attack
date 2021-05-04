fluentPage(
  tags$head(
    tags$link(rel = "icon", type = "image/png", href = "assets/shark.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/sass.min.css"),
    tags$script(src = "js/key-capture.js"),
    tags$script(src = "js/select-difficulty.js"),
    tags$script(src = "js/timer.js")
  ),
  useShinyjs(),
  withReact(
    map$ui("map")
  )
)
