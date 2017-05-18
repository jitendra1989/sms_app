    function optionForEventInvetaion(value){
        $("#selectEventForCommitteeSelectTagID").html("");
        $("#invitationNewFormDivID").html("");

        var urlLink='/guests/event_list/'+value;
         $.ajax({
            url: urlLink ,
            cache: false,
            success: function(data){
               var str='<option value="">'+"Select"+'</option>';
               for (var key in data) {
                str +='<option value="'+data[key].id+'">'+data[key].title+'</option>';
               }
               $("#selectEventForCommitteeSelectTagID").html(str);
            }
        });
    }


	function optionForEventInvitation(value){
		var urlLink = "/invitations/new/";
		if(value=='') {
                  $('#invitationNewFormDivID').html("");

		}else{
        $.ajax({
            url: urlLink ,
            data : {mg_event_id: value},
            cache: false,
            success: function(html){
                  $('#invitationNewFormDivID').html(html);

                  var is_lock_employee=$("input#invitation_employee").is(':checked');
					if(is_lock_employee){
					  $("#accessableTo­EmployeesHideandShowDIVID").show();
					}else{
					  $("#accessableTo­EmployeesHideandShowDIVID").hide();

					}

					var is_lock_std=$("input#invitation_student").is(':checked');
					if(is_lock_std){
					  $("#accessableTo­StudentsHideandShowDIVID").show();
					}else{
					  $("#accessableTo­StudentsHideandShowDIVID").hide();

					}

					var is_lock_gnd=$("input#invitation_guardian").is(':checked');
					if(is_lock_gnd){
					  $("#accessableTo­GuardiansHideandShowDIVID").show();
					}else{
					  $("#accessableTo­GuardiansHideandShowDIVID").hide();

					}

					var is_lock_teacher=$("input#invitation_teacher").is(':checked');
					if(is_lock_teacher){
						$("#accessableTechTo­EmployeesHideandShowDIVID").show();
					}else{
						$("#accessableTechTo­EmployeesHideandShowDIVID").hide();

					}
            }
        });
       }




	}
