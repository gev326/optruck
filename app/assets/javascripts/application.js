// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.inputmask
//= require jquery.inputmask.extensions
//= require jquery.inputmask.numeric.extensions
//= require jquery.inputmask.date.extensions
//= require turbolinks
//= require bootstrap-sprockets
//= require underscore
//= require gmaps/google
//= require moment
//= require daterangepicker
//= require_tree .

function get_safe_fields(driver) {
  driver.full_name = full_name(driver);
  var coveredByUser = driver.Covered && driver.covered_name ?
    driver.covered_name :
    '';

  driver.current_location = current_location(driver);
  driver.desired_location = desired_location(driver);
  driver.updated_at = getLastUpdatedInfo(driver);
  driver.PreferredLanes = preferredLanes(driver);
  var truckHightlight = (
    ['48R', '53R', '53RM'].includes(driver.driver_truck_type) ? 'yellow' : ''
  );
  var coveredHighlight1 = driver.Covered ? 'cyan': '';
  var coveredHighlight2 = driver.Covered ? 'red' : '';
  truckHightlight = truckHightlight.length ? truckHightlight : coveredHighlight2;
  return (
    "<tr driver="+driver.id+">"+
    "<td class="+coveredHighlight2+">"+driver.updated_at+"<br/>"+
    driver.last_updated_by+"</td>"+
    "<td class="+coveredHighlight1+">+<a href=drivers/"+driver.id+">"+
    driver.full_name+"</a><div>ID: "+driver.driver_id_tag+"</div></td>"+
    "<td class="+coveredHighlight1+">"+driver.driver_phone+"<span> - "+
    driver.contact_name+"</span></td>"+
    "<td class="+truckHightlight+">"+driver.driver_truck_type+"</td>"+
    "<td class="+coveredHighlight2+">"+driver.driver_availability+"</td>"+
    "<td class="+coveredHighlight2+">"+driver.current_location+"</td>"+
    "<td class="+coveredHighlight2+">"+driver.desired_location+"</td>"+
    "<td class="+coveredHighlight1+">"+driver.driver_status+"</td>"+
    "<td class="+coveredHighlight1+">"+driver.driver_company+"</td>"+
    "<td class="+coveredHighlight1+"><strong>"+coveredByUser+"</strong></td>"+
    "<td class="+coveredHighlight1+">"+driver.PreferredLanes+"</tr>"
  );
}

function get_all_fields(driver) {
  driver.full_name = full_name(driver);
  var coveredByUser = driver.Covered && driver.covered_name ?
    driver.covered_name :
    '';
  driver.current_location = current_location(driver);
  driver.desired_location = desired_location(driver);
  driver.updated_at = getLastUpdatedInfo(driver);
  driver.PreferredLanes = preferredLanes(driver);
  active = driver.active ? 'Answering' : 'Not Answering';
  activeClass = driver.active ? 'green' : 'red';
  var truckHightlight = (
    ['48R', '53R', '53RM'].includes(driver.driver_truck_type) ? 'yellow' : ''
  );
  var coveredHighlight1 = driver.Covered ? 'cyan': '';
  var coveredHighlight2 = driver.Covered ? 'red' : '';
  truckHightlight = truckHightlight.length ? truckHightlight : coveredHighlight2;
  return (
    "<tr driver="+driver.id+">"+
    "<td class="+coveredHighlight2+">"+driver.updated_at+"<br/>"+
    driver.last_updated_by+"</td>"+
    "<td class="+coveredHighlight1+"><a href=drivers/"+driver.id+">"+
    driver.full_name+"</a><div>ID: "+driver.driver_id_tag+"</div></td>"+
    "<td class="+coveredHighlight1+">"+driver.driver_phone+
    "<span> - "+driver.contact_name+"</span></td>"+
    "<td class="+truckHightlight+">"+driver.driver_truck_type+"</td>"+
    "<td class="+coveredHighlight2+">"+driver.driver_availability+"</td>"+
    "<td class="+coveredHighlight2+">"+driver.current_location+"</td>"+
    "<td class="+coveredHighlight2+">"+driver.desired_location+"</td>"+
    "<td class="+activeClass+">"+active+"</td>"+
    "<td class="+coveredHighlight1+">"+driver.driver_status+"</td>"+
    "<td class="+coveredHighlight1+">"+driver.driver_company+"</td>"+
    "<td class="+coveredHighlight1+"><strong>"+coveredByUser+"</strong></td>"+
    "<td class="+coveredHighlight1+">"+driver.PreferredLanes+"</tr>"
  );
}

function getLastUpdatedInfo(driver) {
  return new Date(driver.updated_at).toLocaleTimeString([], {
    hour: '2-digit',
    minute: '2-digit',
    weekday: 'short',
    month: '2-digit',
    day: '2-digit',
    year: '2-digit'
  });
}

function full_name(driver) {
  return ""+driver.first_name+" "+driver.last_name
}

function preferredLanes(driver) {
  return driver.PreferredLanes ?
    driver.PreferredLanes.split(", ").join(" ").replace(/[\"\[\]]/gm, '') :
    "";
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

setInterval(function() {
  var feedVisisble = $("#driver-feed").is(":visible");
  var accountType = $('meta[name=account-type]').attr('content');
  var isDispatcher = accountType === 'dispatcher';
  if (feedVisisble) {
    $.ajax({
      type: "GET",
      url: "/drivers",
      success: function(data) {
        var html = '';
        var shortList = data.drivers.slice(0, 40);
        shortList.forEach(function(d) {
          if (data.covered_drivers[d.id]) {
            d.covered_name = data.covered_drivers[d.id];
          }
          var content = isDispatcher ? get_safe_fields(d) : get_all_fields(d);
          html += content;
        });
        $("#driver-feed").html(html);
      },
      dataType: "json"
    });
  }
}, 15000);
