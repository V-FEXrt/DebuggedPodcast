
module.exports = {
  getPodcastsAndUpdate: getPodcastsAndUpdate
}

function getPodcastsAndUpdate(podcasts, start){
  if(podcasts){
    $('#most-recent-image').attr('src',podcasts[start].image_url)
    $('#most-recent-subtitle').text(podcasts[start].title)
    $('#most-recent-description').text('').text(podcasts[start].summary)
    $('#player').attr('src', podcasts[start].media_url)

    podcasts.slice(start - 5, start - 1).reverse().forEach(updatePodcast)
  }
};

function updatePodcast(podcast, index){
  console.log("update podcast")
  console.log(podcast)
  $('#recent-header-' + (index + 1)).text(podcast.title)
  $('#recent-image-' + (index + 1)).attr('src', podcast.image_url)
};
