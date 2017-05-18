

 $(document).on("click", ".edit-super-principal", function(e){   

    var myID =$(this).attr('id');
    var splString = myID.split("-");
    var urlLink = "/cloud_admins/edit_super_principal/"+splString[1];
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html) {
                $("#editEmployeeDialog").dialog({
                modal: true,
                title: "Edit Super Principal",
                minHeight: 600,
                minWidth: 860,
                open: function () {
                    $(this).html(html);
                }
            }); //end confirm dialog
        }
    });  
 }); 


 $(document).on("click", ".edit-admin-profile", function(e){   

    var myID =$(this).attr('id');
    var splString = myID.split("-");
    var urlLink = "/cloud_admins/edit_admin/"+splString[1];
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html) {
                $("#editAdminDialog").dialog({
                modal: true,
                title: "Edit Admin",
                minHeight: 600,
                minWidth: 860,
                open: function () {
                    $(this).html(html);
                }
            }); //end confirm dialog
        }
    });  
 });

 $(document).on("click", ".edit-principal-profile", function(e){   

    var myID =$(this).attr('id');
    var splString = myID.split("-");
    var urlLink = "/cloud_admins/edit_principal/"+splString[1];
    $.ajax({
        url: urlLink ,
        cache: false,
        success: function(html) {
                $("#editPrincipalDialog").dialog({
                modal: true,
                title: "Edit Principal",
                minHeight: 600,
                minWidth: 860,
                open: function () {
                    $(this).html(html);
                }
            }); //end confirm dialog
        }
    });  
 });