  

$(document).on("click", ".selectreset_all_class", function(e){
        var studentCategoryID =$(this).attr('id');
     //   alert(studentCategoryID);
        // var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/employees_attendances/reset_all";
        // alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                    modal: true,
                    title: "Edit Student Category",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});




$(document).on("click", ".select_reset_all_class", function(e){
    var myID =$(this).attr('id');

    // var splString = myID.split("-");
    var retVal = confirm("Are you sure to delete course?");
 
       // alert(retVal);
         var urlLink = "/employees_attendances/reset_all/"+2;

          $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
               window.location.reload();
                           
            }
        }); 
});  

$(document).on("click", ".departmentResetclass", function(e){
    var myID =$(this).attr('id');
   // alert("hiiii")
    $("#show-dept-reset").toggle();
});  

$(document).on("click", ".individualResetclass", function(e){
    var myID =$(this).attr('id');
    //alert("hiiii")
    $("#show-indi-reset").toggle();
});


$(document).on("click", ".dept-reset", function(e){

    var myID =$(this).attr('id');

    // var splString = myID.split("-");
    var retVal = confirm("Are you sure to delete course?");
      var departmentId  = $("#employees_attendances_mg_dept_id").val();
 
      //  alert("departmentId :"+departmentId);
         var urlLink = "/employees_attendances/reset_all/"+2;

          $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
               window.location.reload();
                           
            }
        }); 
});  



 $(document).on("click","#employeeAttendanceDoneBTNID",function(e){
  attendance();
 });

