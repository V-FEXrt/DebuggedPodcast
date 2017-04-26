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
