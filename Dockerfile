# Base R Shiny image
FROM rocker/shiny

# Make a directory in the container
RUN mkdir /home/shiny-app
WORKDIR /home/shiny-app

RUN apt-get update && apt-get install -y libudunits2-dev libproj-dev gdal-bin libgdal-dev

COPY requirements.R /tmp/requirements.R
RUN Rscript /tmp/requirements.R

# Copy the Shiny app code
COPY ./ /home/shiny-app/

# Expose the application port
EXPOSE 3838

# Run the R Shiny app
CMD ["R", "-e", "shiny::runApp('/home/shiny-app', host = '0.0.0.0', port = 3838)"]
