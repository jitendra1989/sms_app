$(document).on("click", ".new-event-type-btn", function(e){
        // var myID =$(this).attr('id');
        // var Id=myID.split("-");

        var urlLink = "/event_types/new";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#newEventTypeDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Edit Event Types",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-event-type-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");


        var urlLink = "/event_types/"+Id[0]+"/edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editEventTypeDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Edit Event Types",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".show-event-type-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");



        var urlLink = "/event_types/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#showEventTypeDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    width: 'auto',
                    title: "Show Event Types",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".delete-event-type-btn", function(e){
     
                var myID =$(this).attr('id');
                    var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/event_types/delete/"+Id[0];

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