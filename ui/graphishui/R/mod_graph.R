# ------------------------------------------------ #
# mod_graph                                        #
# Main module for interacting with the database.   #
# ------------------------------------------------ #

# ui ---------------------------------------------------------------
mod_graph_ui <- function(id) {
  ns <- NS(id)
  
  # query database for labels and relationships
  choices <- fct_get_choices()
  
  tagList(
    fluidRow(
      # INSTRUCTIONS #
      box(width = 12, 
          status = "info", 
          solidHeader = TRUE, 
          title = "Instructions", 
          collapsible = TRUE,
          h4("To explore relationships between people, places, projects, etc. 
             (nodes), select two nodes and the type of relationship you wish to 
             explore. Select 'r' to explore all relationships. When ready,
             press the 'Run query' button. Results are displayed as a graph which 
             you can explore by zooming in and out. Hovering over a node highlights 
             nodes within 2 degrees of separation, displays node properties in the table
             below the graph, and indicates if spatial data are available.")
      )
    ),
    
    # QUERY BUILDER #
    fluidRow(
      box(width = 12, 
          status = "warning", 
          solidHeader = TRUE, 
          title = "Query Builder", 
          collapsible = TRUE,
          
          fluidRow(
            column(3, selectInput(ns("node_1"), 
                                  label = "First Node",
                                  choices = choices[["nodes"]], 
                                  selected = "BC_FIRST_NATION")),

            column(3, selectInput(ns("relationship"), 
                                  label = "Relationship",
                                  choices = c("r", choices[["relationships"]]), 
                                  selected = "r")),
            
            column(3, selectInput(ns("node_2"),
                                  label = "Second Node",
                                  choices = choices[["nodes"]],
                                  selected = "BC_NATION_COUNCIL")),

            column(3, actionButton(ns("run"), 
                                   label = "Run query"))
          )
      )
    ),
    
    # GRAPHS, TABLES, MAPS, EDITOR # 
    fixedRow(
      tabBox(width = 12, title = "Query Output", 
             tabPanel( "Graph", type = "pills",
                       
                       fluidRow(
                         column(11, visNetworkOutput(ns("graph"), height = 450)),
                         column(1, textOutput(ns("spatial_note")))
                       ),
                       fixedRow(
                         column(12, reactableOutput(ns("graph_table")))
                       )
             ),
             tabPanel("Details: Selected Node", reactableOutput(ns("node_detail"))),
             tabPanel("Details: All Nodes", reactableOutput(ns("node_table"))),
             tabPanel("Relationships", reactableOutput(ns("rel_table"))),
             tabPanel("Map", leafletOutput(ns("mymap"), height = 600)),
             tabPanel("Map-Watersheds", leafletOutput(ns("mymap_ws"), height = 600)),
             tabPanel("Edit Node", visNetworkOutput(ns("edit"), height = 600))
      )
    )
  )
}


# SERVER ---------------------------------------------------------------
mod_graph_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session){
      
      ns <- session$ns
      
      validate_msg <- "This query returns no data."
      
      # query database
      dat <- eventReactive(input$run, {
          fct_get_data(label_a = input$node_1, 
                       label_b = input$node_2, 
                       relationship = input$relationship)
      })
      
      # create base graph visualization
      vis <- eventReactive(input$run, {
          if (length(dat()) == 0) validate(validate_msg)
          visNetwork(dat()$nodes,
                  dat()$relationships,
                  height = 600,
                  width = "100%") %>%
          visNodes(size = 25,
                   shadow = TRUE,
                   color = list(background = "blue", border = "black",
                                highlight = list(border = "red"))) %>%
          visLayout(randomSeed = NULL, improvedLayout = TRUE, hierarchical = NULL) 
      })
      
      # main graph 
      output$graph <- renderVisNetwork({
              vis() %>% 
                      visInteraction(hover =TRUE) %>%
                      visEvents(select = paste0("function(nodes) {
                          Shiny.onInputChange('", ns("current_node_selection"), "', nodes.nodes);
                          ;}")) %>%
                      visOptions(highlightNearest = list(enabled = TRUE, 
                                                         degree = 2, 
                                                         hover = TRUE)) %>%
                      visIgraphLayout()
      })
      
      # detail table at bottom of main graph
      output$graph_table <- renderReactable({
              if (length(dat()) == 0) validate("")
              reactable(dat()$nodes_detail %>%
                      filter(id %in% input$current_node_selection) %>% 
                              select_if(~ !any(is.na(.))),
                      defaultPageSize = 3, # limit number of rows
                      highlight = TRUE,
                      wrap = FALSE)})      # truncate long text
      
      # node detail table
      output$node_detail <- renderReactable({
              if (length(dat()) == 0) validate(validate_msg)
              reactable(dat()$nodes_detail %>%
                      filter(id %in% input$current_node_selection) %>% 
                      select_if(~ !any(is.na(.))),
              searchable = TRUE,
              highlight = TRUE,
              filterable = TRUE)})
      
      # table containing all node labels and properties
      output$node_table <- renderReactable({
              if (length(dat()) == 0) validate(validate_msg)
              reactable(dat()$nodes_detail, 
                        filterable = TRUE,
                        highlight = TRUE,
                        searchable = TRUE)})
      
      # table containing all relationships
      output$rel_table <- renderReactable({
              if (length(dat()) == 0) validate(validate_msg)
              reactable(dat()$relationships, 
                        searchable = TRUE,
                        filterable = TRUE,
                        highlight = TRUE)})
      
      # map showing all available nodes 
      output$mymap <- renderLeaflet({
              if (length(dat()) == 0) validate(validate_msg)
              if (dim(dat()$location)[1] == 0) validate("No spatial data available.")
              fct_map(dat()$location)})
      
      # add marker to map showing selected node 
      observeEvent(input$current_node_selection, {
              if (is.null(input$current_node_selection)) {
                      NULL
              } else if (input$current_node_selection %in% dat()$location$id){
                      leafletProxy("mymap") %>%
                              clearMarkers() %>%
                      addCircleMarkers(lng = dat()$location %>% pull(longitude),
                              lat = dat()$location %>% pull(latitude),
                              fillColor = "red",
                              fillOpacity = 0.8,
                              weight = 1,
                              radius = 3,
                              color = "black",
                              label = paste0("Node ID: ", dat()$location$id)) %>% 
                      addMarkers(lng = filter(dat()$location, id == input$current_node_selection) %>%
                              pull(longitude),
                              lat = filter(dat()$location, id == input$current_node_selection) %>%
                                      pull(latitude),
                              label = paste0("Node ID: ",
                                      (filter(dat()$location, id == input$current_node_selection)%>% 
                                         pull(id))))
          }
        })
      
      # map showing watershed polygons (FOR DEMO ONLY)
      output$mymap_ws <- renderLeaflet({ws_poly <- read_sf("watershed_polygons/BC_MAJOR_WATERSHEDS.geojson")
      leaflet(ws_poly) %>%
              addTiles() %>%
              addProviderTiles(leaflet::providers$Stamen.TonerLite, group = "Toner Lite") %>%
              addProviderTiles(leaflet::providers$OpenStreetMap, group = "Open Street Map") %>%
              addProviderTiles(leaflet::providers$Esri.WorldImagery, group = "ESRI Imagery") %>%
              addProviderTiles(leaflet::providers$Stamen.Toner, group = "Toner") %>%
              addProviderTiles(leaflet::providers$Esri.WorldTopoMap, group = "Topo") %>%
              addProviderTiles(leaflet::providers$Stamen.Terrain, group = "Terrain") %>%
        
              addPolygons(color = "black", weight = 1, smoothFactor = 0.5,
                      opacity = 1.0, fillOpacity = 0.5,
                      fillColor = "lightblue",
                      highlightOptions = highlightOptions(color = "white", weight = 2,
                                                          fillColor = "blue",
                                                          bringToFront = TRUE),
                      label = ws_poly$MAJOR_WATERSHED_SYSTEM) %>%
              addLayersControl(baseGroups = c("Toner Lite",
                                              "Open Street Map",
                                              "ESRI Imagery",
                                              "Toner",
                                              "Topo",
                                              "Terrain"),
                               options = layersControlOptions(collapsed = TRUE))})
      
      # edit tool (DEMO ONLY - DOES NOT ALTER DATABASE)
      output$edit <- renderVisNetwork({
              if (length(dat()) == 0) validate(validate_msg)
              vis() %>%
              visOptions(manipulation = list(enabled = TRUE, 
                                             editNode = TRUE, 
                                             editEdge = TRUE)) %>%
              visIgraphLayout()
      })
      
      # spatial data indicator
      output$spatial_note <- renderText({
              if (is.null(input$current_node_selection)) {
                  ""} else if (input$current_node_selection %in% dat()$location$id) {
                  "Spatial data available."
              } else {
                  "No spatial data available."
              }
      })
    }
  )
}