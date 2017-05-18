
$(document).on("click", ".books_details_data_for_student_login", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
       
       
          var data=ID.split("-");
              var status_data=data[1];
              var id=data[0];
        var urlLink = "/dashboards/books_information_data_for_student";
       
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"book_id":id},
           success: function(html){

                  $('#book_details_pop_up').dialog({
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

$(document).on("click", ".submits_function_for_student", function(e){
       e.preventDefault();
       

        var ID =$(this).attr('id');
       
       
          var data=ID.split("-");
              var status_data=data[0];
              var id=data[1];
              var student_id=data[2]
        var urlLink = "/libraries/save_reservation_data";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"student_id":student_id,"inventory_id":id},
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

$(document).on("click",".guardian-student-profile",function(e){
        e.preventDefault();
        var Id=$(this).attr("id");
        $.ajax({
             url: "/dashboards/guardian_show/"+Id,
             data:{"id":Id},
            success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/

                    //   $('#profileDialogID').dialog({
                    //     modal: true,
                    //     title: "Show Student",
                    //     //top: 50px,
                    //     minWidth: 625,
                    //     open: function () {
                            
                    //         $(this).html(html);
                    //     }
                    // }); //end confirm dialog
                    $("#guardianStudentProfileViewDIV").empty();
                    $("#guardianStudentProfileViewDIV").append(html);
                   
                }
            });  

        });
$(document).on("click","#search_button_for_student",function(){

        var value=$("#search_by").val();
        var data=$("#search_name").val();
        
        if (value.length==0){

          alert("Please Enter the data to search...........")

        }
        else{
          $.ajax({
            url:'/dashboards/search_books_for_student',
            cache:false,
            data:{"Value":value,"Data":data,"demo":""},
            success: function(data){
              $("#books_details").empty();
              $("#books_details").append(data);


            }
          });


        }


});

      $(document).on("click",".guardian-student-contact-edit-btn",function(e){
        e.preventDefault();
        var myID =$(this).attr('id');
            var urlLink = "/dashboards/guardian_student_profile_contact_edit/"+myID;
            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                      $('<div class="fancybox-outer" style="padding: 5px 0 2px; overflow: hidden; width: auto; height: auto;"></div>').dialog({
                        modal: true,
                        minHeight: 350,
                        minWidth:680,
                        title: "Edit Contact",

                        open: function () {
                            $(this).html(html);
                        }
                    }); 
                }
            });
    });

  $(document).on("click",".guardian-student-address-edit-btn",function(e){
    e.preventDefault();
      var myID =$(this).attr('id');
            var urlLink = "/dashboards/guardian_student_profile_addres_edit/"+myID;
            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                      $('#guardianPAddressEditDialogID').dialog({
                        modal: true,
                        minHeight: 350,
                        minWidth:680,
                        title: "Edit Address",

                        open: function () {
                            $(this).html(html);
                        }
                    }); 
                }
            });
    });




  $(document).on("click",".guardian-student-correspondanceaddress-address-edit-btn",function(e){
    e.preventDefault();
      var myID =$(this).attr('id');
            var urlLink = "/dashboards/guardian_student_profile_correspondanceaddress_address_edit/"+myID;
            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                      $('#guardianCAddressEditDialogID').dialog({
                        modal: true,
                        minHeight: 350,
                        minWidth:680,
                        title: "Edit Address",

                        open: function () {
                            $(this).html(html);
                        }
                    }); 
                }
            });
    });

