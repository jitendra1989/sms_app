/* comm */

  $(document).on("click","#ExistingGuardianBtnID",function(e){
      $(".guardianNewFormID").css('display', 'none');
      $(".existingRowID").css('display', 'block');

  });

  $(document).on("click","#searchGuardianCancelButton",function(e){

      $(".existingRowID").css('display', 'none');
      $(".guardianNewFormID").css('display', 'block');

  });

  $(document).on("click", "#guardianSearchBtnID", function(e){
    var searchForData = $("#guardianSearchBoxID").val();
   // alert("Hello -- "+searchForData.length);

    if(searchForData.length > 0){
        //  alert("Hello -- "+searchForData.length);
        var urlLink = "/guardians/search_guardian_data/";
        $.ajax({
                url: urlLink ,
                cache: false,
                data:{searchData: searchForData },
                success: function(data){
                    console.log(data.length);
                    if(data.length > 0){
                       var apdStr ='<table class="batch-tbl mg-tbl-margin">';
                            apdStr +=        '<tr class="guardian-table-header">';
                            apdStr +=        '<th>Guardian Name</th>';
                            apdStr +=        '<th>Admission Number</th>';
                            apdStr +=        '<th>Gender</th>';
                            apdStr +=       '</tr>' ;

                    for(key in data){
                         apdStr +='<tr class="even">';
                         apdStr += '<td>'+data[key].first_name+ " " +data[key].last_name+'</td>';
                         apdStr += '<td>'+data[key].occupation+'</td>';
                         apdStr += '<td>'+data[key].relation+'</td>';
                         apdStr += '</tr>';

                    }
                    apdStr += '</table>';

                    $("#searchGuardianDataID").empty().append(apdStr);
                    }else{
                      alert("No students found");   
                    }
                  //  alert("Success");
                },
                error: function(){
                  //  alert("error");
                }

           });   
    }else{
        alert("Please enter some value for search");
    }
        



});


   $(document).on("click","#searchGuardianBtnID",function(){
        //alert("btn clicked ");
       $("#guardianListRecord").empty();
       var firstNameVal = $("#guardianFirstNameID").val();
       var lastNameVal = $("#guardianLastNameID").val();

       if(firstNameVal.length == 0 && lastNameVal.length == 0){
        //alert("Please enter some first name or Last name for searching...")
       }else{


          var urlLink = "/guardians/guardian_list_searched"
          $.ajax({
              url: urlLink ,
              cache: false,
              data: {"first_name":firstNameVal,"last_name":lastNameVal},
              success: function(data){
               // alert(data.length)
                  //console.log(data);
                  if(data.length > 0){
                    
                     var apdStr = "<div class='mg-scroll-subject-bar mg-custom-labels'><table class='batch-tbl'>";
                         apdStr += "<tr>";
                             apdStr += "<th>First Name</th>";
                             apdStr += "<th>Last Name</th>";
                             apdStr += "<th>Occupation</th>";
                             apdStr += "<th>Actions</th>";
                       apdStr += "</tr>";
                    for(key in data){
                          apdStr += "<tr>";
                      var fName = data[key].first_name;
                      var lName = data[key].last_name;
                      var occup = data[key].occupation;
                      apdStr += "<td>"+fName+"</td>";
                      apdStr += "<td>"+lName+"</td>";
                      apdStr += "<td>"+occup+"</td>";
                      apdStr += "<td><button class='guardian-select-btn mg-table-btn' id='guardian-"+data[key].id+"' >Select</button></td></tr>";

                    }
                      apdStr += "</table></div>";
                    
                      console.log(apdStr);
                   $("#guardianListRecord").empty();
                   $("#guardianListRecord").append(apdStr);

                  }else{

                    var apdStr = "<h5 class='error mg-custom-labels'>Record not found</h5>";

                    $("#guardianListRecord").empty();
                    $("#guardianListRecord").append(apdStr);


                  }


              }
                  
          });



    
   }



  });


   $(document).on("click",".guardian-select-btn",function(e){

        e.preventDefault();
        var customFieldId =$(this).attr("id");
        var currentID=customFieldId.split("-");
        window.currentGuardianID = currentID[1];



        var   apdStr ='<table class="mg-custom-labels mg-btn-bottom-margin">';
          apdStr +='  <tr>';
          apdStr +='    <td width="33%" valign="bottom">';
          apdStr +='      <label for="guardianRelationID" class="mg-label">Relation</label>';
          apdStr +='    </td>';
          apdStr +='    <td> </td>';
          apdStr +='    <td> </td>';
          apdStr +='  </tr>';
          apdStr +='  <tr>';
          apdStr +='    <td>';
          apdStr +='        <input type="text" id="guardianRelationID" />';
          apdStr +='    </td>  ';
          apdStr +='    <td> </td>' ;
          apdStr +='    <td>';
          apdStr +='        <button id="submitGuardianBtnID" class="btn btn-default" style="margin-left: 6px; margin-top: 1px; font-size: 0.9em;">Submit</button>';
          apdStr +='    </td> ';
          apdStr +='    <td> </td>' ;
          apdStr +='  </tr>';
          apdStr +='</table>';

        $("#guardianListRecord").empty().append(apdStr);
      //  alert("GuardianID "+currentID[1]);
      //  alert("StudentID "+CurrentStudentID);



   });

  $(document).on("click","#submitGuardianBtnID",function(){
    
    var relation = $("#guardianRelationID").val();
    // alert("btn ExistingGuardianBtnID "+relation);
     currentGuardianID
     CurrentStudentID
    //$("#guardianNewFormID").addClass("display-none");


    var urlLink = "/guardians/student_guardian_create/";
   
    $.ajax({
            data:{"relation":relation,"mg_student_id":CurrentStudentID,"mg_guardians_id":currentGuardianID},
            url: urlLink ,
            cache: false,
            success: function(data){
                 //alert("Success ");

                  $("#addParentDialogID").dialog("close");
                  // close dialog
            }

       });  


  });





