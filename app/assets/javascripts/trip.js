TF.Trip = (function(){

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
        subscribe(url, function(data){
          target.hide();
          target.siblings("button.unsubscribe").show();
          updateFollowerCount(+1);
        });
      }else if(target.hasClass("unsubscribe")){
        unsubscribe(url, function(data){
          target.hide();
          target.siblings("button.subscribe").show();
          updateFollowerCount(-1);
        });
      }
    });
  }
  // INCOMPLETE! this function needs to discern WHICH trip followers to update
  // which means setting a unique id on the _trip_subscriber_stats.html.erb link
  // that is generated for it, so we can reach in and fix the link...
  // Maybe give the link a unique class that can be grabbed onto
  function updateSubscriberCount(update_by){
    var subscribers = parseInt($("#subscribers-count").html()) + update_by;
    $("#followers-count").html(followers)
  }



  return {
    addSubscriptionListeners: addSubscriptionListeners
  }

})();