// Hello from java
$(document).ready(function() {

//     $(".tabs").click(function() {
//    $(this).attr("href","newhref.com");
    var myVarsJSON = $("#my_vars_json").html();

    //      console.log(JSON.stringify(myVarsJSON));

    //  console.log(myVarsJSON.length); 

    // comments   
    window.f = "";
// });
    if (typeof myVarsJSON != 'undefined') {

        f = myVarsJSON.replace(/&quot;/g, '');
    }

   $(document).on("click","#homeID_demo",function(){
    //alert("hello");

            if(f.trim() == "student"){
   // alert("studenrt");

                $(this).attr("href","/dashboards/student/");
            }              if(f.trim() == "employee"){
   // alert("studenrt");

                $(this).attr("href","/dashboards/employee/");
            }              if(f.trim() == "guardian"){
  //  alert("studenrt");

                $(this).attr("href","/dashboards/guardian/");
            }              
            if(f.trim() == "principal"){
               //  alert("principle");

                $(this).attr("href","/dashboards/principle/");
            } 

            if(f.trim() == "admin"){
               //  alert("principle");

                $(this).attr("href","/dashboards");
            }  


   });


    
    if (f.trim() == "student") {


        // Adding class 

        // $("#viewStudentProfile").addClass("activeMenu");
        // $("#viewStudentProfileLiID").addClass("active");


        // var urlLink = "/dashboards/student_profile/";
        // $.ajax({
        //     url: urlLink,
        //     cache: false,
        //     success: function(html) {
        //         $("#manageStudentCategoryID").empty();
        //         $("#manageStudentCategoryID").append(html);

                
        // $("#viewStudentProfile").addClass("activeMenu");
        // $("#viewStudentProfileLiID").addClass("active");
        //     }
        // });
    } else if (f.trim() == "parent") {



        // $("#viewGuardianProfile").addClass("activeMenu");
        // $("#viewGuardianProfileLiID").addClass("active");


        // $("#viewAdminProfile").addClass("activeMenu");
        // $("#viewAdminProfileLiID").addClass("active");

        // var urlLink = "/dashboards/guardian_dashboard/";
        // $.ajax({
        //     url: urlLink,
        //     cache: false,
        //     success: function(html) {
        //         $("#manageGuardianCategoryID").empty();
        //         $("#manageGuardianCategoryID").append(html);

        //      //   $("#viewGuardianProfileLiID").addClass("active");
        //      //   $("#viewGuardianProfile").addClass("activeMenu");

        //     }
        // });

    } else if (f.trim() == "employee") {
        // $("#viewEmployeeProfile").addClass("activeMenu");
        // $("#viewEmployeeProfileLiID").addClass("active");


        // var urlLink = "/dashboards/employee_profile/";
        // $.ajax({
        //     url: urlLink,
        //     cache: false,
        //     success: function(html) {
        //         $("#manageEmployeeCategoryID").empty();
        //         $("#manageEmployeeCategoryID").append(html);

        //         $("#viewEmployeeProfileLiID").addClass("active");
        //         $("#viewEmployeeProfile").addClass("activeMenu");
        //     }
        // });
    }else if (f.trim() == "principal") {
        // $("#viewEmployeeProfile").addClass("activeMenu");
        // $("#viewEmployeeProfileLiID").addClass("active");


        // var urlLink = "/dashboards/principle_dashboard/";
        // $.ajax({
        //     url: urlLink,
        //     cache: false,
        //     success: function(html) {
        //         $("#manageEmployeeCategoryID").empty();
        //         $("#manageEmployeeCategoryID").append(html);

        //   //      $("#viewEmployeeProfileLiID").addClass("active");
        //   //      $("#viewEmployeeProfile").addClass("activeMenu");
        //     }
        // });
    } else if (f.trim() == "admin") {

        // $("#viewAdminProfile").addClass("activeMenu");
        // $("#viewAdminProfileLiID").addClass("active");


        var urlLink = "/dashboards/admin_mail/";
        $.ajax({
            url: urlLink,
            cache: false,
            success: function(html) {
                $("#manageAdminCategoryID").empty();
                $("#manageAdminCategoryID").append(html);

                $("#viewAdminProfileLiID").addClass("active");
                $("#viewAdminProfile").addClass("activeMenu");
            }
        });




    }

});

function removeGuardianLiAClass() {


    $("#viewGuardianProfileLiID").removeClass("active");
    $("#viewGuardianProfile").removeClass("activeMenu");

    $("#viewGuardianEventsLiID").removeClass("active");
    $("#viewGuardianEvents").removeClass("activeMenu");

    $("#viewGuardianMessagesLiID").removeClass("active");
    $("#viewGuardianMessages").removeClass("activeMenu");

    $("#viewGuardianNewsLiID").removeClass("active");
    $("#viewGuardianNews").removeClass("activeMenu");

    $("#GuardianStudentAttendenceLiID").removeClass("active");
    $("#GuardianStudentAttendenceID").removeClass("activeMenu");

}

