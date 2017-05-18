$(document).on("click", ".delete-inventory-category-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/inventory/delete/"+Id[0];
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




$(document).on("click", ".delete-inventory-item-btn", function(e){
     e.preventDefault();
                var myID =$(this).attr('id');
            var Id=myID.split("-");
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                     var urlLink = "/inventory/item_delete/"+Id[0];
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

// / Bindhu work starts
function itemCategoryChangeFunction(item_category_id){
  $.ajax({
    url:"/inventory/item_name_based_on_item_category",
    data:{"mg_inventory_item_category_id":item_category_id},
    success:function(html){
      $("#mg_inventory_item_management_mg_inventory_item_id").html(html);
      $("#mg_inventory_item_consumption_mg_inventory_item_id").html(html);
      $("#inventory_new_fine_particular_mg_inventory_item_id").html(html);
    },
    error:function(){
      alert("inside error");    }
  });
}


$(document).on("change","#mg_inventory_item_management_mg_inventory_item_id",function(){
  var item_id=$(this).val();
  $.ajax({
    url:"/inventory/auto_generating_id_from_prefix",
    data:{"mg_inventory_item_id":item_id},
    success:function(data){
      console.log(data);
      $("#mg_inventory_item_management_item_prefix").val(data);
    }
  });
});

function roomChangeFunction(room_id){
  $.ajax({
    url:"/inventory/rack_based_on_room",
    data:{"mg_inventory_room_id":room_id},
    success:function(html){
      $("#mg_inventory_item_management_mg_inventory_rack_id").html(html);
      $("#inventory_new_fine_particular_mg_inventory_rack_id").html(html);
      // $("#mg_inventory_item_consumption_mg_inventory_rack_id").html(html);
    }
  });
}


$(document).on("change","#mg_inventory_item_consumption_mg_inventory_room_id",function(){
  var item_id=$("#mg_inventory_item_consumption_mg_inventory_item_id").val();
  var room_id=$(this).val();
  $.ajax({
    url:"/inventory/rack_based_on_room_and_item",
    data:{"mg_inventory_room_id":room_id,"mg_inventory_item_id":item_id},
    success:function(html){
      $("#mg_inventory_item_consumption_mg_inventory_rack_id").html(html);
    }
  });
});


$(document).on("change","#mg_inventory_item_consumption_mg_inventory_item_id",function(){
  var item_id=$(this).val();
  $.ajax({
    url:"/inventory/room_based_on_item",
    data:{"mg_inventory_item_id":item_id},
    success:function(html){
      $("#mg_inventory_item_consumption_mg_inventory_room_id").html(html);
    }
  });
});

$(document).on("change","#mg_inventory_item_consumption_mg_inventory_rack_id",function(){
  var rack_id=$(this).val();
  var item_id=$("#mg_inventory_item_consumption_mg_inventory_item_id").val();
  $.ajax({
    url:"/inventory/auto_generating_id_from_prefix_consumption",
    data:{"mg_inventory_item_id":item_id,"mg_inventory_rack_id":rack_id},
    success:function(data){
      console.log(data);
      $("#mg_inventory_item_consumption_item_prefix").val(data);
      quantityAvailable(item_id,rack_id);
    }
  });
});

function quantityAvailable(item_id,rack_id){
  $.ajax({
    url:"/inventory/item_available_quantity",
    data:{"mg_inventory_item_id":item_id,"mg_inventory_rack_id":rack_id},
    success:function(data){
      console.log(data[0]);
      console.log(data[1]);
      if(data.length>0){
        $("#mg_inventory_item_consumption_quantity_available").val(data[0]);
        $("#total_quantity").val(data[1]);
      }
      else{
        $("#mg_inventory_item_consumption_quantity_available").val(0);
        $("#total_quantity").val(0);
      }
    }
  });
}

$(document).on("change","#mg_inventory_item_consumption_quantity_consumed",function(e){
  var available_quantity=parseInt($("#mg_inventory_item_consumption_quantity_available").val());
  var quantity_consumption=parseInt($(this).val());
  var item=$("#mg_inventory_item_consumption_mg_inventory_item_id").val();
  if (item=="")
  {
    alert("Item name should be filled first");
    document.getElementById('mg_inventory_item_consumption_quantity_consumed').value ="";
  }
 else if(quantity_consumption > available_quantity){
    alert("Quantity consumption can't be greater than quantity available");
    document.getElementById('mg_inventory_item_consumption_quantity_consumed').value ="";
  } 
});

$(document).on("click", "#selecAllAID", function(e){
  $(".selectCheckBox").prop('checked', true);
  e.preventDefault();     
});

$(document).on("click", "#selectNoneAID", function(e){
  $(".selectCheckBox").prop('checked', false);
  e.preventDefault();
});

$(document).on("change","#mg_consumer_type_id",function(){
  consumer_type=$(this).val();
  if(consumer_type=="student"){
    var url="/inventory/inventory_consumption_for_student";
    replace_html(consumer_type,url);
  }
  else if(consumer_type=="employee"){
    var url="/inventory/inventory_consumption_for_employee";
    replace_html(consumer_type,url);
  }
  else{
    alert("Select Consumer Type");
    $("#student-consumed-p").hide();
    $("#employee-consumed-p").hide();
  }
});

function replace_html(consumer_type,url){
  if(consumer_type=="student"){
    $.ajax({
      url:url,
      success:function(html){
        $("#student-consumed-p").show();
        $("#student-consumed-p").html(html);
        $("#employee-consumed-p").hide();
      }
    });
  }
  else{
    $.ajax({
      url:url,
      success:function(html){
        $("#employee-consumed-p").show();
        $("#student-consumed-p").hide();
        $("#employee-consumed-p").html(html);
      }
    });
  }
}
$(document).on("click","#Add",function(){
  var selected_for_add=$("#returnIds option:selected").remove();
  $("#damagedIds").append(selected_for_add);
  $("#returnIds option").prop('selected',true);
  $("#damagedIds option").prop('selected',true);

});

$(document).on("click","#Remove",function(){
  var selected_for_remove=$("#damagedIds option:selected").remove();
  $("#returnIds").append(selected_for_remove);
  $("#returnIds option").prop('selected',true);
  $("#damagedIds option").prop('selected',true);
});

// Bindhu work Ends

function selectRoomData(data){
 
var urlLink = "/inventory/inventory_room_data/";
        $.ajax({
            url: urlLink ,
            cache: false,
             data:{"id":data},

            success: function(html){
                $("#store_data_id").empty();
                $("#store_data_id").append(html);  
            }
        });

}

function selectEditRoomData(data){
 
var urlLink = "/inventory/inventory_room_data/";
        $.ajax({
            url: urlLink ,
            cache: false,
             data:{"id":data},

            success: function(html){
                $("#store_edit_data_id").empty();
                $("#store_edit_data_id").append(html);  

               
            }
        });

}