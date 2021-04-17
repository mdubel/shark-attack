import("shiny")

export("ui", "init_server")

utils <- use("utils/utils.R")

ui <- function(id) {
  ns <- NS(id)
  tagList(
    div()
  )
}

init_server <- function(id, title) {
  callModule(server, id, title)
}

server <- function(input, output, session, title) {
  ns <- session$ns

}