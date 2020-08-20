# __todo__: Choose your base image
FROM appsilon/rstudio:4.0.0_1

# Set default project opened by RStudio
RUN echo "/mnt/src/src.Rproj" > /home/rstudio/.rstudio/projects_settings/switch-to-project

# Install your project packages
COPY src/renv.lock /tmp/renv.lock
RUN Rscript -e 'renv::restore("/tmp")'
