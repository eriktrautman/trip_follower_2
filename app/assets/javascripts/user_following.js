// USER FOLLOWING LIBRARY *************************
TF.UserFollowing = (function(){

	function User(){
		var that = this;
	}

	User.follow = function(url, follow_id, callback){
		$.ajax( {
			url: url,
			type: 'POST',
			data: { "user_following": { "followed_id": follow_id }},
			dataType: "json",
			success: function(data){
					if(data.failure){
						console.log("The user could not be followed");
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
			}
		});
	}


	function addFollowingListeners(button){

		button.on("click", function(e){
			var target = $(e.target);
			var url = target.data("url");
			var follow_id = target.data("id");

			console.log("CLICK");

			if(target.hasClass("follow")){
				User.follow(url, follow_id, function(data){
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

	function yell(){
		console.log("AAAAAAAH");
	}

	return {
		addFollowingListeners: addFollowingListeners,
		updateFollowerCount: updateFollowerCount,
		yell: yell
	}
})();