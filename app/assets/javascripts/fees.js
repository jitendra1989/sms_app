/* comm */
 $(document).ready(function () {

    

    /*$("#elm_id4").validate({

    rules: {
    "fesses[name]": {required: true},
    "fesses[description]": {required: true},

    }
    });

    $("#elm_id").validate({

    rules: {
    "fesses[name]": {required: true},
    "fesses[description]": {required: true},
    "selected_batches[]":{required: true},
    }
    });

    $( ".start_date" ).datepicker({ dateFormat: 'dd-mm-yy' });
    $( ".end_date" ).datepicker({ dateFormat: 'dd-mm-yy' });
    $( ".due_date" ).datepicker({ dateFormat: 'dd-mm-yy' });

    $("#elm_id3").validate({

        rules: {
        "fesses2[fee_category]": {required: true},
        "fesses2[name]": {required: true},
        "fesses2[description]":{required: true},
        "fesses2[start_date]": {required: true},
        "fesses2[end_date]": {required: true},
        "fesses2[due_date]":{required: true},
        "fesses2[amount]": {required: true},


        }
        });*/
});


$(document).on("click", "#radioButtonAllID", function(){
    //$("#FeeCategoryID").empty();
    //alert("dd");
    $("#feeParticularAdmissionID").val('');
    document.getElementById('fesses2_mg_student_category_id').selectedIndex = -1;

    $(".fee-particular-student-category-cls").css({  
            'display': 'none'
    }); 
    $(".fee-particular-admission-number-cls").css({  
            'display': 'none'
    });
});


$(document).on("change","#start_date_data",function(e){
      var end_date=$("#end_date_data").val();
      
      //alert(end_date)

      if(!(end_date==""))
      {
            var start_date=$(this).val();

     // console.log("Changed dob"); 
     // console.log(new Date(Date.parse(dob,dateFormatStr)).toString());
     // console.log(new Date(Date.parse(admission_date,dateFormatStr)).toString());

     if(getDateObj(start_date,dateFormatStr)>getDateObj(end_date,dateFormatStr)){
        alert("Start Date should be less than End Date");
    document.getElementById('start_date_data').blur(); 

        document.getElementById('start_date_data').value ="";
      }

      var temp=$("#due_date_data").val();
      if(!temp=="")
      {
      var end_date=$("#end_date_data").val();
      var start_date=$("#start_date_data").val();
      var due_date=$("#due_date_data").val();

     if(!(getDateObj(due_date,dateFormatStr)>=getDateObj(start_date,dateFormatStr)&&getDateObj(due_date,dateFormatStr)<=getDateObj(end_date,dateFormatStr))){
        alert("Due Date should be between Start Date and End Date");
    document.getElementById('start_date_data').blur(); 

        document.getElementById('start_date_data').value ="";
      }
}
      }
      
   });

$(document).on("change","#end_date_data",function(e){
      var start_date=$("#start_date_data").val();
     
      if(!(start_date==""))
      {
        var end_date=$(this).val();

     // console.log("Changed dob"); 
     // console.log(new Date(Date.parse(dob,dateFormatStr)).toString());
     // console.log(new Date(Date.parse(admission_date,dateFormatStr)).toString());

     if(getDateObj(start_date,dateFormatStr)>getDateObj(end_date,dateFormatStr)){
        alert("End Date should be more than Start Date");
    document.getElementById('end_date_data').blur(); 

        document.getElementById('end_date_data').value ="";
      }
var temp=$("#due_date_data").val();
      if(!temp=="")
      {
      var end_date=$("#end_date_data").val();
      var start_date=$("#start_date_data").val();
      var due_date=$("#due_date_data").val();

     if(!(getDateObj(due_date,dateFormatStr)>=getDateObj(start_date,dateFormatStr)&&getDateObj(due_date,dateFormatStr)<=getDateObj(end_date,dateFormatStr))){
        alert("Due Date should be between Start Date and End Date");
    document.getElementById('end_date_data').blur(); 

        document.getElementById('end_date_data').value ="";
      }
}
      }
      
   });
 
    
