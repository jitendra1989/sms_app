function toggle(source) {
  checkboxes = document.getElementsByName('mg_student_id[]');
  for(var i=0, n=checkboxes.length;i<n;i++) {
    checkboxes[i].checked = source.checked;
  }
}

$(document).on("click", ".delete-lab-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/laboratory/delete/"+Id[0];

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

$(document).on("click", ".delete-lab-inv-btn", function(e){
     e.preventDefault();
     
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/laboratory/inventory_delete/"+Id[0];

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

$(document).on("click", ".delete-lab-unit-btn", function(e){
     e.preventDefault();
     
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/laboratory/unit_delete/"+Id[0];

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


$(document).on("click", ".delete-laboratory-item-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
                var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/laboratory/item_delete/"+Id[0];

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


$(document).on("click", ".delete-laboratory-subject-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/laboratory/subject_delete/"+Id[0];

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
