

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

var login = {
  post: function(email, password, callback) { post("./login/", { email: email, password: password }, callback); },
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
