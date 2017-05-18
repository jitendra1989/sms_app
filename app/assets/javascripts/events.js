$(document).on("click", ".new-event-btn", function(e){
        // var myID =$(this).attr('id');
        // var Id=myID.split("-");


        var urlLink = "/events/new";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#newEventDIVID').dialog({
                    modal: true,
                    width: 'auto',
                    title: "Edit Event Types",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-event-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");


        var urlLink = "/events/"+Id[0]+"/edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editEventDIVID').dialog({
                    modal: true,
                    width: 'auto',
                    title: "Edit Event",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-event-update-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");


        var urlLink = "/events/edit_event/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editEventDIVID').dialog({
                    modal: true,
                    width: 435,
                    title: "Edit Event",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".show-event-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");


        var urlLink = "/events/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#showEventDIVID').dialog({
                    modal: true,
                    minHeight: 400,
                    maxHeight: 500,
                    maxWidth: 900,
                    minWidth: 600,

                    title: "Show Event",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".delete-event-btn", function(e){
     
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/events/delete/"+Id[0];

                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(html){
                           // window.location.reload();
                                       
                        }
                    });

                }else{
                   // alert(retVal);     
                   return false;
                }

        }); 

$(document).on('click','.delete-event-BTN', function(e){

     var myID =$(this).attr('id');
            var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/events/delete/"+Id[0];

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

