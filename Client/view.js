
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
