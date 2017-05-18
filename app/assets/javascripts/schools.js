/* comm */
$(document).ready(function(){

     // dateFormatStr =  getSchoolDateFormat();
    // $("#schoolDateFormatDbID").html(dateFormatStr);

  $(document).on("click", "#createNewSchool_demo", function(e){
    var urlLink = "/schools/new";
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html){
          $("#manageSchools").html(html);
        }
    });
});

  // Improvement on this method not working
  $(document).on("click", "#viewSchoolList_demo", function(e){
    var urlLink = "/schools/index";
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(data){
          $("#manageSchools").html(data);
        }
    });
});

  $(document).on("click", ".editschool", function(e){
        e.preventDefault();
     //alert("hello");
        var schoolID =$(this).attr("id");
        var Id=schoolID.split("-");
        
        var urlLink = "/schools/"+Id[1]+"/edit";
       // alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#schoolDialogID').dialog({
                    modal: true,
                    height: 640,
                    minWidth: 860,
                    title: "Edit",

                    open: function () {
                        $(this).html(html);
                    }
                }); 
            }
        });
});


   $(document).on("click", ".edit-custum-fields", function(e){
        e.preventDefault();

        var schoolID =$(this).attr("id");
        var Id=schoolID.split("-");
        // alert("Id : "+Id[1]);
        var urlLink = "/schools/custom_fields_edit/"+Id[1];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editSchollCustomDialogID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    minWidth: 'auto',
                    title: "Edit School Custom Field",

                    open: function () {
                        $(this).html(html);
                    }
                }); 
            }
        });
});


$(document).on("click", ".delete-custum", function(e){
            var myID =$(this).attr('id');

            var splString = myID.split("-");
          //  alert(splString);
            var retVal = confirm("Are you sure to delete?");
            if(retVal){
              //  alert(retVal);
                 var urlLink = "/schools/custum_fields_delete/"+splString[1];

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



  $(document).on("click", "#manageCustomFields_demo", function(e){
    var urlLink = "/schools/custom_new";
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(data){
          $("#manageSchools").html(data);
        }
    });
});

});


function checkForUniqueSubDomainName(that){

  var subdomainName=$(that).val();
  var urlLink = "/schools/ajax_request_for_unique_subdomain_name";
  $.ajax({
    type: "get",
    dataType: "json",
    url: urlLink ,
    data: {
      subdomainName:  subdomainName
    },
    success: function(data) {
      console.log(data.schoolObj.is_subdomain_exist);
      if(data.schoolObj.is_subdomain_exist=="true") {
        alert("Subdomain already exist.")
        $(that).val("");
      }
    },
    error:function(error) {
      console.log(error);
    }
  });
}