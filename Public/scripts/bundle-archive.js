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

api.podcasts.index(makeArchive)

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

},{"./api":1,"./view":3}],3:[function(require,module,exports){

module.exports = {
  getPodcastsAndUpdate: getPodcastsAndUpdate,
  passPodcasts: passPodcasts,
  createPodcastArchiveHtml: createPodcastArchiveHtml
}

var allPodcasts = {}


function getPodcastsAndUpdate(podcastIds){
    $("#podcasts-row").empty()
    $("#podcasts-row").append('<div class="col-lg-36"><h3 class="page-header">Less Recent Podcasts</h3></div>')
    drawMostRecent(allPodcasts[podcastIds[0]])
    podcastIds.slice(1).forEach(function(id, index){
      createPodcastHTML(allPodcasts[id], (index + 1))
    });
};

function passPodcasts(podcasts) {
  allPodcasts = podcasts
}

function drawMostRecent(podcast) {
  console.log(podcast)
  if(podcast) {
    $('#most-recent-image').attr('src', podcast.image_url)
    $('#most-recent-subtitle').text(podcast.title)
    $('#most-recent-description').text('').text(podcast.summary)
    $('#player').attr('src', podcast.media_url)
    return
  }
}

function createPodcastHTML(podcast, index) {
  var div = $('<div>')
    .addClass("col-sm-3")
    .addClass("col-xs-6")

  var header = $('<h2>')
    .attr("id", "recent-header-" + index)
    .text(podcast.title)

  var image = $('<img>')
    .attr("id", "recent-image-" + index)
    .addClass("unique-id:" + podcast.id)
    .addClass("img-responsive")
    .addClass("portfolio-item")
    .attr('src', podcast.image_url)
    .on('click', function(){
      var range = []
      for(var i = podcast.id; (i > podcast.id - 5) && (i > 0); i--) {
        range.push(i)
      }
      getPodcastsAndUpdate(range)
    });

  div.append(header)
  div.append(image)
  $("#podcasts-row").append(div)
}

function createPodcastArchiveHtml(podcast) {
  var div = $('<div>')
    .addClass('col-md-12')
    .addClass('unique-id:' + podcast.id)

  var image = $('<img>')
    .addClass("img-responsive")
    .addClass("portfolio-item")
    .attr('src', podcast.image_url)
    .on('click', function(){
      var range = []
      for(var i = podcast.id; (i > podcast.id - 5) && (i > 0); i--) {
        range.push(i)
      }
      console.log(range)
      getPodcastsAndUpdate(range)
    });

  var bodyDiv = $('<div>')
    .addClass('col-md-2')

  var header = $('<h3>')
    .attr('id', 'archive-subtitle-' + podcast.id)
    .text(podcast.title)

  var label = $('<label>')
    .text("Published: " + podcast.publish_date)

  var body = $('<p>')
    .attr('id', 'archive-description-' + podcast.id)
    .text(podcast.summary)

  bodyDiv.append(image)
  div.append(bodyDiv)
  div.append(header)
  div.append(label)
  div.append(body)

  $('#archive-div').append(div)
}

},{}]},{},[2]);