function removeStudentLiAClass() {


    $("#viewStudentProfileLiID").removeClass("active");
    $("#viewStudentProfile").removeClass("activeMenu");

    $("#viewStudentEventsLiID").removeClass("active");
    $("#viewStudentEvents").removeClass("activeMenu");

    $("#ViewStudentMessagesLiID").removeClass("active");
    $("#ViewStudentMessages").removeClass("activeMenu");

    $("#ViewStudentNewsLiID").removeClass("active");
    $("#ViewStudentNews").removeClass("activeMenu");

    $("#ViewStudentAttendenceLiID").removeClass("active");
    $("#ViewStudentAttendence").removeClass("activeMenu");

}

function removeEmployeeLiAClass() {

    $("#viewEmployeeProfileLiID").removeClass("active");
    $("#viewEmployeeProfile").removeClass("activeMenu");

    $("#viewEmployeeEventsLiID").removeClass("active");
    $("#viewEmployeeEvents").removeClass("activeMenu");

    $("#viewEmployeeMessagesLiID").removeClass("active");
    $("#viewEmployeeMessages").removeClass("activeMenu");

    $("#viewEmployeeAttendancesLiID").removeClass("active");
    $("#viewEmployeeAttendances_demo").removeClass("activeMenu");

    $("#viewEmployeeNewsLiID").removeClass("active");
    $("#viewEmployeeNews").removeClass("activeMenu");

}


// $(document).on("click", "#viewEmployeeProfile", function(e) {

//     removeEmployeeLiAClass();

//     $("#viewEmployeeProfileLiID").addClass("active");
//     $("#viewEmployeeProfile").addClass("activeMenu");

//     //alert("hello");
//     var urlLink = "/dashboards/employee_profile/";
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             $("#manageEmployeeCategoryID").empty();
//             $("#manageEmployeeCategoryID").append(html);
//         }
//     });

// });

// $(document).on("click", "#viewEmployeeEvents", function(e) {
//     removeEmployeeLiAClass();

//     $("#viewEmployeeEventsLiID").addClass("active");
//     $("#viewEmployeeEvents").addClass("activeMenu");

//     var urlLink = "/dashboards/employee_events/";
//     //  alert(urlLink)
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             //  alert("hii")
//             $("#manageEmployeeCategoryID").empty();
//             $("#manageEmployeeCategoryID").append(html);
//         }
//     });

// });


// $(document).on("click", "#viewEmployeeMessages", function(e) {

//     removeEmployeeLiAClass();

//     $("#viewEmployeeMessagesLiID").addClass("active");
//     $("#viewEmployeeMessages").addClass("activeMenu");

//     //alert("hello");
//     var urlLink = "/dashboards/employee_messages/";
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             console.log(html);
//             //$(this).removeClass("header");
//             $("#manageEmployeeCategoryID").empty();
//             $("#manageEmployeeCategoryID").append(html);
//         }

//     });
// });

// $(document).on("click", "#viewEmployeeNews", function(e) {

//     removeEmployeeLiAClass();

//     $("#viewEmployeeNewsLiID").addClass("active");
//     $("#viewEmployeeNews").addClass("activeMenu");

//     var urlLink = "/dashboards/employee_news";
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             console.log(html);
//             //$(this).removeClass("header");
//             $("#manageEmployeeCategoryID").empty();
//             $("#manageEmployeeCategoryID").append(html);
//         }

//     });
// });



// $(document).on("click", "#viewStudentProfile", function(e) {


//     removeStudentLiAClass();

//     $("#viewStudentProfileLiID").addClass("active");
//     $("#viewStudentProfile").addClass("activeMenu");



//     var myID1 = $(this).attr('id');
//     // alert("hi");
//     // alert(myID1);
//     var urlLink = "/dashboards/show/";

//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             $("#manageStudentCategoryID").empty();
//             $("#manageStudentCategoryID").append(html);
//         }
//     });

// });

// $(document).on("click", "#viewStudentEvents", function(e) {
 
//     removeStudentLiAClass();

//     $("#viewStudentEventsLiID").addClass("active");
//     $("#viewStudentEvents").addClass("activeMenu");
//     var urlLink = "/dashboards/student_event/";

//     $.ajax({
//         url: urlLink,
//         cache: false,
//         type: "GET",
//         success: function(html) {
//             // alert("hello")
//             $("#manageStudentCategoryID").empty();
//             $("#manageStudentCategoryID").append(html);
//         }
//     });

// });


