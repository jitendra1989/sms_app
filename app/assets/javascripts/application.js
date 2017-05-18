/* comm */
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= html5
//= google-jsapi
//= require chartkick
//= require turbolinks
//= require jquery.ui.all
//= require jquery.ui.datepicker
//= require moment
//= require fullcalendar
//= require jquery.datetimepicker
//= require jquery.timepicker.js

//= jquery.validate.min.js

//= require bootstrap-colorpicker
//= require ckeditor/init

//= require_tree .


/*
equire cloudinary

will hide acrolling dialog
$(formObject).dialog({
 create: function(event, ui) {
  $("body").css({ overflow: 'hidden' })
 },
 beforeClose: function(event, ui) {
  $("body").css({ overflow: 'inherit' })
 }
});


*/
    

$(document).ready(function() {

    



   // added
    //window.addEventListener("hashchange", headerBoxesFocus, false);

    
    $(".sortOption").click(function(e) {
        e.stopPropagation();
        $(".sortOptionsList").slideToggle();
    });

    $(document).click(function(e) {
        e.stopPropagation();
        $(".sortOptionsList").hide();
    });


    $(".content-tab").tabs();

    $(document).on("click", ".home-box-li", function(e) {
        // e.preventDefault();
        $("#headerBoxID > li").removeClass("active");
        //  var currentText = $(this).text().trim();
        //   alert("click "+currentText);
        // headerBoxesFocus();
        $(this).addClass("active");
    });
    //  alert("Step -- 1");

    headerBoxesFocus();

});

function collapseLeftMenu(){
    $('.userMenuBoxLeft ul div li').hide();

    $('.userMenuBoxLeft > ul > li').click(function() {

        $(this).removeClass('mg-toggle-plus');
        $(this).addClass('mg-toggle-minus');

        var checkElement = $(this).next('div').children();   

        if((checkElement.is('li')) && (checkElement.is(':visible'))) {    
        $(this).closest('li').toggleClass('mg-toggle-minus mg-toggle-plus');
        checkElement.slideUp('normal');
        }

        if((checkElement.is('li')) && (!checkElement.is(':visible'))) {      
        $('.userMenuBoxLeft ul div li:visible').slideUp('normal');
        checkElement.slideDown('normal');
           $(".myAccountMenu").removeClass('mg-toggle-minus');
          $(this).closest('li').toggleClass('mg-toggle-minus mg-toggle-plus');
          $(".myAccountMenu").addClass('mg-toggle-plus');
        }
      
    });
}

function focusCurrentTab(paramAID, paramLiID) {

    //    alert("#"+paramAID);
    //    alert("#"+paramLiID);

    // $("li").removeClass("active");
    // $("a").removeClass("activeMenu");

    $("#" + paramLiID).addClass("active");
    $("#" + paramAID).addClass("activeMenu");

    $("#" + paramLiID).show();
    $("#" + paramLiID).siblings('li').show();
    $("#" + paramLiID).parents('div').prev('li').toggleClass("mg-toggle-plus mg-toggle-minus");

    console.log($("#" + paramLiID).parents('div').prev('li'));
}


