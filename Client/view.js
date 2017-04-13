
module.exports = {
  getPodcastsAndUpdate: getPodcastsAndUpdate
}

function getPodcastsAndUpdate(podcasts){
  if(podcasts){
    $('#most-recent-image').attr('src',podcasts[0].image_url)
    $('#most-recent-subtitle').text(podcasts[0].title)
    $('#most-recent-description').text('').text(podcasts[0].summary)
    $('#player').attr('src', podcasts[0].media_url)

    podcasts.slice(1).forEach(updatePodcast)
  }
};

function updatePodcast(podcast, index){
  console.log("update podcast")
  console.log(podcast)
  $('#podcast-' + index + '.h2').text(podcast.title)
  $('#podcast-' + index + '.img').attr('src', podcast.image_url)
};
