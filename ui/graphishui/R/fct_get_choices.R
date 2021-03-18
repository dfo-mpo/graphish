# --------------------------------------------------------------------- #
# fct_get_choices                                                       #
# Retrieves lists of nodes, relationships, and properties from the      #
# database and returns as a list of 3 vectors.                          #
# --------------------------------------------------------------------- #
        
fct_get_choices <- function() {
  
  # connection to Nghia's computer
  con <- neo4j_api$new(
    url = "http://neo4j:7474", #"http://206.47.13.10:7474/",
    user = "neo4j", 
    password = "pskgi"
  )
  
  # create a vector of node labels
  nodes <- "call db.labels" %>%  # query finds all labels in graph
    call_neo4j(con) %>% 
    .[["label"]] %>%             # extract label list object
    pull(value) %>%              # convert tibble of labels to a character vector
    sort()
  
  # create a vector of relationships  
  relationships <- "call db.relationshipTypes" %>% 
    call_neo4j(con) %>% 
    .[["relationshipType"]] %>% 
    pull(value) %>% 
    sort()
  
  # create vector of node properties  
  properties <- "call db.propertyKeys" %>% 
    call_neo4j(con) %>% 
    .[["propertyKey"]] %>% 
    pull(value) %>% 
    sort()
  
  # Create list of vectors and return
  return(list(nodes = nodes, 
              relationships = relationships, 
              properties = properties))
}