function focusheaderBox(text){
    $("#headerBoxID > li").removeClass("active");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
        var id=$(this).attr("id");
        if (currentText == text) {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

$(document).on("click", ".cancel-form-dialog", function(e) {
    // alert("Hello btn is clicked");
    $('.ui-icon-closethick').click();
});

$(document).on("click", "#viewEmployeetList", function(e) {
    focusCurrentTab("viewEmployeetList", "viewEmployeetListLiID");
    focusAttendance();
});
$(document).on("click", "#EmployeeLeaveTypes", function(e) {
    focusCurrentTab("EmployeeLeaveTypes", "EmployeeLeaveTypesLiID");
    focusAttendance();
});
$(document).on("click", "#employeeLeaveResetq", function(e) {
    focusCurrentTab("employeeLeaveResetq", "employeeLeaveResetqLiID");
    focusAttendance();
});

$(document).on("click", "#viewGuardianEvents", function(e) {
    focusCurrentTab("viewGuardianEvents", "viewGuardianEventsLiID");
    focusDashboards();
});

$(document).on("click", "#GuardianStudentAttendenceID", function(e) {
    focusCurrentTab("GuardianStudentAttendenceID", "GuardianStudentAttendenceLiID");
    focusDashboards();
});


$(document).on("click", "#GuardianStudentsID", function(e) {
    focusCurrentTab("GuardianStudentsID", "GuardianStudentsIDLiID");
    focusDashboards();

});

$(document).on("click", "#viewGuardianFees", function(e) {
    focusCurrentTab("viewGuardianFees", "viewGuardianFeesLiID");
    focusDashboards();
});

$(document).on("click", "#viewGuardianNews", function(e) {
    focusCurrentTab("viewGuardianNews", "viewGuardianNewsLiID");
    focusDashboards();
});




$(document).on("click", "#viewGuardianProfile", function(e) {
    focusCurrentTab("viewGuardianProfile", "viewGuardianProfileLiID");
    focusDashboards();
});

$(document).on("click", "#viewGuardianMessages", function(e) {
    focusCurrentTab("viewGuardianMessages", "viewGuardianMessagesLiID");
    focusDashboards();
});

$(document).on("click", "#viewGuardianNews", function(e) {
    focusCurrentTab("viewGuardianNews", "viewGuardianNewsLiID");
    focusDashboards();
});

$(document).on("click", "#viewGuardianDashboard", function(e) {

            var urlLink = "/dashboards/principle_dashboard/";
        $.ajax({
            url: urlLink,
            cache: false,
            success: function(html) {
                $("#manageEmployeeCategoryID").empty();
                $("#manageEmployeeCategoryID").append(html);

                focusCurrentTab("viewGuardianDashboard", "viewGuardianDashboardLiID");
                focusDashboards();

            }
        });
});

// $(document).on("click","#headerBoxID > li",function (e){
//     $("#headerBoxID > li").removeClass("active");
//     var currentText = $(this).text().trim();
//     console.log("Stepp - improvement ");
    
//     $(this).addClass("active");
$(document).on("click", "#navDropDown", function(e) {
    $(".distributedBoxes1").toggle();
});

//     console.log("Stepp - improvement ");
// });

// function focusCurrentHeaderBox(paramHeaderBox){
//     console.log(paramHeaderBox);
// }



function focusExaminationHeaderBox () {
    // body...
    
    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
        var id=$(this).attr("id");
        if (currentText == "EXAMINATION") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusStudentHeaderBox() {
    $("#headerBoxID > li").removeClass("active");
   // $( "selector > selector:kantains('val')" ).addClazz('cls-nam');

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "STUDENTS") {
             console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusDashboards() {
    //  alert("dashboard");
    $("#headerBoxID > li").removeClass("active");

    // alert("dashboards");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "HOME") {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusFees() {
    //  alert("dashboard");
    //focusAttendance();
    $("#headerBoxID > li").removeClass("active");

    // alert("dashboards");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "FEES") {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusAttendance() {

    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "ATTENDANCES") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusSettings() {

    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "SETTINGS") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusCourses() {

    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "CLASS") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}


function focusEmployee() {
    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "EMPLOYEES") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusSubject() {


    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "SUBJECTS") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusFees() {
    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "FEES") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });


}
function focusLibrary() {
    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "LIBRARY") {
            // console.log(currentText.trim());
            $(this).addClass("active");
            scrollFocus(id);
        }
    });


}
function focusVehicle() {

    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "VEHICLE") {
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}
function focusTransport() {

    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "TRANSPORT") {
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}
function focusSchool() {

    $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "SCHOOLS" || currentText == "INSTITUTE") {
            // alert("schools==");
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });

}

function focusTimeTable(){
     $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "TIMETABLE") {
            // alert("schools==");
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}


