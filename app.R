rm(list=ls())
library(shiny)
library(DT)
library(leaflet)
# library(photosearcher)
# library(plantnet)

photo_data <- read.csv('id_results.csv',
                         col.names = c('row','id', 'owner', 'title',
                                     'datetaken', 'latitude',
                                     'longitude', 'url_s', 'score',
                                     'latin_name', 'common_name',
                                     'license_code', 'license', 'url_l'),
                         allowEscapes = TRUE)
# remove duplicates #
photo_data <- dplyr::distinct(photo_data)


# drop the firsrt column
photo_data <- photo_data[,-1]
photo_data$license_code <- as.numeric(as.character(photo_data$license_code))
photo_data$latitude <- as.numeric(as.character(photo_data$latitude))
photo_data$longitude <- as.numeric(as.character(photo_data$longitude))
photo_data$score <- as.numeric(as.character(photo_data$score))

photo_data <- na.omit(photo_data)
nrow(photo_data)

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
      if(as.numeric(score) >= 0.6) {
        "green"
      } else if(as.numeric(score) >= 0.2) {
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
  
  # Add link back to image and attribution
  # https://www.flickr.com/photos/83699771@N00/48428929957
  
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
                                           paste0("<br><b>Score:</b>", round(photo_data$score, digits = 2), ''),
                                           paste0("<br><img src = ", photo_data$url_l,
                                                  " width='400px'>"),
                                           paste0("<br>", photo_data$license),
                                           paste0('<br><a href="',
                                                  paste0('https://www.flickr.com/photos/',
                                                         photo_data$owner, '/',
                                                         photo_data$id),
                                                  '">Owner/Image details</a>')
                                           ),
                            popupOptions = list(keepInView = TRUE,
                                                zoomAnimation = TRUE,
                                                maxWidth = 500))

  output$mymap <- renderLeaflet(map)
  
  output$tableDT <- DT::renderDataTable(photo_data,
                                        quoted = TRUE)

}

shinyApp(ui = ui, server = server)