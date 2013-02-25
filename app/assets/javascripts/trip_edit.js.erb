// ADMIN LIBRARY ********************************
var AdminLibrary = (function(){

	function Admin(){
		var that = this;
	}

	Admin.add = function(username, callback){
		var url = $("#admin-url").attr("data-url");
		$.post(	url, { "username": username },
			function(admin){
				if(!admin.failure){
					if(callback){
						callback(admin);
					}
				}
			}
		);
	}

	Admin.remove = function(admin_id, callback){
		var url = $("#admin-url").attr("data-url");
		console.log(url);
		$.ajax( {
			url: url+"/"+admin_id, 
			type: 'DELETE', 
			dataType: "json",
			success: function(admin){
				if(!admin.failure){
					if(callback){
						callback(admin);
					}
				}
			},
			failure: function(){
				alert("Delete request failed");
			}
		});
	}

	function addAdminListeners(){

		// Listener for additions of admin users via the textbox + button
		$("#add-admin-button").click(function(){
			var username = $("#add-admin").val();

			Admin.add(username, function(admin){
				$("input#add-admin").val("");
				$("ul#admin-list").append("<li id='admin-user-"+admin.id+
						"'>"+admin.username+
						" | <a class='remove-admin' data-id='"+
						admin.id+"'>remove</a></li>");
			});
		});	

		// Listener for removals of admin users
		$("#admin-list").on("click", "a", function(e){
			var admin_id = $(e.target).attr("data-id");

			Admin.remove(admin_id, function(admin){
				$("li#admin-user-"+admin.id).remove();
			});
		});
	}

	return {
		Admin: Admin,
		addAdminListeners: addAdminListeners
	}
})();



// WHITELIST LIBRARY ********************************
var WhitelistLibrary = (function(){

	function Whitelist(){
		var that = this;
	}

	Whitelist.add = function(username, callback){
		var url = $("#whitelist-url").attr("data-url");

		$.post(	url, { "username": username },
			function(whitelisted_user){
				if(!whitelisted_user.failure){
					if(callback){
						callback(whitelisted_user);
					}
				}
			}
		);
	}

	Whitelist.remove = function(whitelisted_user_id, callback){
		var url = $("#whitelist-url").attr("data-url");

		$.ajax( {
			url: url+"/"+whitelisted_user_id, 
			type: 'DELETE', 
			dataType: "json",
			success: function(whitelisted_user){
				if(!whitelisted_user.failure){
					if(callback){
						callback(whitelisted_user);
					}
				}
			},
			failure: function(){
				alert("Delete request failed");
			}
		});
	}

	function addWhitelistListeners(){

		// Listener for additions of whitelisted users via the textbox + button
		$("#add-whitelisted-user-button").click(function(){
			var username = $("#add-whitelisted-user").val();

			Whitelist.add(username, function(whitelisted_user){
				$("input#add-whitelisted-user").val("");

				if(whitelisted_user){
					$("ul#whitelisted-users-list").append("<li id='whitelisted-user-"+whitelisted_user.id+
							"'>"+whitelisted_user.username+
							" | <a class='remove-whitelisted-user' data-id='"+
							whitelisted_user.id+"'>remove</a></li>");
				}
			});
		});	

		// Listener for removals of whitelist users
		$("#whitelisted-users-list").on("click", "a", function(e){
			var whitelisted_user_id = $(e.target).attr("data-id");

			Whitelist.remove(whitelisted_user_id, function(whitelisted_user){
				$("li#whitelisted-user-"+whitelisted_user.id).remove();
			});
		});
	}

	return {
		Whitelist: Whitelist,
		addWhitelistListeners: addWhitelistListeners
	}
})();


// PRIVACY LIBRARY ********************************
var PrivacyAndPostingLibrary = (function(){

	function Trip(){
		var that = this;
	}

	Trip.updateAttribute = function(data, callback){
		var url = $("#trip-url").attr("data-url");

		$.ajax( {
			url: url, 
			type: 'POST', 
			dataType: "json",
			data: data,
			success: function(trip){
				console.log("RUNNIG UPDATE");
				if(!trip.failure){
					if(callback){
						callback(trip);
					}
				}
			},
			failure: function(){
				alert("Update request failed");
			}
		});
	}

	function addPrivacyListeners(){
		$("div#trip-posting-radio-inputs").on("change", "input", function(e){

			$("span.ajax-success").remove();
			var val = $(e.target).val();
			var data = { "trip": {"whitelist_posters": val }, "_method": "put" };

			Trip.updateAttribute(data, function(trip){
			// console.log($(e.target));
				$(e.target).first().closest("label").append("<span class='ajax-success'>Updated!</span>");
				if(val == "true"){
					$("div#whitelist").show();
				}else{
					$("div#whitelist").hide();
				}
			});
		});
	};

	return{
		addPrivacyListeners: addPrivacyListeners
	}
})();



// EXECUTION SCRIPTS *********************************
$(function(){
	AdminLibrary.addAdminListeners();
	WhitelistLibrary.addWhitelistListeners();
	PrivacyAndPostingLibrary.addPrivacyListeners();
});