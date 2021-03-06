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

function filter(){
  var searchString = $('#search-input').val().toUpperCase()
  var podcasts = $('#archive-div').children()
  for(var i = 0; i < podcasts.length; i++){
    var h3 = podcasts[i].getElementsByTagName('h3')
    if (h3[0].innerHTML.toUpperCase().indexOf(searchString) > -1) {
           podcasts[i].style.display = "";
       } else {
           podcasts[i].style.display = "none";
       }
  }
}

function pageDidLoad() {
  api.podcasts.index(makeArchive)
  $('#search-input').keyup(function(){
    filter()
  });
}

$(pageDidLoad)
