# --------------------------------------------------------------------- #
# fct_get_map                                                           #
# Creates leaflet map of location data (if available) in nodes returned #
# by query.                                                             #
# --------------------------------------------------------------------- #

  fct_map <- function(location) {
      m <-   leaflet() %>%
        clearBounds() %>%
        fitBounds(lng1 = max(location$longitude), lng2 = min(location$longitude),
                  lat1 = max(location$latitude), lat2 = min(location$latitude)) %>%
        addTiles() %>%
        addProviderTiles(providers$OpenStreetMap, group = "Open Street Map") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "ESRI Imagery") %>%
        addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
        addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
        addProviderTiles(providers$Esri.WorldTopoMap, group = "Topo") %>%
        addProviderTiles(providers$Stamen.Terrain, group = "Terrain") %>%
    
        addCircleMarkers(lng = location$longitude, lat = location$latitude, fillColor = "red",
                         fillOpacity = 0.8, weight = 1, radius = 3,
                         color = "black",
                         label = paste0("Node ID: ", location$id)) %>%
        addLayersControl(baseGroups = c("Open Street Map",
                                        "ESRI Imagery",
                                        "Toner",
                                        "Toner Lite",
                                        "Topo",
                                        "Terrain"),
                         options = layersControlOptions(collapsed = TRUE))
  m
}
