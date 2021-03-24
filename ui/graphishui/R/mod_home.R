# -------------------------------------------- #
# mod_home                                     #
# Home module - currently just a place holder. #
# -------------------------------------------- #

# ui ---------------------------------------------------------------
mod_home_ui <- function(id) {
  ns <- NS(id)
  fluidRow(
    userBox(
      title = userDescription(
        title = "Samuel Salmon",
        subtitle = "Upstream Swimmer",
        type = 2,
        image = "https://adminlte.io/themes/AdminLTE/dist/img/user1-128x128.jpg",
        ),
      width = 12,
      src = "",
      color = "aqua-active",
      closable = FALSE,
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, 
      quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo 
      consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse 
      cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
      non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      footer = "key words: salmon, biologist, data, restoration"
    )
  )
}

# SERVER ---------------------------------------------------------------
mod_home_server <- function(id) {
  moduleServer(
    id, 
    function(input, output, session){
    }
  )
}