function focusEvent(){
     $("#headerBoxID > li").removeClass("active");

    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
         var id=$(this).attr("id");  
        if (currentText == "EVENTS") {
            // alert("schools==");
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusMasterSettings() {
    //  alert("dashboard");
    //focusAttendance();
    $("#headerBoxID > li").removeClass("active");

    // alert("dashboards");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
        var id=$(this).attr("id");
        if (currentText == "MASTER SETTINGS") {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusNotification () {
    $("#headerBoxID > li").removeClass("active");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
        var id=$(this).attr("id");
        if (currentText == "NOTIFICATIONS") {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusPaySlip () {
    $("#headerBoxID > li").removeClass("active");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
        var id=$(this).attr("id");  
        if (currentText == "PAYROLL") {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusCurriculum () {
    $("#headerBoxID > li").removeClass("active");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
        var id=$(this).attr("id");
        if (currentText == "CURRICULUM") {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function focusLaboratory () {
    $("#headerBoxID > li").removeClass("active");
    $("#headerBoxID > li").each(function(index) {
        var currentText = $(this).text().trim();
        var id=$(this).attr("id");
        
        if (currentText == "LABORATORY") {
            console.log(this);
            $(this).addClass("active");
            scrollFocus(id);
        }
    });
}

function scrollFocus(index){
    var id=parseInt(index)
    var tempInt=parseInt(id/9);
    $( "div.mg-scroll-header-nav-bar" ).scrollTop(tempInt*70);
}



function headerBoxesFocus() {
    // alert("step -text text");
    var currentLocation = window.location.href;

    if (currentLocation.indexOf("dashboards") > -1) {

        focusDashboards();

    }

    if (currentLocation.indexOf("students") > -1) {
        // alert("students==");

        focusStudentHeaderBox();


    }
     if (currentLocation.indexOf("vehicles") > -1) {
        // alert("students==");

        focusVehicle();


    }
     if (currentLocation.indexOf("transports") > -1) {
        // alert("students==");

        focusTransport();


    }

      if (currentLocation.indexOf("curriculum") > -1) {
        // alert("students==");

        focusCurriculum();


    }

    if (currentLocation.indexOf("laboratory") > -1) {
        // alert("students==");

        focusLaboratory();


    }

    if (currentLocation.indexOf("attendances") > -1) {
        //alert("attendances==");

        focusAttendance();
    }
    if (currentLocation.indexOf("settings") > -1) {
        //alert("settings==");
        focusSettings();
    }
    if (currentLocation.indexOf("courses") > -1) {
        // alert("courses==");

        focusCourses();



    }
    if (currentLocation.indexOf("employees") > -1) {
        // alert("employees==");


        focusEmployee();


    }
    if (currentLocation.indexOf("subjects") > -1) {
        // alert("subjects==");
        focusSubject();

    }
    if (currentLocation.indexOf("fees") > -1) {
        // alert("fees==");

        focusFees();


    }
    if (currentLocation.indexOf("library") > -1) {
        // alert("fees==");

        focusLibrary();


    }
    if (currentLocation.indexOf("schools") > -1) {

        focusSchool();


    }
     if (currentLocation.indexOf("timetable") > -1) {

        focusTimeTable();

    }
       if (currentLocation.indexOf("events") > -1) {

        focusEvent();

    }

    if (currentLocation.indexOf("master_settings") > -1) {

        focusMasterSettings();

    }

    if (currentLocation.indexOf("notification") > -1) {

        focusNotification();

    }

}

// #function for date format



function compareDate(start_date, end_date, formatStr){

    var lowDate = getDateObj(start_date ,formatStr);
    var highDate = getDateObj(end_date ,formatStr);

     
    if(lowDate.getFullYear()>highDate.getFullYear()){
        //alert("1" + " " +lowDate.getFullYear() +" "+highDate.getFullYear());
        return false;
    }else if(lowDate.getFullYear()==highDate.getFullYear()){
            if(lowDate.getMonth()>highDate.getMonth()){
                //alert("2" + " " +lowDate.getMonth() +" "+highDate.getMonth()); 
                return false;
            }else if(lowDate.getMonth()==highDate.getMonth()){
                if(lowDate.getDate()>highDate.getDate()){
                    //alert("3" + " " +lowDate.getDate() +" "+highDate.getDate());
                    return false;
                }
                
            }
    }    

    return true;

}


function getDateObj(dateStr ,formatStr){
    var currentDate=new Date();
    //alert(dateStr);
    var parseDate = dateStr;
    //alert(dateStr);
    
    if(dateStr){
        var date = dateStr.match(/\d+/g); 
        if(date!=null && date.length==3){
        parseDate = new Date(date[2], date[1]-1, date[0]);
        var dateDiff = currentDate.getFullYear()-parseDate.getFullYear();

            if(dateDiff>95){
              parseDate.setYear(parseDate.getFullYear()+100);
            }
        }
    }
    return parseDate;
  }

  function getStudentAdmissionDateObj(dateStr ,formatStr){
    var currentDate=new Date();
    var parseDate ;
    if(dateStr!=""){
        var date = dateStr.match(/\d+/g); 
        parseDate = new Date(date[2], date[1]-1, date[0]);
        var dateDiff = currentDate.getFullYear()-parseDate.getFullYear();
        if(dateDiff>95){
          parseDate.setYear(parseDate.getFullYear()+97);
        }else if(formatStr=="dd/mm/yy"){
          parseDate.setYear(parseDate.getFullYear()-3);  
        }
        // alert("hi "+dateDiff);
    }    
    return parseDate;
  }

  function getEmployeeJoiningDateObj(dateStr ,formatStr){
    var currentDate=new Date();
    var parseDate ;
    if(dateStr!=""){
            var date = dateStr.match(/\d+/g); 
            parseDate = new Date(date[2], date[1]-1, date[0]);
            var dateDiff = currentDate.getFullYear()-parseDate.getFullYear();
            if(formatStr=="dd/mm/y" && dateDiff>95){
              parseDate.setYear(parseDate.getFullYear()+82);
            }
            else if(formatStr=="dd/mm/yy")
            {
                parseDate.setYear(parseDate.getFullYear()-18);
            }
        }    
    return parseDate;
  }


  function getGuardianDateObj(dateStr ,formatStr){
    var currentDate=new Date();
    var date = dateStr.match(/\d+/g); 
    var parseDate = new Date(date[2], date[1]-1, date[0]);
    var dateDiff = currentDate.getFullYear()-parseDate.getFullYear();
    if(formatStr=="dd/mm/y" && dateDiff>95){
      parseDate.setYear(parseDate.getFullYear()+82);
    }
    else if(formatStr=="dd/mm/yy")
    {
        parseDate.setYear(parseDate.getFullYear()-18);
    }
    return parseDate;
  }


function getPrincipleJoiningDateObj(dateStr ,formatStr){
    var currentDate=new Date();
    var date = dateStr.match(/\d+/g); 
    var parseDate = new Date(date[2], date[1]-1, date[0]);
    var dateDiff = currentDate.getFullYear()-parseDate.getFullYear();
    if(formatStr=="dd/mm/y" && dateDiff>95){
      parseDate.setYear(parseDate.getFullYear()+80);
    }
    else if(formatStr=="dd/mm/yy")
    {
        parseDate.setYear(parseDate.getFullYear()-20);
    }
    return parseDate;
  }

  function getYearDifference(selected_date, current_date, formatStr){

    var selectedDate = selected_date;//getDateObj(selected_date ,formatStr);
    var currentDate = current_date;//getDateObj(current_date ,formatStr);
    
    var day  = selectedDate.getDate();  
    var month = selectedDate.getMonth() + 1;            
    var year =  selectedDate.getFullYear();

    var currentMonth=currentDate.getMonth() + 1;
    var currentYear=currentDate.getFullYear();
    var yearDif=currentYear-year;
    if(yearDif<3) {
        return true;
    }
    return false;
}



(function(b,c){var $=b.jQuery||b.Cowboy||(b.Cowboy={}),a;$.throttle=a=function(e,f,j,i){var h,d=0;if(typeof f!=="boolean"){i=j;j=f;f=c}function g(){var o=this,m=+new Date()-d,n=arguments;function l(){d=+new Date();j.apply(o,n)}function k(){h=c}if(i&&!h){l()}h&&clearTimeout(h);if(i===c&&m>e){l()}else{if(f!==true){h=setTimeout(i?k:l,i===c?e-m:e)}}}if($.guid){g.guid=j.guid=j.guid||$.guid++}return g};$.debounce=function(d,e,f){return f===c?a(d,e,false):a(d,f,e!==false)}})(this);
    
    // $(function(){

function table_sticky(table_id){

  $('#'+table_id).each(function() {
    if($(this).find('thead').length > 0 && $(this).find('th').length > 0) {
      // Clone <thead>
      var $w     = $(window),
        $t     = $(this),
        $thead = $t.find('thead').clone(),
        $col   = $t.find('thead, tbody').clone();

      // Add class, remove margins, reset width and wrap table
      $t
      .addClass('sticky-enabled')
      .css({
        margin: 0,
        width: '100%'
      }).wrap('<div class="sticky-wrap" />');

      if($t.hasClass('overflow-y')) $t.removeClass('overflow-y').parent().addClass('overflow-y');

      // Create new sticky table head (basic)
      $t.after('<table class="sticky-thead" />');

      // If <tbody> contains <th>, then we create sticky column and intersect (advanced)
      if($t.find('tbody th').length > 0) {
        $t.after('<table class="sticky-col" /><table class="sticky-intersect" />');
      }

      // Create shorthand for things
      var $stickyHead  = $(this).siblings('.sticky-thead'),
        $stickyCol   = $(this).siblings('.sticky-col'),
        $stickyInsct = $(this).siblings('.sticky-intersect'),
        $stickyWrap  = $(this).parent('.sticky-wrap');

      $stickyHead.append($thead);

      $stickyCol
      .append($col)
        .find('thead th:gt(0)').remove()
        .end()
        .find('tbody td').remove();

      $stickyInsct.html('<thead><tr><th>'+$t.find('thead th:first-child').html()+'</th></tr></thead>');
      
      // Set widths
      var setWidths = function () {
          $t
          .find('thead th').each(function (i) {
            $stickyHead.find('th').eq(i).width($(this).width());
          })
          .end()
          .find('tr').each(function (i) {
            $stickyCol.find('tr').eq(i).height($(this).height());
          });

          // Set width of sticky table head
          $stickyHead.width($t.width());

          // Set width of sticky table col
          $stickyCol.find('th').add($stickyInsct.find('th')).width($t.find('thead th').width())
        },
        repositionStickyHead = function () {
          // Return value of calculated allowance
          var allowance = calcAllowance();
        
          // Check if wrapper parent is overflowing along the y-axis
          if($t.height() > $stickyWrap.height()) {
            // If it is overflowing (advanced layout)
            // Position sticky header based on wrapper scrollTop()
            if($stickyWrap.scrollTop() > 0) {
              // When top of wrapping parent is out of view
              $stickyHead.add($stickyInsct).css({
                opacity: 1,
                top: $stickyWrap.scrollTop()
              });
            } else {
              // When top of wrapping parent is in view
              $stickyHead.add($stickyInsct).css({
                opacity: 0,
                top: 0
              });
            }
          } else {
            // If it is not overflowing (basic layout)
            // Position sticky header based on viewport scrollTop
            if($w.scrollTop() > $t.offset().top && $w.scrollTop() < $t.offset().top + $t.outerHeight() - allowance) {
              // When top of viewport is in the table itself
              $stickyHead.add($stickyInsct).css({
                opacity: 1,
                top: $w.scrollTop() - $t.offset().top
              });
            } else {
              // When top of viewport is above or below table
              $stickyHead.add($stickyInsct).css({
                opacity: 0,
                top: 0
              });
            }
          }
        },
        repositionStickyCol = function () {
          if($stickyWrap.scrollLeft() > 0) {
            // When left of wrapping parent is out of view
            $stickyCol.add($stickyInsct).css({
              opacity: 1,
              left: $stickyWrap.scrollLeft()
            });
          } else {
            // When left of wrapping parent is in view
            $stickyCol
            .css({ opacity: 0 })
            .add($stickyInsct).css({ left: 0 });
          }
        },
        calcAllowance = function () {
          var a = 0;
          // Calculate allowance
          $t.find('tbody tr:lt(3)').each(function () {
            a += $(this).height();
          });
          
          // Set fail safe limit (last three row might be too tall)
          // Set arbitrary limit at 0.25 of viewport height, or you can use an arbitrary pixel value
          if(a > $w.height()*0.25) {
            a = $w.height()*0.25;
          }
          
          // Add the height of sticky header
          a += $stickyHead.height();
          return a;
        };

      setWidths();

      $t.parent('.sticky-wrap').scroll($.throttle(250, function() {
        repositionStickyHead();
        repositionStickyCol();
      }));

      $w
      .load(setWidths)
      .resize($.debounce(250, function () {
        setWidths();
        repositionStickyHead();
        repositionStickyCol();
      }))
      .scroll($.throttle(250, repositionStickyHead));
    }
  });
// });
}

function textSeeMoreLess(){
  var showChar = 350;
  var ellipsestext = "...";
  // var moretext = '<%#=image_tag  image_url("index.png" , class: "title-part", :alt => "Title-Part")  ,:class=>"title-part ajR"%>';
  // var lesstext = moretext;
  var moretext = "See More";
  var lesstext = "See Less";

  $('.comments-space').each(function () {
      var content = $(this).html();
      if (content.length > showChar) {
          var show_content = content.substr(0, showChar);
          var hide_content = content.substr(showChar, content.length - showChar);
          var html = show_content + '<span class="moreelipses">' + ellipsestext + '</span><span class="remaining-content"><span>' + hide_content + '</span>&nbsp;&nbsp;<a href="" class="morelink" style="text-decoration:none;color: #0000ff;font-weight:400;">' + moretext + '</a></span>';
          $(this).html(html);
      }
  });

  $(".morelink").click(function () {
      if ($(this).hasClass("less")) {
          $(this).removeClass("less");
          $(this).html(moretext);
      } else {
          $(this).addClass("less");
          $(this).html(lesstext);
      }
      $(this).parent().prev().toggle();
      $(this).prev().toggle();
      return false;
  });
}