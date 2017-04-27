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
  console.log(searchString)
  var podcasts = $('#archive-div').children()
  console.log(podcasts)
  for(var i = 0; i < podcasts.length; i++){
    var h3 = podcasts[i].getElementsByTagName('h3')
    console.log(h3[0].innerHTML)
    if (h3[0].innerHTML.toUpperCase().indexOf(searchString) > -1) {
           console.log(h3[0].innerHTML.toUpperCase().indexOf(searchString))
           console.log("match")
           podcasts[i].style.display = "";
       } else {
           console.log(h3[0].innerHTML.toUpperCase().indexOf(searchString))
           console.log("non match")
           podcasts[i].style.display = "none";
       }
  }
  console.log($("h3:contains(searchString)"))
}

function pageDidLoad() {
  api.podcasts.index(makeArchive)
  $('#search-input').keyup(function(){
    filter()
  });
}

$(pageDidLoad)
