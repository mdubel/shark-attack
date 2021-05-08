import("R6")
import("utils")
import("purrr")
import("shiny")
import("shinyjs")
import("glue")

export("TrashManager")

ObjectsManager <- use("logic/ObjectsManager.R")$ObjectsManager

TrashManager <- R6::R6Class(
  "TrashManager",
  inherit = ObjectsManager,
  
  private = list(

  ),
  
  public = list(
    initialize = function() {
      
    }
  )
)