function departmentChange(){

attendance();
}


  function attendance(){
    // e.preventDefault();
                    var SelectValueIs = $( "#attendances_mg_employee_department_id" ).val();
                    if(SelectValueIs){

                    $( "#employeeAttendanceDatePickerID" ).datepicker("hide");


                     var month = parseInt($("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
                     var year = parseInt($("#ui-datepicker-div .ui-datepicker-year :selected").val());
                      
                    
                      if(isNaN(month)){
                        
                        var presentDate = new Date();
                        month=presentDate.getMonth()+1;
                        year=presentDate.getFullYear();

                        // year1=year;
                        // month1=month;

                      }
                 

                     

                    var days = new Array(7);
                        days[0]=  "Sun";
                        days[1] = "Mon";
                        days[2] = "Tues";
                        days[3] = "Wed";
                        days[4] = "Thur";
                        days[5] = "Fri";
                        days[6] = "Sat";
                    Date.prototype.getDayName = function() {
                            return days[ this.getDay() ];
                        };
                    //  generate dynamic calendr here
                    var totalDays = parseInt(daysInMonth(month, year));

                    var strDates = "<thead><tr><th class='mg-fix-width'>Name</th>"
                    for(var index=1; index <= totalDays;index++){
                               var now = new Date(year,month-1,index);
                  strDates +="<th>"+index+"<br/>"+now.getDayName()+"</th>";
                                 
                                
                    }
                    // strDates +="";
                
                  $('.header-row-data').empty();
                    $('.header-row-data').prepend( strDates );
                     var urlLink = "/employees_attendances/studentsHash/"+SelectValueIs;  
                             $.ajax({
                        url: urlLink,
                        cache: false, 
                        success: function(data) {
                                var strName = "";
                                var count=0;
                                var day_1=new Date().getDate();
                                var day=new Date().getDate();

                                var current_month = parseInt(new Date().getMonth()) + 1;
                                var current_year = parseInt(new Date().getFullYear());
                              //  alert(day_1+":"+current_month+":"+current_year);
                              
                                for(var outerIndex = 0;outerIndex < data[0].length;outerIndex++){
                                    strName += "<tr><th>"+data[0][outerIndex].first_name+"</th>"
                                    for(var index=1; index <= totalDays;index++){
                                    var value=0;

                                    if(new Date().getDate()<index && current_month==month && current_year==year){
                                      value=4;
                                     //}else if(current_month<month || current_year<year){// && current_year<year
                                      }else if(new Date(month+'/01/'+year) > new Date(current_month+'/01/'+current_year)){
                                      value=5;
                                     }else{
                                      // var date=year1+'-'+month1+'-'+index;
                                      //var value=0;
                                      if(data[1].length >0){
                                           for(var dbindex=0;dbindex< data[1].length;dbindex++){
                                                var checkDate=month+'/'+index+'/'+year
                                                    d = new Date(checkDate); 
                                                    x = d.getDay(); 
                                                    if(data[2].indexOf(x)>-1){
                                                      value = 2;
                                                    }
                                                    if(data[1][dbindex].year ==year && data[1][dbindex].month ==month && data[1][dbindex].day== index && data[1][dbindex].mg_employee_id==data[0][outerIndex].id && x !=0 && data[1][dbindex].created_at==data[1][dbindex].updated_at){
                                                       value = 1;
                                                     }
                                                    if(data[1][dbindex].year ==year && data[1][dbindex].month ==month && data[1][dbindex].day== index && data[1][dbindex].mg_employee_id==data[0][outerIndex].id && x !=0 && data[1][dbindex].created_at!=data[1][dbindex].updated_at){
                                                     value = 3;
                                                    }
                                              }
                                      }else{
                                            var checkDate=month+'/'+index+'/'+year;
                                            x = new Date(checkDate).getDay();
                                            if(data[2].indexOf(x)>-1){
                                              value = 2;
                                            }
                                      } 
                                      }  
                                      var TDID="TDID";
                                    if (value!=5){
                                        if (value!=4){
                                            if(value!=1 && value!=2 && value ==3){
                                              strName +="<td class='mg-att-bg-clr' bgcolor='#ffb0b0' id='"+index+","+data[0][outerIndex].id+TDID+"'><a id="+ index+","+data[0][outerIndex].id +" class='atts_class-all'><i class='fa fa-circle'> </i></a></td>";
                                            }else if(value!=1 && value==2 && value !=3){
                                              strName +="<td><i class='fa fa-ellipsis-h'></i></td>";
                                            }else if(value==1 && value!=2 && value !=3){
                                              strName +="<td class='mg-att-bg-clr' id='"+index+","+data[0][outerIndex].id+TDID+"'><a id="+ index+","+data[0][outerIndex].id +" class='atts_class-all'><i class='fa fa-circle' > </i></a></td>";
                                            }else{
                                             strName +="<td class='mg-att-bg-clr' id='"+index+","+data[0][outerIndex].id+TDID+"'><a id="+ index+","+data[0][outerIndex].id +" class='atts_class-all'><i class='fa fa-check' > </i></a></td>";

                                            }
                                        }else{
                                          strName +="<td></td>";
                                          console.log("value 4 ---->  else");
                                        }
                                    }else{
                                          strName +="<td></td>";
                                          console.log("value 5 ---->  else");

                                    }



                                    }
                                  // 
                                    strName +="</tr>";
                                }
                                 var table_part1='<div class="ul-container"><div class="component"><table class="att-calendar mg-scroll-att-table overflow-y"   id="mg-scroll-attendance-tbl">';
                                 var table_part2='</table></div> </div>'  ;
                                     
                                $('#attendanceTanleAppendDIVID').empty();
                                $('#attendanceTanleAppendDIVID').html( table_part1+strDates+"</tr></thead><tbody>"+strName+"</tbody>" );
                                console.log(strDates+"</tr></thead><tbody>"+strName+"</tbody>"+table_part2);
                                // table_sticky("mg-scroll-attendance-tbl");
                              },
                        error: function() {
                                alert("Please Select Department");
                                // $('#attendanceTanleAppendDIVID').empty();
                              }
                });  // Ajax close"

             }else{
              $('#attendanceTanleAppendDIVID').empty();
             }

                // });  // on click is close for that button

  }



// $(function).on("change","#attendances_mg_employee_department_id",function(){
// alert("hi");
// });
// index page js

          function daysInMonth(iMonth, iYear){
                    return new Date(iYear, iMonth, 0).getDate();
                }  
  





function toggleAll()
{
 //    alert("i'm in toggleAll function");
 $("#whatever").toggle();
}



$(document).on("click", "#emp_attendances_halfday", function(){
 
       var depVal = $("#emp_attendances_halfday").is(':checked')
       $("#emp_halfdayfield").val(depVal);
        });


$(document).on("click", "#employees_attendances_is_afternoon_false", function(){

       var depVal = $("#employees_attendances_is_afternoon_false").val();
  //     alert("i am in afternoon false");
       $("#emp_afternoonfield").val(depVal);
        });


$(document).on("click", "#employees_attendances_is_afternoon_true", function(){
    
       var depVal = $("#employees_attendances_is_afternoon_true").val();
   //    alert("i am in afternoon true");

       $("#emp_afternoonfield").val(depVal);
        });




$(document).on("click",".is-half-day-count",function(e){
                  e.preventDefault();
  
  var id =$(this).attr('id');
  var arr = id.split(",");
        $.ajax({
        url: "/employees_attendances/report/",
        type: "get",
        cache: false,
        data:{ "employee":"halfday", start_date:arr[0], end_date:arr[1], employeeID:arr[2]

        },
        success:function(data){
          if(data.halfdayObject.length >0){

                // alert("success");
                 var str='<table class="batch-tbl" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th>Absent Date</th><th>Reason</th><th>Leave type</th></tr>';
                  $("#employeeLeaveSelectID").append(str);


                   for(key in data.halfdayObject )  
                   {
                        var absentDate=data.halfdayObject[key].absent_date;
                        var reson=data.halfdayObject[key].reason;
                        var mg_leave_type_id=data.halfdayObject[key].mg_leave_type_id;
                        var name="undiffined"
                          for(i in data.leaveName){
                            if(data.leaveName[i].id==data.halfdayObject[key].mg_leave_type_id){
                              name =data.leaveName[i].leave_name
                            }
                          }
                        str +='<tr class="employee-class" rowspan="2"><td>'+absentDate+'</td><td>'+reson+'</td><td>'+name+'</td></tr>';
                   }
                   str +='</table>';
                   
                  $('#employeeAttendanceLeaveReportForHalfDayDIVID').dialog({
                        modal: true,
                        title: "Halfday",
                        width:'450',
                        open: function () {
                            
                            $(this).html(str);
                        }
                    }); 
              

               }else{
                alert("No half day");
              }
             

            },
        error: function(){
          alert("Error: Please try again.");
        }

    }); 

});

// is-full-day-count

$(document).on("click",".is-full-day-count",function(e){
                  e.preventDefault();

  var id =$(this).attr('id');
  var arr = id.split(",");
        $.ajax({
        url: "/employees_attendances/report/",
        type: "get",
        cache: false,
        data:{ "employee":"fullday", start_date:arr[0], end_date:arr[1], employeeID:arr[2]

        },
        success:function(data){
          if(data.fulldayObject.length >0){

                // alert("success");
                 var str='<div class="mg-scroll-employee-bar"><table class="batch-tbl" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th>Absent Date</th><th>Reason</th><th>Leave Type</th></tr>';
                  $("#employeeLeaveSelectID").append(str);


                   for(key in data.fulldayObject )  
                   {
                        var absentDate=data.fulldayObject[key].absent_date;
                        var reson=data.fulldayObject[key].reason;
                         var mg_leave_type_id=data.fulldayObject[key].mg_leave_type_id;
                        var name="undiffined"
                          for(i in data.leaveName){
                            if(data.leaveName[i].id==data.fulldayObject[key].mg_leave_type_id){
                              name =data.leaveName[i].leave_name
                            }
                          }
                        str +='<tr class="employee-class" rowspan="2"><td>'+absentDate+'</td><td>'+reson+'</td><td>'+name+'</td></tr>';
                   }
                   str +='</table></div>';
                  $('#employeeAttendanceLeaveReportForFullDayDIVID').dialog({
                    modal: true,
                    title: "Absent Days",
                    width:'auto',
                    open: function () {
                        
                        $(this).html(str);
                    }
                }); 

               }else{
                alert("No full Day");
              }
              
              
              

            },
        error: function(){
          alert("Error: Please try again.");
        }

    }); 

});

$(document).on("click",".is-all-day-count",function(e){
                  e.preventDefault();

  var id =$(this).attr('id');
  var arr = id.split(",");
        $.ajax({
        url: "/employees_attendances/report/",
        type: "get",
        cache: false,
        data:{ "employee":"allday", start_date:arr[0], end_date:arr[1], employeeID:arr[2]

        },
        success:function(data){
          if(data.fulldayObject.length >0 || data.halfdayObject.length>0 || data.fullday.length){

                // alert("success");
                                         
                var str=" <h5 class='mg-custom-labels mg-font-bold'>Afternoon</h5>"
                 str +='<div style="padding: 0 10px 0 8px;"><table class="batch-tbl mg-tbl-margin" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th class="mg-table-nowrap">Absent Date</th><th class="mg-table-nowrap">Reason</th><th class="mg-table-nowrap">Leave Type</th></tr>';
                  $("#employeeLeaveSelectID").append(str);


                   for(key in data.fulldayObject )  
                   {
                        var absentDate=data.fulldayObject[key].absent_date;
                        var reson=data.fulldayObject[key].reason;
                         var mg_leave_type_id=data.fulldayObject[key].mg_leave_type_id;
                        var name="undiffined"
                          for(i in data.leaveName){
                            if(data.leaveName[i].id==data.fulldayObject[key].mg_leave_type_id){
                              name =data.leaveName[i].leave_name
                            }
                          }
                        str +='<tr class="employee-class" rowspan="2"><td>'+absentDate+'</td><td>'+reson+'</td><td>'+name+'</td></tr>';
                   }
                   str +='</table></div>';
                str +=" <hr><h5 class='mg-custom-labels mg-font-bold'>Morning</h5>"


                  str +='<div style="padding: 0 10px 0 8px;"><table class="batch-tbl mg-tbl-margin" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th class="mg-table-nowrap">Absent Date</th><th class="mg-table-nowrap">Reason</th><th class="mg-table-nowrap">Leave Type</th></tr>';
                  
                   for(key in data.halfdayObject )  
                   {
                        var absentDate=data.halfdayObject[key].absent_date;
                        var reson=data.halfdayObject[key].reason;
                        var mg_leave_type_id=data.halfdayObject[key].mg_leave_type_id;
                        var name="undiffined"
                          for(i in data.leaveName){
                            if(data.leaveName[i].id==data.halfdayObject[key].mg_leave_type_id){
                              name =data.leaveName[i].leave_name
                            }
                          }
                        str +='<tr class="employee-class" rowspan="2"><td>'+absentDate+'</td><td>'+reson+'</td><td>'+name+'</td></tr>';
                   }
                   str +='</table></div>';

                str +=" <hr><h5 class='mg-custom-labels mg-font-bold'>Full Days </h5>"
                    

                   str +='<div style="padding: 0 10px 0 8px;"><table class="batch-tbl mg-tbl-margin" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th class="mg-table-nowrap">Absent Date</th><th class="mg-table-nowrap">Reason</th><th class="mg-table-nowrap">Leave Type</th></tr>';
                  
                   for(key in data.fullday )  
                   {
                        var absentDate=data.fullday[key].absent_date;
                        var reson=data.fullday[key].reason;
                        var mg_leave_type_id=data.fullday[key].mg_leave_type_id;
                        var name="undiffined"
                          for(i in data.leaveName){
                            if(data.leaveName[i].id==data.fullday[key].mg_leave_type_id){
                              name =data.leaveName[i].leave_name
                            }
                          }
                        str +='<tr class="employee-class" rowspan="2"><td>'+absentDate+'</td><td>'+reson+'</td><td>'+name+'</td></tr>';
                   }
                   str +='</table></div>';

                   // fullday




                  $('#employeeAttendanceLeaveReportForAllDayDIVID').dialog({
                    modal: true,
                    title: "All Days Details",
                    width: 'auto',
                    open: function () {
                        
                        $(this).html(str);
                    }
                }); 

               }else{
                alert("Didn't take any holiday");
              }
              
              
              

            },
        error: function(){
          alert("Error: Please try again.");
        }

    }); 

});




$(document).on('change','#attendenceDepartmentID',function(e){
  // alert("hi");
 e.preventDefault();


    // alert("hi");
    var departmentId = $("#attendenceDepartmentID").val();
    $(".all-employee-table").empty();
    //alert(retVal);

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

                
                   var str='<div class="mg-scroll-employee-bar mg-tbl-margin" style="width: 50%;"><table class="batch-tbl" cellspacing="0" style="padding:0; height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th>First Name</th><th>Last Name</th><th>actions</th></tr>';
              //     $("#employeeLeaveSelectID").append(str);
                   for(key in data.employee )  
                   {

                
                        var employeeId=data.employee[key].id;
                        var employeeName=data.employee[key].first_name;
                        var employeeLastName=data.employee[key].last_name;
                      
                        str +='<tr class="employee-class" rowspan="2"><td>'+employeeName+'</td><td>'+employeeLastName+'</td><td class="mg-align-center"><a , id="'+employeeId+'-AttendanceLeaveDetails" title="View Leave" class="mg-employee-leave-taken-list mg-icon-btn"><i class="fa fa-eye"></i></a></td></tr>';
                   }
                   str +='</table></div>';

                   console.log(str) ;


                   $(".all-employee-table").append(str);

               }else{
                 var str='<h5>Employee Not Found</h5>';
                 $(".all-employee-table").append(str);
               }

            }   
        }); 

});


