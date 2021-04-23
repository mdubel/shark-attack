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
    plants = NULL,
    
    get_move_vector = function(direction) {
      switch (
        direction,
        top = c(0,-1),
        right = c(1,0),
        bottom = c(0,1),
        left = c(-1,0)
      )
    }
  ),
  public = list(
    add_on_grid = function(object_name, location) {
      #location <- private$random_grid_location(seq_len(private$number_of_rows), seq_len(private$number_of_columns))
      private[[object_name]] <- location
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'url(./assets/{object_name}.png)');"))
    },
    
    move_object = function(object_name, direction) {
      location <- private[[object_name]]
      self$clean_grid(location)
      
      new_location <- private$get_grid_element_location(location) + private$get_move_vector(direction)
      new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2])
      
      self$add_on_grid(object_name, new_location_id)
    },
    
    initialize = function() {
      self$add_on_grid("diver", private$prepare_grid_element_id(1,1))
      self$move_object("diver", "right")
    }
  )
)
