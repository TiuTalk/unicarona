//= require turbolinks
//= require jquery
//= require jquery-ujs
//= require tether
//= require bootstrap/dist/js/bootstrap

$(document).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip();

  if ($('body').hasClass('routes_search')) {
    var $search_form = $('form[data-search-route]');

    // Disable the submit to fetch the position
    $search_form.find(':submit').attr('disabled', true);

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };

        $search_form.find('#route_origin').val(pos.lat + ',' + pos.lng);

        // Enable the submit again
        $search_form.find(':submit').attr('disabled', false);
      }, function() {
        console.log('FAIL');
      });
    } else {
      console.log('ERROR');
    }
  }
});
