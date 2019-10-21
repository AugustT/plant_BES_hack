rm(list = ls())
photo_data <- read.csv('id_results.csv',
                       col.names = c('row','image_id', 'owner_id', 'title',
                                     'datetaken', 'latitude',
                                     'longitude', 'url_small_image',
                                     'classification_score',
                                     'latin_name', 'common_name_english',
                                     'image_license_code', 'image_license', 'url_large_image'),
                       allowEscapes = TRUE)
# remove duplicates #
photo_data <- dplyr::distinct(photo_data)


# drop the firrt column
photo_data <- photo_data[,-1]
photo_data$license_code <- as.numeric(as.character(photo_data$image_license_code))
photo_data$latitude <- as.numeric(as.character(photo_data$latitude))
photo_data$longitude <- as.numeric(as.character(photo_data$longitude))
photo_data$classification_score <- as.numeric(as.character(photo_data$classification_score))

# sort out the dates
dates <- as.character(photo_data$datetaken)

# remove the time from the dates that have them
dates <- gsub('[[:space:]][[:digit:]]{2}:[[:digit:]]{2}$', '', dates)
dates <- as.Date(dates, format = '%d/%m/%Y')
photo_data$datetaken <- dates

photo_data <- na.omit(photo_data)

photo_data$image_information_link <- paste0('https://www.flickr.com/photos/',
                                            photo_data$owner_id, '/',
                                            photo_data$image_id)

write.csv(photo_data,
          file = 'August_et_al_2019.csv', 
          row.names = FALSE)

range(photo_data$datetaken)

hist(photo_data$datetaken, breaks = 100)

# plot histogram for slide
hist(photo_data$classification_score, col = 'darkgrey',
     main = 'Distibution of classification score',
     xlab = 'Score')

# Get sample images for slide
# Good images
samp <- dplyr::sample_n(photo_data[photo_data$classification_score>0.9 &
                                           grepl('^Attribution', as.character(photo_data$license)),],
                6)
paste0('https://www.flickr.com/photos/',
       samp$owner, '/',
       samp$id)
# how many?
nrow(photo_data[photo_data$classification_score > 0.9, ])

# bad images
samp<-dplyr::sample_n(photo_data[photo_data$classification_score<0.1 &
                                         grepl('^Attribution', as.character(photo_data$license)),],
                      6)
paste0('https://www.flickr.com/photos/',
       samp$owner, '/',
       samp$id)
nrow(photo_data[photo_data$classification_score < 0.1, ])
