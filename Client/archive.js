var api = require('./api');
var view = require('./view')

function makeArchive(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  var allPodcasts = {}
  allPodcasts = convertPodcastsToDict(response)
  view.passPodcasts(allPodcasts)
  drawArchivePage(allPodcasts)
}

function convertPodcastsToDict(podcasts) {
  allPodcasts = {}
  podcasts.forEach(function(podcast, index){
    allPodcasts[podcast.id] = podcast
  });
  return allPodcasts
}

function drawArchivePage(podcasts){
  $('#archive-div').empty()
  var keys = Object.keys(podcasts)
  keys.reverse().forEach(function(key, index){
    view.createPodcastArchiveHtml(podcasts[key])
  });
}

function pageDidLoad() {
  api.podcasts.index(makeArchive)
}

$(pageDidLoad)