$(document).on('click','.mg-employee-leave-taken-list',function(e){
  e.preventDefault();
 var myID =$(this).attr('id');
   var splitId=myID.split("-");
   var urlLink = "/employees_attendances/leave_details_for_employee/"+splitId[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#employeeLeaveTypeReportDIVID').dialog({
                    modal: true,
                    minHeight: 150,
                    width: 575,
                    //left: 400,
                    title: "Leave Report",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on('click','.mg-employee-leave-taken-list1',function(){
 var employeeID =$(this).attr('id');
 // alert("employeeID:"+employeeID);

    // alert("hi");
    // var departmentId = $("#attendenceDepartmentID").val();
    $(".one-employee-table").empty();
    // alert(departmentId);

    var urlLink = "/employees_attendances/employee_list";
          $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                employeeCheck: "employee",
                employeeID: employeeID
            },
            success: function(data)
            {
              console.log(data);
              var str='<table class="batch-tbl" border="1"><tr class="subject-table-header"><th>Leave Name</th><th>Leave Taken</th><th>Max Leave Count</th><th>Left leaves</th></tr>';

              if(data.levee_typs.length >0){  
                  for(key in data.levee_typs){
                    var leave_name_out=data.levee_typs[key].leave_name;
                          // alert(leave_name_out+"----1----");

                         var count='';

                    if(data.employee.length > 0){
                      for(key in data.employee) {
                        var leave_name=data.employee[key].leave_name;
                          var leave_taken=data.employee[key].leave_taken;
                          var max_leave_count=data.employee[key].max_leave_count;
                          var how_many_he_can_take=max_leave_count-leave_taken;

                        if(leave_name_out==leave_name){
                          // alert(leave_name_out+"-----2----");
                          

                          str +='<tr class="employee-class"><td>'+leave_name+'</td><td>'+leave_taken+'</td><td>'+max_leave_count+'</td><td>'+how_many_he_can_take+'</td></tr>';
                        }else{
                          // alert("no match");
                          count=leave_name_out;
                        }
                      }
                    }else{
                       str +='<tr class="employee-class"><td>'+leave_name_out+'</td><td>0</td><td>'+data.levee_typs[key].max_leave_count+'</td><td>'+data.levee_typs[key].max_leave_count+'</td></tr>';
                    }
                    if(leave_name_out==count){

                          str +='<tr class="employee-class"><td>'+leave_name_out+'</td><td>0</td><td>'+data.levee_typs[key].max_leave_count+'</td><td>'+data.levee_typs[key].max_leave_count+'</td></tr>';

                    }
                  }
              }else{
                alert("Add Some live  type");
              }
              
              $('<div id ="attedenceLeaveID" class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                    modal: true,
                    title: "Leaves",
                    width:'auto',
                    open: function () {
                        
                        $(this).html(str);
                    }
                }); 


            }   

            


        }); 

});






