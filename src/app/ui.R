fluentPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/sass.min.css"),
    tags$script(src = "js/key-capture.js"),
    tags$script(src = "js/select-difficulty.js")
  ),
  useShinyjs(),
  withReact(
    map$ui("map")
  )
)
