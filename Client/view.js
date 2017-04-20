
module.exports = {
  getPodcastsAndUpdate: getPodcastsAndUpdate,
  passPodcasts: passPodcasts
}

var allPodcasts = {}

function getPodcastsAndUpdate(start){
    drawMostRecent(allPodcasts[start])
    var j = 1
    for(var i=start - 1; i--; i>=start - 5){
      if(i == 0) return
      console.log("get podcasts and update")
      console.log(allPodcasts[i])
      drawFourPodcasts(allPodcasts[i], j)
      j += 1
    }
};

function passPodcasts(podcasts) {
  allPodcasts = podcasts
}

function addUniqueIdentAndOnClickToPodcast(podcast, index){
  if( $('#recent-header-' + index).hasClass("img[class^='unique-id']")) return 
  $('#recent-image-' + index)
    .addClass("unique-id:" + podcast.id)
    .on('click', function(){
      console.log("Clicked podcast: " + podcast.id)
      getPodcastsAndUpdate(podcast.id)
    });
};

function drawFourPodcasts(podcast, index) {
    console.log("Draw podcast")
    console.log(podcast)
    addUniqueIdentAndOnClickToPodcast(podcast, index)
    $('#recent-header-' + index).text(podcast.title)
    $('#unique-id:' + podcast.id)
      .attr('src', podcast.image_url)
}

function drawMostRecent(podcast) {
  $('#most-recent-image').attr('src',podcast.image_url)
  $('#most-recent-subtitle').text(podcast.title)
  $('#most-recent-description').text('').text(podcast.summary)
  $('#player').attr('src', podcast.media_url)
  return
}
