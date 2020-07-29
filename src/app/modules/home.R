import("htmltools")
import("shiny")
import("shiny.semantic")

export("ui", "init_server")

expose("utils/utils.R")
# referenced to object that lives in the environment that calls module, global.R in this case.
consts <- modules::use(consts)

ui <- function(id) {
  ns <- NS(id)
  tagList(
    uibutton(ns("count_me"), consts$texts$button_label, class = "theme-even"),
    uiOutput(ns("counted"))
  )
}

init_server <- function(id, title) {
  callModule(server, id, title)
}

server <- function(input, output, session, title) {
  ns <- session$ns

  counter <- reactiveVal(consts$global$counter_start_position)

  observeEvent(input$count_me, {
    counter(add_one(counter()))
  })

  output$counted <- renderUI({
    n_count <- counter()
    count_message(n_count)
  })
}

count_message <- function(n_count) {
  sprintf(consts$texts$clicked_info, n_count)
}
