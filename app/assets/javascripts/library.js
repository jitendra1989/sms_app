$(document).on("click", ".delete-library-subject-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/library/subject_delete/"+Id[0];

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


$(document).on("click", ".delete-resource-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/library/resource_delete/"+Id[0];

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

$(document).on("click", ".delete-inventory-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/library/inventory_delete/"+Id[0];

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


$(document).on("click","#search_button_fordata",function(e){
     e.preventDefault();

          $("#student_employee_data_info").empty();

        var value=$("#search_by").val();
        var data=$("#library_search_name").val();
        //alert(value)
        if (value.length==0){

          alert("Please Enter the data to search...........")

        }
        else{
          $.ajax({
            url:'/library/search_books',
            cache:false,
            data:{"Value":value,"Data":data,"demo":""},
            success: function(data){
              $("#library_particular_book_search").empty();
              $("#library_particular_book_search").append(data);


            }
          });


        }


});
$(document).on("click","#submitlibraryFormBtnId",function(e){
     e.preventDefault();

 $("#student_employee_data_info").empty();
 var data_id=$("#library_id_hidden").val();
 var dta_id=$("#library_category_id_hidden").val();
var id_data=$("#employee_student_id").val();

if (id_data==""){
  alert("Please Enter Id");
}
else{

$.ajax({
            url:'/library/employee_student_information',
            cache:false,
            data:{"Data":id_data,"value":dta_id,"resource_type":data_id},
            success: function(data){
              $("#student_employee_data_info").empty();
              $("#student_employee_data_info").append(data);


            },
            error: function(data){

              alert("Not a valid User ID");
            }
          });


}

});
$(document).on("click",".issueemployee_button_for_library",function(e){
     e.preventDefault();


            var myIDs =$(this).attr('id');
            var splStrings = myIDs.split("-");
      $.ajax({
            url:'/library/save_issue_data_status_for_library',
            cache:false,
            data:{"category_id":splStrings[0],"resource_type_id":splStrings[1],"status_data":"Employee","working_id":splStrings[2]},
            success: function(data){
              // $("#student_employee_data_info").empty();
              // $("#student_employee_data_info").append(data);
              $("#student_employee_data_info").empty();

              $("#library_particular_book_search").empty();
              //var $newdiv1 = $( "<div calss='object1'/>" ),
              $("#student_employee_data_info").html("<div class='alert alert-info mg-success-msg'>Successfully Issued</div>");
              

            },
            error: function(data){

              alert("Not a valid User ID");
            }
          });

});
$(document).on("click",".issuestudent_button_for_library",function(e){
     e.preventDefault();


var myIDs =$(this).attr('id');
            var splStrings = myIDs.split("-");
      $.ajax({
            url:'/library/save_issue_data_status_for_library',
            cache:false,
            data:{"category_id":splStrings[0],"resource_type_id":splStrings[1],"status_data":"Student","working_id":splStrings[2]},
            success: function(data){
              // $("#student_employee_data_info").empty();
              // $("#student_employee_data_info").append(data);
              $("#student_employee_data_info").empty();

              $("#library_particular_book_search").empty();
              $("#student_employee_data_info").append("<div class='alert alert-info mg-success-msg'>Successfully Issued</div>");

            },
            error: function(data){

              alert("Not a valid User ID");
            }
          });

});
$(document).on("click",".returnsubmitlibraryFormBtnId",function(e){
     e.preventDefault();


var myIDs =$(this).attr('id');
var value=$("#is_there_a_delay").val();
var return_data=$("#is_it_returned_in_the_as_was_taken").val();
var id_data=$("#no_of_days_delayed").val();
 var damage_amount=$("#extent_of_damage_amount").val();

 

if ((value==0&&id_data=="")||(return_data==0 && damage_amount=="") ||(!(Number(id_data)%1===0))||(!(Number(damage_amount)%1===0)))
{
  if(return_data==0 && damage_amount==""){
     $("#damaged_amount_error").empty();
     var amountss_values=$("#extent_of_damage_amount").val();

 var fine=$("#fine_amount").val();
 $("#fine_amount").val(Number(fine)-Number(amountss_values));
$("#extent_of_damage_amount").val("");
    
    $("#damaged_amount_error").append("Please Enter The Amount")
//alert("Please Enter The Amount")
}
 if(value==0&&id_data==""){
 $("#no_of_days_delayed_error").empty();
 var amount_value=$("#fine_amount_data").val();

 var fine=$("#fine_amount").val();
 $("#fine_amount").val(Number(fine)-Number(amount_value));
$("#fine_amount_data").val("");
$("#no_of_days_delayed").val("");

    $("#no_of_days_delayed_error").append("Please Enter The Amount")

//alert("Please Enter the Fine Amount");
}
 if(!(Number(id_data)%1===0)){
//alert("Please Enter Integer");
 $("#no_of_days_delayed_error").empty();
var amount_value=$("#fine_amount_data").val();

 var fine=$("#fine_amount").val();
 $("#fine_amount").val(Number(fine)-Number(amount_value));

$("#fine_amount_data").val("");
$("#no_of_days_delayed").val("");
    $("#no_of_days_delayed_error").append("Please Enter The Integer")

}
if(!(Number(damage_amount)%1===0)){
//alert("Please Enter damaged Integer");
     $("#damaged_amount_error").empty();
     var amountss_values=$("#extent_of_damage_amount").val();

 var fine=$("#fine_amount").val();
 $("#fine_amount").val(Number(fine)-Number(amountss_values));
$("#extent_of_damage_amount").val("");

    $("#damaged_amount_error").append("Please Enter The Integer")

}
}
else
{
this.disabled=true

 var boolean_data=$("#is_fine_applicable").val();

 var data_id=$("#fine_amount").val();
 var dta_id=$("#extent_of_damage").val();



$.ajax({
            url:'/library/save_return_data',
            cache:false,
            data:{"no_of_days_delayed":id_data,"extent_of_damage":dta_id,"fine_amount":data_id,"inventory_id":myIDs,"boolean_data":boolean_data},
            success: function(data){
              $("#student_employee_data_info").empty();

              $("#library_particular_book_search").empty();

$("#student_employee_data_info").append("<div class='alert alert-info mg-success-msg'>Successfully Returned</div>");
              

            },
            error: function(data){

              alert("Not a valid User ID");
            }
          });


}

});

$(document).on("click",".renewsubmitslibrarysFormBtnId",function(e){
  e.preventDefault();

var myIDs =$(this).attr('id');
 
 
this.disabled=true
$.ajax({
            url:'/library/update_renew_data',
            cache:false,
            data:{"resource_type_id":myIDs},
            success: function(data){
              $("#student_employee_data_info").empty();

              $("#library_particular_book_search").empty();
              
              $("#student_employee_data_info").append("<div class='alert alert-info mg-success-msg'>Successfully Renewed</div>");


            },
            error: function(data){

              alert("Not a valid User ID");
            }
          });




});

$(document).on("click",".maxRenewalsallowed",function(e){
     e.preventDefault();

alert("Can not be renewed");
});


$(document).on("click","#maxCountsubmitlibraryFormBtnId",function(e){
     e.preventDefault();

alert("Book Can not be issued He has Taken Max Books");

})

$(document).on("click",".employeereturnsubmitlibraryFormBtnId",function(){


var value=$("#is_there_a_delay").val();
var id_data=$("#no_of_days_delayed").val();

if ((value==0&&id_data=="")||(!(Number(id_data)%1===0)))
{
  
 if(value==0&&id_data==""){
 $("#no_of_days_delayed_error").empty();
 

    $("#no_of_days_delayed_error").append("Please Enter The Data")

//alert("Please Enter the Fine Amount");
}
if(!(Number(id_data)%1===0)){
//alert("Please Enter Integer");
 $("#no_of_days_delayed_error").empty();
var amount_value=$("#fine_amount_data").val();

 var fine=$("#fine_amount").val();
 $("#fine_amount").val(Number(fine)-Number(amount_value));

$("#fine_amount_data").val("");
$("#no_of_days_delayed").val("");
    $("#no_of_days_delayed_error").append("Please Enter The Integer")

}
}
else{
this.disabled=true

var myIDs =$(this).attr('id');
//var value=$("#is_there_a_delay").val();
//var return_data=$("#is_it_returned_in_the_as_was_taken").val();
var id_data=$("#no_of_days_delayed").val();
 //var damage_amount=$("#extent_of_damage_amount").val();

 var boolean_data=$("#is_fine_applicable").val();

 var data_id=$("#fine_amount").val();
 var dta_id=$("#extent_of_damage").val();


$.ajax({
            url:'/library/save_return_data',
            cache:false,
            data:{"no_of_days_delayed":id_data,"extent_of_damage":dta_id,"fine_amount":data_id,"inventory_id":myIDs,"boolean_data":boolean_data},
            success: function(data){
              $("#student_employee_data_info").empty();

              $("#library_particular_book_search").empty();

              $("#student_employee_data_info").append("<div class='alert alert-info mg-success-msg'>Successfully Returned</div>");

            },
            error: function(data){

              alert("Not a valid User ID");
            }
          });



}
});
