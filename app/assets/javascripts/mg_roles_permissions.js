/* comm */
     $(document).ready(function(){

              $("li").removeClass( "active" );
              $("a").removeClass( "activeMenu" );
             
              $("#rolePerLiID").addClass("active");
              $("#rolePerAID").addClass("activeMenu");
     });
     $(document).on("click","#addRolePermissionBtn", function(){
     	// Add New Action here
     	//alert("Btn is clicked");

     	        var urlLink = "/mg_roles_permissions/new";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){
                        console.log(html);

                         $('<div></div>').dialog({
                          //  modal: true,
                            title: "Add Employee Role and Permission",
                            minHeight: 350,
                            minWidth: 250,
                            open: function () {
                                $(this).html(html);
                            }
                     });
                    }
                      
                });
     });

     // update
         $(document).on("click", ".edit-mg-role-permission", function(e){
           //     alert("edit");
                 var myID =$(this).attr('id');
            var splString = myID.split("-");
           // alert(splString[1]);
            var urlLink = "/mg_roles_permissions/edit/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                      $('<div></div>').dialog({
                        modal: true,
                        title: "Editing Role and Permission",
                        minHeight: 350,
                        minWidth: 250,
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  

        });
        // delete 
   
                   $(document).on("click", ".delete-mg-role-permission", function(e){
                var myID =$(this).attr('id');

                var splString = myID.split("-");
           //     alert(splString);
                var retVal = confirm("Are you sure to delete ?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/mg_roles_permissions/delete/"+splString[1];

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
         