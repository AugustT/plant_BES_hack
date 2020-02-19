# AI validated plant observations from social media: Flickr images from central London 2011-2019

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3514685.svg)](https://doi.org/10.5281/zenodo.3514685)

This is the code and data used to create the dataset hosted on Zenodo (click DOI above)

Cite as: August, Tom A, Affouard, Antoine, Bystriakova, Nadia, Fox, Nathan, Marlowe, Celia, Millard, Joseph W, Sanderson, Roy, Bonnet, Pierre, 2019. AI validated plant observations from social media: Flickr images from central London 2011-2019. doi:10.5281/zenodo.3514685

![Untitled](https://user-images.githubusercontent.com/3987564/67211996-86861180-f413-11e9-8052-33b2d80dbe99.png)

This dataset is the result of using an AI image classifer to classify images of plants on social media. We believe this is the first AI validated dataset of biological records taken from social media. This represents the dawn of AI naturalists whose domain of exploration is not the outdoor world but the digital realm. These AI naturalists will trawl streams of data from all over the globe, identifying genuine images of species, and in so doing create valuable data sets that will further our understanding of the distribution of wildlife on our planet. 

This dataset contains 31,973 classifications of images taken in central London between May 2011 and September 2019 retrieved using the search term 'flower' on Flickr.com. Some images have very low classification confidence (7910 below 0.1), while others have very high confidence (3185 over 0.9). As expected given the spatial extent of the dataset many of the observations are of planted species in gardens and parks.

August_et_al_2019.csv provides the data while metadata.txt contains a description of the data and its generation.

An interactive visualisation of this data can be viewed at https://tomaugust.shinyapps.io/ai_flickr_data/
