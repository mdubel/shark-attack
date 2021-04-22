import("R6")
import("utils")
import("purrr")
import("shiny")

export("GridManager")

GridManager <- R6::R6Class(
  "GridManager",
  private = list(
    single_grid_element = function(id) {
      div(
        style = "border: 1px solid black;",
        id = id
      )
    },
    create_grid = function(number_of_columns, number_of_rows) {
      grid_elements_ids <- expand.grid(x = seq_len(number_of_rows), y = seq_len(number_of_columns)) %>% {paste0(.$x, "-", .$y)}
      div(
        style = sprintf(
          "display: grid;
           grid-template-columns: repeat(%s, 1fr);
           grid-template-rows: repeat(%s, 1fr);",
          number_of_columns, number_of_rows
        ),
        lapply(grid_elements_ids, private$single_grid_element)
      )
    }
  ),
  public = list(
    grid = NULL,
    initialize = function() {
      self$grid <- private$create_grid(10, 10)
    }
  )
)