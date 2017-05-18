/* comm */
$(document).on("click", ".editPrincipalClass", function(e){  
            
            var id=$(this).attr("id");
            var emp_id=id.split('-');
          //  alert("hello");
            var urlLink = "/principals/edit/"+emp_id[1] ;

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                      $('#principalEditDialogID').dialog({
                        modal: true,
                        title: "Edit Principal",
                        height: 640,
                        minWidth: 860,
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog
                   
                }
            });  



        }); 