$(document).on("change","#due_date_data",function(e){

      var end_date=$("#end_date_data").val();
      var start_date=$("#start_date_data").val();
     
      
      var due_date=$("#due_date_data").val();
if(start_date=="" || end_date=="")
{
  alert("Enter The Start Date And End Date");
    document.getElementById('due_date_data').blur(); 

  document.getElementById('due_date_data').value ="";
}
      else
      {

     if(!(getDateObj(due_date,dateFormatStr)>=getDateObj(start_date,dateFormatStr)&&getDateObj(due_date,dateFormatStr)<=getDateObj(end_date,dateFormatStr))){
        alert("Due Date should be between Start Date and End Date");
    document.getElementById('due_date_data').blur(); 
        
        document.getElementById('due_date_data').value ="";
      }
   }
   });

























 $(document).on("click", "#fesses2_value1_demo", function(){

  //alert("hello");

  //$("#feeParticularAdmissionID").val('');
  document.getElementById('fesses2_mg_student_category_id').selectedIndex = -1;

  $(".fee-particular-student-category-cls").css({  
            'display': 'none'
    }); 
    $(".fee-particular-admission-number-cls").css({  
            'display': 'block'
    });
  //$("#FeeCategoryID").empty();
  //$("#FeeCategoryID").append('<label></label>Admission Number<input id="feeParticularAdmissionNumID" type="text" name="admission_no">');
  /*var urlLink="/fees/student_number/";
   // alert( urlLink);
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html){
            console.log(html);
            //$(this).removeClass("header");
            $("#FeeCategoryID").empty();
            $("#FeeCategoryID").append(html);
        }
            
    });*/
});
 $(document).on("click", "#fesses2_value1_demo2", function(){

    //alert("hello");

    $("#feeParticularAdmissionID").val('');
    $(".fee-particular-student-category-cls").css({  
            'display': 'block'
    }); 
    $(".fee-particular-admission-number-cls").css({  
            'display': 'none'
    });
  /*var urlLink="/fees/student_category/";
   // alert( urlLink);
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html){
            console.log(html);
            //$(this).removeClass("header");
            $("#FeeCategoryID").empty();
            $("#FeeCategoryID").append(html);
        }
            
    });*/
});






 $(document).on("click", ".edit_class", function(e){
       e.preventDefault();
   //    alert("Work on progress");

        var FeeCategoryID =$(this).attr('id');
     //    alert(FeeCategoryID);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/fees/"+FeeCategoryID+"/edit/";
       // alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editFeeCaregoryDivID').dialog({
                    modal: true,
                    title: "Edit Fee Category",
                    minWidth: 330,
                    minHeight: 350,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


  $(document).on("click", ".show_class", function(e){
        var FeeCategoryID =$(this).attr('id');
      //   alert(FeeCategoryID);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/fees/"+FeeCategoryID+"show";
      //  alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                    modal: true,
                    title: "Fee Category",
                    width: 'auto',
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

    $(document).on("click", "#createNewFeeCategoryID", function(e){
        e.preventDefault();
        var urlLink = "/fees/new/";
      //  alert("createNewFeeCategoryID is clicked");
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#createFeeCategoryDivID').dialog({
                    modal: true,
                    title: "Create New Fee Category",
                    minWidth: 425,
                    minHeight: 350,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

  // fee particular checked or unchecked checkbox
  $(document).on("click", "#checkAllCheckBoxInFeeParticularId", function(e){

        $(".auto-ckeckbox-fee-particular-batch-cls").prop('checked', true);
        e.preventDefault();
        
  });

  $(document).on("click", "#unCheckAllCheckBoxInFeeParticularId", function(e){

        $(".auto-ckeckbox-fee-particular-batch-cls").prop('checked', false);
        e.preventDefault();
  });


  // fee category checked or unchecked checkbox
  $(document).on("click", "#checkAllCheckBoxInFeeCategoryId", function(e){

        $(".auto-ckeckbox-fee-category-batch-cls").prop('checked', true);
        e.preventDefault();
  });

  $(document).on("click", "#unCheckAllCheckBoxInFeeCategoryId", function(e){

        $(".auto-ckeckbox-fee-category-batch-cls").prop('checked', false);
        e.preventDefault();
  });

  $(document).on("click", "#checkAllCheckBoxInFeeCategoryEditId", function(e){

        $(".auto-checkbox-fee-category-edit-cls").prop('checked', true);
        e.preventDefault();

  });

  $(document).on("click", "#unCheckAllCheckBoxInFeeCategoryEditId", function(e){

        $(".auto-checkbox-fee-category-edit-cls").prop('checked', false);
        e.preventDefault();
  });   

  $(document).on("click", "#checkAllCheckBoxInFeeDiscountId", function(e){

        $(".auto-ckeckbox-fee-discount-batch-cls").prop('checked', true);
        e.preventDefault();
  });

  $(document).on("click", "#unCheckAllCheckBoxInFeeDiscountId", function(e){

        $(".auto-ckeckbox-fee-discount-batch-cls").prop('checked', false);
        e.preventDefault();
  });   

  $(document).on("click", "#checkAllCheckBoxInFeeScheduleId", function(e){

        $(".auto-ckeckbox-fee-schedule-batch-cls").prop('checked', true);
        e.preventDefault();
  });

  $(document).on("click", "#unCheckAllCheckBoxInFeeScheduleId", function(e){

        $(".auto-ckeckbox-fee-schedule-batch-cls").prop('checked', false);
        e.preventDefault();
  });







// Finace fee will going to call
 $(document).on("click", ".add_particulars-demo", function(e){
            var myID =$(this).attr('id');
            var splString = myID.split("-");
 ///   alert(splString[1]);
    var urlLink = "/fees/financeFee/"+splString[1];
   // alert(urlLink);
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html){

            console.log(html);
            //$(this).removeClass("header");
            $("#manageFeeCategoryID").empty();
            $("#manageFeeCategoryID").append(html);

        }
            
    });
});




$(document).on("click", "#viewFeeList", function(e){

    //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
    /*var urlLink = "/fees/index/";
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html){
        $("#manageFeeCategoryID").empty();
        $("#manageFeeCategoryID").append(html);
        }
    });*/ 
       
});

 $(document).on("click", ".create_new_cls", function(e){
        var urlLink = "/fees/newparticular/";
        var myID =$(this).attr('id');
       //alert(myID);
        $.ajax({
            url: urlLink ,
            cache: false,
            data: {"id":myID},
            success: function(html){  
                    $('#createFeeParticularDivId').dialog({
                    modal: true,
                    title: "Add Fee Particular",
                    minWidth: 700,
                    minHeight: 350,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 $(document).on("click", ".creates_new_clss", function(e){
        var urlLink = "/fees/newfineparticular/";
      //  alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                    $('#createfineFeeParticularDivId').dialog({
                    modal: true,
                    title: "Add Fine Particular",
                    minWidth: 665,
                    minHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".show_fee_class", function(e){
        var ID1 =$(this).attr('id');
       //  alert(ID1);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/fees/show_fee_particular/"+ID1;
      //  alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                   //$('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                   $('#showFeeParticularDivId').dialog({
                  
                    modal: true,
                    title: "Show Fee Particular Category",
                    minWidth: 300,
                    width: 'auto',
                    minHeight: 220,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".show_fine_fee_class", function(e){
        var ID1 =$(this).attr('id');
       //  alert(ID1);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/fees/show_fine_fee_particular";
      //  alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            data: {"id":ID1},
            success: function(html){  
                   //$('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                   $('#showfineFeesParticularDivId').dialog({
                  
                    modal: true,
                    title: "Show Fine Fee Particular ",
                    width: 'auto',
                    minHeight: 210,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".edit_fee_class", function(e){
        var ID1 =$(this).attr('id');
      //   alert(ID1);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/fees/edit_fee_particular/"+ID1;
      //  alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                    $('#editFeeParticularDivId').dialog({
                    modal: true,
                    title: "Edit Fee Particular Category",
                    minWidth: 300,
                    minHeight: 270,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 //fee discount
 $(document).on("click", ".edit_fine_fee_class", function(e){
        var ID1 =$(this).attr('id');
      //   alert(ID1);
        //var urlLink = "/student_categories/"+studentCategoryID+"/edit";
        var urlLink = "/fees/edit_fine_fee_particular";
      //  alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            data: {"id":ID1},
            success: function(html){
                    $('#editfineFeesParticularDivId').dialog({
                    modal: true,
                    title: "Edit Fee Particular Category",
                    minWidth: 300,
                    height: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});



 $(document).on("click", "#createNewFeeDiscountID", function(e){
        e.preventDefault();
        var urlLink = "/fees/fee_discounts/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                   $('#createFeeDiscountDivId').dialog({
                    modal: true,
                    title: "Create New Fee Discount",
                    minWidth: 650,
                    minHeight: 300,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
 });
 $(document).on("click", ".show-fee-discount-class", function(e){
        e.preventDefault();
        var ID1 =$(this).attr('id');
        var urlLink = "/fees/show_fee_discount/"+ID1;
        //alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                  $('#showFeeDiscountDivId').dialog({
                    modal: true,
                    title: "Show Fee Discount",
                    minWidth: 450,
                    width: 'auto',
                    height:210,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".show-fee-fine-class", function(e){
        e.preventDefault();
        var ID1 =$(this).attr('id');
        var urlLink = "/fees/show_fee_fine/"+ID1;
        //alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                
                  $('#showFineDivId').dialog({
                    modal: true,
                    title: "Show Fee Fine",
                    width: 'auto',
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


 $(document).on("click", ".edit-fee-discount-class", function(e){
        e.preventDefault();
        var ID1 =$(this).attr('id');
        var urlLink = "/fees/edit_fee_discount/"+ID1;
        //alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                  $('#editFeeDiscountDivId').dialog({
                    modal: true,
                    title: "Edit Fee Discount",
                    minWidth: 600,
                    minHeight: 300,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});



$(document).on("change","#fee_discount_course", function(){

    var courseId=$("#fee_discount_course").val();
    $("#fee_discount_batch").empty();
    var urlLink="/fees/fee_discounts";
    //"<%= fees_fee_discounts_path %>"
    if(courseId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            courseId: courseId,
            courseParam:'courseParam'
        },
        success: function(data)
        {
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
            $("#fee_discount_batch").append(str);
            str = "";
            //alert(subject_name);
            }
        }
    }); 
    }
});


 $(document).on("blur","#fee_discount_admission_number", function()
 {
    var admissionNumber=$("#fee_discount_admission_number").val();
    var urlLink="/fees/fee_discounts";
    //"<%= fees_fee_discounts_path %>"
    //alert(admissionNumber);
    if(admissionNumber.trim()!='')
    {
        //alert(admissionNumber);
        $.ajax({
            type: "get",
            dataType: "json",
            url: urlLink , 
            cache: false,
            data:
            {
                admissionNumber: admissionNumber,
                admissionNumberParam:'admissionNumberParam'
            },
            success: function(data)
            {
                console.log(data);
                if(data.validAdmissionNumber.length>0)
                {
                    var studentId=data.validAdmissionNumber[0].id;
                    $("#receiverId").val(studentId);
                    //alert(studentId);
                }
                else
                {
                    alert("Invalid Admission Number");
                    $("#fee_discount_admission_number").val('');
                }
            }
        });
    }

 });

var receiverId='';    
 $(document).on("change","#fee_discount_mg_fee_category_id", function()
 {
    receiverId='';
    var feeCategoryId=$(this).val();
    var urlLink="/fees/fee_discounts";
    //"<%= fees_fee_discounts_path %>"
    $("#batchDetailId").empty();  
     
    /* $(".fee-category-batch-cls").css({  
            'display': 'block'
      });*/
    //alert(admissionNumber);
    if(feeCategoryId.trim()!='')
    {
        $.ajax({
            type: "get",
            dataType: "json",
            url: urlLink, 
            cache: false,
            data:
            {
                feeCategoryId: feeCategoryId,
                feeCategoryIdParam:'feeCategoryIdParam'
            },
            success: function(data)
            {
                
                console.log(data);
                $("#batchDetailId").empty();
                $("#batchDetailId").append('<label class="mg-label">Select Class-Section</label><br/>');
                $("#batchDetailId").append('<label class="mg-label">Select</label> <a href="#" id="checkAllCheckBoxInFeeDiscountId" class="mg-pop-link">All</a>');
                $("#batchDetailId").append(' <a href="#" id="unCheckAllCheckBoxInFeeDiscountId" class="mg-pop-link">None</a>');
                
                var dataArray = data.batch_details;
                if(data.batch_details.length>0)
                {
                    var str='<div class="mg-scroll-bar">';
                    //for (var key in data.batch_details) 
                    for (var key = 0 ;key< dataArray.length;key++) 
                    {
                        var d2 = dataArray[key]
                        batch_id=d2[0];
                        console.log("d2.id"); 
                        console.log(d2[0]); 
                        batch_name=d2[3]+'-'+d2[1];
                        str +='<input type="checkbox" name="selected_batch[]" value="'+batch_id+'" class="batchId_checkbox_cls  auto-ckeckbox-fee-discount-batch-cls">'+batch_name+'<br/>'
                   }
                        str+='</div>';
                        $("#batchDetailId").append(str);
                        str='';
                
                }
                
            }
        });
    }
 });


$(document).on("change","#feeDiscountFeeCategoryId", function()
 {
    receiverId='';
    var feeCategoryId=$(this).val();
    var urlLink="/fees/fee_discounts";
    alert(urlLink);
    //"<%= fees_fee_discounts_path %>"
    $("#batchDetailInFeeDiscountId").empty();  
     
    /* $(".fee-category-batch-cls").css({  
            'display': 'block'
      });*/
    //alert(admissionNumber);
    if(feeCategoryId.trim()!='')
    {
        $.ajax({
            type: "get",
            dataType: "json",
            url: urlLink, 
            cache: false,
            data:
            {
                feeCategoryId: feeCategoryId,
                feeCategoryIdParam:'feeCategoryIdParam'
            },
            success: function(data)
            {
                console.log(data);
                $("#batchDetailInFeeDiscountId").empty();
                $("#batchDetailInFeeDiscountId").append('<label class="mg-label">Select Batch</label><br/>');
                $("#batchDetailInFeeDiscountId").append('<label class="mg-label">Select</label> <a href="#" id="checkAllCheckBoxInFeeDiscountId">All</a>');
                $("#batchDetailInFeeDiscountId").append(' <a href="#" id="unCheckAllCheckBoxInFeeDiscountId">None</a><br/>');
                if(data.batch_details.length>0)
                {
                    var str='';
                    for (var key in data.batch_details) 
                    {
                        var d2 = data.batch_details[key]
                        batch_id=d2[0].id;
                        console.log("d2[0].id"); 
                        console.log(d2[0].id); 
                        batch_name=d2[0].name;
                        str +='<input type="checkbox" name="selected_batch[]" value="'+batch_id+'" class="batchId_checkbox_cls  auto-ckeckbox-fee-discount-batch-cls">'+batch_name+'<br/>'
                        $("#batchDetailInFeeDiscountId").append(str);
                        str='';
                    }
                }
            }
        });
    }
 });

 $(document).on("change",".batchId_checkbox_cls", function()
 {
    var lb_checkboxValue=$(this).is(':checked');
    var checkboxValue=$(this).val();
    if(lb_checkboxValue)
    {
        receiverId +=checkboxValue+',';
    }

    if(!lb_checkboxValue)
    {
        //var checkboxValue=$(this).val();
        receiverId=receiverId.replace(checkboxValue,'');
    }
    //alert(receiverId);
    $("#receiverId").val(receiverId);

 });




//$("#fee_discount_course").on("change",function(){
$(document).on("change","#fee_discount_discount_type", function()
{
    //
    $(".fee-discount-name-cls, .course-cls, .batch-cls, .fee-category-cls, .admission-number-cls, .fee-discount-cls, .save-button-cls, .mode-cls, .fee-category-batch-cls, .fee-category-batch-cls, .student-category-cls").css({  
            'display': 'none'
    });

    
    var discountType=$(this).val();
    //alert(discountType)
    if(discountType=='Student')
    {
        $(".fee-discount-name-cls, .course-cls, .batch-cls, .fee-category-cls, .admission-number-cls, .fee-discount-cls, .save-button-cls, .mode-cls").css({  
            'display': 'block'
        });
    }

    if(discountType=='Student Category')
    {
        $(".fee-discount-name-cls, .fee-category-batch-cls, .fee-category-batch-cls, .fee-category-cls, .student-category-cls, .fee-discount-cls, .save-button-cls, .mode-cls").css({  
            'display': 'block'
        });
    }

    if(discountType=='Section')
    {
        $(".fee-discount-name-cls, .fee-category-batch-cls, .fee-category-cls, .fee-discount-cls, .save-button-cls, .mode-cls").css({  
            'display': 'block'
        });
    }
});  
   
//, .fee-category-batch-cls

//due fine


$(document).on("click", "#editAddDueFineId", function(e){

    var lastRepeatingGroup = $('.due-fine-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');

    //added
    cloned.find('a').remove();

    $(cloned).append('<a class="remove-fine-due-classses mg-icon-btn" style="color: #297ACC; font-size:0.8em;" href="#"> <i class="fa fa-trash"></i></a>');
   //end


    cloned.insertAfter( lastRepeatingGroup );
    return false;

    //alert("hh");
    //$("#dueFineDivId").append("<%= escape_javascript(render :partial => 'fee_fine_due' ,:locals => {:dueFine => 'dueFine'}) %>");
    //$("#dueFineDivId").append(<%= render :partial => "fee_fine_due" ,:locals => {:dueFine => "dueFine"} %>);

    //$("#dueFineDivId").append("<%= escape_javascript( render 'fee_fine_due' ) %>");
    //$.getScript('/fees/create.js.erb');
    //!= "$('#dueFineDivId').append('#{escape_javascript( render :partial => 'fee_fine_due', :locals => {:dueFine => 'dueFine'})}');
});
$(document).on("click", "#addDueFineId", function(e){

    var lastRepeatingGroup = $('.due-fine-div').last();

     console.log("lastRepeatingGroup");
    console.log(lastRepeatingGroup);
    //lastRepeatingGroup.clone().insertAfter(lastRepeatingGroup);

    var cloned = lastRepeatingGroup.clone();
    cloned.find('input').val('');



    cloned.insertAfter( lastRepeatingGroup );
    return false;

    //alert("hh");
    //$("#dueFineDivId").append("<%= escape_javascript(render :partial => 'fee_fine_due' ,:locals => {:dueFine => 'dueFine'}) %>");
    //$("#dueFineDivId").append(<%= render :partial => "fee_fine_due" ,:locals => {:dueFine => "dueFine"} %>);

    //$("#dueFineDivId").append("<%= escape_javascript( render 'fee_fine_due' ) %>");
    //$.getScript('/fees/create.js.erb');
    //!= "$('#dueFineDivId').append('#{escape_javascript( render :partial => 'fee_fine_due', :locals => {:dueFine => 'dueFine'})}');
}); 


$(document).on("click", ".remove-fine-due-cls", function(e){

   var total = $('.remove-fine-due-cls').length
   if(total!=1)
   {
        $(this).parent('div').remove();
    }
   //alert($(this).val());
});



//fee defaulter

$(document).on("change","#feeDefaulterCourseId", function(){

    var courseId=$("#feeDefaulterCourseId").val();
    $("#feeDefaulterBatchId").empty();
    $("#feeDefaulterCollectionId").empty();
    $("#feeDefaulterStudentListID").empty();
    $("#feeDefaulterBatchId").append('<option value="">Select</option>');
    $("#feeDefaulterCollectionId").append('<option value="">Select</option>');
    var urlLink="/fees/fee_defaulter";
    if(courseId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            courseId: courseId,
            taskRequired:'getBatchList'
        },
        success: function(data)
        {
            console.log(data);
            var str='';
            for (var key in data.name) 
            {
                var d2 = data.name[key]
                //for (var key2 in d2) 
                //{
                    var batch_name=d2.name;
                    var batch_id=d2.id;
                //}
            str+='<option value='+batch_id+'>'+batch_name+'</option>';
            $("#feeDefaulterBatchId").append(str);
            str = "";
            //alert(subject_name);
            }
        }
    }); 
    }
});

$(document).on("change","#feeDefaulterBatchId", function(){
    var batchId=$("#feeDefaulterBatchId").val();
    $("#feeDefaulterCollectionId").empty();
    $("#feeDefaulterStudentListID").empty();
    $("#feeDefaulterCollectionId").append('<option value="">Select</option>');
    var urlLink="/fees/fee_defaulter";
    if(batchId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            batchId: batchId,
            taskRequired:'getCollectionList'
        },
        success: function(data)
        {
            console.log(data);
            var str='';
            for (var key in data.fee_collection_list) 
            {
                var d2 = data.fee_collection_list[key]
                var collection_name=d2.name;
                var collection_id=d2.id;
                str+='<option value='+collection_id+'>'+collection_name+'</option>';
                $("#feeDefaulterCollectionId").append(str);
                str = "";
            }
        }
    }); 
    }
});

$(document).on("change","#feeDefaulterBatchId", function(){
    var batchId=$("#feeDefaulterBatchId").val();
    $("#feeDefaulterCollectionId").empty();
    $("#feeDefaulterStudentListID").empty();
    $("#feeDefaulterCollectionId").append('<option value="">Select</option>');
    var urlLink="/fees/fee_defaulter";
    if(batchId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            batchId: batchId,
                taskRequired:'getStudentList',
        },
        success: function(data)
        {
            console.log(data);
            if(data.studentList.length==0)
                {
                    $("#feeDefaulterStudentListID").append('<tr><td align="center">No Student Found</td></tr>');
                }
            if(data.studentList.length>0)
                {
                    var str='';
                    str += '<div class="mg-scroll-employee-bar"><table>';
                    str +='<th>Student name</th><th>Actions</th>';
                    $("#feeDefaulterStudentListID").append(str);
                    str='';
                    var firstName=""
                    var lastName=""
                    var firstName=""
                    var studentId=0
                    for (var key in data.studentList) 
                    {
                        var d2 = data.studentList[key]
                        studentId=d2.id; 
                        firstName=d2.first_name;
                        console.log(firstName);
                        
                        console.log(studentId);
                        //middleName=d2.middle_name;
                        lastName=d2.last_name;
                        console.log(lastName);
                        str ='<tr><td>'+d2.admission_number+' - '+firstName+' '+ lastName+'</td><td class="mg-align-center"><a class="mg-icon-btn" title="View" href="/fees/defaulter_fees_submission/'+studentId+'" ><i class="fa fa-eye"></i></a></td></tr>';
                        $("#feeDefaulterStudentListID").append(str);
                        str='';
                    }
                }
                apdStr += '</table></div>';
        }
    }); 
    }
});
// $(document).on("change","#feeDefaulterCollectionId", function(){
//     //$("#feeCollectionStudentListID").append("<tr><td>abc</td><td>vv</td></tr>");

//     var batchId=$("#feeDefaulterBatchId").val();
//     var urlLink="/fees/fee_defaulter";
//     $("#feeDefaulterStudentListID").empty();
//     var selectFeeScheduleId=$("#feeDefaulterCollectionId").val();
//     if(batchId.trim()!='')
//     {
//         $.ajax({
//             type: "get",
//             dataType: "json",
//             url: urlLink, 
//             cache: false,
//             data:
//             {
//                 batchId: batchId,
//                 taskRequired:'getStudentList',
//                 collectionId:selectFeeScheduleId
//             },
//             success: function(data)
//             {
//                 console.log(data);
//                 if(data.studentList.length==0)
//                 {
//                     $("#feeDefaulterStudentListID").append('<tr><td align="center">No Student Found</td></tr>');
//                 }
//                 /*$("#batchDetailFeeCollectionID").empty();}*/
//                 if(data.studentList.length>0)
//                 {
//                     var str='';
//                     str ='<th>Student Name</th><th>Actions</th>';
//                     $("#feeDefaulterStudentListID").append(str);
//                     str='';
//                     for (var key in data.studentList) 
//                     {
//                         var d2 = data.studentList[key]
//                         studentId=d2.id; 
//                         firstName=d2.first_name;
//                         //middleName=d2.middle_name;
//                         lastName=d2.last_name;
//                         str ='<tr><td>'+firstName+' '+ lastName+'</td><td class="mg-align-center"><a class="mg-icon-btn" title="View" href="/fees/defaulter_fees_submission/'+studentId+'/'+selectFeeScheduleId+'" ><i class="fa fa-eye"></i></a></td></tr>';
//                         $("#feeDefaulterStudentListID").append(str);
//                         str='';
//                     }
//                 }
                
//             }
//         });
//     }
// });



//fee collection

$(document).on("change","#fee_collection_course", function(){

    var courseId=$("#fee_collection_course").val();
    $("#fee_collection_batch").empty();
    $("#fee_collection_fee_collection").empty();
    $("#feeCollectionStudentListID").empty();
    $("#fee_collection_batch").append('<option value="">Select</option>');
    $("#fee_collection_fee_collection").append('<option value="">Select</option>');
    var urlLink="/fees/fee_collection";
    if(courseId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            courseId: courseId,
            taskRequired:'getBatchList'
        },
        success: function(data)
        {
            console.log(data);
            var str='';
            for (var key in data.name) 
            {
                var d2 = data.name[key]
                //for (var key2 in d2) 
                //{
                    var batch_name=d2.name;
                    var batch_id=d2.id;
                //}
            str+='<option value='+batch_id+'>'+batch_name+'</option>';
            $("#fee_collection_batch").append(str);
            str = "";
            //alert(subject_name);
            }
        }

    }); 
    }
});

$(document).on("change","#fee_collection_batch", function(){
    var batchId=$("#fee_collection_batch").val();
    //$("#fee_collection_fee_collection").empty();
    $("#feeCollectionStudentListID").empty();
   // $("#fee_collection_fee_collection").append('<option value="">Select</option>');
    var urlLink="/fees/fee_collection";
    if(batchId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            batchId: batchId,
            taskRequired:'getStudentList'
        },
        success: function(data)
        {
             //console.log(data.collectionID);
             //console.log("demo");
            // var str='';
           // for (var key in data.collectionID) 
             //{
                 
            //     //for (var key2 in d2) 
            //     //{
            //         var collection_name=d2.name;
            //         var collection_id=d2.id;
            //     //}
            // str+='<option value='+collection_id+'>'+collection_name+'</option>';
            // $("#fee_collection_fee_collection").append(str);
            // str = "";
            // //alert(subject_name);
         
            // }
            console.log(data);
                if(data.studentList.length==0)
                {
                    $("#feeCollectionStudentListID").append('<tr><td align="center">No Student Found</td></tr>');
                }
                /*$("#batchDetailFeeCollectionID").empty();}*/
                if(data.studentList.length>0)
                {
                    var str='';
                    str += '<div class="mg-scroll-employee-bar"><table>';
                    str +='<th>Student Name</th><th>Actions</th>';
                    $("#feeCollectionStudentListID").append(str);
                    str='';
                    for (var key in data.studentList) 
                    {
                        var d2 = data.studentList[key]
                        studentId=d2.id; 
                        firstName=d2.first_name;
                        middleName=d2.middle_name;
                        lastName=d2.last_name;

                        str ='<tr><td>'+d2.admission_number+' - '+firstName+' '+ lastName+'</td><td class="mg-align-center"><a title="View" class="mg-icon-btn" href="/fees/fees_submission_batch/'+studentId+'/'+data.collectionID+'" ><i class="fa fa-eye"></i></a></td></tr>';
                        $("#feeCollectionStudentListID").append(str);
                        str='';
                    }
                    
                }
                apdStr += '</table></div>';
        },
        error: function(data)
        {

   $("#feeCollectionStudentListID").append('<tr><td align="center">No Fee Collection For this Batch Student</td></tr>');

        }
    }); 
    }
});    




$(document).on("change","#fee_collection_fee_collection", function(){
    //$("#feeCollectionStudentListID").append("<tr><td>abc</td><td>vv</td></tr>");

    var batchId=$("#fee_collection_batch").val();
    var urlLink="/fees/fee_collection";
    $("#feeCollectionStudentListID").empty();
    var selectFeeScheduleId=$("#fee_collection_fee_collection").val();
    if(batchId.trim()!='')
    {
        $.ajax({
            type: "get",
            dataType: "json",
            url: urlLink, 
            cache: false,
            data:
            {
                batchId: batchId,
                taskRequired:'getStudentList'
            },
            success: function(data)
            {
                console.log(data);
                if(data.studentList.length==0)
                {
                    $("#feeCollectionStudentListID").append('<tr><td align="center">No Student Found</td></tr>');
                }
                /*$("#batchDetailFeeCollectionID").empty();}*/
                if(data.studentList.length>0)
                {
                    var str='';
                    str ='<th>Student Name</th><th>Actions</th>';
                    $("#feeCollectionStudentListID").append(str);
                    str='';
                    for (var key in data.studentList) 
                    {
                        var d2 = data.studentList[key]
                        studentId=d2.id; 
                        firstName=d2.first_name;
                        middleName=d2.middle_name;
                        lastName=d2.last_name;
                        str ='<tr><td>'+d2.admission_number+' - '+firstName+' '+ lastName+'</td><td class="mg-align-center"><a title="View" class="mg-icon-btn" href="/fees/fees_submission_batch/'+studentId+'/'+selectFeeScheduleId+'" ><i class="fa fa-eye"></i></a></td></tr>';
                        $("#feeCollectionStudentListID").append(str);
                        str='';
                    }
                }
                
            }
        });
    }
});
///fees/fees_submission_batch/'+studentId+'" id="'+studentId+'
//?feeCollectionId='+selectFeeScheduleId+

 $(document).on("click", ".display-student-fee-detail-cls", function(e){
       // e.preventDefault();
        var studentID =$(this).attr('id');
        var urlLink = "/fees/fees_submission_batch/"+studentID;
        var selectFeeScheduleId=$("#fee_collection_fee_collection").val();
        //alert(selectFeeScheduleId);
        //alert(urlLink);
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                selectFeeCollectionId: selectFeeScheduleId,
                ajaxParamDisplayFee:'ajaxParamDisplayFee'
            },
            success: function(data)
            {
                  console.log(data);
            }
        });
 });   



  $(document).on("click", "#createNewFeeFineID", function(e){
        e.preventDefault();
        var urlLink = "/fees/generate_fine/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){   
                  //$('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                  $('#createFineDiveId').dialog({
                  
                    modal: true,
                    title: "Create New Fee Fine",
                    minWidth: 600,
                    minHeight: 400,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
 });

  $(document).on("click", ".edit-fee-fine-class", function(e){
        e.preventDefault();
        var feeFineID =$(this).attr('id');
        var urlLink = "/fees/edit_fee_fine/"+feeFineID;
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  //$('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                  $('#editFineDiveId').dialog({
                    modal: true,
                    title: "Edit Fee Fine",
                    minWidth: 400,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
 });   


//fee schedule
  $(document).on("click", ".edit-fee-schedule-class", function(e){
        e.preventDefault();
        var feeSheduleID =$(this).attr('id');
        var urlLink = "/fees/edit_fee_schedule/"+feeSheduleID;
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                 // $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                   $('#editFeeScheduleId').dialog({
                  
                    modal: true,
                    title: "Edit Fee Schedule",
                    minWidth: 530,
                    minHeight: 270,
                    open: function () {
                        
                        console.log(this);
                        $('#editFeeScheduleId').html(html);

                    }
                }); 
               
            }
        });
 });  

  $(document).on("click", ".show-fee-schedule-class", function(e){
        e.preventDefault();
        var feeSheduleID =$(this).attr('id');
        var urlLink = "/fees/show_fee_schedule/"+feeSheduleID;
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                 // $('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                    $('#showFeeScheduleId').dialog({
                    modal: true,
                    title: "Show Fee Schedule",
                    minWidth: 400,
                    width: 'auto',
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
 }); 





