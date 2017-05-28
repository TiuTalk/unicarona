//= require turbolinks
//= require jquery
//= require jquery-ujs
//= require tether
//= require bootstrap/dist/js/bootstrap

function showToast(message) {
  if (typeof variable !== 'undefined') {
    Android.showToast(message);
  } else {
    alert(message);
  }
}

$(document).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip();

  // Toggle sidebar
  $('[data-toggle="sidebar"]').on('click', function(e) {
    e.preventDefault();
    $('#wrapper').toggleClass('toggled');
  });

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

function initMap() {
  $('[data-map-origin]').each(function() {
    var directionsService = new google.maps.DirectionsService;
    var directionsDisplay = new google.maps.DirectionsRenderer;
    var map = new google.maps.Map(this, { zoom: 6 });

    var origin = $(this).data('map-origin'),
      destination = $(this).data('map-destination');

    directionsDisplay.setMap(map);
    calculateAndDisplayRoute(directionsService, directionsDisplay, origin, destination);
  });
}

function calculateAndDisplayRoute(directionsService, directionsDisplay, origin, destination) {
  directionsService.route({
    origin: origin,
    destination: destination,
    optimizeWaypoints: true,
    travelMode: 'DRIVING'
  }, function(response, status) {
    if (status === 'OK') {
      directionsDisplay.setDirections(response);
    } else {
      window.alert('Directions request failed due to ' + status);
    }
  });
}

function callFromActivity(method, message) {
  if (method == 'setDeviceToken') {
    var data = { token: message };
    $.post('/users/set_device_token.json', data);
  }
}
