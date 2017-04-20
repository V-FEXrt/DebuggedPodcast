(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){


var podcasts = {
    index: function(callback) { get("./podcasts/", callback); },
    get: function(id, callback) { get("./podcasts/" + id, callback); },
    post: function(params, callback) { post("./podcasts/", params, callback); },
    delete: function(id, callback) { del("./podcasts/" + id, callback); },
    // TODO: Update
}

var metadata = {
  index: function(callback) { get("./metadatas/", callback); },
  get: function(id, callback) { get("./metadatas/" + id, callback); },
}

var users = {
    index: function(callback) { get("./users/", callback); },
    get: function(id, callback) { get("./users/" + id, callback); },
    post: function(params, callback) { post("./users/", params, callback); },
    delete: function(id, callback) { del("./users/" + id, callback); },
    // TODO: Update
}

var utils = {
  login: function(email, password, callback) {
    post("./login/", {
      email: email,
      password: password
    }, callback);
  }
}

module.exports = {
    podcasts: podcasts,
    metadata: metadata,
    users: users,
    utils: utils
};

function get(url, callback) {
  $.ajax({
      "url": url,
      success: function(result) {
        callback(false, result);
      },
      error: function(xhr, status, error) {
          callback(JSON.parse(xhr.responseText), false)
      }
  });
}

function post(url, params, callback) {
    $.ajax({
        url: url,
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(params),
        dataType: "json",
        success: function(result) {
          callback(false, result);
        },
        error: function(xhr, status, error) {
          callback(JSON.parse(xhr.responseText), false)
        }
    });
}

function del(url, callback) {
    $.ajax({
        url: url,
        type: "DELETE",
        contentType: "application/json",
        success: function(result) {
          callback(false, result);
        },
        error: function(xhr, status, error) {
          callback(JSON.parse(xhr.responseText), false)
        }
    });
}

},{}],2:[function(require,module,exports){
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

},{"./api":1,"./view":3}],3:[function(require,module,exports){

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

},{}]},{},[2]);
