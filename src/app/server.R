server <- function(input, output, session) {

  DataManager <- DataManager$new()
  map$init_server("map", DataManager$dataset)
}
