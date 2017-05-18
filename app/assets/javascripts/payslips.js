$(document).on("change","#mg_employee_department", function(e){
    e.preventDefault();
    $("#mg_employee_id_for_payslip").empty();
    $("#payslipPresHowDIVID").empty();
    $("#hideAndShowYearMonthDIVID").hide();
    var mg_employee_department=$("#mg_employee_department").val();
    var urlLink="/payslips/employee_list/"+mg_employee_department;
    if(mg_employee_department!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:{
        	data: 'employee_list'
        },
        success: function(data)
        {   
            var str='';
            str='<option value="">'+"Select"+'</option>';
            for (var key in data.employee_list) 
            {
                var dept = data.employee_list[key]
                for (var key2 in dept) 
                {
                    var employee_name=dept.first_name+' '+dept.last_name+" - ( "+dept.employee_number+' )';
                    var employee_id=dept.id;
                }
            str+='<option value='+employee_id+'>'+employee_name+'</option>';
            $("#mg_employee_id_for_payslip").append(str);
            str = "";
            console.log(str);
            }
        }
    }); 
    }
});



$(document).on("change","#mg_employee_department_over_time", function(e){
    e.preventDefault();
    $("#mg_employee_id_for_payslip_over_time").empty();
    var mg_employee_department=$("#mg_employee_department_over_time").val();
    var urlLink="/payslips/employee_list/"+mg_employee_department;
    if(mg_employee_department!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:{
            data: 'employee_list'
        },
        success: function(data)
        {   
            var str='';
            str='<option value="">'+"Select"+'</option>';
            for (var key in data.employee_list) 
            {
                var dept = data.employee_list[key]
                for (var key2 in dept) 
                {
                    var employee_name=dept.first_name+' '+dept.last_name+" - ( "+dept.employee_number+' )';
                    var employee_id=dept.id;
                }
            str+='<option value='+employee_id+'>'+employee_name+'</option>';
            $("#mg_employee_id_for_payslip_over_time").append(str);
            str = "";
            console.log(str);
            }
        }
    }); 
    }
});



    $(document).on("click", ".edit-payslip-gen-cls-btn", function(e){
     e.preventDefault();
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/payslips/"+Id[0]+"/edit";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#payslipsEditGenDIVID').empty().dialog({
                    modal: true,
                    height: '600',
                    width: '700',
                    title: "Payslip Edit",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
            }
        });
});

$(document).on("click", ".pdf-payslip-gen-btn", function(e){
     e.preventDefault();
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/payslips/generate_payslip_pdf/"+Id[0]+","+Id[2]+'-'+Id[1]+'-01,'+Id[3]; 
        window.location=urlLink;

 });


