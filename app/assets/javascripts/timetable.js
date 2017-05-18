
$(document).on("click", "#checkAllCheckBoxInTimingId", function(e){

        $(".auto-checkbox-timing-cls").prop('checked', true);
        e.preventDefault();
        
  });

  $(document).on("click", "#unCheckAllCheckBoxInTimingId", function(e){

        $(".auto-checkbox-timing-cls").prop('checked', false);
        e.preventDefault();
  });

    	function selectClassTimeForTimeTable(class_time_name){
    		
   			$.ajax({
			url:"/timetable/show_free_teacher",
			data:{"class_time_name":class_time_name},
			success:function(html){
				
				$("#freeEmployeeViewDivID").html(html);
			},
			error:function(){
				alert("inside error");
			}
		});
   	}