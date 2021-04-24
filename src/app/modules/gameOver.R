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
          class = "modal-grid",
          div(
            Text(variant = "xLarge", "The best Lorem Ipsum Generator in all the sea! Heave this scurvy copyfiller fer yar next adventure and cajol yar clients into walking the plank with ev'ry layout! Configure above, then get yer pirate ipsum...own the high seas, arg!"),
            class = "modal-element modal-element--text"
          ),
          div(
            ShinyComponentWrapper(PrimaryButton(session$ns("playAgain"), text = "Play Again!")),
            class = "modal-element modal-element--play"
          ),
          div(
            ShinyComponentWrapper(DefaultButton(session$ns("hideModal"), text = "Close")),
            class = "modal-element modal-element--learn"
          )
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
