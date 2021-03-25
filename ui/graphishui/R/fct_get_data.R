# --------------------------------------------------------------------- #
# fct_get_data                                                          #
# Queries database using user input, returns list of tibbles containing #
# data frames for nodes, relationships, properties, node details, and   #
# location.                                                             #
# --------------------------------------------------------------------- #
           
fct_get_data <- function(label_a, label_b, relationship) {  
  
  # connection to database
  con <- neo4j_api$new(
    url = "http://neo4j:7474",          # connct to container
    # url = "http://206.47.13.10:7474/", # connect to Nghia's computer
    user = "neo4j", 
    password = "pskgi"
  )
  
  # build query from user inputs
  query <- if(relationship == "r") { # "r" means find all relationships
    {
      paste0("MATCH (a:",
             label_a,
             ")-[r",
             "]-(b:",
             label_b,
             ") RETURN a, r, b")
    }
  } else {
    paste0("MATCH (a:",
           label_a,
           ")-[rel:",
           relationship,  # find particular relationship
           "]-(b:",
           label_b,
           ") RETURN a, rel, b")
  }
  
  print(query) # for debugging - prints query in the console
  
  # query database
  dat <- query %>%
    call_neo4j(con, type = "graph")
  
  if (length(dat) == 0) {
    return(dat)
  } else {
  # process nodes table
  nodes <- dat$nodes
  nodes$title <- dat$nodes$id
  nodes$group <- dat$nodes$label
  
  # process relationships table
  relationships <- dat[["relationships"]] %>%
    select(from = startNode, to = endNode, label = type)
  
  # create table of properties for each label 
  nodes_detail <- dat$nodes %>%
    unnest(cols = "label") %>% 
    unnest(cols = "properties") %>% 
    mutate(key = names(properties)) %>% 
    select(id, label, key, value = properties)
  
  # create table of properties for each node id (labels remain nested)
  props <- nodes %>% unnest(cols = "properties")
  properties <- tibble(id = props$id,
                       label = props$label,
                       key = names(props$properties),
                       value = props$properties)
  
  # create table of locations (not all nodes contain spatial data)
  location <- properties %>% 
    filter(key == "location")
  
  if(dim(location)[[1]] > 0){ # only process location table if it contains data
    location <- location %>% 
      unnest_wider(value) %>%
      unnest_wider(coordinates) %>%
      rename(longitude = ...1, latitude = ...2)
    
    # convert positive longitudes to negative longitudes
    # IMPORTANT: THIS IF FOR THE DEMO, SHOULD CHECK TO SEE IF THEY ARE 
    # TRULY POSITIVE IF USING IN PRODUCTION
    location$longitude <- -abs(location$longitude)
  }
  
  # combine tables and return
  list(nodes = nodes, 
              nodes_detail = nodes_detail,
              relationships = relationships, 
              properties = properties, 
              location = location)
  }
}
