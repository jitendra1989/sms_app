$(document).on("click", ".show-vehicle-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/show";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#vehicle_datasShow').dialog({
                    modal: true,
                    title: "Show Vehicle",
                    minWidth: 330,
                    minHeight: 500,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".edit-vehicle-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                $('#vehicle_datasEdit').empty()

                $('#vehicle_datasEdit').html(html)
                //     $('#vehicle_datasEdit').dialog({
                //     modal: true,
                //     title: "Edit Vehicle",
                //     minWidth: 360,
                //     height: 500,
                //     // maxHeight: 500,
                //     open: function () {
                        
                //         $(this).html(html);
                //     }
                // }); 
               
            }
        });
});

$(document).on("click", "#create_report_details_class", function(e){
        
        //var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/new_report_type//";
        $.ajax({
            url: urlLink ,
            cache: false,
            //data:{"id":Id},
            success: function(html){  
                    $('#create_dialog_box').dialog({
                    modal: true,
                    title: "Create Report Type",
                    minWidth: 300,
                    minHeight: 250,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".show-report-type-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/report_type_show";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#report_type_datasShow').dialog({
                    modal: true,
                    title: "Show Report Type",
                    minWidth: 200,
                    minHeight: 200,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-report-type-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/report_type_edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#report_type_datasEdit').dialog({
                    modal: true,
                    title: "Edit Report Type",
                    minWidth: 250,
                    height: 250,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", "#create_payment_details_class", function(e){
        
        //var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/new_payment_type//";
        $.ajax({
            url: urlLink ,
            cache: false,
            //data:{"id":Id},
            success: function(html){  
                    $('#create_payment_dialog_box').dialog({
                    modal: true,
                    title: "Create Payment Type",
                    minWidth: 300,
                    minHeight: 250,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".show-payment-type-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/payment_type_show";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#payment_type_datasShow').dialog({
                    modal: true,
                    title: "Show Payment Type",
                    minWidth: 200,
                    minHeight: 200,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-payment-type-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/payment_type_edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#payment_type_datasEdit').dialog({
                    modal: true,
                    title: "Edit Payment Type",
                    minWidth: 250,
                    height: 250,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", "#add_file_reports_uploads", function(e){

    var lastRepeatingGroup = $('.student_file_file_div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 

 $(document).on("click", ".reports-upload", function(e){

   var total = $('.reports-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
  
});

 $(document).on("click", "#add_file_payment_reports_uploads", function(e){

    var lastRepeatingGroup = $('.student_payments_file_file_div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 

 $(document).on("click", ".payment_reports-upload", function(e){

   var total = $('.payment_reports-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
  
});
$(document).on("click", "#edit_file_payment_reports_uploads", function(e){

    var lastRepeatingGroup = $('.edit_edit_student_payments_file_file_div').last();

     

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 

 $(document).on("click", ".edit_payment_reports-upload", function(e){

   var total = $('.edit_payment_reports-upload').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
  
});

$(document).on("click", ".show-report-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/vehicle_report_show";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#report_datasShow').dialog({
                    modal: true,
                    title: "Show Report Details",
                    minWidth: 200,
                    minHeight: 200,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-report-details-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert("urlLink");
        var urlLink = "/vehicles/vehicle_report_edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){
                //alert("hii")
            $("#vehicle_report_index").empty();
            $("#vehicle_report_index").append(html);
         
        }
                }); 
               
            });


$(document).on("click", "#edit_file_reports_uploads", function(e){

    var lastRepeatingGroup = $('.students_files_files_divs').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;
}); 

 $(document).on("click", ".edit-reports-uploads", function(e){

   var total = $('.edit-reports-uploads').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
  
});