$(document).on("click", ".Student-Messages", function(e) {

    //alert("hello");
    var urlLink = "/dashboards/student_messages/";
    $.ajax({
        url: urlLink,
        cache: false,
        success: function(html) {
            console.log(html);
            //$(this).removeClass("header");
            $("#manageStudentCategoryID").empty();
            $("#manageStudentCategoryID").append(html);
        }

    });
});

// $(document).on("click", "#ViewStudentNews", function(e) {


//     removeStudentLiAClass();

//     $("#ViewStudentNewsLiID").addClass("active");
//     $("#ViewStudentNews").addClass("activeMenu");

//     var urlLink = "/dashboards/student_news/";
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             console.log(html);
//             //$(this).removeClass("header");
//             $("#manageStudentCategoryID").empty();
//             $("#manageStudentCategoryID").append(html);
//         }

//     });
// });


// $(document).on("click", "#viewGuardianProfile", function(e) {


//     removeGuardianLiAClass();

//     $("#viewGuardianProfileLiID").addClass("active");
//     $("#viewGuardianProfile").addClass("activeMenu");

//     //alert("hello");
//     var urlLink = "/dashboards/guardian_profile/";
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             $("#manageGuardianCategoryID").empty();
//             $("#manageGuardianCategoryID").append(html);
//         }
//     });

// });

// $(document).on("click", "#viewGuardianEvents", function(e) {

//     removeGuardianLiAClass();

//     $("#viewGuardianEventsLiID").addClass("active");
//     $("#viewGuardianEvents").addClass("activeMenu");

//     //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
//     var urlLink = "/dashboards/guardian_events/";
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             $("#manageGuardianCategoryID").empty();
//             $("#manageGuardianCategoryID").append(html);
//         }
//     });

// });


$(document).on("click", "#GuardianStudents", function(e) {
 
    //removeStudentLiAClass();
    //alert("Hello ");
    
    var urlLink = "/dashboards/guardian_students/";

    $.ajax({
        url: urlLink,
        cache: false,
        type: "GET",
        success: function(html) {
            // alert("hello")
            $("#manageGuardianCategoryID").empty();
            $("#manageGuardianCategoryID").append(html);
        }
    });

});

$(document).on("click", "#viewGuardianMessages", function(e) {

    removeGuardianLiAClass();

    $("#viewGuardianMessagesLiID").addClass("active");
    $("#viewGuardianMessages").addClass("activeMenu");

    //alert("hello");
    var urlLink = "/dashboards/guardian/";
    $.ajax({
        url: urlLink,
        cache: false,
        success: function(html) {
            console.log(html);
            //$(this).removeClass("header");
            $("#manageGuardianCategoryID").empty();
            $("#manageGuardianCategoryID").append(html);
        }

    });
});

// $(document).on("click", "#viewGuardianNews", function(e) {


//     removeGuardianLiAClass();

//     $("#viewGuardianNewsLiID").addClass("active");
//     $("#viewGuardianNews").addClass("activeMenu");

//     var urlLink = "/dashboards/guardian_news/";
//     $.ajax({
//         url: urlLink,
//         cache: false,
//         success: function(html) {
//             console.log(html);
//             //$(this).removeClass("header");
//             $("#manageGuardianCategoryID").empty();
//             $("#manageGuardianCategoryID").append(html);
//         }

//     });
// });

function removeAdminLiAClass() {

    $("#viewAdminProfileLiID").removeClass("active");
    $("#viewAdminProfile").removeClass("activeMenu");

    $("#viewAdminEventsLiID").removeClass("active");
    $("#viewAdminEvents").removeClass("activeMenu");

    $("#viewAdminMessagesLiID").removeClass("active");
    $("#viewAdminMessages").removeClass("activeMenu");

    $("#viewAdminNewsLiID").removeClass("active");
    $("#viewAdminNews").removeClass("activeMenu");

    $("#viewAdminCalendarLiID").removeClass("active");
    $("#viewAdminCalendar").removeClass("activeMenu");



}

$(document).on("click", "#viewAdminProfile", function(e) {

    removeAdminLiAClass();

    $("#viewAdminProfileLiID").addClass("active");
    $("#viewAdminProfile").addClass("activeMenu");

    //alert("hello");
    var urlLink = "/dashboards/admin_mail/";
    $.ajax({
        url: urlLink,
        cache: false,
        success: function(html) {
            $("#manageAdminCategoryID").empty();
            $("#manageAdminCategoryID").append(html);
        }
    });

});

