// App.driver = App.cable.subscriptions.create("DriverChannel", {
//   connected: function() {
//     // Called when the subscription is ready for use on the server
//   },

//   disconnected: function() {
//     // Called when the subscription has been terminated by the server
//   },

//   received: function(data) {
//     // Called when there's incoming data on the websocket for this channel
//     var mapVisible = $("#map").is(":visible");
//     var feedVisisble = $("#driver-feed").is(":visible");
//     var driver = '';
//     var active = '';
//     var activeClass = '';
//     var html = '';
//     var el = '';
//     var accountType = $('meta[name=account-type]').attr('content');
//     var isDispatcher = accountType === 'dispatcher';

//     switch (data.msg) {
//       case 'add-driver':
//         driver = data.driver;
//         html = isDispatcher ? get_safe_fields(driver) : get_all_fields(driver);
//         if (data.marker && mapVisible) {
//           var newMarker = handler.addMarker(data.marker[0]);
//           newMarker.serviceObject.set('id', data.marker[0].id);
//           Gmaps.store.markers.unshift(newMarker);
//         }
//         if (feedVisisble) {
//           $('#driver-feed').append(html);
//         }
//         break;
//       case 'update-driver':
//         driver = data.driver;
//         if (data.covered_name) { driver.covered_name = data.covered_name; }
//         html = isDispatcher ? get_safe_fields(driver) : get_all_fields(driver);
//         if (mapVisible) {
//           Gmaps.store.markers = Gmaps.store.markers.filter(function(m) {
//             if (m.serviceObject.id === driver.id) handler.removeMarker(m);
//             return m.serviceObject.id != driver.id;
//           });
//           if (data.marker) {
//             var newMarker = handler.addMarker(data.marker[0]);
//             newMarker.serviceObject.set('id', data.marker[0].id);
//             Gmaps.store.markers.unshift(newMarker);
//           }
//         }
//         el = $("tr[driver="+driver.id+"]");
//         if (el) { el.replaceWith(html); }
//         break;
//       case 'delete-driver':
//         if (mapVisible) {
//           Gmaps.store.markers = Gmaps.store.markers.filter(function(m) {
//             if (m.serviceObject.id === data.id) handler.removeMarker(m);
//             return m.serviceObject.id != data.id;
//           });
//         }
//         el = $("tr[driver="+data.id+"]");
//         if (el) { el.remove(); }
//         break;
//       default:
//         break;
//     }
//   }
// });

// function get_safe_fields(driver) {
//   driver.full_name = full_name(driver);
//   var coveredByUser = driver.Covered && driver.covered_name ?
//     driver.covered_name :
//     '';

//   driver.current_location = current_location(driver);
//   driver.desired_location = desired_location(driver);
//   driver.updated_at = getLastUpdatedInfo(driver);
//   driver.PreferredLanes = preferredLanes(driver);
//   var truckHightlight = (
//     ['48R', '53R', '53RM'].includes(driver.driver_truck_type) ? 'yellow' : ''
//   );
//   var coveredHighlight1 = driver.Covered ? 'cyan': '';
//   var coveredHighlight2 = driver.Covered ? 'red' : '';
//   truckHightlight = truckHightlight.length ? truckHightlight : coveredHighlight2;
//   return (
//     "<tr driver="+driver.id+">"+
//     "<td class="+coveredHighlight2+">"+driver.updated_at+"<br/>"+
//     driver.last_updated_by+"</td>"+
//     "<td class="+coveredHighlight1+">+<a href=drivers/"+driver.id+">"+
//     driver.full_name+"</a><div>ID: "+driver.driver_id_tag+"</div></td>"+
//     "<td class="+coveredHighlight1+">"+driver.driver_phone+"<span> - "+
//     driver.contact_name+"</span></td>"+
//     "<td class="+truckHightlight+">"+driver.driver_truck_type+"</td>"+
//     "<td class="+coveredHighlight2+">"+driver.driver_availability+"</td>"+
//     "<td class="+coveredHighlight2+">"+driver.current_location+"</td>"+
//     "<td class="+coveredHighlight2+">"+driver.desired_location+"</td>"+
//     "<td class="+coveredHighlight1+">"+driver.driver_status+"</td>"+
//     "<td class="+coveredHighlight1+">"+driver.driver_company+"</td>"+
//     "<td class="+coveredHighlight1+"><strong>"+coveredByUser+"</strong></td>"+
//     "<td class="+coveredHighlight1+">"+driver.PreferredLanes+"</tr>"
//   );
// }

