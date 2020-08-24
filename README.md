# Shiny boilerplate

This branch provides:
* Shiny app structure
* RStudio in a Docker container (based on `appsilon/rstudio:4.0.0_x` image from https://github.com/Appsilon/docker images)
* Linter (`lintr`) and unit tests (`testthat`) configuration
* GitHub Actions configuration to lint and test the project

## Usage

1. Make sure you have installed `workflow`: https://github.com/Appsilon/workflow
   Pattern tasks are defined in `environment/tasks.py`
1. Run `environment/bootstrap.sh` to install additional dependencies.

Available tasks:

```
workflow rstudio.start                 # Run full development environment
workflow rstudio.build --tag={tag}     # Build project image based on environment/Dockerfile
workflow rstudio.snapshot --tag={tag}  # Save project image based on the current state of a container
workflow rstudio.down                  # Bring down the development environment
workflow rstudio.prune                 # This will remove unused docker resources (like dangling images)
workflow rstudio.ps                    # List running docker-compose services
workflow rstudio.push                  # Push created images to docker registry
workflow rstudio.r                     # Execute R shell in the rstudio container
workflow rstudio.bash                  # Execute shell in the rstudio container
workflow rstudio.lint                  # Lint R sources with `lintr`
workflow rstudio.styler                # Style all R files according to tidyverse styleguide with `styler`
workflow rstudio.test                  # Run unit tests with `testthat`
```

#### Build your development docker image

* Development image is built using `environment/Dockerfile`. Edit it to install required system dependencies.
* Edit `environment/workflow.yml` and choose name for your image (`image: appsilon/project` value)
* For tagging (versioning) images we use the following convention: `MAJOR.MINOR` for example: `1.0`, `1.23`, `2.5`. Increase `MAJOR` when you do breaking changes (e.g. changing the base image). Increase `MINOR` every time you add any small change.
* Build it: `./workflow rstudio.build --tag=1.0`

#### Install R packages

R packages are installed with **renv** which uses `src/renv.lock`.

There are 2 ways of updating your image with R packages. One is quick, using `./workflow rstudio.snapshot`, second is strict using `./workflow rstudio.build` and rebuilding the image from `environment/Dockerfile` and `src/renv.lock`.

* **Quick install**: run `./workflow rstudio.snapshot --tag={yourtag}` to save the current state of your container
* **Strict install**: run `./workflow rstudio.build --tag={yourtag}` to build image from `Dockerfile` and `renv.lock`.

#### Remember to publish your changes

* Push your image to the registry: `./workflow rstudio.push`
* Commit your changes in git
