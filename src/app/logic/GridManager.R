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
    number_of_columns = 10,
    number_of_rows = 10,
    
    single_grid_element = function(id) {
      div(
        style = "border: 1px solid black;",
        class = "single-grid",
        id = id
      )
    },
    prepare_grid_element_id = function(id_col, id_row) {
      paste0(id_col, "-", id_row)
    },
    get_grid_element_location = function(grid_id) {
      strsplit(grid_id, "-") %>% unlist() %>% as.numeric()
    },
    random_grid_location = function(row_range, column_range) {
      private$prepare_grid_element_id(
        sample(column_range, 1),
        sample(row_range, 1)
      )
    },
    create_grid = function() {
      grid_elements_ids <- expand.grid(
        x = seq_len(private$number_of_rows),
        y = seq_len(private$number_of_columns)
      ) %>% {private$prepare_grid_element_id(id_col = .$x, id_row = .$y)}
      
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
    clean_grid = function(location) {
      shinyjs::runjs(glue("$('#{location}').css('background-image', 'none');"))
    },
    initialize = function() {
      self$grid <- private$create_grid()
    }
  )
)
