import("R6")
import("utils")
import("purrr")
import("shiny")
import("shinyjs")
import("glue")

export("ScoreManager")

ScoreManager <- R6::R6Class(
  "ScoreManager",
  
  private = list(
    points = list(
      easy = 0,
      medium = 0,
      hard = 0
    ),
    points_max = list(
      easy = 0,
      medium = 0,
      hard = 0
    )
  ),
  
  public = list(
    reset_scores = function() {
      purrr::walk(names(private$points), function(level) {
        if(private$points[[level]] > private$points_max[[level]]) {
          private$points_max[[level]] <- private$points[[level]]
        }
        private$points[[level]] <- 0
      })
      shinyjs::runjs("updateScore('0');")
    },
    
    update_score = function(trash_points, trash_collected, level) {
      points <- trash_points[[trash_collected]]
      private$points[[level]] <- private$points[[level]] + points
      
      shinyjs::runjs(glue("$('.diver').append('<p class=show-score-{trash_collected}>+{points}</p>');"))
      shinyjs::runjs(glue("updateScore({private$points[[level]]});"))
    },
    
    get_scores = function(level) {
      if(is.null(level)) {
        return(list())
      }
      list(
        current = as.character(private$points[[level]]),
        easy = as.character(private$points_max$easy),
        medium = as.character(private$points_max$medium),
        hard = as.character(private$points_max$hard)
      )
    }
  )
)
