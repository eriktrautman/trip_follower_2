// USER FOLLOWING LIBRARY *************************
TF.UserFollowing = (function(){

	function User(){
		var that = this;
	}

	User.follow = function(url, callback){
		$.ajax( {
			url: url,
			type: 'POST',
			dataType: "json",
			success: function(data){
					if(data.failure){
						alert("The user could not be followed");
					}else if(callback){
						callback(data);
					}
				},
			error: function(request, status, error){
				console.log("Failed to follow user");
				console.log(error);
			}
		})
	}

	User.unfollow = function(url, callback){
		$.ajax( {
			url: url,
			type: 'DELETE',
			dataType: "json",
			success: function(data){
				if(!data.failure && callback){
					callback(data);
				}
			},
      error: function(request, status, error){
        console.log(error);
			}
		});
	}


	function addFollowingListeners(button){
		button.on("click", function(e){
			var target = $(e.target);
			var url = target.data("url");

			if(target.hasClass("follow")){
				User.follow(url, function(data){
					target.hide();
					target.siblings("button.unfollow").show();
					updateFollowerCount(1);
				});
			} else if (target.hasClass("unfollow")){
				User.unfollow(url, function(data){
					target.hide();
					target.siblings("button.follow").show();
					updateFollowerCount(-1);
				});
			}
		});
	}

	function updateFollowerCount(update_by){
		var followers = parseInt($("#followers-count").html()) + update_by;
		$("#followers-count").html(followers)
	}

	return {
		addFollowingListeners: addFollowingListeners,
		updateFollowerCount: updateFollowerCount
	}
})();