

$(document).ready(function() {


	$('#login-form').submit(function(event){

		var $form = $(this),
			$inputs = $form.find("input, select, button, textarea"),
			serializedData = $form.serialize();

		$inputs.attr("disabled", "disabled");

		$.ajax({
			url: "/login",
			type: "post",
			data: serializedData,
			success: function(response, textStatus, jqXHR){
				
				if (response.success) {
					$('#loginBox').modal('hide');
					window.location.reload();
				}
				else {
					$('#login-form-messages').append('<div id="invalid-password-email" class="alert"><button type="button" class="close" data-dismiss="alert">×</button>You have entered an invalid e-mail address or password.</div>');
				}

			},
			error: function(jqXHR, textStatus, errorThrown){

			},
			complete: function(){
				$inputs.removeAttr("disabled");
			}
		});

		// prevent default posting of form
		event.preventDefault();

		return false;
	});

	$('#register-form').submit(function(event){

		var $form = $(this),
			$inputs = $form.find("input, select, button, textarea"),
			serializedData = $form.serialize();

		if (this.password.value != this.password2.value) {
			$('#register-form-messages').append('<div id="invalid-password-email" class="alert"><button type="button" class="close" data-dismiss="alert">×</button>The passwords do not match.</div>');
			return false;
		}

		$inputs.attr("disabled", "disabled");

		$.ajax({
			url: "/register",
			type: "post",
			data: serializedData,
			success: function(response, textStatus, jqXHR){
				
				if (response.success) {
					$('#loginBox').modal('hide');
					window.location.reload();
				}
				else {
					$('#register-form-messages').append('<div id="invalid-password-email" class="alert"><button type="button" class="close" data-dismiss="alert">×</button>The registration failed. You may use a username or mail address already used.</div>');
				}

			},
			error: function(jqXHR, textStatus, errorThrown){
				alert("Error during storing the data.");
			},
			complete: function(){
				$inputs.removeAttr("disabled");
			}
		});

		// prevent default posting of form
		event.preventDefault();

		return false;
	});

	// $('#action-register').on("click", function() {
	// 	alert("register");
	// });


});