// Today changes is above


$(document).on("click",".delete-guardian",function(){
                var myID =$(this).attr('id');

                var splString = myID.split("-");
             //   alert(splString);
                var retVal = confirm("Are you sure to delete data?");
                if(retVal){
                   // alert(retVal);
                     var urlLink = "/guardians/delete/"+splString[1];

                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(html){
                           window.location.reload();
                                       
                        }
                    });

                }else{     
                   return false;
                }

});
//-custom-field
$(document).on("click",".edit-guardian",function(){
	//alert("inside Edit");
	   var Id=$(this).attr("id").split("-");

        var urlLink = "/guardians/"+Id[1]+"/edit";
    //     alert(Id[1]);
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#editGuardianDialogDivId').dialog({
                    modal: true,
                    height: 640,
                    minWidth: 860,
                    title: "Edit Guardian",

                    open: function () {
                        $(this).html(html);
                    }
                }); 
            }
        });
});

$(document).on("click", ".edit-guardian-custum-fields", function(e){
        e.preventDefault();

        var customFieldId =$(this).attr("id");
        var id=customFieldId.split("-");
        // alert("Id : "+Id[1]);
        var urlLink = "/guardians/custom_fields_edit/"+id[1];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html)
            {
                  $("#editGuardianCustomFieldsDivID").dialog({
                    modal: true,
                    minHeight: 'auto',
                    minWidth: 'auto',
                    title: "Edit Guardian Custom Field",

                    open: function () 
                    {
                        $(this).html(html);
                    }
                }); 
            }
        });
});

$(document).on("click", ".delete-guardian-custum-field", function(e){
            var myID =$(this).attr('id');

            var splString = myID.split("-");
          //  alert(splString);
            var retVal = confirm("Are you sure to delete data?");
            if(retVal){
              //  alert(retVal);
                 var urlLink = "/guardians/custum_fields_delete/"+splString[1];

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


// Bindhu Work start

// $(document).on("change",".check_radio_button_for_login_accesss > :radio",function(){
//     $("#loginAccessChangeSubmitBtn").removeAttr("disabled");
//   });

function btnEnable() {
   //$("#changeLoginAccessSaveID").removeAttr("disabled");
   $("#changeLoginAccessSaveID").removeClass("mg-disable-a");
}

function validateGuardianImage(inputFile, that) {

    if ( that.files && that.files[0]) {
      //alert("inside if");
      var reader = new FileReader();
      reader.onload = imageIsLoaded;
      reader.readAsDataURL(that.files[0]);
    }
    var allowedExtension = ["jpg", "jpeg", "gif", "png"];
    var extName = inputFile.split('.');
    if ($.inArray(extName[1], allowedExtension) == -1){
       window.alert("Only image file with extension: .jpg, .jpeg, .gif or .png is allowed");
       $("#mg_guardian_photo").val('');
    }
    else{
      // $("#schoolImageTagID").attr("src","ssc.jpeg.url");

    }
 
} 


function imageIsLoaded(e) {
    $('#guardianImageTagID').attr('src', e.target.result);
    $('#guardianImageTagID').show();
};
// Bindhu work ends