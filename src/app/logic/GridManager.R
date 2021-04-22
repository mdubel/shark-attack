import("R6")
import("utils")
import("purrr")
import("shiny")
import("shinyjs")
import("glue")

export("GridManager")

GridManager <- R6::R6Class(
  "GridManager",
  private = list(
    number_of_columns = NULL,
    number_of_rows = NULL,
    
    object_location = NULL,
    
    single_grid_element = function(id) {
      div(
        style = "border: 1px solid black;",
        class = "single-grid",
        id = id
      )
    },
    prepare_grid_element_id = function(id_row, id_col) {
      paste0(id_row, "-", id_col)
    },
    create_grid = function() {
      grid_elements_ids <- expand.grid(
        x = seq_len(private$number_of_rows),
        y = seq_len(private$number_of_columns)
      ) %>% {private$prepare_grid_element_id(id_row = .$x, id_col = .$y)}
      
      div(
        style = sprintf(
          "display: grid;
           grid-template-columns: repeat(%s, 1fr);
           grid-template-rows: repeat(%s, 1fr);",
          private$number_of_columns, private$number_of_rows
        ),
        lapply(grid_elements_ids, private$single_grid_element)
      )
    }
    
  ),
  public = list(
    grid = NULL,
    add_on_random_grid = function(img_src) {
      location <- private$prepare_grid_element_id(
        sample(seq_len(private$number_of_rows), 1),
        sample(seq_len(private$number_of_columns), 1)
      )
      
      private$object_location <- location
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'url(./assets/{img_src})');"))
    },
    clean_grid = function(location) {
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'none');"))
    },
    initialize = function(number_of_columns, number_of_rows) {
      private$number_of_columns <- number_of_columns
      private$number_of_rows <- number_of_rows
      self$grid <- private$create_grid()
    }
  )
)