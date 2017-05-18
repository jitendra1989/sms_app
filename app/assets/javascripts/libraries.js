

// $(document).on("click", ".edit-libarary-book_purchase-details-class", function(e){
//        e.preventDefault();
       

//         var ID =$(this).attr('id');
         
       
//         var urlLink = "/libraries/edit";
       
//         $.ajax({
//             url: urlLink ,
//             cache: false,
//             data:{"edit_id":ID},
//            success: function(html){

//                   $('#library_book_purchase_datasEdit').dialog({
//                     modal: true,
//                     title: "Edit Library",
//                     width: 860,
//                     height: 640,
//                     open: function () {
                        
//                         $(this).html(html);
//                     }
//                 }); 
               
//             }
//         });
// });

$(document).on("click", ".show-libarary-book_purchase-details-class", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
         
       
        var urlLink = "/libraries/show";
       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"show_id":ID},
           success: function(html){

                  $('#librarys_books_purchase_datasShow').dialog({
                    modal: true,
                    title: "Show Library",
                    width: 700,
                    height: 400,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
//$('.delete').live('click', function() { });
$( document ).on( "change", ".library-auto-class ", function(){ 
var unit=$(this).val();
 // console.log($(this).parent('td').siblings(".cost-td-class").children(".cost-auto-class").val());
 
  var cost=$(this).parent('td').siblings(".libraries-td-class").children(".library-cost-auto-class").val();
 
 console.log($(this).parent('td').siblings(".libraries-td-class"));

  if (cost=="")
  {
    alert("First provide cost for the perticular category");
    $(this).val("");
  }
  else
  {
    var total=cost*unit;
  $(this).parent('td').siblings(".library-total-td-class").children(".library-total-auto-class").val(total);
  }
});

$( document ).on( "change", ".library-cost-auto-class", function(){
  $(this).parent('td').siblings(".unit-td-class").children(".library-auto-class ").val("");
  $(this).parent('td').siblings(".library-total-td-class").children(".library-total-auto-class").val("");
});
//======================total amount=====================================================
// $(".unit-auto-class").change(function(){
  
// });
//======================category=========================================================

//======================category============================
//var temp=2;
$(document).on("click", "#library_details_for_data", function(e){
    var lastRepeatingGroup = $('.demo-div').last();
    //alert(lastRepeatingGroup);
    var cloned = lastRepeatingGroup.clone();
    //console.log(cloned);
    cloned.find('input').val('');
    cloned.find('select').val('');

    //console.log(cloned.find('input').val(''));
    



    cloned.insertAfter( lastRepeatingGroup );
    //alert(temp);
    // $('.required-incremented-field').last().text(temp);
    // temp++;
      $(".required-incremented-field:visible").each(function(index,element){
          $(this).text(index+1);

    });
    
    //add_validation_for_forms();
    return false;

}); 
    


$(document).on("click", ".remove-library-details", function(e){
   var total = $('.remove-library-details').length
   var last_count = $('.remove-library-details').text();
   //console.log(last_count);
 //alert(last_count); 
   if(total!=1)
   {
    $(this).parent('td').parent().remove();   
    }
   
    //temp==$('.remove-library-details').length;
    //temp=temp-1;
  $(".required-incremented-field:visible").each(function(index,element){
          $(this).text(index+1);
    });
});
//=============================================================


//=============================================================
// $('#laboratry_purchase').validate({
//     // your other rules and options
// });
  
//   $('.category-validation-class').each(function() {
//     $(this).rules('add', {
//         required: true
//     });
// });

// the following method must come AFTER .validate()


$(document).on("click", ".edit-library", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
         
       
        var urlLink = "/libraries/library_settings_edit";
       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"edit_id":ID},
           success: function(html){

                //   $('#libraryDialogID').dialog({
                //     modal: true,
                //     title: "Edit Library Settings",
                //     width: 860,
                //     height: 640,
                //     open: function () {
                        
                //         $(this).html(html);
                //     }
                // }); 
        $('#libraryDialogID').empty();
        $('#libraryDialogID').html(html);

               
            }
        });
});


