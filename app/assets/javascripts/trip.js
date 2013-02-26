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

  function addSubscriptionListeners(parent_element){
    console.log("Adding subscribe listeners");

    parent_element.on("click", "button.subscribe", function(e){
      var url = $(e.target).data("url");
      subscribe(url, function(data){
        $(e.target).hide();
        $(e.target).siblings("button.unsubscribe").show();
      });
    });

    parent_element.on("click", "button.unsubscribe", function(e){
      var url = $(e.target).data("url");
      unsubscribe(url, function(data){
        $(e.target).hide();
        $(e.target).siblings("button.subscribe").show();
      });
    });
  }



  return {
    addSubscriptionListeners: addSubscriptionListeners
  }

})();