$(document).on("click",".atts_class-all", function(e){
   e.preventDefault();
  var employee_date =$(this).attr('id');
   var x=document.getElementById(employee_date);
  if(x.innerHTML=='<i class="fa fa-circle"> </i>'){
    isCheck(employee_date);
  }else{
     isCircle(employee_date);
  }
});

//new employee
function  isCircle(employee_date){
  var studentCategoryID =employee_date;
          var date_student_id=studentCategoryID;
         var deptId = $( "#attendances_mg_employee_department_id" ).val();
          var month = parseInt($("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
          var year = parseInt($("#ui-datepicker-div .ui-datepicker-year :selected").val());

          if(isNaN(month)){
            var presentDate = new Date();
            month=presentDate.getMonth()+1;
            year=presentDate.getFullYear();
          }
         var urlLink = "/employees_attendances/new";
        $.ajax({
             url: urlLink ,
            data: {'mg_employee_departments_id': deptId, 'date_student_id':date_student_id, 'month':month, 'year':year},
           
            cache: false,
            success: function(html){

                  $('#employeeAttendanceDIVID2').dialog({
                    title: "Attendance Details",
                    model: false,
                    open: function () {
                         $(this).html(html);
                    },
                    close: function (e) {
                        $(this).empty();
                    }
                }); 
            }
           
        });
}

//edit and delete
function isCheck(employee_date){
   var date_student_id=employee_date;
         var student_id = date_student_id.split(",");
         var deptId = $( "#attendances_mg_employee_department_id" ).val();
          var month = parseInt($("#ui-datepicker-div .ui-datepicker-month :selected").val()) + 1;
          var year = parseInt($("#ui-datepicker-div .ui-datepicker-year :selected").val());
            if(isNaN(month)){
            var presentDate = new Date();
            month=presentDate.getMonth()+1;
            year=presentDate.getFullYear();
          }
         var urlLink = "/employees_attendances/"+student_id[1]+"/edit";
        $.ajax({
             url: urlLink ,
            data: {'mg_employee_departments_id': deptId, 'date_student_id':date_student_id, 'month':month, 'year':year},
            cache: false,
            success: function(html){
                  $('#employeeAttendanceDIVID1').dialog({
                    title: "Attendance Details",
                    model: false,
                    open: function () {
                         $(this).html(html);
                    },
                    close: function (e) {
                        $(this).empty();
                    }
                }); 
            }
           
        });

}

//new start
function attendanceForEmployee(){
  $("#mg_employee_attendance_save_btn").prop('disabled', true);
  var employee_id=$("#employees_attendances_mg_employee_id").val();
  var noOfDays=$("#employees_attendances_no_of_days").val();
  var absent_date=$("#employees_attendances_absent_date").val();
  var halfday=$("#emp_halfdayfield").val();
  var is_late=$("input#employees_attendances_is_late_come").is(':checked');

    var urlLink = "/employees_attendances/attendance_validation";
        $.ajax({
             url: urlLink ,
            data: { mg_employee_id: employee_id,
                    no_of_days: noOfDays,
                    absent_date: absent_date,
                    is_halfday: halfday,
                    is_late: is_late

                  },
            cache: false,
            success: function(data){
                  if(data.notice=='date_equal_to_absent_date'){
                   alert("Can't absent on joining date.");
                     $(".ui-dialog-titlebar-close").click(); 
                   
                  }else if(data.notice=='absent_date_present'){
                    alert("already absent for selected date range.");
                     $(".ui-dialog-titlebar-close").click(); 
                  }else{
                    attendanceForEmployee_validation();
                  }
            }
           
        });
}


function attendanceForEmployee_validation(){
    var leaveType=$("#employees_attendances_leave_type").val();
    var halfday=$("#emp_halfdayfield").val();
    var time1=$("#emp_afternoonfield").val();
    var noOfDays=$("#employees_attendances_no_of_days").val();
    var reason=$("#employees_attendances_reason").val();
    var abcent_without_notice=$("input#employees_attendances_abcent_without_notice").is(':checked');
    var isDeleted=$("#employees_attendances_is_deleted").val();
    var department_id=$("#employees_attendances_mg_employee_department_id").val();
    var employee_id=$("#employees_attendances_mg_employee_id").val();
    var absent_date=$("#employees_attendances_absent_date").val();
    var is_approved=$("#employees_attendances_is_approved").val();
    var is_late=$("input#employees_attendances_is_late_come").is(':checked');
    var time=$("#employees_attendances_time").val();
    var is_lock=$("input#employees_attendances_is_lock").is(':checked');
    var URL='/employees_attendances/create'
    $.ajax({
        url: URL ,
        type: "POST",
        cache: true,
        data: {"mg_employee_id":employee_id,"mg_leave_type_id":leaveType,
                "absent_date":absent_date,"mg_employee_department_id":department_id,
                "reason":reason,"is_halfday":halfday,"is_afternoon":time1,
                "no_of_days":noOfDays,"is_deleted":isDeleted,
                "abcent_without_notice":abcent_without_notice,"leave_type":leaveType,"is_late_come":is_late,"time":time,"is_lock":is_lock},

        success:function(data){
          console.log(data);
            var school_employee_weekday=$("#school_employee_weekday_arr").val();
            school_employee_weekday=school_employee_weekday.split(" ")
            console.log(school_employee_weekday);
              if(noOfDays<=0){
                var absent_date=$("#employees_attendances_absent_date").val();
                var spldate = absent_date.split("-");
                var dayNum = spldate[0] ;
                var tableData =dayNum+","+employee_id;
                $(document.getElementById(tableData)).html('<i class="fa fa-circle"> </i>');
              }else{
                var absent_date=$("#employees_attendances_absent_date").val();
                var spldate = absent_date.split("-");
                var dayNum = spldate[0] ;
                for(var i = 0;i<=data;i++){
                 var checkDate=spldate[1]+'/'+dayNum+'/'+spldate[2];
                      x = new Date(checkDate).getDay();
                      if(school_employee_weekday.indexOf(x.toString())>-1){
// 
                        dayNum++;
                        
                      }else{
                      var tableData =dayNum+","+employee_id;
                      $(document.getElementById(tableData)).html('<i class="fa fa-circle"> </i>');
                      dayNum++;
                      }
                                            
                }
              }
              // tableData.empty();
              delete tableData;
              delete dayNum;
              delete day;
              $(this).empty();


             $(".ui-dialog-titlebar-close").click();
              dayNum=0;
              tableData=0;
            },
        error: function(){
          alert("Error: Please try again.");
        }
    }); 
  }


$(document).on("click","#mg_employee_attendance_save_btn",function(e){
   e.preventDefault();
  var leaveType=$("#employees_attendances_leave_type").val();
    var halfday=$("#emp_halfdayfield").val();
    var time1=$("#emp_afternoonfield").val();
    var noOfDays=$("#employees_attendances_no_of_days").val();
    var reason=$("#employees_attendances_reason").val();
    var abcent_without_notice=$("input#employees_attendances_abcent_without_notice").is(':checked');
    var isDeleted=$("#employees_attendances_is_deleted").val();
    var department_id=$("#employees_attendances_mg_employee_department_id").val();
    var employee_id=$("#employees_attendances_mg_employee_id").val();
    var absent_date=$("#employees_attendances_absent_date").val();
    var is_approved=$("#employees_attendances_is_approved").val();
    var is_late=$("input#employees_attendances_is_late_come").is(':checked');
    var time=$("#employees_attendances_time").val();
      if (is_late==true){
            if(document.getElementById('employees_attendances_reason').value == '') 
             {      
                  alert("Please provide reason.");
                  document.getElementById('employees_attendances_reason').focus();

            return false;       
            }
            if(document.getElementById('employees_attendances_time').value == '') 
             {      
                  alert("Please provide time.");
                  document.getElementById('employees_attendances_time').focus();
            return false;       
            }
            attendanceForEmployee();

            
      }else if(halfday=='true'){
            if(leaveType <1) 
             {      
                  alert("Please select leave type.");
                  document.getElementById('employees_attendances_leave_type').focus();
            return false;       
            }
            if(document.getElementById('employees_attendances_reason').value == '') 
             {      
                  alert("Please provide reason.");
                  document.getElementById('employees_attendances_reason').focus();
            return false;       
            }
            attendanceForEmployee();
      }else{
              if(leaveType <1) 
               {      
                    alert("Please select leave type.");
                    document.getElementById('employees_attendances_leave_type').focus();
                    return false;       
              }
              if (isNaN(noOfDays)){
                alert("No of Days should be number.");
                document.getElementById('employees_attendances_no_of_days').focus();
                document.getElementById('employees_attendances_no_of_days').value ="";
                        return false;    
              }

              if(noOfDays=='undiffined') 
               {      
                    alert("Please provide No of Day.");
                    document.getElementById('employees_attendances_no_of_days').focus();
                    return false;       
              }

              if(noOfDays<=0) 
               {      
                    alert("Please provide No of Days, it should be greater then zero.");
                    document.getElementById('employees_attendances_no_of_days').focus();
              return false;       
              }
              if(document.getElementById('employees_attendances_reason').value == '') 
               {      
                    alert("Please provide reason.");
                    document.getElementById('employees_attendances_reason').focus();
              return false;       
              }

            attendanceForEmployee();
      }

});

//new end

//from edit 
$(document).on("click","#mg_employee_attendance_update_btn",function(e){
   e.preventDefault();

  var leaveType=$("#employees_attendances_mg_leave_type_id").val();
    var halfday=$("#emp_attendances_halfday").val();
    var time1=$("#emp_afternoonfield").val();
    var reason=$("#employees_attendances_reason").val();
    var abcent_without_notice=$("input#employees_attendances_abcent_without_notice").is(':checked');
    var isDeleted=$("#employees_attendances_is_deleted").val();
    var department_id=$("#employees_attendances_mg_employee_department_id").val();
    var employee_id=$("#employees_attendances_mg_employee_id").val();
    var absent_date=$("#employees_attendances_absent_date").val();
    var is_approved=$("#employees_attendances_is_approved").val();
    var is_late=$("input#employees_attendances_is_late_come").is(':checked');
    var time=$("#employees_attendances_time").val();
    var id=$("#employees_attendances_id").val();
    var is_lock=$("input#employees_attendances_is_lock").is(':checked');
      if (is_late==true){
            if(document.getElementById('employees_attendances_reason').value == '') 
             {      
                  alert("Please provide reason.");
                  document.getElementById('employees_attendances_reason').focus();

            return false;       
            }
            if(document.getElementById('employees_attendances_time').value == '') 
             {      
                  alert("Please provide time.");
                  document.getElementById('employees_attendances_time').focus();
            return false;       
            }
            edit_attendance();

            
      }else if(halfday=='true'){
            if(leaveType <1) 
             {      
                  alert("Please select leave type.");
                  document.getElementById('employees_attendances_mg_leave_type_id').focus();
            return false;       
            }
            if(document.getElementById('employees_attendances_reason').value == '') 
             {      
                  alert("Please provide reason.");
                  document.getElementById('employees_attendances_reason').focus();
            return false;       
            }
            edit_attendance();
      }else{
              if(leaveType <1) 
               {      
                    alert("Please select leave type.");
                    document.getElementById('employees_attendances_mg_leave_type_id').focus();
                    return false;       
              }
             

             
              if(document.getElementById('employees_attendances_reason').value == '') 
               {      
                    alert("Please provide reason.");
                    document.getElementById('employees_attendances_reason').focus();
              return false;       
              }

            edit_attendance();
      }

});


// $(document).on("click","#mg_employee_attendance_update_btn",function(e){
  function edit_attendance(){
      $("#mg_employee_attendance_update_btn").prop('disabled', true);
       var leaveType=$("#employees_attendances_mg_leave_type_id").val();
        var halfday=$("#emp_attendances_halfday").val();
       var time1=$("#emp_afternoonfield").val();
       var reason=$("#employees_attendances_reason").val();
        var abcent_without_notice=$("input#employees_attendances_abcent_without_notice").is(':checked');
        var isDeleted=$("#employees_attendances_is_deleted").val();
        var department_id=$("#employees_attendances_mg_employee_department_id").val();
        var employee_id=$("#employees_attendances_mg_employee_id").val();
        var absent_date=$("#employees_attendances_absent_date").val();
        var is_approved=$("#employees_attendances_is_approved").val();
        var is_late=$("input#employees_attendances_is_late_come").is(':checked');
        var time=$("#employees_attendances_time").val();
        var id=$("#employees_attendances_id").val();
        var is_lock=$("input#employees_attendances_is_lock").is(':checked');
        
        $.ajax({
        url: "/employees_attendances/"+id,
        type: "patch",
        cache: false,
        data: {"mg_employee_id":employee_id,"mg_leave_type_id":leaveType,
                "absent_date":absent_date,"mg_employee_department_id":department_id,
                "reason":reason,"is_halfday":halfday,"is_afternoon":time1,
                "is_deleted":isDeleted,"abcent_without_notice":abcent_without_notice,"leave_type":leaveType, "is_late_come":is_late, "time":time, 'is_lock': is_lock},

        success:function(data){
              $(".ui-dialog-titlebar-close").click();
              dayNum=0;
              var spldate = absent_date.split("-"); 
              var tableData =parseInt(spldate[2])+","+employee_id;
              // $(document.getElementById(tableData)).html('<i class="fa fa-circle"> </i>');
               var cell = document.getElementById(tableData+"TDID");
              cell.style.background = "#ffb0b0";
            },
        error: function(){
          alert("Error: Please try again.");
        }
    }); 





}

$(document).on("click","#mg_employee_attendance_clear_btn",function(e){
        var employee_id=$("#employees_attendances_mg_employee_id").val();
        var id=$("#employees_attendances_id").val();
        var absent_date=$("#employees_attendances_absent_date").val();
        $.ajax({
        url: "/employees_attendances/delete/"+id,
        type: "patch",
        cache: false,
        success:function(data){
                var spldate = absent_date.split("-"); 
                var tableData =parseInt(spldate[2])+","+employee_id;
                $(document.getElementById(tableData)).html('<i class="fa fa-check" > </i>');
              $(".ui-dialog-titlebar-close").click();
              dayNum=0;
              tableData=0;
            },
        error: function(){
          alert("Error: Please try again.");
        }
    }); 

});

//edit end






