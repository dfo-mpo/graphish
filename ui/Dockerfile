# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny-verse:latest

# system libraries of general use
## install debian packages
RUN apt-get update && apt-get install -y \
 sudo \
 gdebi-core \
  pandoc \
  pandoc-citeproc \
  libcurl4-gnutls-dev \
  libcairo2-dev \
  libgdal-dev \
  libproj-dev \
  libudunits2-dev \
  libgeos-dev \ 
  libxt-dev \
    xtail \
  wget
  
## update system libraries
RUN apt-get update && \
apt-get upgrade -y && \
apt-get clean

RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboard', repos='http://cran.rstudio.com/')"
RUN R -e "devtools::install_github('davidlrosenblum/neo4r')"
RUN R -e "install.packages('glue', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('reactable', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('htmltools', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('leaflet', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rgdal', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('sf', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('visNetwork', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboardPlus', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dashboardthemes', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinyjs', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('igraph', repos='http://cran.rstudio.com/')"

# copy necessary files
## app folder
#RUN mkdir /app
#COPY ./ /app/
COPY ./graphishui/ /app/

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('/app', host = '0.0.0.0', port = 3838)"]