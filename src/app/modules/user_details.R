import("utils")
import("shiny")
import("auth0api")

export("init_server")

#' User details module
#'
init_server <- function(user_id) {
  callModule(server, "user_details_module", user_id)
}

#' User details
#'
#' Call via \code{user_details$init_server()}
#'
#' @param input shiny input
#' @param output shiny output
#' @param session shiny session
#'
#' @return user email if passt
server <- function(input, output, session, user_id) {
  tryCatch({
      suppressMessages(generate_token(Sys.getenv("AUTH0_CLIENT_ID"), Sys.getenv("AUTH0_CLIENT_SECRET")))
      
      # Store data in session userData
      session$userData$user_auth0 <- get_user(user_id)$content
    },
    error = function(e) {
      print(e)
      session$close()
    }
  )
  session$userData$user_auth0$email
}
