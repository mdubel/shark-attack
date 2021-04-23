import("R6")
import("utils")
import("purrr")
import("shiny")
import("shinyjs")
import("glue")

GridManager <- use("logic/GridManager.R")$GridManager

export("ObjectsManager")

ObjectsManager <- R6::R6Class(
  "ObjectsManager",
  inherit = GridManager,
  private = list(
    diver = NULL,
    shark = NULL,
    chest = NULL,
    key = NULL,
    boat = NULL,
    plants = NULL
  ),
  public = list(
    add_on_grid = function(object_name, location) {
      #location <- private$random_grid_location(seq_len(private$number_of_rows), seq_len(private$number_of_columns))
      private[[object_name]] <- location
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'url(./assets/{object_name}.png)');"))
    },
    initialize = function() {
      self$add_on_grid("diver", private$prepare_grid_element_id(1,1))
    }
  )
)
