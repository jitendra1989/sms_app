
$(document).on("click", ".new-guests-btn", function(e){
        var urlLink = "/guests/new";
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        $.ajax({
            url: urlLink ,
            data :{mg_event_id: Id[0] },
            cache: false,
            success: function(html){
                  $('#newGuestDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "New Guest",
                    open: function () {
                        $(this).html(html);
                    }
                }); 
            }
        });
});


$(document).on("click", ".edit-guests-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/guests/"+Id[0]+"/edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editGuestDIVID').dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Edit Guest",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
            }
        });
});

$(document).on("click", ".show-guests-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/guests/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#showGuestDIVID').dialog({
                    modal: true,
                    minHeight: 400,
                    maxHeight: 500,
                    maxWidth: 900,
                    minWidth: 600,

                    title: "Show Guest",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
            }
        });
});


$(document).on("click", ".delete-guests-btn", function(e){
                var myID =$(this).attr('id');
                    var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/guests/delete/"+Id[0];
                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(html){
                            var mg_event_id=$("#selectEventForCommitteeSelectTagID").val()
                           window.location='/guests?mg_event_id='+mg_event_id;
                        }
                    });
                }else{    
                   return false;
                }

        });

    function optionForEvent(value){
        $("#selectEventForCommitteeSelectTagID").html("");
        $("#eventListForCommitteGuestsDivID").html("");

        var urlLink='/guests/event_list/'+value;
         $.ajax({
            url: urlLink ,
            cache: false,
            success: function(data){
               var str='<option value="">'+"Select"+'</option>';
               for (var key in data) {
                str +='<option value="'+data[key].id+'">'+data[key].title+'</option>';
               }
               $("#selectEventForCommitteeSelectTagID").html(str);
            }
        });
    }

    function optionForEventSelect(value){
        $("#eventListForCommitteGuestsDivID").html("");

        var urlLink='/guests/guests_for_event/'+value;
         $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
               $("#eventListForCommitteGuestsDivID").html(html);
            }
        });
    }


    
    function optionForEventInvetaionGuestParticipation(value){
        $("#selectCommitteeSelectForEventGuestTagID").html("");
        $("#guestListDIVID").html("");

        var urlLink='/guests/event_list/'+value;
         $.ajax({
            url: urlLink ,
            cache: false,
            success: function(data){
               var str='<option value="">'+"Select"+'</option>';
               for (var key in data) {
                str +='<option value="'+data[key].id+'">'+data[key].title+'</option>';
               }
               $("#selectCommitteeSelectForEventGuestTagID").html(str);
            }
        });
    }

    function optionForEventGuest(value){
        if(value==''){
             $('#guestListDIVID').empty();
        }else{
             var urlLink = "/guests/guests_list/"+value;
             $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                    $('#guestListDIVID').empty();
                    $('#guestListDIVID').append(html);
                    }
            });
        }
    }