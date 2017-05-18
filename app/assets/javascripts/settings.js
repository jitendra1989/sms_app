/* comm */
  $(document).ready(function(){

            focusSettings();
            $(document).on("click","#rolePerID_partial", function(){
               // alert("Hello");

              $("#userUlLiID li").removeClass("active");
              $("#userUlLiID li a").removeClass("activeMenu");


              $(this).parent().parent().addClass("active");
              $(this).addClass("activeMenu");

              apdStr = '<div class="role-dash" id="actionDivID">Actions</div>';
              apdStr += '<div class="role-dash" id="modelDivID">Models</div>';
              apdStr += '<div class="role-dash" id="roleDivID">Roles</div>';
              apdStr += '<div class="role-dash" id="perDivID">Permissions</div>';
              apdStr += '<div class="role-dash" id="rolePerDivID">Roles And Permission</div>';
              apdStr += '<div class="role-dash" id="userRoleDivID">User Roles</div>';

                $("#userRegFormID").empty().append(apdStr);

                 //event.preventDefault();
                 return false;
            });


            $(document).on("click","#actionDivID_par", function(){
                var Data = ajax_Caller("/mg_actions");
                console.log(Data);
                $("#userRegFormID").empty().append(Data);
            });


            $(document).on("click","#addActionBtn_par", function(){
                var Data = $().ajax_Caller("/mg_actions/new");
                console.log(Data);
                $("#userRegFormID").empty().append(Data);
            });


            $(document).on("click","#modelDivID_par", function(){
               // alert("modelDivID");
            });


            $(document).on("click","#roleDivID_par", function(){
               // alert("roleDivID");
            });

            $(document).on("click","#perDivID_par", function(){
                //alert("perDivID");
            });//

            $(document).on("click","#rolePerDivID_par", function(){
               // alert("rolePerDivID");
            });

            $(document).on("click","#manageUserID", function(){
                //alert("work on progress");
            });


  // function ajax_Caller(urlParam){
  //    Data = "";
  //    $.ajax({
  //           url: urlParam,
  //           cache: false,
  //           success: function(html){
  //               Data = html
  //               console.log(html);
  //              return Data;
  //           },
  //           error: function(){
  //               alert("url not exist") ;
  //           }
  //       });
  //    return Data;
  // }


/*  $.fn.ajax_Caller = function(urlParam){
    Data : "";
   
    
  };

*/

});