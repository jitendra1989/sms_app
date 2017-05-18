

$(document).on("change", "#mg_course", function(e){
      var course_id=$("#mg_course").val();
        var urlLink = "/my_questions/select_batch";
        $.ajax({
            url: urlLink ,
            data:{
            	course_id: course_id
            },
            cache: false,
            success: function(html){
                  $('#bachtSelectListDIVID').empty();
                  $('#bachtSelectListDIVID').append(html);
               
            }
        });
});
	

$(document).on("click", "#submitContentShareBTNID", function(e){
  var course=$("#mg_course").val();
  
  if(course >0){
    var mg_batch_id=$("#mg_batch_id").val();
    if (mg_batch_id>0){
      $('#submitContentShareID').click(); 
    }else{
      alert("Please Select Section.");

    }

  }else{
  alert("Please Select Class.");
  }
});