# Appsilon Project Patterns

**Code of Work**
 - single feature / tool / solution is called `pattern`
 - each pattern is a separate branch, that is possible to add to new project using `./workflow add --pattern={pattern}`
 - you can start developing new pattern by forking `new-pattern` branch
 - update the README for each pattern implemented with the steps/files needed to use it, like field to be set/modified etc.
 - mark those parts clearly in the code with `_todo_` comment

## Usage

Workflow task management based on [pyinvoke](https://www.pyinvoke.org/).
Main `workflow` script scans for `tasks.py` files in the project structure to register new tasks.
If you run workflow for the very first time, just run `./workflow` and press [enter].
It will install required dependencies like pyinvoke.

Run `./workflow --list` to see available tasks.

```
./workflow init   Initialize workflow in a recently cloned project repo. It will add patterns remote.
./workflow add    Add pattern to your project.
./workflow ls     List all available patterns.
```

#### Create new project from template repository

To start new project click **Use this template** in the `Appsilon/project.pattern` github repository.
You don't have to include all branches, only `master` branch is needed.
How to use template repositories: https://github.blog/2019-06-06-generate-new-repositories-with-repository-templates/

#### Initialize workflow

To add patterns to your new project repository, you have to run `./workflow init`.
It adds `Appsilon/project.pattern` repository as additional remote to fetch pattern branches.

#### Add patterns

1. From branch `master` (on your newly created project repo!) run `./workflow add --pattern={pattern-branch-name}` to add pattern to your project. It fetches pattern branch to your repo.
Note! when adding mature patterns it is enough to use it's name without prefix, e.g. `./workflow add --pattern=rstudio`. For other branches without `pattern/` prefix you need to use full name with `--explicit-branch` option, e.g. `./workflow add --pattern=experimental/rstudio --explicit-branch`.
2. Fix conflicts and refactor pattern code according to its readme.
3. Push pattern to the origin and open pull request and ask for code review.
4. Decide how you want to merge pull request. For commercial projects it is recommended to squash pattern branch history.

# RStudio pattern

This pattern contains tasks and configuration to run RStudio in a docker container with all required dependencies.

## Usage

Tasks are defined in `environment/tasks.py`

Run `./workflow init` to install required dependencies like pyyaml or docker-compose.
Workflow dependencies are defined in `environment/bootstrap.sh`.

Available tasks:

```
./workflow rstudio.start                 # Run full development environment
./workflow rstudio.build --tag={tag}     # Build project image based on environment/Dockerfile
./workflow rstudio.snapshot --tag={tag}  # Save project image based on the current state of a container
./workflow rstudio.down                  # Bring down the development environment
./workflow rstudio.prune                 # This will remove:
./workflow rstudio.ps                    # List running docker-compose services
./workflow rstudio.push                  # Push created images to docker registry
./workflow rstudio.r                     # Execute R shell in the rstudio container
./workflow rstudio.bash                  # Execute shell in the rstudio container
./workflow rstudio.lint                  # Lint R sources with `lintr`
./workflow rstudio.styler                # TODO: needs to be implemented
./workflow rstudio.test                  # Run unit tests with `testthat`
```

#### Build your development docker image

1. Development image is built using `environment/Dockerfile`. Edit it to install required system dependencies.
1. Edit `environment/workflow.yml` and choose name for your image (`image: appsilon/project` value)
1. For tagging (versioning) images we use the following convention: `MAJOR.MINOR` for example: `1.0`, `1.23`, `2.5`. Increase `MAJOR` when you do breaking changes (e.g. changing the base image). Increase `MINOR` every time you add any small change.
1. Build it: `./workflow rstudio.build --tag=1.0`

#### Install R packages

R packages are installed with **renv** which uses `src/renv.lock`.

There are 2 ways of updating your image with R packages. One is quick, using `./workflow rstudio.snapshot`, second is strict using `./workflow rstudio.build` and rebuilding the image from `environment/Dockerfile` and `src/renv.lock`.

1. Use `./workflow rstudio.start` or `./workflow rstudio.r` to start R session
1. Install your packages using `renv::install()`. Make sure you are in `/mnt/src` directory, to write to `/mnt/src/renv.lock`
1. Run `renv::snapshot()` to save changes to the `renv.lock`
1. **Quick install**: run `./workflow rstudio.snapshot --tag={yourtag}` to save the current state of your container
1. **Strict install**: run `./workflow rstudio.build --tag={yourtag}` to build image from `Dockerfile` and `renv.lock`.

#### Remember to publish your changes

1. Push your image to the registry: `./workflow rstudio.push`
1. Commit your changes in git

# Lint

This pattern provides you with tools to lint your code. It provides linter scripts (check next section for available languages) and tasks to use them locally or inside a container. Scripts also can be included in your CI solution.

## Supported languages

* R

## Usage

### R

Linter for R can be run locally or inside a Docker container. The latter option requires pattern `rstudio` and a running project container. Running R linter locally requires `lintr` and `optparse` packages. To install them run `workflow lint.r-local-dependencies`.

```{shell}
workflow lint.r-local-dependencies    install dependencies required for running R linter locally
workflow lint.r-local                 run R linter locally
workflow lint.r-docker                run R linter in Docker container
```

# Shiny pattern

Project files for Shiny app.

## Usage

Define your custom tasks in `src/tasks.py`
