import("shiny")
import("shinyjs")
import("shiny.fluent")

export("ui", "init_server")

ui <- function(id) {
  ns <- NS(id)
  reactOutput(ns("biteModal"))
}

init_server <- function(id, ObjectsManager) {
  callModule(server, id, ObjectsManager)
}

server <- function(input, output, session, ObjectsManager) {
  ns <- session$ns
  
  output$biteModal <- renderReact({
    reactWidget(
      Modal(
        className = "bite-modal",
        isOpen = session$userData$isBiteModalOpen(), isBlocking = FALSE,
        div(
          style = "margin: 20px",
          ShinyComponentWrapper(DefaultButton(session$ns("playAgain"), text = "Play Again!")),
          ShinyComponentWrapper(DefaultButton(session$ns("hideModal"), text = "Close"))
        )
      )
    )
  })
  
  observeEvent(input$hideModal, { session$userData$isBiteModalOpen(FALSE) })
  
  observeEvent(input$playAgain, {
    session$userData$isBiteModalOpen(FALSE)
    ObjectsManager$place_objects()
  })
  
}
