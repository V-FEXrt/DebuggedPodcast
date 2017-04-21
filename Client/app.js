var api = require('./api');
var view = require('./view')


function makeIndex(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  var allPodcasts = {}
  allPodcasts = convertPodcastsToDict(response)
  view.passPodcasts(allPodcasts)
  view.getPodcastsAndUpdate(response.slice(response.length - 5, response.length).reverse().map(function(podcast){
    return podcast.id
  }))
}

function convertPodcastsToDict(podcasts) {
  allPodcasts = {}
  podcasts.forEach(function(podcast, index){
    allPodcasts[podcast.id] = podcast
  });
  return allPodcasts
}

function pageDidLoad() {
  api.podcasts.index(makeIndex);

  $("#site-header-image").click(function(){
    api.podcasts.index(makeIndex);
  });

  $("#admin-login-submit").click(function() {
    var email = $("#admin-login-email").val()
    var password = $("#admin-login-password").val()

    api.utils.login.post(email, password, function(err, response){
      if(err){
        $("#admin-login-modal").shake();
        return;
      }

      $("#admin-login-modal").modal('hide');

      setTimeout(function(){
        window.location.replace("./admin");
      }, 1000)

    })
  });
}

$(pageDidLoad)