$(document).on("click", "#viewAdminEvents", function(e) {
    removeAdminLiAClass();
    $("#viewAdminEventsLiID").addClass("active");
    $("#viewAdminEvents").addClass("activeMenu");

    //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
    var urlLink = "/student_categories";
    $.ajax({
        url: urlLink,
        data: {"data":"hello"},
        cache: false,
        success: function(html) {
            //$("#manageAdminCategoryID").empty();
            $("#manageAdminCategoryID").html(html);
        }
    });

});

$(document).on("click", "#viewAdminMessages", function(e) {

    removeAdminLiAClass();

    $("#viewAdminMessagesLiID").addClass("active");
    $("#viewAdminMessages").addClass("activeMenu");

    //alert("hello");
    var urlLink = "/dashboards/admin_messages/";
    $.ajax({
        url: urlLink,
        cache: false,
        success: function(html) {
            console.log(html);
            //$(this).removeClass("header");
            $("#manageAdminCategoryID").empty();
            $("#manageAdminCategoryID").append(html);
        }

    });
});


$(document).on("click", "#viewAdminNews", function(e) {

    removeAdminLiAClass();

    $("#viewAdminNewsLiID").addClass("active");
    $("#viewAdminNews").addClass("activeMenu");

    var urlLink = "/dashboards/admin_news/";
    $.ajax({
        url: urlLink,
        cache: false,
        success: function(html) {
            console.log(html);
            //$(this).removeClass("header");
            $("#manageAdminCategoryID").empty();
            $("#manageAdminCategoryID").append(html);
        }

    });
});

$(document).on("click", "#viewAdminCalendar", function(e) {

    removeAdminLiAClass();

    $("#viewAdminCalendarLiID").addClass("active");
    $("#viewAdminCalendar").addClass("activeMenu");

    var urlLink = "/dashboards/admin_calendar/";
    $.ajax({
        url: urlLink,
        cache: false,
        success: function(html) {
            console.log(html);
            //$(this).removeClass("header");
             $("#manageAdminCategoryID").empty();
            $("#manageAdminCategoryID").append(html);
        }

    });
});

$(document).on("click", "#viewReportsAID", function(e) {

    removeAdminLiAClass();

    $("#viewReportsLiID").addClass("active");
    $("#viewReportsAID").addClass("activeMenu");

    //alert("hello");
    var urlLink = "/reports/index/";
    $.ajax({
        url: urlLink,
        cache: false,
        success: function(html) {
            console.log(html);
            //$(this).removeClass("header");
            $("#manageAdminCategoryID").empty();
            $("#manageAdminCategoryID").append(html);
        }

    });
});



