/* comm */
$(document).on("click", ".edit-previous-education", function(e){
// alert("abc");
        var myID =$(this).attr('id');
     //    alert(myID);

       var splString = myID.split("-");
     //  alert(splString);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/previous_educations/"+splString[1]+"/edit/";
    //    alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                    modal: true,
                    title: "Edit Subject",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
//skip

 $(document).on("click", "#skipPreviousEducationID", function(e){
            //   alert("Hi");

                var urlLink = "/students/index";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){
                        console.log(html);

                    //     $('<div id="newEmployeeDepartmentDialogID" ></div>').dialog({
                          //  modal: true,
                      //      title: "Add Employee Department",
                      //      minHeight: 350,
                       //     minWidth: 250,
                         //   open: function () {
                                $(this).html(html);
                        //    }
                    // });
                    }
                      
                });
        }); 
// Delete

          $(document).on("click", ".delete-previous-education", function(e){
                var myID =$(this).attr('id');

                var splString = myID.split("-");
              //  alert(splString);
                var retVal = confirm("Are you sure to delete course?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/previous_educations/delete/"+splString[1];

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
        $(document).on("click", ".show-previous-education", function(e){ 
       
            var myID =$(this).attr('id');
            var splString = myID.split("-");
          
            var urlLink = "/previous_educations/show/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

              //$("#manageEmployeeForm").empty();
               //$("#manageEmployeeForm").append(html);
                   
                }
            });  



        });  



    $(document).on("click",".preEdcDet",function(){
        var Id=$(this).attr("id");
        //alert(Id);
        $.ajax({
             url: "/previous_educations/show/",
             data: {"studentId": Id},
            success: function(html){
                
               
            }
        });
    });


   $(document).on("click",".preEssdcDet",function(){
        var Id=$(this).attr("id");
        $.ajax({
             url: "/previous_educations/show/"+Id,
            success: function(html){
                
                 $("#manageStudentCategoryID").empty();
               $("#manageStudentCategoryID").append(html);
               
            }
        });
    });


     $(document).on("click",".preEditdcDet",function(){
        var Id=$(this).attr("id");
        $.ajax({
             url: "/previous_educations/edit/"+Id,
            success: function(html){
                 
                 $("#manageStudentCategoryID").empty();
               $("#manageStudentCategoryID").append(html);
               
            }
        });
    });