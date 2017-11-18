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
    var driver = '';
    var active = '';
    var activeClass = '';
    var html = '';
    var accountType = $('meta[name=account-type]').attr('content');
    var isDispatcher = accountType === 'dispatcher';

    switch (data.msg) {
      case 'add-driver':
        driver = data.driver;
        html = isDispatcher ? get_safe_fields(driver) : get_all_fields(driver);
        if (data.marker) {
          var newMarker = handler.addMarker(data.marker[0]);
          newMarker.serviceObject.set('id', data.marker[0].id);
          Gmaps.store.markers.unshift(newMarker);
        }
        $('#driver-feed').append(html);
        break;
      case 'update-driver':
        driver = data.driver;
        html = isDispatcher ? get_safe_fields(driver) : get_all_fields(driver);
        Gmaps.store.markers = Gmaps.store.markers.filter(function(m) {
          if (m.serviceObject.id === driver.id) handler.removeMarker(m);
          return m.serviceObject.id != driver.id;
        });
        if (data.marker) {
          var newMarker = handler.addMarker(data.marker[0]);
          newMarker.serviceObject.set('id', data.marker[0].id);
          Gmaps.store.markers.unshift(newMarker);
        }
        $("tr[driver="+driver.id+"]").html(html);
        break;
      case 'delete-driver':
        Gmaps.store.markers = Gmaps.store.markers.filter(function(m) {
          if (m.serviceObject.id === data.id) handler.removeMarker(m);
          return m.serviceObject.id != data.id;
        });
        $("tr[driver="+data.id+"]").remove();
        break;
      default:
        break;
    }
  }
});

function get_safe_fields(driver) {
  driver.full_name = full_name(driver);
  driver.current_location = current_location(driver);
  driver.desired_location = desired_location(driver);
  return "<tr driver="+driver.id+"><td><a href=drivers/"+driver.id+">"+driver.full_name+"</a></td><td>"+driver.driver_phone+"</td><td>"+driver.driver_truck_type+"</td><td>"+driver.driver_availability+"</td><td>"+driver.current_location+"</td><td>"+driver.desired_location+"</td><td>"+driver.driver_status+"</td><td>"+driver.lang+"</td><td>"+driver.driver_company+"</td></tr>";
}

function get_all_fields(driver) {
  driver.full_name = full_name(driver);
  driver.current_location = current_location(driver);
  driver.desired_location = desired_location(driver);
  active = driver.active ? 'yes' : 'no';
  activeClass = driver.active ? 'success' : 'danger';
  return "<tr driver="+driver.id+"><td><a href=drivers/"+driver.id+">"+driver.full_name+"</a></td><td>"+driver.driver_phone+"</td><td>"+driver.driver_truck_type+"</td><td>"+driver.driver_availability+"</td><td>"+driver.current_location+"</td><td>"+driver.desired_location+"</td><td class="+activeClass+">"+active+"</td><td>"+driver.driver_status+"</td><td>"+driver.lang+"</td><td>"+driver.driver_company+"</td></tr>";
}

function full_name(driver) {
  return ""+driver.first_name+" "+driver.last_name
}

function current_location(driver) {
  if (driver.current_city && driver.current_state) {
    return ""+driver.current_city+", "+driver.current_state;
  } else if (driver.current_city) {
    return driver.current_city;
  } else if (driver.current_state) {
    return driver.current_state;
  } else {
    return "";
  }
}

function desired_location(driver) {
  if (driver.desired_city && driver.desired_state) {
    return ""+driver.desired_city+", "+driver.desired_state;
  } else if (driver.desired_city) {
    return driver.desired_city;
  } else if (driver.desired_state) {
    return driver.desired_state;
  } else {
    return "";
  }
}