function onChangeFunctionForPrincipalChart(value){
    if (value=='leave_status'){
        $("#employeeDashboardPrincipalCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").show();
        $("#feeDefaulterForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
        $("#evntForDashboardDIVID").hide();

        

        
    }
    if(value=="attendance_teaching"){
        $("#employeeDashboardPrincipalCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#feeDefaulterForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").hide();


    }
    

    if(value=='syllabus_progress'){
        $("#employeeDashboardPrincipalCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#feeDefaulterForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").show();
    $("#evntForDashboardDIVID").hide();


    }
    if(value=='notification'){
        $("#employeeDashboardPrincipalCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#feeDefaulterForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").show();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").hide();


    }
    if(value=='events'){
        // $("#employeeDashboardPrincipalCalenderDIVID").append('<div id="employeeDashboardPrincipalCalender" class="mg-tbl-margin"></div>');
        // eventDashboardPrincipalCalender();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#feeDefaulterForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").show();


    }
    if(value=='time_table'){
        $("#employeeDashboardCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").show();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").hide();






    }
    if(value=='attendance_teaching'){
        $("#employeeDashboardCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").show();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").hide();


    }
    if(value=='attendance'){
        $("#employeeDashboardPrincipalCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").show();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#feeDefaulterForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").hide();


    }
    if(value=='fee_defaulter'){
        $("#employeeDashboardPrincipalCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#feeDefaulterForPrincipalDIVID").show();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").hide();
        $("#feeDefaulterPrincipalDashboardDIVID").show();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").hide();


    }
    if(value=='fee_collection'){
        $("#employeeDashboardPrincipalCalenderDIVID").empty();
        $("#employeeDashboardPrincipalAbsentTeacherDIVID").hide();
        $("#employeeDashboardPrincipalAbsentNonTeacherDIVID").hide();
        $("#leaveDetailsForPrincipalDIVID").hide();
        $("#feeDefaulterForPrincipalDIVID").hide();
        $("#todayTimeTableForPrincipleDIVID").hide();
        $("#feeCollectionPrincipleDashBoardDIVID").show();
        $("#feeDefaulterPrincipalDashboardDIVID").hide();
        $("#notificationPrincipalDashboardDIVID").hide();
        $("#trackSyllabusDashboardPrincipalDIVID").hide();
    $("#evntForDashboardDIVID").hide();


    }

 }

$(document).on("click", ".subject-class-list-dashboard-cls", function(e){
        var myID =$(this).attr('id');
        var mg_employee_id=myID.split("-");


        var urlLink = "/dashboards/sublect_and_class_for_employee/"+mg_employee_id;
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#employeeDashboardSubjectPrincipalShowDIVID').dialog({
                    modal: true,
                    width: '330',
                    height: 'auto',

                    title: "Subject & Class",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on('change','#attendencePrincipalDepartmentID',function(e){
 e.preventDefault();
    var departmentId = $("#attendencePrincipalDepartmentID").val();
    var urlLink = "/employees_attendances/employee_list";
          $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                departmentId: departmentId,
                departmentParam: 'departmentParam'
            },
            success: function(data)
            {
                if(data.employee.length > 0){ 
                   var str='<table class="batch-tbl" cellspacing="0" style="padding:0;width:50%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th>First Name</th><th>Last Name</th><th>actions</th></tr>';
                   for(key in data.employee )  
                   {
                        var employeeId=data.employee[key].id;
                        var employeeName=data.employee[key].first_name;
                        var employeeLastName=data.employee[key].last_name;
                        str +='<tr class="employee-class" rowspan="2"><td>'+employeeName+'</td><td>'+employeeLastName+'</td><td><a , id="'+employeeId+'-AttendanceLeaveDetailsBTNID" class="mg-employee-leave-taken-list-cls">View Leave</a></td></tr>';
                   }
                   str +='</table>';

                   console.log(str) ;

                   $("#employeeDashboardSubjectPrincipalLeaveShowDIVID").empty();
                   $("#employeeDashboardSubjectPrincipalLeaveShowDIVID").append(str);

               }else{
                 var str='Employee Not Found';
                   $("#employeeDashboardSubjectPrincipalLeaveShowDIVID").empty();
                 $("#employeeDashboardSubjectPrincipalLeaveShowDIVID").append(str);
               }

            }   
        }); 

});


