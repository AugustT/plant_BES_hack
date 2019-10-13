# Setup script
library(photosearcher)
library(plantnet)

# Set up tokens
source('toms_tokens.R')
tokens <- toms_tokens()

# Get the image data
photo_meta <- photo_search(mindate_taken = "2000-03-01",
                           maxdate_taken = "2019-10-01",
                           text = "flower",
                           # tags = "flower",
                           bbox = "-0.312836,51.439050,-0.005219,51.590237")

#lake district# bbox = "-3.463,54.206,-2.639,54.749"
#london# bbox = "-0.312836,51.439050,-0.005219,51.590237"

nrow(photo_meta)

# x <- T
# while(x){
#   browseURL(photo_meta$url_s[runif(1, 1, nrow(photo_meta))])
#   l <- readline()
#   if(l=='e') x <- F
# }

write.csv(file = 'photo_metadata.csv',
          x = photo_meta)

###############
# repeat runs #
###############

photo_meta <- read.csv('photo_metadata.csv')
photo_meta$datetaken <- as.Date(photo_meta$datetaken)
photo_meta <- photo_meta[order(photo_meta$datetaken, decreasing = TRUE),]

nrow(photo_meta)

ided_already <- read.csv('id_results.csv', header = FALSE)
ided_already$V5 <- as.Date(ided_already$V5, format = '%d/%m/%Y %H:%M')

photo_meta <- photo_meta[!photo_meta$id %in% ided_already$V2,]
nrow(photo_meta)

# Classify these images and save as we go
browseURL(as.character(photo_meta$url_l[2]))

for(i in 1:5000){#nrow(photo_meta)){
  cat('image', i,'\n')
  id <- identify(key = tokens$plantnet,
                 imageURL = as.character(photo_meta$url_l[i]))
  if(length(id) > 1){ # we have an id... else we dont
    id_full <- c(photo_meta[i, c('id', 'owner', 'title',
                                 'datetaken', 'latitude',
                                 'longitude', 'url_s')],
                 id[1,])
    write.table(file = 'id_results.csv',
                x = id_full,
                sep = ',',
                append = TRUE,
                col.names = FALSE,
                quote = TRUE)  
  }
}