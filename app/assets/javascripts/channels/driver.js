App.driver = App.cable.subscriptions.create("DriverChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    if (!$("#map").is(":visible")) return;
    var meta = document.querySelector('meta[name="current_user"]');
    var user = meta.getAttribute('content');
    var driver = '';
    var active = '';
    var activeClass = '';
    var covered = '';
    var coveredClass = '';
    var html = '';

    switch (data.msg) {
      case 'add-driver':
        driver = data.driver;
        driver.full_name = full_name(driver);
        driver.full_address = full_address(driver);
        active = driver.active ? 'yes' : 'no';
        activeClass = driver.active ? 'success' : 'danger';
        covered = data.covered_name ? data.covered_name : 'no';
        coveredClass = driver.Covered ? 'success' : 'danger';
        html = `<tr id=${driver.id}><td>${driver.full_name}</td><td>${driver.full_address}</td><td>${driver.desired_city}</td><td>${driver.desired_state}</td><td>${driver.driver_id_tag}</td><td>${driver.driver_phone}</td><td>${driver.driver_truck_type}</td><td class=${activeClass}>${active}</td><td>${driver.driver_status}</td><td>${driver.driver_contract_number}</td><td>${driver.driver_availability}</td><td>${driver.driver_company}</td><td>${driver.comments}</td><td class=${coveredClass}>${covered}</td><td>${driver.PlateTrailer}</td><td>${driver.Etrac}</td><td>${driver.PreferredLanes}</td><td>${driver.reeferunit}</td><td>${driver.insurance}</td>`;
        if (user === 'admin' || user === 'updater') {
          var extended = `<td><a href=drivers/${driver.id}> Show </a></td><td><a href=drivers/${driver.id}/edit> Edit </a></td><td><a data-confirm="Are you sure?" data-method="delete" href=drivers/${driver.id}> Destroy </a></td></tr>`;
          html += extended;
        } else {
          html += `</tr>`
        }
        if (data.marker) {
          var newMarker = handler.addMarker(data.marker[0]);
          newMarker.serviceObject.set('id', data.marker[0].id);
          Gmaps.store.markers.unshift(newMarker);
        }
        $('#driver-feed').append(html);
        break;
      case 'update-driver':
        driver = data.driver;
        driver.full_name = full_name(driver);
        driver.full_address = full_address(driver);
        active = driver.active ? 'yes' : 'no';
        activeClass = driver.active ? 'success' : 'danger';
        covered = data.covered_name ? data.covered_name : 'no';
        coveredClass = driver.Covered ? 'success' : 'danger';
        html = `<td>${driver.full_name}</td><td>${driver.full_address}</td><td>${driver.desired_city}</td><td>${driver.desired_state}</td><td>${driver.driver_id_tag}</td><td>${driver.driver_phone}</td><td>${driver.driver_truck_type}</td><td class=${activeClass}>${active}</td><td>${driver.driver_status}</td><td>${driver.driver_contract_number}</td><td>${driver.driver_availability}</td><td>${driver.driver_company}</td><td>${driver.comments}</td><td class=${coveredClass}>${covered}</td><td>${driver.PlateTrailer}</td><td>${driver.Etrac}</td><td>${driver.PreferredLanes}</td><td>${driver.reeferunit}</td><td>${driver.insurance}</td>`;
        if (user === 'admin' || user === 'updater') {
          var extended = `<td><a href=drivers/${driver.id}> Show </a></td><td><a href=drivers/${driver.id}/edit> Edit </a></td><td><a data-confirm="Are you sure?" data-method="delete" href=drivers/${driver.id}> Destroy </a></td>`;
          html += extended;
        }
        Gmaps.store.markers = Gmaps.store.markers.filter(function(m) {
          if (m.serviceObject.id === driver.id) handler.removeMarker(m);
          return m.serviceObject.id != driver.id;
        });
        if (data.marker) {
          var newMarker = handler.addMarker(data.marker[0]);
          newMarker.serviceObject.set('id', data.marker[0].id);
          Gmaps.store.markers.unshift(newMarker);
        }
        $(`tr[driver=${driver.id}]`).html(html);
        break;
      case 'delete-driver':
        Gmaps.store.markers = Gmaps.store.markers.filter(function(m) {
          if (m.serviceObject.id === data.id) handler.removeMarker(m);
          return m.serviceObject.id != data.id;
        });
        $(`tr[driver=${data.id}]`).remove();
        break;
      default:
        break;
    }
  }
});

function full_name(driver) {
  return `${driver.first_name} ${driver.last_name}`
}

function full_address(driver) {
  if (driver.current_city && driver.current_state) {
    return `${driver.current_city}, ${driver.current_state}`;
  } else if (driver.current_city) {
    return `${driver.current_city}`;
  } else if (driver.current_state) {
    return `${driver.current_state}`;
  } else {
    return "";
  }
}
