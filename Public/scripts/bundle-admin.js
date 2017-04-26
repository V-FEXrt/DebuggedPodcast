(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var api = require('./api');

var objectUrl;
var audioDuration = "00:00"

function pageDidLoad() {
  setUpSubmit();
  setUpDurationHack();
}

function setUpSubmit(){
  $("#submit-podcast-button").click(function(){

    var author = $('#form-author').val()
    var title = $('#form-title').val()
    var subtitle = $('#form-subtitle').val()
    var summary = $('#form-summary').val()
    var imageData = $('#form-image')[0].files[0]
    var podcastData = $('#form-podcast')[0].files[0]

    var form = new FormData();
    form.append('title', title);
    form.append('subtitle', subtitle);
    form.append('author', author);
    form.append('summary', summary);
    form.append('media_duration', audioDuration);

    if(imageData){
      form.append('image', imageData, imageData.name);
    }

    form.append('media', podcastData, podcastData.name);

    api.podcasts.post(form, function(err, response){
      if(err){
        console.log("Error: err");
        alert("Upload Failed");
        return;
      }
      alert("Upload Complete");
    });
  });
}

function setUpDurationHack(){
  $('#audio').on('canplaythrough', function(e){
      var seconds = e.currentTarget.duration;
      var duration = moment.duration(seconds, 'seconds');

      var time = "";
      var hours = duration.hours();
      if (hours > 0) { time = hours + ":" ; }

      var minutes = duration.minutes();
      if (minutes < 10) { minutes = "0" + minutes }

      var seconds = duration.seconds();
      if(seconds < 10) { seconds = "0" + seconds }

      time = time + minutes + ":" + seconds;
      audioDuration = time;

      URL.revokeObjectURL(objectUrl);
  });

  $('#form-podcast').change(function(e){
    var file = e.currentTarget.files[0];

    objectUrl = URL.createObjectURL(file);
    $('#audio').prop('src', objectUrl);
  });
}


$(pageDidLoad)

},{"./api":2}],2:[function(require,module,exports){
var podcasts = {
    index: function(callback) {
        get("./podcasts/", callback);
    },
    get: function(id, callback) {
        get("./podcasts/" + id, callback);
    },
    post: function(params, callback) {
        createPodcast(params, callback);
    },
    delete: function(id, callback) {
        del("./podcasts/" + id, callback);
    },
    // TODO: Update
}

var metadata = {
    index: function(callback) {
        get("./metadatas/", callback);
    },
    get: function(id, callback) {
        get("./metadatas/" + id, callback);
    },
}

var users = {
    index: function(callback) {
        get("./users/", callback);
    },
    get: function(id, callback) {
        get("./users/" + id, callback);
    },
    post: function(params, callback) {
        post("./users/", params, callback);
    },
    delete: function(id, callback) {
        del("./users/" + id, callback);
    },
    // TODO: Update
}

var login = {
    post: function(email, password, callback) {
        post("./login/", {
            email: email,
            password: password
        }, callback);
    },
}

var utils = {
    login: login
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

function createPodcast(form, callback) {
    $.ajax({
        "async": true,
        "url": "./podcasts/",
        "method": "POST",
        "headers": {
            "cache-control": "no-cache",
        },
        "processData": false,
        "contentType": false,
        "mimeType": "multipart/form-data",
        "data": form,
        success: function(result) {
            callback(false, result);
        },
        error: function(xhr, status, error) {
            callback(JSON.parse(xhr.responseText), false)
        }
    });
}

},{}]},{},[1]);