$(document).on("click", ".delete-payslip-gen-btn", function(e){
      e.preventDefault();
                var myID =$(this).attr('id');
                    var Id=myID.split("-");


                
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/payslips/delete/"+Id[0];

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


$(document).on("click", ".show-payslip-gen-btn", function(e){
     e.preventDefault();
        var myID =$(this).attr('id');
        var Id=myID.split("-");



        var urlLink = "/payslips/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#showPayslipDIVID').dialog({
                    modal: true,
                    height: '600',
                    width: '700',
                    title: "Payslip Show",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".report-show-for-employee-cls", function(e){
    e.preventDefault();
        var myID =$(this).attr('id');
        var Id=myID.split("-");



        var urlLink = "/payslips/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#showPayslipReportDIVID').dialog({
                    modal: true,
                    height: '600',
                    width: '700',
                    title: "Payslip Show",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});



    function component_deduction(){
        var arr=[];
        var components=0.0;
        $(".validation-compont-in-payslip-gen-grade-new-sum-cls").each(function() {
            components=components+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
        });
        
         var deduction=0.0;
        $(".validation-compont-grade-new-payslip-sum-cls").each(function() {
            deduction=deduction+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
        });

        arr.push(components);
        arr.push(deduction);
        return arr;

    }

       $(document).on("change", ".validation-compont-grade-new-payslip-sum-cls", function(e){
    e.preventDefault();
    $("#payslipGenSubmitAID").contents().unwrap().wrap("<button id='payslipGenSubmitAID' class='mg-small-form-btn'></button>");
    $('#payslipGenSubmitAID').attr("disabled", true);
    $("#errorMsgPaylipGenDIVID").show();
   });


    $(document).on("change", ".validation-compont-in-payslip-gen-grade-new-sum-cls", function(e){
    e.preventDefault();
    $("#payslipGenSubmitAID").contents().unwrap().wrap("<button id='payslipGenSubmitAID' class='mg-small-form-btn'></button>");
    $('#payslipGenSubmitAID').attr("disabled", true);
    $("#errorMsgPaylipGenDIVID").show();

   });


    $(document).on("click", ".re-calculate-calculation-a-cls", function(e){
    e.preventDefault();
    var arr=[];
    arr=component_deduction();
     if(arr[0]>=arr[1]){
        $(".validation-compont-for-payslip-grade-new-total-gross-salary-cls").val(arr[0].toFixed(2));
             $(".validation-compont-grade-new-total-net-amount-sum-cls").val((arr[0]-arr[1]).toFixed(2));
        $("#payslipGenSubmitAID").contents().unwrap().wrap("<a onclick='$(this).closest("+'"form"'+").submit()' id='payslipGenSubmitAID' class='mg-small-form-btn'></a>");
        $("#errorMsgPaylipGenDIVID").hide();
        
        }else{
          alert("Components total shoud be greter then deduction.");
        }
   });


function component_deduction_edit(){
        var arr=new Array();
        var components=0.0;
        $(".validation-compont-grade-edit-payslip-sum-cls").each(function() {
            components=components+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
        });
        
         var deduction=0.0;
        $(".validation-compont-deduction-grade-edit-payslip-sum-cls").each(function() {
            deduction=deduction+((parseFloat($(this).val()) > 0.0) ? parseFloat($(this).val()) : 0.0);
        });

        arr.push(components);
        arr.push(deduction);
        console.log(arr);
        return arr;

    }



  $(document).on("change", ".validation-compont-grade-edit-payslip-sum-cls", function(e){
    e.preventDefault();
    $("#payslipEditSubmitAID").contents().unwrap().wrap("<button id='payslipEditSubmitAID' class='mg-small-form-btn'></button>");
    $('#payslipEditSubmitAID').attr("disabled", true);
    $("#errorMsgPaylipEditGenDIVID").show();

   });


    $(document).on("change", ".validation-compont-deduction-grade-edit-payslip-sum-cls", function(e){
    e.preventDefault();
    $("#payslipEditSubmitAID").contents().unwrap().wrap("<button id='payslipEditSubmitAID' class='mg-small-form-btn'></button>");
    $('#payslipEditSubmitAID').attr("disabled", true);
    $("#errorMsgPaylipEditGenDIVID").show();

   });


    $(document).on("click", ".re-calculate-in-edit-calculation-a-cls", function(e){
    e.preventDefault();
    var arr=[];
    arr=component_deduction_edit();
     if(arr[0]>=arr[1]){
         $(".validation-compont-for-payslip-grade-edit-total-gross-salary-cls").val(arr[0].toFixed(2));
         $(".validation-compont-grade-edit-total-net-amount-sum-cls").val((arr[0]-arr[1]).toFixed(2));
        $("#payslipEditSubmitAID").contents().unwrap().wrap("<a onclick='$(this).closest("+'"form"'+").submit()' id='payslipEditSubmitAID' class='mg-small-form-btn'></a>");
        arr=[];
        $("#errorMsgPaylipEditGenDIVID").hide();

        }else{
          alert("Components total shoud be greter then deduction.");
        }
   });


$(document).on("change", ".payslip-check-box-edit-class", function(e){


    var is_editable=$(this).is(':checked');
    var check_box_id=$(this).parent('td').attr('id')
    var salary=$("#eachComponentEditTextID-"+check_box_id).val();
    var salary_back_up=$("#eachComponentEditTextID-"+check_box_id).siblings(".salary_component_back_up_cls").val();
    // alert(salary+"------"+salary_back_up);
    if (parseFloat(salary)==parseFloat(salary_back_up)){

        if(is_editable){
             $("#eachComponentEditTextID-"+$(this).parent('td').attr('id')).attr("readonly", false);
             $("#eachComponentEditTextAreaID-"+$(this).parent('td').attr('id')).attr("readonly", false);
        }else{
             $("#eachComponentEditTextID-"+$(this).parent().attr('id')).attr("readonly", true);
             $("#eachComponentEditTextAreaID-"+$(this).parent().attr('id')).attr("readonly", true);
             var reason=$("#eachComponentEditTextAreaBackUPID-"+check_box_id).val();
             // 
             $("#eachComponentEditTextAreaID-"+check_box_id).val(reason);
        }

    }else{
        alert("once salary edited, uncheck is not allowed");
        // $(this).is(':checked');
          $(this).prop('checked', true);

    }

    // alert(is_editable);
    
    

});




$(document).on("change", ".payslip-back-upcomp-cls", function(e){
    // alert("change");
    $(".payslip-back-upcomp-cls").each(function () {
        // alert("changes");
        var salary=$("#eachComponentEditTextID-"+$(this).parent().parent('td').attr('id')).val();
        var salary_back_up=$(this).siblings(".salary_component_back_up_cls").val();
        console.log(salary+"----"+salary_back_up);

        if (parseFloat(salary)==parseFloat(salary_back_up)){
            // $(this).parent().parent('td').siblings(".payslip-td-cls").children(".payslip-check-box-edit-class").attr("disabled", false);
            // alert();
            
            console.log("eqval");

        }else{
            // $(this).parent().parent('td').siblings(".payslip-td-cls").children(".payslip-check-box-edit-class").attr("disabled", true);
           
            console.log("not eqval");


        }
    });

});


  function salary_deduction_camponent_array(){
      var salary_deduction=[];
      $('.payslip-approval-cls').each(function () {
        if($(this).is(':checked')){
            salary_deduction.push($(this).val());
        } 
      });
      var date=$("#date_month_approve_date").val();
      var arr=date.split("-");
      // alert(date);
      var month=arr[0];//$("#month").val();
      var year=arr[1];//$("#year").val();
      if (salary_deduction.length>0){
        window.location="/payslips/salary_deduction.xls?"+"salary_deduction="+salary_deduction+"&month="+month+"&year="+year;
      }else{
        alert("Please select component");
      }
      
        
  }



$(document).on("change", "#isApprovedSelectTagID", function(e){
    var is_approved=$(this).val();
    if (is_approved=="Reject"){
        $("#hideAndShowPayslipReasonRejectDIVID").show();
    }else{
        $("#hideAndShowPayslipReasonRejectDIVID").hide();
        $("#rejectReasonTextAreaID").val("");


    }
});