$(document).on("click",".edit-super-principal",function(){var i=$(this).attr("id"),t=i.split("-"),n="/cloud_admins/edit_super_principal/"+t[1];$.ajax({url:n,cache:!1,success:function(i){$("#editEmployeeDialog").dialog({modal:!0,title:"Edit Super Principal",minHeight:600,minWidth:860,open:function(){$(this).html(i)}})}})}),$(document).on("click",".edit-admin-profile",function(){var i=$(this).attr("id"),t=i.split("-"),n="/cloud_admins/edit_admin/"+t[1];$.ajax({url:n,cache:!1,success:function(i){$("#editAdminDialog").dialog({modal:!0,title:"Edit Admin",minHeight:600,minWidth:860,open:function(){$(this).html(i)}})}})}),$(document).on("click",".edit-principal-profile",function(){var i=$(this).attr("id"),t=i.split("-"),n="/cloud_admins/edit_principal/"+t[1];$.ajax({url:n,cache:!1,success:function(i){$("#editPrincipalDialog").dialog({modal:!0,title:"Edit Principal",minHeight:600,minWidth:860,open:function(){$(this).html(i)}})}})});