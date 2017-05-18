
$(document).on("click", ".show-vehicle-transport-details-classes", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/transports/vehicle_transport_show";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#transports_datasShows').dialog({
                    modal: true,
                    title: "Show Route Details",
                    minWidth: 330,
                    minHeight: 350,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-vehicle-transport-details-classes", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/transports/vehicle_transport_edit";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                //     $('#transport_datasEdit').dialog({
                //     modal: true,
                //     title: "Edit Route Details",
                //     minWidth: 330,
                //     minHeight: 350,
                //     // maxHeight: 500,
                //     open: function () {
                        
                //         $(this).html(html);
                //     }
                // }); 
               $('#transports_datasEdits').empty();
               $('#transports_datasEdits').html(html);
            }
        });
});

$(document).on("click", ".show-transport-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/transports/show";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#transport_datasShow').dialog({
                    modal: true,
                    title: "Show Route Details",
                    minWidth: 330,
                    minHeight: 350,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-transport-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/transports/edit";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                //     $('#transport_datasEdit').dialog({
                //     modal: true,
                //     title: "Edit Route Details",
                //     minWidth: 330,
                //     minHeight: 350,
                //     // maxHeight: 500,
                //     open: function () {
                        
                //         $(this).html(html);
                //     }
                // }); 
               $('#transport_datasEdit').empty();
               $('#transport_datasEdit').html(html);
            }
        });
});

$(document).on("click", ".show-transport-time-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/transports/transport_time_management_show";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#transport_time_datasShow').dialog({
                    modal: true,
                    title: "Show Route Time Details",
                    minWidth: 330,
                    minHeight: 350,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-transport-time-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/transports/transport_time_management_edit";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                //     $('#transport_time_datasEdit').dialog({
                //     modal: true,
                //     title: "Edit Route Time Details",
                //     minWidth: 330,
                //     minHeight: 350,
                //     // maxHeight: 500,
                //     open: function () {
                        
                //         $(this).html(html);
                //     }
                // }); 
        $('#transport_time_datasEdit').empty();
        $('#transport_time_datasEdit').html(html);

               
            }
        });
});