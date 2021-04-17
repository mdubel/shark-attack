import("R6")
import("utils")

export("DataManager")

DataManager <- R6::R6Class(
  "DataManager",
  private = list(
    
  ),
  public = list(
    dataset = NULL,
    initialize = function() {
      self$dataset <- read.csv("./app/data/GSAF5.csv")
    }
  )
)