$(document).on('click','.mg-employee-leave-taken-list-cls',function(e){
  e.preventDefault();
 var myID =$(this).attr('id');
   var splitId=myID.split("-");
   var urlLink = "/employees_attendances/leave_details_for_employee/"+splitId[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#employeeLeaveTypeReportPrincipalDIVID').dialog({
                    modal: true,
                    width: 'auto',
                    title: "Leave Report",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


//employee
 function onChangeFunctionForEmployeeChart(value){
    if (value=='leave_status'){
        $("#employeeLeaveStatusChartDIVID").show();
        $("#employeeAttendanceChartDIVID").hide();
        $("#showNotificationDashboardEmployeeDIVID").hide();
        $("#employeeDashboardCalenderDIVID").hide();
        $("#employeeDashboardTimeTableDivid").hide();
        $("#employeeDashboardSyllabusDivid").hide();

        

        

    }
    if(value=='attendance'){
        $("#employeeAttendanceChartDIVID").show();
        $("#employeeLeaveStatusChartDIVID").hide();
        $("#showNotificationDashboardEmployeeDIVID").hide();
        $("#employeeDashboardCalenderDIVID").hide();
        $("#employeeDashboardTimeTableDivid").hide();
        $("#employeeDashboardSyllabusDivid").hide();



    }
    if(value=='syllabus_progress'){
        $("#employeeAttendanceChartDIVID").hide();
        $("#employeeLeaveStatusChartDIVID").hide();
        $("#showNotificationDashboardEmployeeDIVID").hide();
        $("#employeeDashboardCalenderDIVID").hide();
        $("#employeeDashboardTimeTableDivid").hide();
        $("#employeeDashboardSyllabusDivid").show();




    }
    if(value=='notification'){
        $("#employeeAttendanceChartDIVID").hide();
        $("#employeeLeaveStatusChartDIVID").hide();
        $("#showNotificationDashboardEmployeeDIVID").show();
        $("#employeeDashboardCalenderDIVID").hide();
        $("#employeeDashboardTimeTableDivid").hide();
        $("#employeeDashboardSyllabusDivid").hide();



    }
    if(value=='events'){
        $("#employeeAttendanceChartDIVID").hide();
        $("#employeeLeaveStatusChartDIVID").hide();
        $("#showNotificationDashboardEmployeeDIVID").hide();
        // $("#employeeDashboardCalenderDIVID").show();
        $("#employeeDashboardCalenderDIVID").show();
        // .append('<div id="employeeDashboardCalender" class="mg-tbl-margin"></div>');
        // eventDashboardCalender();
        $("#employeeDashboardTimeTableDivid").hide();
        $("#employeeDashboardSyllabusDivid").hide();


        



    }
    if(value=='time_table'){
        $("#employeeAttendanceChartDIVID").hide();
        $("#employeeLeaveStatusChartDIVID").hide();
        $("#showNotificationDashboardEmployeeDIVID").hide();
        $("#employeeDashboardCalenderDIVID").hide();
        $("#employeeDashboardTimeTableDivid").show();
        $("#employeeDashboardSyllabusDivid").hide();




    }
 }


function onChangeFunctionForGuardianChart(value){

  if(value=='attendance'){
    $("#attendanceCalendarGuardianDashboardHideDIVID").show();
    $("#employeeDashboardGuardianCalenderDIVID").hide();
    $("#ShowNotificationForGuardianDashBoardDIVID").hide();
    $("#feeReciptForGuardianDashboardDIVID").hide();
    

    
  }

  if(value=='homework'){
    $("#attendanceCalendarGuardianDashboardHideDIVID").hide();
    $("#employeeDashboardGuardianCalenderDIVID").hide();
    $("#ShowNotificationForGuardianDashBoardDIVID").hide();
    $("#feeReciptForGuardianDashboardDIVID").hide();


    
  }
  
  if(value=='notification'){
    $("#attendanceCalendarGuardianDashboardHideDIVID").hide();
    $("#employeeDashboardGuardianCalenderDIVID").hide();
    $("#ShowNotificationForGuardianDashBoardDIVID").show();
    $("#feeReciptForGuardianDashboardDIVID").hide();



  }
  if(value=='events'){
    $("#attendanceCalendarGuardianDashboardHideDIVID").hide();
    // $("#employeeDashboardGuardianCalenderDIVID").append('<div id="employeeDashboardguardianCalender" class="mg-tbl-margin"></div>');
    // eventDashboardStudentCalender();
    $("#employeeDashboardGuardianCalenderDIVID").show();
    $("#ShowNotificationForGuardianDashBoardDIVID").hide();
    $("#feeReciptForGuardianDashboardDIVID").hide();



  }
  if(value=='time_table'){
    $("#attendanceCalendarGuardianDashboardHideDIVID").hide();
    $("#employeeDashboardGuardianCalenderDIVID").hide();
    $("#ShowNotificationForGuardianDashBoardDIVID").hide();
    $("#feeReciptForGuardianDashboardDIVID").hide();

    

  }
   if(value=='receipts'){
    $("#attendanceCalendarGuardianDashboardHideDIVID").hide();
    $("#employeeDashboardGuardianCalenderDIVID").hide();
    $("#ShowNotificationForGuardianDashBoardDIVID").hide();
    $("#feeReciptForGuardianDashboardDIVID").show();
    // $("#feeReciptForGuardianDashboardDIVID").hide();


    
    

  }
   if(value=='result'){
    $("#attendanceCalendarGuardianDashboardHideDIVID").hide();
    $("#employeeDashboardGuardianCalenderDIVID").hide();
    $("#ShowNotificationForGuardianDashBoardDIVID").hide();
    $("#feeReciptForGuardianDashboardDIVID").hide();

    
    

  }
 }