var feeCollectionReceiverId='';
 $(document).on("change","#fee_schedule_fee_category_id", function()
 {
    feeCollectionReceiverId='';
    var feeCategoryId=$(this).val();
    var urlLink="/fees/fee_schedule";
    //alert(feeCategoryId);
    $("#batchDetailFeeCollectionID").empty();   
    //$(".fee-detail-fee-collection-class").empty(); 
    if(feeCategoryId.trim()!='')
    {
        $.ajax({
            type: "get",
            dataType: "json",
            url: urlLink, 
            cache: false,
            data:
            {
                feeCategoryId: feeCategoryId,
                feeCategoryIdParam:'feeCategoryIdParam'
            },
            success: function(data)
            {
                console.log(data);
                $("#batchDetailFeeCollectionID").empty();
                $("#batchDetailFeeCollectionID").append('<label class="mg-label">Select Class & Section</label><br/>');
                $("#batchDetailFeeCollectionID").append('<label class="mg-label">Select</label> <a href="#" id="checkAllCheckBoxInFeeScheduleId" class="mg-pop-link">All</a>');
                $("#batchDetailFeeCollectionID").append(' <a href="#" id="unCheckAllCheckBoxInFeeScheduleId" class="mg-pop-link">None</a><br/>');
                
                var dataArray = data.batch_details;
                if(data.batch_details.length>0)
                {
                    var str='';
                     str='<div class="mg-scroll-bar">';
                    //
                    //$("#batchDetailFeeCollectionID").append('<div class="mg-scroll-bar-fee-schedule">');
                
                    for (var key = 0 ;key< dataArray.length;key++) 
                    {
                        var d2 = dataArray[key]
                        batch_id=d2[0];
                        console.log("d2.id"); 
                        console.log(d2[0]); 
                        batch_name=d2[3]+'-'+d2[1];
                        str +='<input type="checkbox" name="selected_batch[]" value="'+batch_id+'" class="batchId_checkbox_cls auto-ckeckbox-fee-schedule-batch-cls auto-ckeckbox-fee-discount-batch-cls">'+batch_name+'<br/>'
                   }
                    str+='</div>';
                        $("#batchDetailFeeCollectionID").append(str);
                         str='';
                    
                }
            }
        });
    }
 });

