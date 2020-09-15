semanticPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/sass.min.css"),
    tags$script(src = "js/bundle.min.js"),
  ),
  tags$h3("Hello"),
  home$ui("module_id")
)
