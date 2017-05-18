$(document).on("click", ".change-password-btn", function(e){
        var myID =$(this).attr('id');
        var Id=myID.split("-");
        var urlLink = "/accounts/central_incharge_change_password/"+Id[0];
        $.ajax({
            url: urlLink ,
            cache: false,
            success: function(html){
                  $('#changePasswordInchargeDIVID').dialog({
                    modal: true,
                     minHeight: 'auto',
                    width: 'auto',
                    title: "Change Password",
                    open: function () {
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
