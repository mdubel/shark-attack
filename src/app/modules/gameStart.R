import("shiny")
import("shinyjs")
import("shiny.fluent")
import("glue")

export("ui", "init_server")

ui <- function(id) {
  ns <- NS(id)
  tagList(
    reactOutput(ns("startModal"))
  )
}

init_server <- function(id, ObjectsManager, consts) {
  callModule(server, id, ObjectsManager, consts)
}

server <- function(input, output, session, ObjectsManager, consts) {
  ns <- session$ns
  
  output$startModal <- renderReact({
    reactWidget(
      Modal(
        className = "start-modal",
        isOpen = session$userData$isStartModalOpen(), isBlocking = FALSE,
        div(
          class = "start-grid",
          start_content()
        )
      )
    )
  })
  
  level_icon <- function(type) {
    div(img(src = glue("./assets/{type}.png")), class = "start-element start-element--icon")
  }
  
  start_content <- function() {
    tagList(
      div(
        # TODO Implement carousel with game tutorial
        class = "start-element start-element--carousel"
      ),
      div(class = "start-element start-element--text", h4("Select difficulty")),
      div(class = "level-icon--easy", level_icon("easy")),
      div(class = "level-icon--medium", level_icon("medium")),
      div(class = "level-icon--hard", level_icon("hard"))
    )
  }
}
