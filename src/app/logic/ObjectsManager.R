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
    
    grid_manager = NULL,
    
    get_move_vector = function(direction) {
      switch (
        direction,
        up = c(0,-1),
        right = c(1,0),
        down = c(0,1),
        left = c(-1,0)
      )
    },
    
    can_object_move = function(location, direction) {
      new_location <- private$get_new_location(location, direction)
      if(any(new_location == 0) || new_location[1] > private$number_of_columns || new_location[2] > private$number_of_rows) {
        return(FALSE)
      } else {
        return(TRUE)
      }
    },
    
    get_new_location = function(location, direction) {
      private$get_grid_element_location(location) + private$get_move_vector(direction)
    }
  ),
  public = list(
    add_on_grid = function(object_name, location) {
      private[[object_name]] <- location
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'url(./assets/{object_name}.png)');"))
    },
    
    place_objects = function() {
      self$add_on_grid("diver", private$prepare_grid_element_id(1, 1))
      self$add_on_grid("shark", private$random_grid_location(2:private$number_of_rows, 2:private$number_of_columns))
      shinyjs::runjs("randomMove('shark');")
    },
    
    move_object = function(object_name, direction) {
      location <- private[[object_name]]
      if(private$can_object_move(location, direction)) {
        self$clean_grid(location)
        
        new_location <- private$get_new_location(location, direction)
        new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2])
        
        self$add_on_grid(object_name, new_location_id)
      }
    },
    
    initialize = function() {
    }
  )
)
