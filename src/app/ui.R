fluentPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/sass.min.css"),
    tags$script(src = "js/key-capture.js"),
  ),
  useShinyjs(),
  withReact(
    map$ui("map")
  )
)
