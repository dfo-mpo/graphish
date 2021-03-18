# ------------------------------------------------------------- #
# app.R                                                         #
# Run app with this file                                        #
#                                                               #
# Developed by Sitka Technology Group, Portland, OR             #
# George Batten                                                 #
# george.batten@sitkatech.com                                   #
# ------------------------------------------------------------- #

library(tidyverse)
library(shinydashboard)
library(reactable)
library(dashboardthemes)
library(tidyverse)
library(htmltools)
library(leaflet)
library(rgdal)
library(sf)
library(glue)
library(visNetwork)
library(neo4r)
library(shinydashboardPlus)
library(shinyjs)
library(shiny)

# ui ---------------------------------------------------------------

ui <- dashboardPage(
        dashboardHeader(title = "Graphish", disable = FALSE),
    
        dashboardSidebar( 
            sidebarMenu(
                menuItem("Home", tabName = "home", icon = icon("home")),
                menuItem("Graph", tabName = "graph", icon = icon("project-diagram"))
            )
        ),
    
        dashboardBody(
            tabItems(
                tabItem(tabName = "home", mod_home_ui("home")),
                tabItem(tabName = "graph", mod_graph_ui("graph"))
        )
    )
)

# SERVER ---------------------------------------------------------------
server <- function(input, output) {
    mod_home_server("home")
    mod_graph_server("graph")
}

shinyApp(ui, server)
