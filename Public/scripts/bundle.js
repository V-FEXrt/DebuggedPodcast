(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){


var podcasts = {
    index: function(callback) { get("./podcasts/", callback); },
    get: function(id, callback) { get("./podcasts/" + id, callback); },
    post: function(params, callback) { post("./podcasts/", params, callback); },
    delete: function(id, callback) { del("./podcasts/" + id, callback); },
    // TODO: Delete
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
    // TODO: Delete
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
window.api = api;

api.podcasts.index(function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log(response);
});

api.podcasts.get(1, function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log(response);
});

/*
var params = {
    title: "Title",
    subtitle : "Subtitle",
    author : "Author",
    summary : "Summary",
    media_duration : "12:34",
    media : null // TODO: This will cause the server to throw an err. This should be the file from the user
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
  console.log(response);
});

api.metadata.get(1, function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log(response);
});

api.utils.login("test@debuggedpodcast.com", "password", function(err, response){
  if(err){
    console.log(err.message);
    return;
  }
  console.log(response);
});

},{"./api":1}]},{},[2]);