$(document).on("click", "#books_category_id", function(e){
       e.preventDefault();
       

       
       
        var urlLink = "/libraries/books_category_new";
       
        $.ajax({
            url: urlLink ,
            cache: false,
           
           success: function(html){

                  $('#create_book_category').dialog({
                    modal: true,
                    title: "Create Book Category",
                    width: 300,
                    height: 300,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".show-book-category-class", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
       
       
        var urlLink = "/libraries/books_category_show";
       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"show_id":ID},
           success: function(html){

                  $('#show_book_category').dialog({
                    modal: true,
                    title: "Show Book Category",
                    width: 300,
                    height: 180,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".edit-book-category-class", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
       
       
        var urlLink = "/libraries/books_category_edit";
       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"edit_id":ID},
           success: function(html){

                  $('#edit_book_category').dialog({
                    modal: true,
                    title: "Edit Book Category",
                    width: 300,
                    height: 250,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});




$(document).on("click", ".show-books-inventory-class", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
       
        
        var urlLink = "/libraries/books_inventory_show";
       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"show_id":ID},
           success: function(html){

                  $('#books_inventoryShow').dialog({
                    modal: true,
                    title: "Show Book Inventory",
                    width: 530,
                    height: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


// $(document).on("click", ".edit-books-inventory-class", function(e){
//        e.preventDefault();
       

//         var ID =$(this).attr('id');
       
       
//         var urlLink = "/libraries/books_inventory_edit";
       
//         $.ajax({
//             url: urlLink ,
//             cache: false,
//             data:{"edit_id":ID},
//            success: function(html){

//                   $('#books_inventoryEdit').dialog({
//                     modal: true,
//                     title: "Edit Book Inventory",
//                     width: 300,
//                     height: 680,
//                     open: function () {
                        
//                         $(this).html(html);
//                     }
//                 }); 
               
//             }
//         });
// });


$(document).on("click", ".books_details_data", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
       
       
          var data=ID.split("-");
              var status_data=data[1];
              var id=data[0];
        var urlLink = "/libraries/books_information_data";
       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"book_id":id},
           success: function(html){

                  $('#book_details_pop_up_data').dialog({
                    modal: true,
                    title: " Book Details",
                    width: 530,
                    height: 450,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click","#search_button",function(){

        var value=$("#search_by").val();
        var data=$("#search_name").val();
        //alert(value)
        if (value.length==0){

          alert("Please Enter the data to search...........")

        }
        else{
          $.ajax({
            url:'/libraries/search_books',
            cache:false,
            data:{"Value":value,"Data":data,"demo":""},
            success: function(data){
              $("#books_details").empty();
              $("#books_details").append(data);


            }
          });


        }


});


function selectfunction(data){
  

if (data==""){
 $("#test").hide();
}
else{
  $('#search_name').val("");
 $("#test").show();


}


}






$(document).on("click",".submits_function",function(e){
  //alert("sdkljf");
e.preventDefault();
          var student_id=$("#mg_student_school_id").val();
        
        var ID =$(this).attr('id');
          var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
      
var urlLink = "/libraries/update_status";

      




       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"book_id":id,"status_dat":status_data,"student_id":student_id},
           success: function(data){
  //alert(data.name);
           
               if (data.name=="Return") {
              var urlLink = "/libraries/fine_status";
                 
                     $.ajax({
                 //var a=data.object_data; // This line shows error.
                
                 url: urlLink ,
                 cache: false,
                 data:{"object_id":data.object_data,"student_id":student_id},
                 success: function(data){
                    
               //     $("#fine_pop_up").dialog({
               //      modal: true,
               //      //title: " Fine Book Inventory",
               //       width: 300,
               //      height: 250,
               //      open: function () {
                        
               //          $(this).html(data);
               //      }
               // }); 
                     $("#Renew-"+id+"").attr("disabled",true)
                      $("#Reserved-"+id+"").attr("disabled",true)
                   $("#cancel_reservation-"+id+"").attr("disabled",true )
                      
                     $("#fine_pop_up").empty();
                     $("#fine_pop_up").append(data);

                       }
                    });

                    //$(".ui-dialog-titlebar-close").click();
                   
               }
               //now i am adding
                else if (data.name=="Issued"){

                var urlLink = "/libraries/issue_data_status";
                 
                     $.ajax({
                 //var a=data.object_data; // This line shows error.
                
                 url: urlLink ,
                 cache: false,
                 data:{"object_id":data.object_data},
                 success: function(data){
 // alert(data);

                    var boolean=$("#issued_pop_up").empty();
                    //alert(boolean);

                    $("#issued_pop_up").append(data)
               //      $("#issued_pop_up").dialog({
               //      modal: true,
               //      //title: " Fine Book Inventory",
               //       width: 300,
               //      height: 250,
               //      open: function () {
                        
               //          $(this).html(data);
               //      }
               // }); 
                       }
                    });



              }
              else if (data.name=="Renew"){

                var urlLink = "/libraries/renew_fine_status";
                 
                     $.ajax({
                 //var a=data.object_data; // This line shows error.
                
                 url: urlLink ,
                 cache: false,
                 data:{"object_id":data.object_data,"student_id":student_id},
                 success: function(data){
                  //console.log(data);
                  //alert(data);
                    if (data.name=="Return"){
                       $("#"+id+"-TdDIVID").empty();
                    $("#"+id+"-TdDIVID").append("Issued");
                    $(".ui-dialog-titlebar-close").click();
                   
                 }
                 else{


                    $("#renew_fine_pop_up").dialog({
                    modal: true,
                    title: " Fine Book Inventory",
                     width: 300,
                    height: 250,
                    open: function () {
                        
                        $(this).html(data);
                    }
               }); 

                 }


                       }
                    });
                    

              }
              else if (data.name=="Reserved"){

                      $("#Renew-"+id+"").attr("disabled",true)
                      $("#Return-"+id+"").attr("disabled",true)

                var urlLink = "/libraries/reserved_fine_status";
                 
                     $.ajax({
                 //var a=data.object_data; // This line shows error.
                
                 url: urlLink ,
                 cache: false,
                 data:{"object_id":data.object_data},
                 success: function(data){
                     $("#issued_pop_up").empty();
                    $("#issued_pop_up").append(data)
               //      $("#reserved_pop_up").dialog({
               //      modal: true,
               //      //title: " Fine Book Inventory",
               //       width: 300,
               //      height: 250,
               //      open: function () {
                        
               //          $(this).html(data);
               //      }
               // }); 
                       }
                    });



              }
              else{
                 $("#"+id+"-TdDIVID").empty();
                 $("#"+id+"-TdDIVID").append(data.name);
            

                    $(".ui-dialog-titlebar-close").click();

              }
            //$(".ui-dialog-titlebar-close").click();
}

                                     

});

});


$(document).on("click",".cancel-submits-returns-data",function(e){

      e.preventDefault();

        var ID =$(this).attr('id');
          var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
      
         $("#fine_pop_up").empty();
          $("#Renew-"+id+"").attr("disabled",false)
           $("#Reserved-"+id+"").attr("disabled",false  )
           $("#cancel_reservation-"+id+"").attr("disabled",false )


                    });
  

$(document).on("click",".submit_for_fine_data",function(e){

      e.preventDefault();
      
var urlLink = "/libraries/save_fee_fine_particulars";


          var book_status=$("#book_status").val();
          var fine_amount=$("#fine_amount").val();
          

         var ID=$(this).attr('id')
         var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
              var student_id=data[2];
          
          var amount=$(".fine_status123").val();
          

      $.ajax({
            url: urlLink ,
            cache: false,
            data:{"inventory_id":id,"amount":amount,"fine_amount":fine_amount,"book_status":book_status,"student_id":student_id},
           success: function(data){
             $("#"+id+"-TdDIVID").empty();
                 $("#"+id+"-TdDIVID").append("On-shelf");
                    $(".ui-dialog-titlebar-close").click();
            
               
                    }
               }); 
                      
                    });



$(document).on("click",".submits_issued_datas",function(e){

      e.preventDefault();
      
var urlLink = "/libraries/save_issue_data_status";


          
         
          var student_id=$("#mg_student_school_id").val();
          
          //alert(student_id);


         var ID=$(this).attr('id')
         var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
             


      $.ajax({
            url: urlLink ,
            cache: false,
            data:{"inventory_id":id,"student_id":student_id},
           success: function(data){
            console.log(data.name);
            if(data.name=="Not saved"){
                    alert("Book can not be Issued to this Student already had taken Max Books");

            }
            else{

              $("#"+id+"-TdDIVID").empty();
                    $("#"+id+"-TdDIVID").append("Issued");
                    $(".ui-dialog-titlebar-close").click();

            }
               
                    }
               }); 
                      
                    });



function selectedcourseid(courseid){

     

      
//    function selectedCourseIdforissue(courseid){
    $(".mg_batch_id_for_data").empty();
 
  $.ajax({
    url:"/libraries/sestion_for_selected_class",
    data:{"course_id":courseid},
    type:"GET",
    success:function(data){
   

      //$(".select_sections_validate").append(html);
      console.log(data);
            var str='';
            str='<option>'+"Select"+'</option>';
            for (var key in data.name) 
            {
                var d2 = data.name[key]
                for (var key2 in d2) 
                {
                    var batch_name=d2.name;
                    var batch_id=d2.id;
                }

            str+='<option value='+batch_id+'>'+batch_name+'</option>';
            $(".mg_batch_id_for_data").append(str);
            str = "";
            //alert(subject_name);
            }
    },
    error:function(){
      alert("inside error");
    }
  });
};
function selectedBatchIdforissue(batchId){
 
  $.ajax({
    url:"/libraries/students_for_selected_section",
    data:{"batch_id":batchId},
    type:"GET",
    success:function(html){
  
      $(".select_students").empty().append(html);
    },
    error:function(){
      alert("inside error");
    }
  });
}


$(document).on("click",".submit_for_renew_fines_data",function(e){
      e.preventDefault();

      
var urlLink = "/libraries/save_renew_fee_fine_particulars";


          
         
          var fine_amount=$("#fine_amount").val();
          
         



         var ID=$(this).attr('id')
         var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
              var student_id=data[2];


      $.ajax({
            url: urlLink ,
            cache: false,
            data:{"inventory_id":id,"fine_amount":fine_amount,"student_id":student_id},
           success: function(data){
                    $(".ui-dialog-titlebar-close").click();
            
               
                    }
               }); 
                      
                    });




$(document).on("click",".submits_reservation_data",function(e){

      e.preventDefault();
      
var urlLink = "/libraries/save_reservation_data";


          
         
          var student_id=$("#mg_student_school_id").val();
          
         


         var ID=$(this).attr('id')
         var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
             


      $.ajax({
            url: urlLink ,
            cache: false,
            data:{"inventory_id":id,"student_id":student_id},
           success: function(data){
            console.log(data.name);
             if(data.name=="Not Saved"){

            alert("Book can not be Reserved To this Student he already had taken Max Books");


                      }
                      else if(data.Same=="Same Id"){
                        alert("This book is already issued to same student can not be Reserved");
                      }
                      else{
                    $("#"+id+"-TdDIVID").empty();
                    $("#"+id+"-TdDIVID").append("Reserved");
                    $(".ui-dialog-titlebar-close").click();
            }
               
                    }
               }); 
                      
                    });




$(document).on("click",".submits_function_for_issue",function(e){

 e.preventDefault();
          

        var ID =$(this).attr('id');
          var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
        $("#cancel_reservation-"+id+"").attr("disabled",true)
      
var urlLink = "/libraries/update_status";
             


       $.ajax({
            url: urlLink ,
            cache: false,
            data:{"book_id":id,"status_dat":status_data},
           success: function(data){
                    if (data.name=="Issued"){

                var urlLink = "/libraries/issue_data_status_validation";
                 
                     $.ajax({
                 //var a=data.object_data; // This line shows error.
                
                 url: urlLink ,
                 cache: false,
                 data:{"object_id":data.object_data},
                 success: function(data){
                  $("#issued_pop_up").empty();
                    $("#issued_pop_up").append(data)


               //      $("#issued_pop_up").dialog({
               //      modal: true,
               //      //title: " Fine Book Inventory",
               //       width: 300,
               //      height: 250,
               //      open: function () {
                        
               //          $(this).html(data);
               //      }
               // }); 
                       }
                    });



              }
            
               
                    }
               }); 
                      
                    });


$(document).on("click",".submits_issued_validates",function(e){

      e.preventDefault();

        
          
          var student_ids=$("#mg_student_school_id").val();

          
        

         
          var student_id=$(".mg-student-class-id").val();
          
          


         var ID=$(this).attr('id');
         var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
var urlLink = "/libraries/save_issued_validate_data";
             
        
      $.ajax({
            url: urlLink ,
            cache: false,
            data:{"inventory_id":id,"student_id":student_id},
           success: function(data){
                  console.log(data.name);
                      if(data.name=="Saved") {
                    $("#"+id+"-TdDIVID").empty();
                    $("#"+id+"-TdDIVID").append("Issued");
                    $(".ui-dialog-titlebar-close").click();
            } 
                      else if(data.name=="Not saved"){

                      alert("Book can not be Issued To this Student he already had taken Max Books");


                      }
                    else{
                      alert("Book Is Already Reserved");

                    }
                    }
               }); 
                      
                    });


 // $(document).on("change",".mg-student-class-id",function(e){
      function particularstudentlibraryRecords(studentid){

            //var studentid=$("#mg_student_school_id").val();
                    
           var urlLink = "/libraries/particular_student_library_records";
             
        
      $.ajax({
            url: urlLink ,
            cache: false,
            data:{"student_id":studentid},
           success: function(data){
                    

                $("#student_list_for_library_status").empty().append(data);

              
            
               
                    }
               }); 
                      
}

$(document).on("click",".cancel_reservation_submits_function",function(e){
      e.preventDefault();
  
var ID=$(this).attr('id')
         var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
  $.ajax({
    url:"/libraries/cancel_reservation_data",
    cache:false,
     data:{"inventory_id":id},
     success: function(data){


                   $("#"+id+"-TdDIVID").empty();
                    $("#"+id+"-TdDIVID").append("Issued");
                    $(".ui-dialog-titlebar-close").click();

     }
  });

});

$(document).on("click",".cancel-reservation-submits-function-for-second-time",function(e){
      e.preventDefault();

var ID=$(this).attr('id')
         var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
  $.ajax({
    url:"/libraries/cancel_reservation_data_for_second_condition",
    cache:false,
     data:{"inventory_id":id},
     success: function(data){


                   $("#"+id+"-TdDIVID").empty();
                    $("#"+id+"-TdDIVID").append("Issued");
                    $(".ui-dialog-titlebar-close").click();

     }
  });

});