$(document).on("change",".mg-batch-checkbox-cls", function()
 {
    var lb_checkboxValue=$(this).is(':checked');
    var checkboxValue=$(this).val();
    if(lb_checkboxValue)
    {
        feeCollectionReceiverId +=checkboxValue+',';
    }

    if(!lb_checkboxValue)
    {
        //var checkboxValue=$(this).val();
        feeCollectionReceiverId=feeCollectionReceiverId.replace(checkboxValue,'');
    }
    //alert(receiverId);
    $("#feeCollectioBatchID").val(feeCollectionReceiverId);

 });



$(document).on("click", "#addNewFeeScheduleID", function(e){
        e.preventDefault();
        var urlLink = "/fees/fee_schedule/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){  
                  //$('<div class="fancybox-outer" style="padding: 15px; width: auto; height: auto;"></div>').dialog({
                  $('#createFeeScheduleId').dialog({
                  
                    modal: true,
                    title: "Create New Fee Schedule",
                    minWidth: 530,
                    minHeight: 270,
                    open: function () {
                        
                        $('#createFeeScheduleId').html(html);
                    }
                }); 
               
            }
        });
 });

//fee particular

$(document).on("blur",".check-for-valid-admission-number-cls", function()
 {
    var admissionNumber=$(this).val();
    var urlLink="/fees/fee_discounts";
    //"<%= fees_fee_discounts_path %>"
    //alert(admissionNumber);
    if(admissionNumber.trim()!='')
    {
        //alert(admissionNumber);
        $.ajax({
            type: "get",
            dataType: "json",
            url: urlLink , 
            cache: false,
            data:
            {
                admissionNumber: admissionNumber,
                admissionNumberParam:'admissionNumberParam'
            },
            success: function(data)
            {
                console.log(data);
                if(data.validAdmissionNumber.length>0)
                {
                    var studentId=data.validAdmissionNumber[0].id;
                    //$("#admissionNumberID").val(studentId);
                    //alert(studentId);
                }
                else
                {
                    alert("Invalid Admission Number");
                    //$("#admissionNumberID").val('');
                    $(".check-for-valid-admission-number-cls").val('');
                }
            }
        });
    }

 });




