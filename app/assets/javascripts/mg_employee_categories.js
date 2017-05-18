/* comm */

$(document).ready(function(){
   

  $(document).bind('ajaxError', '#new_mg_employee_category', function(event, jqxhr, settings, exception){

    // note: jqxhr.responseJSON undefined, parsing responseText instead
    //alert("Step-1");
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

  });

});

(function($) {


  $.fn.modal_success = function(){
    console.log("step-one");
    console.log(this);
    // close modal
    this.modal('hide');
    $(this).dialog("close");
    // clear form input elements
    // todo/note: handle textarea, select, etc
    this.find('form input[type="text"]').val('');

    // clear error state
    this.clear_previous_errors();
  };

  $.fn.render_form_errors = function(errors){
    $form = this;
    this.clear_previous_errors();
    model = this.data('model');

    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
    });

  };

  $.fn.clear_previous_errors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  };

}(jQuery));