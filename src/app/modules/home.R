import("htmltools")
import("shiny")
import("shiny.semantic")

export("initialize", "ui", "init_server", "count_message")

utils <- use("utils/utils.R")

# Avoid referencing objects from global scope outside of a module.
# Initialize local environment to reference objects explicitly.
consts <- list()
initialize <- function(consts) {
  consts <<- consts
}

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
    counter(utils$add_one(counter()))
  })

  output$counted <- renderUI({
    n_count <- counter()
    count_message(n_count)
  })
}

count_message <- function(n_count) {
  sprintf(consts$texts$clicked_info, n_count)
}
