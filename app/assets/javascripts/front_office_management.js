$(document).on("click", ".delete-meeting-plan-event-BTN", function(e){
  var myID =$(this).attr('id');
  var Id=myID.split("-");
  var retVal = confirm("Are you sure to delete?");
  if(retVal){
    //  alert(retVal);
       var urlLink = "/front_office_management/meeting_planner_delete/"+Id[0];
        $.ajax({
          url: urlLink ,
          cache: false,
          success: function(html){
              window.location.reload();
          }
      });
  }else{
     // alert(retVal);     
     return false;
  }
  });


  $(document).on("click", ".delete-caller-category-btn", function(e){
    var editID = $(this).attr('id');
    var id = editID.split("-");
    var result = confirm("Are you sure to delete?");
    var urlLink = "/front_office_management/delete_caller_category/"+id[0];
    if(result){
      window.location=urlLink;
    }
  });