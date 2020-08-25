# __todo__: Choose your base image
FROM appsilon/rstudio:4.0.0_1

ENV NODE_VERSION=8.10.0
RUN apt-get update && \
    apt-get install wget curl ca-certificates rsync -y
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/node /usr/bin/
RUN cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm /usr/bin/
RUN /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm install  uglify-js@latest -g

# Set default project opened by RStudio
RUN echo "/mnt/src/src.Rproj" > /home/rstudio/.rstudio/projects_settings/switch-to-project

# Install your project packages
COPY src/renv.lock /tmp/renv.lock
RUN Rscript -e 'renv::restore("/tmp")'
