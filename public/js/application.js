$(document).ready(function(){

  // ('a#user').addClass("hidden")

  $("#create_new").on("click", function(event){
    event.preventDefault();

    // console.log("hello");

    var div = $('#add_form')
    var attribute = $("a#user").attr("href");
    var url = "/create/event/"+attribute""

    var createEvent = "<form id='event' action=''+url+'' method='POST'><input type='text' name='name'><input id='location' type='text' name='location'><input id='starts_at' type='datetime' name='starts_at'><input id='ends_at' type='datetime' name='ends_at'><input id='new_event' type='submit' value='CREATE EVENT!'></form>"

    $(div).html(crEve);


  })


  $('#new_event').on('submit', function(event){

    event.preventDefault();

    // var data = $('#event').serialize();


    var name = $(#name).val();
    var location = $(#location).val();
    var starts_at = $(#starts_at).val();
    var ends_at = $(#ends_at).val();
    var form_url = $('#event').attr("action");

    var data = {name: name, location: location, starts_at: starts_at, ends_at: ends_at}

    $.post(form_url, data, function(response){
      (".container").html(response)
    })
  })


});