// function get_all_fields(driver) {
//   driver.full_name = full_name(driver);
//   var coveredByUser = driver.Covered && driver.covered_name ?
//     driver.covered_name :
//     '';
//   driver.current_location = current_location(driver);
//   driver.desired_location = desired_location(driver);
//   driver.updated_at = getLastUpdatedInfo(driver);
//   driver.PreferredLanes = preferredLanes(driver);
//   active = driver.active ? 'Answering' : 'Not Answering';
//   activeClass = driver.active ? 'green' : 'red';
//   var truckHightlight = (
//     ['48R', '53R', '53RM'].includes(driver.driver_truck_type) ? 'yellow' : ''
//   );
//   var coveredHighlight1 = driver.Covered ? 'cyan': '';
//   var coveredHighlight2 = driver.Covered ? 'red' : '';
//   truckHightlight = truckHightlight.length ? truckHightlight : coveredHighlight2;
//   return (
//     "<tr driver="+driver.id+">"+
//     "<td class="+coveredHighlight2+">"+driver.updated_at+"<br/>"+
//     driver.last_updated_by+"</td>"+
//     "<td class="+coveredHighlight1+"><a href=drivers/"+driver.id+">"+
//     driver.full_name+"</a><div>ID: "+driver.driver_id_tag+"</div></td>"+
//     "<td class="+coveredHighlight1+">"+driver.driver_phone+
//     "<span> - "+driver.contact_name+"</span></td>"+
//     "<td class="+truckHightlight+">"+driver.driver_truck_type+"</td>"+
//     "<td class="+coveredHighlight2+">"+driver.driver_availability+"</td>"+
//     "<td class="+coveredHighlight2+">"+driver.current_location+"</td>"+
//     "<td class="+coveredHighlight2+">"+driver.desired_location+"</td>"+
//     "<td class="+activeClass+">"+active+"</td>"+
//     "<td class="+coveredHighlight1+">"+driver.driver_status+"</td>"+
//     "<td class="+coveredHighlight1+">"+driver.driver_company+"</td>"+
//     "<td class="+coveredHighlight1+"><strong>"+coveredByUser+"</strong></td>"+
//     "<td class="+coveredHighlight1+">"+driver.PreferredLanes+"</tr>"
//   );
// }

// function getLastUpdatedInfo(driver) {
//   return new Date(driver.updated_at).toLocaleTimeString([], {
//     hour: '2-digit',
//     minute: '2-digit',
//     weekday: 'short',
//     month: '2-digit',
//     day: '2-digit',
//     year: '2-digit'
//   });
// }

// function full_name(driver) {
//   return ""+driver.first_name+" "+driver.last_name
// }

// function preferredLanes(driver) {
//   return driver.PreferredLanes ?
//     driver.PreferredLanes.split(", ").join(" ").replace(/[\"\[\]]/gm, '') :
//     "";
// }

// function current_location(driver) {
//   if (driver.current_city && driver.current_state) {
//     return ""+driver.current_city+", "+driver.current_state;
//   } else if (driver.current_city) {
//     return driver.current_city;
//   } else if (driver.current_state) {
//     return driver.current_state;
//   } else {
//     return "";
//   }
// }

// function desired_location(driver) {
//   if (driver.desired_city && driver.desired_state) {
//     return ""+driver.desired_city+", "+driver.desired_state;
//   } else if (driver.desired_city) {
//     return driver.desired_city;
//   } else if (driver.desired_state) {
//     return driver.desired_state;
//   } else {
//     return "";
//   }
// }
