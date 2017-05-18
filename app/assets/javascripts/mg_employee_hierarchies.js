/* comm */
function mg_employee_list(department_id) { 
  jQuery.ajax({
    url: "mg_employee_hierarchies/mg_employee_list",
    type: "GET",
    data: {"departmentId" : department_id},
    dataType: "html",
    success: function(data) {
      jQuery("#employeeSelect").html(data);
    }
  });
}

function list_of_employee(department_id) { 
  var depVal = $("#employee").val();
  jQuery.ajax({
    url: "mg_employee_hierarchies/list_of_employee",
    type: "GET",
    data: {"add_departmentId" : department_id,"managerListId" :depVal},
    dataType: "html",
    success: function(data) {
        $("#listOfEmployee").show();
      jQuery("#listOfEmployee").html(data);
    }
  });
}

function mg_manager_employee(manager_id) { 
  jQuery.ajax({
    url: "mg_employee_hierarchies/employee_under_manager",
    type: "GET",
    data: {"managerId" : manager_id},
    dataType: "html",
    success: function(data) {
      $("#employeeUnderManager").show();
      jQuery("#employeeUnderManager").html(data);
    }
  });
}

$(document).on("click","#mg-employee-manager-save-btn",function(e){
        e.preventDefault();
        var manager_id =$("#employee").val();
        
        var values = $('input:checkbox:checked').map(function () {
            return this.value;
        }).get();

         jQuery.ajax({
            url: "mg_employee_hierarchies/create",
            type: "GET",
            data: {"managerId" : manager_id,"selected_employee_id":values},
            dataType: "html",
            success: function(data) {
              var department_id=$("#add_department").val();
              list_of_employee(department_id);
                 $("#employeeUnderManager").show();
              jQuery("#employeeUnderManager").html(data);
            }
        });
    });

$(document).on("click", ".removeEmployeeLink", function(e){
       e.preventDefault();
        var empId =$(this).attr("id");
        var manager_id =$("#employee").val();
        $.ajax({
            url: "mg_employee_hierarchies/remove_employee" ,
            type: "GET",
            data: {"empId" : empId,"managerId" : manager_id},
            success:function(data){
                 var department_id=$("#add_department").val();
                list_of_employee(department_id);
                 $("#employeeUnderManager").show();
                  jQuery("#employeeUnderManager").html(data);
                },
            error: function(){
              alert("db connection fail please retry");
            }
        
        });
    
});