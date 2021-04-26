import("shiny")
import("shinyjs")
import("shiny.fluent")
import("glue")

export("ui", "init_server")

ui <- function(id) {
  ns <- NS(id)
  tagList(
    reactOutput(ns("biteModal")),
    reactOutput(ns("chestModal"))
  )
}

init_server <- function(id, ObjectsManager, consts) {
  callModule(server, id, ObjectsManager, consts)
}

server <- function(input, output, session, ObjectsManager, consts) {
  ns <- session$ns
  
  output$biteModal <- renderReact({
    reactWidget(
      Modal(
        className = "bite-modal",
        isOpen = session$userData$isBiteModalOpen(), isBlocking = FALSE,
        div(
          class = "modal-grid",
          build_icon("failure"),
          build_modal_content()
        )
      )
    )
  })
  
  output$chestModal <- renderReact({
    reactWidget(
      Modal(
        className = "bite-modal",
        isOpen = session$userData$isChestModalOpen(), isBlocking = FALSE,
        div(
          class = "modal-grid",
          build_icon("success"),
          build_modal_content()
        )
      )
    )
  })
  
  build_icon <- function(type) {
    div(div(img(src = glue("./assets/{type}.png"))), class = "modal-element modal-element--icon")
  }
  
  build_modal_content <- function() {
    tagList(
      div(
        div(Text(variant = "xLarge", consts$texts$gameOver)),
        class = "modal-element modal-element--text"
      ),
      div(
        ShinyComponentWrapper(PrimaryButton(session$ns("playAgain"), text = "Play Again!")),
        class = "modal-element modal-element--play"
      ),
      div(
        ShinyComponentWrapper(DefaultButton(session$ns("learnMore"), text = "Learn More!")),
        class = "modal-element modal-element--learn"
      )
    )
  }
  
  observeEvent(input$learnMore, { session$userData$isBiteModalOpen(FALSE) })
  
  observeEvent(input$playAgain, {
    session$userData$isBiteModalOpen(FALSE)
    session$userData$isChestModalOpen(FALSE)
    ObjectsManager$place_objects(session$userData$level)
  })
  
}
