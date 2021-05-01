import("shiny")
import("shinyjs")
import("shiny.fluent")
import("glue")

export("ui", "init_server")

ui <- function(id) {
  ns <- NS(id)
  tagList(
    reactOutput(ns("biteModal")),
    reactOutput(ns("successModal"))
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
        className = "modal",
        isOpen = session$userData$isBiteModalOpen(), isBlocking = FALSE,
        div(
          class = "failure-grid",
          build_text(consts$texts$gameOver),
          build_icon("failure"),
          build_buttons()
        )
      )
    )
  })
  
  output$successModal <- renderReact({
    reactWidget(
      Modal(
        className = "modal",
        isOpen = session$userData$isSuccessModalOpen(), isBlocking = FALSE,
        div(
          class = "success-grid",
          build_text(consts$texts$gameSuccess),
          build_scores_table(list(current = "56", easy = "123", medium = "32", hard = "2")),
          build_icon("success"),
          build_buttons()
        )
      )
    )
  })
  
  build_scores_table <- function(scores_list) {
    div(
      class = "modal-element modal-element--scores",
      div(
        class = "scores-grid",
        div(
          class = "scores-current-score",
          p(scores_list$current)
        ),
        div(
          class = "scores-easy-score",
          p(scores_list$easy),
          build_icon("easy")
        ),
        div(
          class = "scores-medium-score",
          p(scores_list$medium),
          build_icon("medium")
        ),
        div(
          class = "scores-hard-score",
          p(scores_list$hard),
          build_icon("hard")
        )
      )
    )
  }
  
  build_text <- function(text) {
    div(
      div(Text(variant = "xLarge", text)),
      class = "modal-element modal-element--text"
    )
  }
  
  build_icon <- function(type) {
    div(div(img(src = glue("./assets/{type}.png"))), class = "modal-element modal-element--icon")
  }
  
  build_buttons <- function() {
    tagList(
      div(
        ShinyComponentWrapper(PrimaryButton(session$ns("playAgain"), text = "Play Again!")),
        class = "modal-element modal-element--play"
      ),
      div(
        ShinyComponentWrapper(PrimaryButton(session$ns("mainMenu"), text = "Back to Menu!")),
        class = "modal-element modal-element--menu"
      ),
      div(
        ShinyComponentWrapper(DefaultButton(session$ns("learnMore"), text = "Learn More!")),
        class = "modal-element modal-element--learn"
      )
    )
  }
  
  observeEvent(input$learnMore, { 
    # TODO open in new tab appropriate site
  })
  
  observeEvent(input$mainMenu, {
    session$userData$isBiteModalOpen(FALSE)
    session$userData$isSuccessModalOpen(FALSE)
    session$userData$isStartModalOpen(TRUE)
  })
  
  observeEvent(input$playAgain, {
    session$userData$isBiteModalOpen(FALSE)
    session$userData$isSuccessModalOpen(FALSE)
    ObjectsManager$place_objects(session$userData$level)
  })
  
}
