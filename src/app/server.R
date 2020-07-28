server <- function(input, output, session) {

  # Get user details from auth0 ans set email in session$user
  # session$user <- user_details$init_server(Sys.getenv("SHINYPROXY_USERNAME", unset = "auth0|5e577c3b2d725316b195bb56"))
  # message(paste(Sys.time(), "User", session$user, "sign in."))
  
  home$init_server("module_id")
 }
