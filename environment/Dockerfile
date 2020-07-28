# __todo__: Choose your base image
FROM appsilon/rstudio:3.6.3_2

# Set default project opened by RStudio
RUN echo "/mnt/src/src.Rproj" > /home/rstudio/.rstudio/projects_settings/switch-to-project

# Set default working directory
RUN mkdir -p /mnt/src && \
    echo "setwd('/mnt/src')" >> /home/rstudio/.Rprofile && \
    echo "setwd('/mnt/src')" >> /root/.Rprofile

# Install your project packages
COPY src/renv.lock /tmp/renv.lock
RUN cd /tmp && R -e 'renv::restore()'
