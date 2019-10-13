library(shiny)
library(DT)
library(leaflet)
# library(photosearcher)
# library(plantnet)

photo_data <- read.csv('id_results.csv',
                         col.names = c('row','id', 'owner', 'title',
                                     'datetaken', 'latitude',
                                     'longitude', 'url_s', 'score',
                                     'latin_name', 'common_name'),
                         allowEscapes = TRUE)

# drop the firsrt column
photo_data <- photo_data[,-1]

ui <- fluidPage(
  titlePanel("AI validated plant observations in London"),
  navbarPage("",
             tabPanel("Map",
                      leafletOutput('mymap', height = '1000px')
                      ),
             tabPanel("Image data",
                      DT::dataTableOutput('tableDT')
                      )
             )
)

server <- function(input,output) {
  
  getColor <- function(photo_data) {
    sapply(photo_data$score, function(score) {
      if(score >= 0.6) {
        "green"
      } else if(score >= 0.2) {
        "orange"
      } else {
        "red"
      } })
  }
  
  icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = getColor(photo_data)
  )
  
  map <- leaflet() %>%
          addTiles() %>%
          setView(-0.142630, 51.501130,  zoom = 14) %>%
          addAwesomeMarkers(data = photo_data,
                            clusterOptions = markerClusterOptions(),
                            lng = photo_data$longitude,
                            lat = photo_data$latitude,
                            icon = icons,
                            popup = paste0(paste('<b>Species:</b>', photo_data$common_name,
                                                 paste0('<i>(', photo_data$latin_name, ')</i>')),
                                           paste0("<p><b>Score:</b>", round(photo_data$score, digits = 2), '</p>'),
                                           paste0("<p><img src = ", photo_data$url_s,
                                                  " width='100%'></p>")),
                            popupOptions = list(keepInView = TRUE,
                                             zoomAnimation = TRUE))

  output$mymap <- renderLeaflet(map)
  
  output$tableDT <- DT::renderDataTable(photo_data,
                                        quoted = TRUE,
                                        extensions = 'Buttons',
                                        options = list( 
                                          dom = "Blfrtip",
                                          buttons = 
                                            list("copy", list(
                                              extend = "collection",
                                              buttons = c("csv", "excel", "pdf"),
                                              text = "Download"
                                            ) ), # end of buttons customization
                                          
                                          # customize the length menu
                                          lengthMenu = list( c(10, 20, -1) # declare values
                                                               , c(10, 20, "All") # declare titles
                                          ), # end of lengthMenu customization
                                          pageLength = 10 
                                        ))

}

shinyApp(ui = ui, server = server)