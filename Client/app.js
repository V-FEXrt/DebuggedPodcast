var api = require('./api');
var view = require('./view')

api.podcasts.index(function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log("podcast index")
  view.getPodcastsAndUpdate(response, response.length - 1)
  linkPodcastsToUpdateSet(response)
});

api.podcasts.get(1, function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log("podcast get")
  //console.log(response);
});

function linkPodcastsToUpdateSet(podcasts){
    podcasts.forEach(function(podcast, index){
      $("#unique-id:" + podcast.id).on('click', function(){
        view.getPodcastsAndUpdate(podcasts, podcast.id)
      });
    });
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
