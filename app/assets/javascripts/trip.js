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
        });
      }else if(target.hasClass("unsubscribe")){
        unsubscribe(url, function(data){
          target.hide();
          target.siblings("button.subscribe").show();
        });
      }
    });
  }



  return {
    addSubscriptionListeners: addSubscriptionListeners
  }

})();