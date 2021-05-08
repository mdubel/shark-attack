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
          build_scores_table(ObjectsManager$get_scores()),
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
          class = "scores-current-text",
          consts$texts$currentScore
        ),
        div(
          class = "scores-high-text",
          consts$texts$highScore
        ),
        div(
          class = "scores-current-score",
          p(scores_list$current)
        ),
        build_level_score(scores_list, "easy"),
        build_level_score(scores_list, "medium"),
        build_level_score(scores_list, "hard")
      )
    )
  }
  
  build_text <- function(text) {
    div(
      div(Text(variant = "xLarge", text)),
      class = "modal-element modal-element--text"
    )
  }
  
  build_level_score <- function(scores_list, level) {
    div(
      class = glue("scores-{level}-score"),
      p(scores_list[[level]]),
      build_icon(level)
    )
  }
  
  build_icon <- function(type) {
    div(div(img(src = glue("./assets/{type}.png"))), class = "modal-element modal-element--icon")
  }
  
  build_buttons <- function() {
    div(
      class = "buttons-grid",
      div(
        ShinyComponentWrapper(PrimaryButton(ns("playAgain"), text = "Play Again!")),
        class = "modal-element button-play"
      ),
      div(
        ShinyComponentWrapper(PrimaryButton(ns("mainMenu"), text = "Back to Menu!")),
        class = "modal-element button-menu"
      ),
      div(
        ShinyComponentWrapper(DefaultButton(ns("learnMore"), text = "Learn More!")),
        class = "modal-element button-learn"
      ),
      div(consts$texts$modalFooter, class = "buttons-footer")
    )
  }
  
  open_in_new_tab <- function(url) {
    shinyjs::runjs(glue("window.open('{url}', '_blank');"))
  }
  
  observeEvent(input$learnMore, {
    purrr::walk(consts$links, ~open_in_new_tab(.x))
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
