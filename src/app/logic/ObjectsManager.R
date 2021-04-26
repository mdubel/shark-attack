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
    objects = list(
      diver = c(),
      shark = c(),
      chest = c(),
      key = c(),
      boat = c(),
      plants = c()
    ),
    
    is_key = FALSE,
    is_chest = FALSE,
    
    get_move_vector = function(direction) {
      switch (
        direction,
        up = c(0, -1),
        right = c(1, 0),
        down = c(0, 1),
        left = c(-1, 0)
      )
    },
    
    can_object_move = function(location, direction) {
      new_location <- private$get_new_location(location, direction)
      if(isTRUE(any(new_location == 0) || new_location[1] > private$number_of_columns || new_location[2] > private$number_of_rows)) {
        return(FALSE)
      } else {
        return(TRUE)
      }
    },
    
    can_object_pass = function(object_name, location, direction) {
      new_location <- private$get_new_location(location, direction)
      new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2]) 
      if(object_name == "shark") {
        if(all(new_location_id == private$objects$key) || all(new_location_id == private$objects$chest) || any(new_location_id == private$objects$plants) || all(new_location_id == private$objects$boat)) {
          return(FALSE)
        } else {
          return(TRUE)
        }
      } else if(object_name == "diver") {
        if((all(new_location_id == private$objects$chest) && !private$is_key) || any(new_location_id == private$objects$plants) || (all(new_location_id == private$objects$boat) && !private$is_chest)) {
          return(FALSE)
        } else {
          return(TRUE)
        }
      }
    },
    
    get_new_location = function(location, direction) {
      private$get_grid_element_location(location) + private$get_move_vector(direction)
    },
    
    occupied_grids = function() {
      private$objects %>% unlist() %>% unname()
    },
    
    rotate_element = function(location, direction) {
      if(direction == "left") {
        shinyjs::runjs(glue("$('#{location}').removeClass('rotated');"))
      } else if(direction == "right") {
        shinyjs::runjs(glue("$('#{location}').addClass('rotated');"))
      }
    }
  ),
  public = list(
    add_on_grid = function(object_name, location) {
      self$clean_grid(location)
      private$objects[[object_name]] <- location
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'url(./assets/{object_name}.png)');"))
    },
    
    add_on_multiple_grid = function(object_name, location) {
      self$clean_grid(location)
      private$objects[[object_name]] <- c(private$objects[[object_name]], location)
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'url(./assets/{object_name}.png)');"))
    },
    
    place_objects = function() {
      self$clean_it_all()

      self$add_on_grid(
        "diver",
        private$prepare_grid_element_id(1, 2)
      )
      self$add_on_grid(
        "boat",
        private$prepare_grid_element_id(1, 1)
      )
      self$add_on_grid(
        "chest",
        private$random_grid_location(
          1:private$number_of_columns,
          c(private$number_of_rows, private$number_of_rows),
          private$occupied_grids()
        )
      )
      self$add_on_grid(
        "key",
        private$random_grid_location(
          1:private$number_of_columns,
          2:(private$number_of_rows - 1),
          private$occupied_grids()
        )
      )
      self$add_on_grid(
        "shark",
        private$random_grid_location(
          2:private$number_of_columns,
          2:private$number_of_rows,
          private$occupied_grids()
        )
      )
      
      purrr::walk(
        seq_len(private$number_of_plants),
        function(x) {
          self$add_on_multiple_grid(
            "plants",
            private$random_grid_location(
              1:private$number_of_columns,
              1:private$number_of_rows,
              private$occupied_grids()
            )
          )
        }
      )
      
      shinyjs::runjs("randomMove('shark');")
    },
    
    check_shark_bite = function() {
      if(private$objects$diver == private$objects$shark) {
        shinyjs::runjs("stopMove();")
        self$clean_grid(private$objects$diver)
        self$add_on_grid("shark", private$objects$shark)
        return(TRUE)
      } else {
        return(FALSE)
      }
    },
    
    check_collect = function() {
      if(private$objects$key == private$objects$diver) {
        private$is_key <- TRUE
      }
      if(private$objects$chest == private$objects$diver) {
        private$is_chest <- TRUE
      }
    },
    
    check_success = function() {
      if(private$is_chest && isTRUE(private$objects$diver == private$prepare_grid_element_id(1, 1))) {
        shinyjs::runjs("stopMove();")
        self$add_on_grid(
          "boat",
          private$prepare_grid_element_id(1, 1)
        )
        return(TRUE)
      } else {
        return(FALSE)
      }
    },
    
    move_object = function(object_name, direction) {
      location <- private$objects[[object_name]]
      if(private$can_object_move(location, direction) && private$can_object_pass(object_name, location, direction)) {
        self$clean_grid(location)
        
        new_location <- private$get_new_location(location, direction)
        new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2])
        
        self$add_on_grid(object_name, new_location_id)
        private$rotate_element(new_location_id, direction)
      }
    },

    clean_grid = function(locations) {
      purrr::walk(
        locations, 
        function(location) shinyjs::runjs(glue("$('#{location}').css('background-image', 'none');"))
      )
    },
    
    clean_it_all = function() {
      shinyjs::runjs("$('.single-grid').css('background-image', 'none');")
      shinyjs::runjs("stopMove();")
      private$is_key <- FALSE
      private$is_chest <- FALSE
      purrr::walk(names(private$objects), function(object_name) private$objects[[object_name]] <- c())
    },
    
    initialize = function() {
    }
  )
)
