$(document).on("click", ".delete-file-for-employee-share-BTNID", function(e){
             e.preventDefault();
                var myID =$(this).attr('id');
                var splString = myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/document_managements/delete_file/"+splString[0];
                      $.ajax({
                        url: urlLink ,
                        data:{delete_share: "share"

                        },
                        cache: false,
                        success: function(html){
                           window.location.reload();
                        }
                    });

                }else{    
                   return false;
                }

        })


  function fileShowFunction(subfolderID, count){

       var urlLink = "/document_managements/view_file_in_list/"+subfolderID;

    $.ajax({
            url: urlLink ,
            data:{
              subfolderID: subfolderID, count: count 
            },
            cache: false,
            success: function(html){
                
                $("#userFileUploadManagementTDID").empty();

                $("#userFileUploadManagementTDID").append(html);
                
               
            }
        });
  }

    $(document).on("click", ".hide-and-show-sub_folder-Ol", function(e){
     e.preventDefault();
        var myID =$(this).attr('id');
       var splString = myID.split("-");
       fileShowFunction(splString[0], splString[0]);

        var urlLink = "/document_managements/view_file_in_sub_folder_list/";

        $.ajax({
            url: urlLink ,
            data:{
              subfolderID: splString[0], count: splString[0] 
            },
            cache: false,
            success: function(html){
              // alert($("#breadcrumbsForFileManagement").val());
              myDivObj = document.getElementById("breadcrumbsForFileManagement");
              
                // $("#userFileUploadManagementTDID").empty();
                $("#"+splString[0]+'-'+splString[1]+'-hideAndShowSubFolderDIVIDID').empty();
                $("#"+splString[0]+'-'+splString[1]+'-hideAndShowSubFolderDIVIDID').append(html);
                $("#"+splString[0]+'-'+splString[1]+'-hideAndShowSubFolderDIVIDID').toggle();
                $("#"+splString[0]+"hideAndShowSubFolderDIVID").toggle();

                console.log(html);

                // 24-9-subFolderOLID
                // logger.info

                var value=  $("#"+splString[0]+'-'+splString[1]+'-'+"subFolderOLID").html();
              // $("#hideAndShowLinkForEmployeeFileDivID").toggle();
               // 
               // alert("value :"+value)
               // alert("#"+splString[0]+'-'+splString[1]+'-'+"folderPlusID");
               
                if(value=='<i class="fa fa-minus-square-o mg-file-mgmt-icon"></i>'){
                  // $("#userFileUploadManagementTDID").empty();
                  var table='<div id="breadcrumbsForFileManagement" class="mg-bold-brdcrmb">'+myDivObj.innerHTML+'</div>'
                      table +='<table class="batch-tbl"><tr><th>File Name</th><th>file size</th><th>Actions</th></tr><tr></tr></table>'
                  // $("#userFileUploadManagementTDID").append(table);
                  $("#"+splString[0]+'-'+splString[1]+'-'+"subFolderOLID").empty();

                  $("#"+splString[0]+'-'+splString[1]+'-'+"subFolderOLID").append('<i class="fa fa-plus-square-o mg-file-mgmt-icon"></i>');
                }else{
                  $("#"+splString[0]+'-'+splString[1]+'-'+"subFolderOLID").empty();
                $("#"+splString[0]+'-'+splString[1]+'-'+"subFolderOLID").append('<i class="fa fa-minus-square-o mg-file-mgmt-icon"></i>');
                }
   
               
            }
        });
});



    $(document).on("click", ".create-new-chaild-folder-BTN", function(e){
       e.preventDefault();
        var myID =$(this).attr('id');
       var splString = myID.split("-");


        var urlLink = "/document_managements/folder_new/";
        $.ajax({
            url: urlLink ,
            data:{
              mg_employee_folder_id: splString[0]
            },
            cache: false,
            success: function(html){
                $("#createNewFolderForEmployeeDIVID").dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "New Folder",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

     $(document).on("click", "#createFolderForEmployeeBTNID", function(e){
       e.preventDefault();
        var urlLink = "/document_managements/folder_new/";
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                $("#createNewFolderForEmployeeDIVID").dialog({
                    modal: true,
                    minHeight: 180,
                    title: "New Folder",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

  $(document).on("click", ".show-file-in-folder-div", function(e){
     e.preventDefault();
        var myID =$(this).attr('id');
       var splString = myID.split("-");
       // folderPlusID
       $("#"+splString[1]+"filDivID").toggle();
       $("#"+splString[1]+"hideAndShowCreateChaildFolderDivID").toggle();
       $("#"+splString[1]+"hideAndShowSubFolderDIVID").toggle();
       $("#"+splString[1]+"hideAndShowSubFolderFileDIVID").toggle();


        var urlLink = "/document_managements/view_file_in_list/"+splString[0];
        $.ajax({
            url: urlLink ,
            data:{

            },
            cache: false,
            success: function(html){
                $("#"+splString[1]+"filDivID").empty();
                $("#userFileUploadManagementTDID").empty();
                $("#userFileUploadManagementTDID").append(html);

                var value=  $("#"+splString[0]+'-'+splString[1]+'-'+"folderPlusID").html();
                if(value=='<i class="fa fa-minus-square-o mg-file-mgmt-icon"></i>'){
                  
                    $(".hideOldFolder").empty();

                  $("#"+splString[0]+'-'+splString[1]+'-'+"folderPlusID").empty();
                  
                  $("#"+splString[0]+'-'+splString[1]+'-'+"folderPlusID").append('<i class="fa fa-plus-square-o mg-file-mgmt-icon"></i>');
                  // $("#userFileUploadManagementTDID").empty();
                  myDivObj = document.getElementById("breadcrumbsForFileManagement");
                  var table='<div id="breadcrumbsForFileManagement" class="mg-bold-brdcrmb">'+myDivObj.innerHTML+'</div>'
                  table +='<table class="batch-tbl"><tr><th>File Name</th><th>file size</th><th>Actions</th></tr><tr></tr></table>'
                  // $("#userFileUploadManagementTDID").empty();
                  // $("#userFileUploadManagementTDID").append(table);
                }else{
                  $("#"+splString[0]+'-'+splString[1]+'-'+"folderPlusID").empty();
                $("#"+splString[0]+'-'+splString[1]+'-'+"folderPlusID").append('<i class="fa fa-minus-square-o mg-file-mgmt-icon"></i>');
                }
   
               
            }
        });
});


// sub-folder-show-BTN

  $(document).on("click", ".add-file-to-folder-BTN", function(e){
     e.preventDefault();
        var myID =$(this).attr('id');
       var splString = myID.split("-");


        var urlLink = "/document_managements/new/";
        $.ajax({
            url: urlLink ,
            data:{
              mg_employee_folder_id: splString[0]
            },
            cache: false,
            success: function(html){
                $("#createNewFileForEmployeeDIVID").dialog({
                    modal: true,
                    minHeight: 150,
                    width: 350,
                    title: "New File",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

function toggleAll()
{
 $("#whatever").toggle();
 $(".no-of-days-attendence").toggle();
}

$(document).on("click", ".hide-and-show-link-for-employee-file-BTNID", function(e){
   e.preventDefault();
  $("#hideAndShowLinkForEmployeeFileDivID").toggle();
   var value=$("#hideAndShowLinkForEmployeeFolderBTNID").html();
    if(value=='<i class="fa fa-minus-square-o mg-file-mgmt-icon"></i>'){
      $("#hideAndShowLinkForEmployeeFolderBTNID").empty();
      $("#hideAndShowLinkForEmployeeFolderBTNID").append('<i class="fa fa-plus-square-o mg-file-mgmt-icon"></i>');
    }else{
      $("#hideAndShowLinkForEmployeeFolderBTNID").empty();
      $("#userFileUploadManagementTDID").empty();
      $("#hideAndShowLinkForEmployeeFolderBTNID").append('<i class="fa fa-minus-square-o mg-file-mgmt-icon"></i>');
      myDivObj = document.getElementById("breadcrumbsForFileManagement");
      var table='';
      if (myDivObj!=null){
      table +='<div id="breadcrumbsForFileManagement" class="mg-bold-brdcrmb">'+myDivObj.innerHTML+'</div>'
      }else{
        table +='<div id="breadcrumbsForFileManagement" class="mg-bold-brdcrmb"> My Folder > </div>'
      }
      table +='<button id="createFolderForEmployeeBTNID" class="mg-custom-form-btn mg-text-margin"><span for="subfolder1">Create Folder</span></button>';
      table +='<table class="batch-tbl mg-text-margin"><tr><th>File Name</th><th>file size</th><th>Actions</th></tr><tr></tr></table>'
                  $("#userFileUploadManagementTDID").append(table);
    
    }
});


          $(document).on("click", ".delete-file-for-employee-BTNID", function(e){
             e.preventDefault();
                var myID =$(this).attr('id');
                var splString = myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/document_managements/delete_file/"+splString[0];
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
                $(document).on("click", ".delete-file-from-folder-BTN", function(e){
                   e.preventDefault();
                var myID =$(this).attr('id');
                var splString = myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/document_managements/delete_folder/"+splString[0];

                      $.ajax({
                        url: urlLink ,
                        cache: false,
                        success: function(html){
                        }
                    });

                }else{   
                   return false;
                }

        }); 




    $(document).on("click", "#shareFileForStudentBTNID", function(e){
     e.preventDefault();

   
     var mg_batch_id=$("#batch").val();
     if(mg_batch_id>0){
     var mg_document_management_id=$("#document_management_id").val();
     var urlLink='/document_managements/share_file_for_batch_save/';
     $.ajax({
            url: urlLink ,
            data:{
              mg_batch_id: mg_batch_id, mg_document_management_id: mg_document_management_id
            },
            cache: false,
            success: function(html){
              $("#shereFileForBatchDIVID").empty();
              alert("file shared successfully");
                    // $("#shereFileForBatchDIVID").remove(); 
             
              $(".ui-dialog-titlebar-close").click();
            }

            
        });
   }else{
    alert("Please select Batch");
    $("#batch").val("select");
   }


  });

      $(document).on("click", ".share-file-for-sudent-A-cls", function(e){
     e.preventDefault();
      var myID =$(this).attr('id');
      var splString = myID.split("-");
     var urlLink='/document_managements/share_file_for_batch/'+splString[0];
     $.ajax({
            url: urlLink ,
            data:{
              
            },
            cache: false,
            success: function(html){
                
               $("#shereFileForBatchDIVID").dialog({
                    modal: true,
                    minHeight: 'auto',
                    title: "Share file",
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
  });
