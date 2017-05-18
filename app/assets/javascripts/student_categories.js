/* comm */
// $(document).ready(function(){
//     $('form#new_mg_student_category').submit(function(event){
//     event.preventDefault();
//       $(this).find(input[type='submit']).attr("disabled", "true");
//       return false;
//   });
//   $(document).bind('ajaxError', 'form#new_mg_student_category', function(event, jqxhr, settings, exception){
//     // note: jqxhr.responseJSON undefined, parsing responseText instead
//     $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );
//   });
// });
// (function($) {
//   $.fn.modal_success = function(){
//     // close modal
//     this.modal('hide');
//     // clear form input elements
//     // todo/note: handle textarea, select, etc
//     this.find('form input[type="text"]').val('');
//     // clear error state
//     this.clear_previous_errors();
//   };
//   $.fn.render_form_errors = function(errors){
//     $form = this;
//     this.clear_previous_errors();
//     model = this.data('model');
//     // show error messages in input form-group help-block
//     $.each(errors, function(field, messages){
//       $input = $('input[name="' + model + '[' + field + ']"]');
//       $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
//     });
//   };
//   $.fn.clear_previous_errors = function(){
//     $('.form-group.has-error', this).each(function(){
//       $('.help-block', $(this)).html('');
//       $(this).removeClass('has-error');
//     });
//   };
// }(jQuery));
     $(document).ready(function(){
              $("li").removeClass( "active" );
              $("a").removeClass( "activeMenu" );
              $("#rolePerLiID").addClass("active");
              $("#rolePerAID").addClass("activeMenu");
     });

     $(document).on("click","#addStudentCategoryBtn", function(){
      // Add New Action here
      //alert("Btn is clicked");
              var urlLink = "/student_categories/new";
                $.ajax({
                    url: urlLink ,
                    cache: false,
                    success: function(html){
                        console.log(html);
                         $('#createStudentCaregoryDiv').dialog({
                          //  modal: true,
                            title: "New Student Category",
                            minHeight: 150,
                            minWidth: 250,
                            open: function () {
                                $(this).html(html);
                            }
                     });
                    }  
                });
     });

     // update   edit-mg-student-category
         $(document).on("click", ".edit-mg-student-category", function(e){
           //     alert("edit");
                 var myID =$(this).attr('id');
            var splString = myID.split("-");
           // alert(splString[1]);
            var urlLink = "/student_categories/edit/"+splString[1];

            $.ajax({
                url: urlLink ,
                cache: false,
                success: function(html){
                   /* $("#dialogID").empty();
                    $("#dialogID").append(html);*/
                      $('#editStudentCategoryDiv').dialog({
                        modal: true,
                        title: "Edit  Student Category",
                        minHeight: 150,
                        minWidth: 250,
                        open: function () {
                            
                            $(this).html(html);
                        }
                    }); //end confirm dialog    
                }
            });
        });
        // delete 
         $(document).on("click", ".delete-mg-student-category", function(e){
                var myID =$(this).attr('id');
                var splString = myID.split("-");
             //   alert(splString);
                var retVal = confirm("Are you sure to delete?");
                if(retVal){
                  //  alert(retVal);
                     var urlLink = "/student_categories/delete/"+splString[1];
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
