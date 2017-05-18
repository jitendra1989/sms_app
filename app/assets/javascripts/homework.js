$(document).on("click", ".delete-student-attachment-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/homework/employee_attachment_delete/"+Id[0];

                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(html){
                            window.location=window.location;           
                        }
                    });

                }else{
                   // alert(retVal);     
                   return false;
                }

        });


$(document).on("click", ".delete-homework-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/homework/category_delete/"+Id[0];

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