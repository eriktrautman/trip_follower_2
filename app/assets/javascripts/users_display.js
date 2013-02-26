// USERS DISPLAY LIBRARY *************************
TF.FollowingLibrary = (function(){

	function User(){
		var that = this;
	}

	User.follow = function(url, follow_id, callback){
		$.post( url+".json", { "user_following": { "followed_id": follow_id }}, function(data){
			if(!data.failure && callback){
				callback(data);
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


	function addFollowingListeners(parent_element){

		parent_element.on("click", "button.follow", function(e){

			var url = $(e.target).data("url");
			var follow_id = $(e.target).data("id");

			User.follow(url, follow_id, function(data){
				$(e.target).hide();
				$("button.unfollow[data-id="+follow_id+"]").show();
				updateFollowerCount(1);
			});
		});


		parent_element.on("click", "button.unfollow", function(e){

			var url = $(e.target).data("url");
			var unfollow_id = $(e.target).data("id");

			User.unfollow(url, function(data){
				$(e.target).hide();
				$("button.follow[data-id="+unfollow_id+"]").show();
				updateFollowerCount(-1);
			});
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

// $(function(){
// 	UsersLibrary.addUsersListListeners();
// 	console.log("LOADED.  Current user: "+ current_user.username);

// });