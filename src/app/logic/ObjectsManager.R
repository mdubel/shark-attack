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
    
    diver_current_side = "left",
    timer = "59",
    
    objects = list(
      diver = c(),
      shark = c(),
      boat = c(),
      plants = c()
    ),
    
    level = NULL,
    points = list(
      easy = 0,
      medium = 0,
      hard = 0
    ),
    points_max = list(
      easy = 0,
      medium = 0,
      hard = 0
    ),
    
    number_of_plants = 20, 
    number_of_sharks = list(
      easy = 4,
      medium = 8,
      hard = 12
    ),
    initial_trash_count = 15,
    new_trash_count = 1,
    
    trash = list(
      organic = c(),
      glass = c(),
      metal = c(),
      electro = c(),
      plastic = c(),
      radio = c()
    ),
    trash_chances = list(
      organic = 0.1,
      glass = 0.1,
      metal = 0.15,
      electro = 0.2,
      plastic = 0.4,
      radio = 0.05
    ),
    trash_points = list(
      organic = 1,
      glass = 3,
      metal = 3,
      electro = 7,
      plastic = 5,
      radio = 15
    ),
    
    get_move_vector = function(direction) {
      switch (
        direction,
        up = c(0, -1),
        right = c(1, 0),
        down = c(0, 1),
        left = c(-1, 0)
      )
    },
    
    can_object_move = function(new_location) {
      if(isTRUE(any(new_location == 0) || new_location[1] > private$number_of_columns || new_location[2] > private$number_of_rows)) {
        return(FALSE)
      } else {
        return(TRUE)
      }
    },
    
    can_object_pass = function(object_name, new_location) {
      new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2]) 
      if(object_name == "shark") {
        if(new_location_id %in% private$objects$plants || new_location_id == private$objects$boat || new_location_id %in% private$objects$shark || new_location_id %in% private$occupied_trash() || new_location_id %in% "1-2") {
          return(FALSE)
        } else {
          return(TRUE)
        }
      } else if(object_name == "diver") {
        if(new_location_id %in% private$objects$plants) {
          return(FALSE)
        } else {
          return(TRUE)
        }
      } else if(object_name == "boat") {
        if(new_location_id %in% private$objects$plants || new_location_id %in% private$objects$shark || new_location_id %in% private$occupied_trash()) {
          return(FALSE)
        } else {
          return(TRUE)
        }
      }
    },
    
    can_trash_pass = function(new_location) {
      new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2])
      if(new_location_id %in% c(private$occupied_grids(), private$occupied_trash())) {
        return(FALSE)
      } else {
        return(TRUE)
      }
    },
    
    get_new_location = function(location, direction) {
      private$get_grid_element_location(location) + private$get_move_vector(direction)
    },
    
    occupied_grids = function() {
      private$objects %>% unlist() %>% unname()
    },
    
    occupied_trash = function() {
      private$trash %>% unlist() %>% unname()
    },
    
    random_trash = function() {
      sample(names(private$trash_chances), 1, prob = unlist(private$trash_chances))
    },
    
    set_scores = function() {
      purrr::walk(names(private$points), function(level) {
        if(private$points[[level]] > private$points_max[[level]]) {
          private$points_max[[level]] <- private$points[[level]]
        }
        private$points[[level]] <- 0
      })
      shinyjs::runjs("updateScore('0');")
    },
  
    update_score = function(trash_collected, points) {
      private$points[[private$level]] <- private$points[[private$level]] + points
      shinyjs::runjs(glue("updateScore({private$points[[private$level]]});"))
      self$remove_trash(trash_collected,  private$objects$diver)
    },
    
    get_image_name = function(object_name) {
      if(object_name == "shark") {
        return(private$level)
      } else if(object_name == "diver") {
        return(paste0("diver-", private$diver_current_side))
      } else {
        return(object_name)
      }
    },
    
    start_moving = function(countdown_time = 3) {
      timeout_time <- (countdown_time + 1) * 1000
      shinyjs::runjs(glue("runCountdown({countdown_time})"))
      shinyjs::runjs(glue("setTimeout(() => runTimer({private$timer}), {timeout_time});"))
      shinyjs::runjs(glue("setTimeout(() => randomMove('shark', {private$number_of_sharks[[private$level]]}), {timeout_time});"))
    }
  ),
  public = list(
    #' Main function to place objects on grid element.
    #'
    #' @param object_name string; name of the object as listed on `objects` or `trash``
    #' @param location string; grid unique id where to place
    #' @param image_name string; name of the png from www/assets, if different than object_name
    #' @param index numeric; for objects with multiple instances (e.g. sharks) index of object from that group
    #' @param type string; which list of objects to use
    #' @param extra_content string; HTML code that can be placed additionally on grid
    #'
    #' @return
    add_on_grid = function(object_name, location, image_name = object_name, index = 1, type = "objects", extra_content = NULL) {
      private$clean_locations(location)
      private[[type]][[object_name]][index] <- location
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'url(./assets/{image_name}.png)'); $('#{location}').addClass('{object_name}');"))
      if(!is.null(extra_content)) {
        shinyjs::runjs(glue("$('#{location}').append('{extra_content}');"))
      }
    },
    
    set_diver_side = function(direction) {
      if(direction %in% c("left", "right")) {
        private$diver_current_side <- direction
      }
    },
    
    place_objects = function(level) {
      self$clean_it_all()

      private$level <- level

      self$add_on_grid(
        "diver",
        private$prepare_grid_element_id(1, 2),
        image_name = private$get_image_name("diver"),
        extra_content = glue("<p class=timer>0:{private$timer}</p><p class=score>0</p>")
      )
      self$add_on_grid(
        "boat",
        private$prepare_grid_element_id(1, 1)
      )
      
      purrr::walk(
        seq_len(private$number_of_sharks[[private$level]]),
        function(index) {
          self$add_on_grid(
            "shark",
            private$random_grid_location(
              2:private$number_of_columns,
              2:private$number_of_rows,
              private$occupied_grids()
            ),
            image_name = private$level,
            index = index
          )
        }
      )
      
      purrr::walk(
        seq_len(private$number_of_plants),
        function(index) {
          self$add_on_grid(
            "plants",
            private$random_grid_location(
              1:private$number_of_columns,
              2:private$number_of_rows,
              private$occupied_grids()
            ),
            index = index
          )
        }
      )
      
      self$place_trash()
      
      private$start_moving()
    },
    
    check_shark_bite = function() {
      if(private$objects$diver %in% private$objects$shark) {
        shinyjs::runjs("stopMove();")
        private$clean_locations(private$objects$diver)
        self$add_on_grid("shark", private$objects$shark, private$level)
        return(TRUE)
      } else {
        return(FALSE)
      }
    },
    
    check_success = function() {
      if(isTRUE(private$objects$diver == private$objects$boat)) {
        shinyjs::runjs("stopMove();")
        self$add_on_grid(
          "boat",
          private$objects$boat
        )
        return(TRUE)
      } else {
        return(FALSE)
      }
    },
    
    move_object = function(object_name, direction, index = 1, extra_content = NULL) {
      location <- private$objects[[object_name]][index]
      new_location <- private$get_new_location(location, direction)
      if(private$can_object_move(new_location) && private$can_object_pass(object_name, new_location)) {
        private$clean_locations(location)
        
        new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2])
        
        self$add_on_grid(
          object_name, new_location_id,
          image_name = private$get_image_name(object_name),
          index = index,
          extra_content = extra_content
        )
        if(object_name != "diver") {
          private$rotate_element(new_location_id, direction)
        } else {
          shinyjs::runjs(glue("$('.diver').append('<p class=score>{private$points[[private$level]]}</p>');"))
        }
      }
    },
    
    clean_it_all = function() {
      private$clean_grid(".single-grid")
      shinyjs::runjs("stopMove();")
      purrr::walk(names(private$objects), function(object_name) private$objects[[object_name]] <- c())
      purrr::walk(names(private$trash), function(trash_name) private$trash[[trash_name]] <- c())
      private$set_scores()
    },
    
    place_trash = function(count = private$initial_trash_count, col_range = 1:private$number_of_columns, row_range = 1:private$number_of_rows) {
      purrr::walk(
        seq_len(count),
        function(index) {
          trash_name <- private$random_trash()
          self$add_on_grid(
            trash_name,
            private$random_grid_location(
              col_range,
              row_range,
              c(private$occupied_grids(), private$occupied_trash())
            ),
            index = length(private$trash[[trash_name]]) + 1,
            type = "trash"
          )
        }
      )
    },
    
    check_collect = function() {
      if(length(private$occupied_trash()) > 0 && private$objects$diver %in% private$occupied_trash()) {
        trash_collected <- names(private$trash)[purrr::map_lgl(private$trash, ~private$objects$diver %in% .x)]
        points <- private$trash_points[[trash_collected]]
      
        shinyjs::runjs(glue("$('.diver').append('<p class=show-score-{trash_collected}>+{points}</p>');"))

        private$update_score(trash_collected, points)
      }
    },
    
    move_all_trash = function() {
      purrr::walk(
        names(private$trash),
        function(trash_name) {
          iwalk(private$trash[[trash_name]], ~self$move_trash(trash_name, .x, sample(c("left", "down"), 1), .y))
        }
      )
      self$place_trash(private$new_trash_count, c(private$number_of_columns, private$number_of_columns), 1:private$number_of_rows)
      self$place_trash(private$new_trash_count, 1:private$number_of_columns, c(1, 1))
    },
    
    remove_trash = function(trash_name, location) {
      private$trash[[trash_name]] <- setdiff(private$trash[[trash_name]], location)
    },
    
    move_trash = function(trash_name, location, direction, index = 1) {
      new_location <- private$get_new_location(location, direction)
      if(private$can_object_move(new_location)) {
        if(private$can_trash_pass(new_location)) {
          private$clean_locations(location)
          new_location_id <- private$prepare_grid_element_id(new_location[1], new_location[2])
          
          self$add_on_grid(
            trash_name,
            new_location_id,
            index = index,
            type = "trash"
          )
          
          self$check_collect()
        }
      } else {
        private$clean_locations(location)
        self$remove_trash(trash_name, location)
      }
    },
    
    get_scores = function() {
      if(is.null(private$level)) {
        return(list())
      }
      list(
        current = as.character(private$points[[private$level]]),
        easy = as.character(private$points_max$easy),
        medium = as.character(private$points_max$medium),
        hard = as.character(private$points_max$hard)
      )
    },
    
    initialize = function() {
    }
  )
)
