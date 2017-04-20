var api = require('./api');
var view = require('./view')

var allPodcasts = {}

api.podcasts.index(function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log("podcast index")
  console.log(response)
  convertPodcastsToDict(response)
  view.passPodcasts(allPodcasts)
  view.getPodcastsAndUpdate(response.length - 1)
});

api.podcasts.get(1, function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log("podcast get")
  //console.log(response);
});

function convertPodcastsToDict(podcasts) {
  podcasts.forEach(function(podcast, index){
    allPodcasts[podcast.id] = podcast
  });
  console.log(allPodcasts)
}


/*
var params = {
    title: "Title",
    subtitle : "Subtitle",
    author : "Author",
    summary : "Summary",
    media_duration : "12:34",
    media : null // TODO: This will cause the server to throw an error. This should be the file from the user
}

api.podcasts.post(params, function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log(response);
});
*/

api.metadata.index(function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log("metadata index")
  //console.log(response);
});

api.metadata.get(1, function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log("metadata get")
  //console.log(response);
});

api.utils.login("test@debuggedpodcast.com", "password", function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log("utils login")
  //console.log(response);
});