$(document).on("change","#fee_collection_course_report", function(){
 
    var courseId=$("#fee_collection_course_report").val();
    // $("#fee_collection_batch").empty();
    // $("#fee_collection_fee_collection").empty();
    // $("#feeCollectionStudentListID").empty();
    // $("#fee_collection_batch").append('<option value="">Select</option>');
    // $("#fee_collection_fee_collection").append('<option value="">Select</option>');
    var urlLink="/fees/fee_collection";
    if(courseId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            courseId: courseId,
            taskRequired:'getBatchList'
        },
        success: function(data)
        {
          
            console.log(data);
            var str='';
            $("#fee_collection_batch_report").empty();
            $("#feeCollectionReportStudentListID").empty();
              str+='<option value='+"select"+'>'+"Select"+'</option>';
            for (var key in data.name) 
            {
                var d2 = data.name[key]
                //for (var key2 in d2) 
                //{
                    var batch_name=d2.name;
                    var batch_id=d2.id;
                //}
            str+='<option value='+batch_id+'>'+batch_name+'</option>';
            $("#fee_collection_batch_report").append(str);
            str = "";
            // alert(subject_name);
            }
        }

    }); 
    }
});


$(document).on("change","#fee_collection_batch_report", function(){
    var batchId=$("#fee_collection_batch_report").val();
    //$("#fee_collection_fee_collection").empty();
    $("#feeCollectionReportStudentListID").empty();
   // $("#fee_collection_fee_collection").append('<option value="">Select</option>');
    var urlLink="/fees/fee_collection";
    if(batchId!='')
    {
     $.ajax({
        type: "get",
        dataType: "json",
        url: urlLink, 
        cache: false,
        data:
        {
            batchId: batchId,
            taskRequired:'getStudentList'
        },
        success: function(data)
        {
             //console.log(data.collectionID);
             //console.log("demo");
            // var str='';
           // for (var key in data.collectionID) 
             //{
                 
            //     //for (var key2 in d2) 
            //     //{
            //         var collection_name=d2.name;
            //         var collection_id=d2.id;
            //     //}
            // str+='<option value='+collection_id+'>'+collection_name+'</option>';
            // $("#fee_collection_fee_collection").append(str);
            // str = "";
            // //alert(subject_name);
         
            // }
            console.log(data);
                if(data.studentList.length==0)
                {
                    $("#feeCollectionReportStudentListID").append('<tr><td align="center"><h5 class="mg-custom-labels">No Student Found</h5></td></tr>');
                }
                /*$("#batchDetailFeeCollectionID").empty();}*/
                if(data.studentList.length>0)
                {
                    var str='';
                    str += '<div class="mg-scroll-employee-bar" style="margin-left: 13.5em;"><table style="width: 175px;">'
                    str +='<th>Student Name</th><th>Actions</th>';
                    //$("#feeCollectionReportStudentListID").append(str);
                    //str='';
                    for (var key in data.studentList) 
                    {
                        var d2 = data.studentList[key]
                        studentId=d2.id; 
                        firstName=d2.first_name;
                        middleName=d2.middle_name;
                        lastName=d2.last_name;

                        str +='<tr><td>'+d2.admission_number+" - "+firstName+' '+ lastName+'</td><td class="mg-align-center"><a title="View" class="mg-icon-btn select-student-fee-report" id="'+studentId+'-feeReportAID" ><i class="fa fa-eye"></i></a></td></tr>';
                        //$("#feeCollectionReportStudentListID").append(str);
                        //str='';
                    }
                    str+='</table></div>';
                    $("#feeCollectionReportStudentListID").append(str);
                }
                //apdStr += '</table>';
        },
        error: function(data)
        {

   $("#feeCollectionReportStudentListID").append('<tr><td align="center">No Fee Collection for this Batch Student</td></tr>');

        }
    }); 
    }
});    


// 

$(document).on("click", ".select-student-fee-report", function(e){
        e.preventDefault();
        var studentID =$(this).attr('id');
        var splitStudentID=studentID.split('-');

         var urlLink = "/fees/fee_report_for_student/";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{
                mg_student_id: splitStudentID[0] 
            },
            success: function(append){  
                $("#feeCollectionReportStudentListID").empty();
                $("#feeCollectionReportStudentListID").append(append);

                
                 
            }
        });
 });
