$(document).on("click",".edit-super-principal",function(i){var t=$(this).attr("id"),n=t.split("-"),c="/cloud_admins/edit_super_principal/"+n[1];$.ajax({url:c,cache:!1,success:function(i){$("#editEmployeeDialog").dialog({modal:!0,title:"Edit Super Principal",minHeight:600,minWidth:860,open:function(){$(this).html(i)}})}})}),$(document).on("click",".edit-admin-profile",function(i){var t=$(this).attr("id"),n=t.split("-"),c="/cloud_admins/edit_admin/"+n[1];$.ajax({url:c,cache:!1,success:function(i){$("#editAdminDialog").dialog({modal:!0,title:"Edit Admin",minHeight:600,minWidth:860,open:function(){$(this).html(i)}})}})}),$(document).on("click",".edit-principal-profile",function(i){var t=$(this).attr("id"),n=t.split("-"),c="/cloud_admins/edit_principal/"+n[1];$.ajax({url:c,cache:!1,success:function(i){$("#editPrincipalDialog").dialog({modal:!0,title:"Edit Principal",minHeight:600,minWidth:860,open:function(){$(this).html(i)}})}})});