// USERS DISPLAY LIBRARY *************************
var UsersLibrary = (function(){

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


	function addUsersListListeners(){

		$(".users-list").on("click", "button.follow", function(e){

			var url = $(e.target).data("url");
			var follow_id = $(e.target).data("id");

			User.follow(url, follow_id, function(data){
				$(e.target).hide();
				$("button.unfollow[data-id="+follow_id+"]").show();

			});
		});


		$(".users-list").on("click", "button.unfollow", function(e){

			var url = $(e.target).data("url");
			var unfollow_id = $(e.target).data("id");

			console.log("UNFOLLOW " + url);

			User.unfollow(url, function(data){
				console.log("WWOOOOO");
				$(e.target).hide();
				$("button.follow[data-id="+unfollow_id+"]").show();

			});
		});
	}

	return {
		addUsersListListeners: addUsersListListeners
	}
})();

$(function(){
	UsersLibrary.addUsersListListeners();
	console.log("LOADED.  Current user: "+ current_user.username);

});