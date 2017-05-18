//index operation


$(document).on("click",".show-exam-details",function(){
	var showID = $(this).attr('id');
	var id = showID.split("-");
	var urlLink = "/entrance_exam_details/"+id[0];
	$.ajax({
		url: urlLink,
		cache: false,
		success: function(data){
			$("#exam_detail_show").dialog({
				modal: true,
				title: "Entrance Exam Detail",
				minHeight: "auto",
        width: "auto",
				open: function(){
					$(this).html(data);
				}
			});
		}
	});
});


$(document).on("click",".delete-exam-details",function(){
	var delID = $(this).attr('id');
	var id = delID.split("-");
	var retVal = confirm("Are you sure to delete?");
  if(retVal){
		var urlLink = "/entrance_exam_details/"+id[0];
		$.ajax({
			type: 'DELETE',
			url: urlLink,
			cache: false,
			data: {"_method":"delete"},
			success: function(data){
				window.location.reload();
			}
		});
  }	else{
        return false;                }
});

function examVenue(institute_id){
  if(institute_id!='')
  {    
    $.ajax({
      url:'/entrance_exam_details/center_name',
      data:{"institute_id": institute_id},
      type:"GET",
      success:function(data){
      $("#exam_detail_exam_venue").val(data.venue_detail.exam_venue);
      }
    });
  }else{
    $("#exam_detail_exam_venue").val('');
  }
} 
//***************new operation************************//

