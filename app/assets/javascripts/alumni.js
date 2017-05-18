$(document).on("click", ".remove-polling-options", function(e){
   var total = $('.remove-polling-options').length
   if(total!=1)
   {
      $(this).parent('div').remove();
    }
   //alert($(this).val());
});

// $(document).on("blur","#search_gallery",function(){
//   var galler_name=$("#search_gallery").val();
//   if(galler_name==''){
//     var urlLink = "/alumni/photo_gallery";
//     window.location=urlLink;
//   }
// });



$(document).on("click", ".photo-gallery-count-cls", function(e){
  alert("You can not create more than 15 gallery");
  return false;
});