TF.Trip = (function(){

  function subscribers(url, callback){
    $.ajax( {
      url: url,
      type: 'GET',
      dataType: 'json',
      success: function(data){
        if(data.failure){
          alert("The trip subscribers couldn't be retrieved");
        } else if(callback){
          callback(data);
        }
      },
      error: function(request, status, error){
        console.log(error);
      }
    });
  }

  function subscribe(url, callback){
    $.ajax( {
      url: url,
      type: 'POST',
      dataType: 'json',
      success: function(data){
        if(data.failure){
          alert("The trip could not be subscribed to");
        }else if(callback){
          callback(data);
        }
      },
      error: function(request, status, error){
        console.log(error);
      }
    });
  }

  function unsubscribe(url, callback){
    $.ajax( {
      url: url,
      type: 'DELETE',
      dataType: 'json',
      success: function(data){
        if(data.failure){
          alert("The trip could not be unsubscribed to");
        }else if(callback){
          callback(data);
        }
      },
      error: function(request, status, error){
        console.log(error);
      }
    });
  }

  function addSubscriptionListeners(button){

    button.on("click", function(e){
      var target = $(e.target);
      var url = target.data("url");
      if(target.hasClass("subscribe")){
        subscribe(url, function(trip){
          target.hide();
          target.siblings("button.unsubscribe").show();
          updateSubscriberCount(trip.id);
        });
      }else if(target.hasClass("unsubscribe")){
        unsubscribe(url, function(trip){
          target.hide();
          target.siblings("button.subscribe").show();
          updateSubscriberCount(trip.id);
        });
      }
    });
  }

  // Takes a trip_id and will update its count 
  // wherever on the page its count is displayed
  function updateSubscriberCount(trip_id){
    var element = $("span.trip-subscriber-count[data-id="+trip_id+"]");
    var url = element.data("url");
    subscribers(url, function(subscribers){
      element.text(subscribers.length);
    });
  }


  return {
    addSubscriptionListeners: addSubscriptionListeners
  }

})();