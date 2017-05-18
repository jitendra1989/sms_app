$(document).on("change","#mg_inventory_item_consumption_mg_inventory_rack_id",function(){
  var rack_id=$(this).val();
  var item_id=$("#mg_inventory_item_consumption_mg_inventory_item_id").val();
  $.ajax({
    url:"/inventory/auto_generating_id_from_prefix_consumption",
    data:{"mg_inventory_item_id":item_id,"mg_inventory_rack_id":rack_id},
    success:function(data){
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