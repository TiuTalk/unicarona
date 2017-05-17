//= require turbolinks
//= require jquery
//= require jquery-ujs
//= require tether
//= require bootstrap/dist/js/bootstrap

$(document).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip();

  $('[data-geolocate]').on('click', function(e) {
    e.preventDefault();

    var $target = $($(this).data('geolocate'));

    if ($target.length && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };

        $target.val(pos.lat + ',' + pos.lng);
      }, function() {
        console.log('FAIL');
      });
    } else {
      console.log('ERROR');
    }
  });
});
