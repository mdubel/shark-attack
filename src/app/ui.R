function(input, output, session){
  semanticPage(
    tags$head(
      # _todo_ load any additional files like this:
      tags$link(rel = "stylesheet", type = "text/css", href = "css/sass.min.css"),
      tags$script(src = "js/button-theme.js"),
    ),
    tags$h3("Hello"),
    home$ui("module_id")
  )  
}
