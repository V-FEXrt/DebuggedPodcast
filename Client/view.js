
module.exports = {
  getPodcastsAndUpdate: getPodcastsAndUpdate,
  passPodcasts: passPodcasts,
  createPodcastArchiveHtml: createPodcastArchiveHtml,
  getRange: getRange
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
  if(podcast) {
    var date = new Date(Date.parse(podcast.publish_date))
    $('#most-recent-image').attr('src', podcast.image_url)
    $('#most-recent-subtitle').text(podcast.title)
    $('#most-recent-label').text('Published: ' + date.toLocaleDateString())
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
      var range = getRange(podcast.id)
      getPodcastsAndUpdate(range)
    });

  var date = (new Date(Date.parse(podcast.publish_date))).toLocaleDateString()

  var label = $('<label>')
    .text("Published: " + date)

  div.append(header)
  div.append(image)
  div.append(label)
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
      window.location.replace("./" + podcast.id)
    });

  var bodyDiv = $('<div>')
    .addClass('col-md-2')

  var header = $('<h3>')
    .attr('id', 'archive-subtitle-' + podcast.id)
    .text(podcast.title)

  var date = (new Date(Date.parse(podcast.publish_date))).toLocaleDateString()

  var label = $('<label>')
    .text("Published: " + date)

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

function getRange(start){
  var range = []
  var sortedPodcasts = Object.keys(allPodcasts).sort(function(a, b){
    return parseInt(a) > parseInt(b)
  });
  var currentIndex = sortedPodcasts.indexOf(start)
  // build array of indexes
  for(var i = 0; i < 5; i++){
    range.push(currentIndex)
    currentIndex = currentIndex - 1
    if(currentIndex < 0 ){
      currentIndex = sortedPodcasts.length - 1
    }
  }
  // build ids
  var ids = []
  for(var j = 0; j < range.length; j++){
      ids.push(sortedPodcasts[range[j]])
  }
  return ids
}

/*
  This snippet of code adds a 'shake' function to a jQuery object. i.e. $("#item").shake()
*/
(function ($) {
    $.fn.shake = function (options) {
        // defaults
        var settings = {
            'shakes': 2,
            'distance': 10,
            'duration': 400
        };
        // merge options
        if (options) {
            $.extend(settings, options);
        }
        // make it so
        var pos;
        return this.each(function () {
            $this = $(this);
            // position if necessary
            pos = $this.css('position');
            if (!pos || pos === 'static') {
                $this.css('position', 'relative');
            }
            // shake it
            for (var x = 1; x <= settings.shakes; x++) {
                $this.animate({ left: settings.distance * -1 }, (settings.duration / settings.shakes) / 4)
                    .animate({ left: settings.distance }, (settings.duration / settings.shakes) / 2)
                    .animate({ left: 0 }, (settings.duration / settings.shakes) / 4);
            }
        });
    };
}(jQuery));
