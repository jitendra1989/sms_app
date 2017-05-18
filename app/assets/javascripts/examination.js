

 
$(document).on("click", ".grades-class", function(e){
        var urlLink = "/examination/add_grades/";
        var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                "batch_id":batchId
            },
            success: function(html){  
                    $('#examinationClassID').dialog({
                    modal: true,
                    title: "Add Student Grades",
                    // minWidth: 350,
                    // minHeight: 350,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

  
//  $(document).ready(function(){
//       $("#saveGrade").click(function(e){
// //$(document).on("click","#saveGrade",function(){
//     alert("inside on click sh");
//      var name=$("#grades_name").val();
//   var min_score=$("#grades_min_score").val();
//   var desc=$("#grades_description").val();
//   var credit_points=$("#grades_credit_points").val();
//       $.ajax({
//             url:"examination/add_new_grade/",
//             type: "GET",
//               data:{"name":name,"min_score":min_score,"description":desc,"credit_points":credit_points},
           
//             success:function(html){
//               alert("success");
//              // $("#").html(html);

//             },
//             error:function(){
//               alert("error");
//             }

//       });
//   });
   //    });
function myFunction(batchid){
    var urlLink = "/examination/show/";
       //
    
        $.ajax({
            url: urlLink ,
            data:{"mg_batch_id":batchid},
            cache: false,
            success: function(html){
                //alert("hii")
     
       
            if (html.name=="")
                {

            $("#tableID").empty();

            $("#tableID").append("<h5>Add Some Grades</h5>");

                }
                else
                {
            var str='<table class="batch-tbl" cellspacing="0" style="padding:0;width:100%;height:100%; border-collapse:collapse;"><tr class="subject-table-header" rowspan="2"><th>Grades</th><th>Description</th><th>Min Score</th><th>Credit Points</th><th>Actions</th></tr>';

            for (var key in html.name) 
            {
                var value=html.name[key];
                name=value.name;
                description=value.description;
                min_score=value.min_score;
                credit_points=value.credit_points;
                id=value.id
                str+='<tr><td class="mg-align-center">'+name+'</td><td style="max-width: 400px;">'+description+' </td><td class="mg-align-center">'+min_score+'</td><td class="mg-align-center">'+credit_points+'</td><td class="mg-align-center"><a href="#" id='+id+' class="edit-class"><button title="Edit" class="mg-text-exam mg-icon-btn mg-right-align"><i class="fa fa-pencil-square-o"></i></button></a><a href="#" id='+id+' class="delete-class"><button title="Delete" class="mg-text-exam mg-icon-btn"><i class="fa fa-trash"></i></button></a></td></tr>';

            }
            str +='</table>';

            $("#tableID").empty();
            $("#tableID").append(str);

        }
    }
                }); 
    };
               
           
       
$(document).on("click", ".edit-class", function(e){
        
        var Id=$(this).attr('id');
       
        //alert(urlLink);
        var urlLink = "/examination/edit/";
        $.ajax({
            url: urlLink ,
            cache: false,
            data:{"id":Id},
            success: function(html){  
                    $('#editClassID').dialog({
                    modal: true,
                    title: "Edit Student Grades",
                    minWidth: 300,
                    minHeight: 320,
                    // maxHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".delete-class", function(e){
    var Id =$(this).attr('id');

    // var splString = myID.split("-");
    var retVal = confirm("Are you sure to delete ?");
        if(retVal)
        {
            var urlLink = "/examination/destroy/";
            $.ajax({
            url: urlLink ,
            data:{"id":Id},
            cache: false,
            success: function(html)
            {
                window.location.reload();            
            }
            }); 

        }
         
});  


function myRankingFunction(courseid){
    var urlLink = "/examination/ranking_newdata/";
       
        $.ajax({
            url: urlLink ,
            data:{"mg_course_id":courseid},
            cache: false,
            success: function(html){
                //alert("hii")
            console.log(html);
            $("#examinationrankingCommonID").empty();
            $("#examinationrankingCommonID").append(html);
            $("#rankingData").show()
        }
                }); 
    };
$(document).on("click", ".ranking-edit-class", function(e){
    var myID =$(this).attr('id');
  

    // var splString = myID.split("-");
 
        
         var urlLink = "/examination/ranking_edit/";

          $.ajax({
            url: urlLink ,
            data:
            {
                 id:myID
             },
            cache: false,
            success: function(html){
                
            $("#examinationrankingCommonID").empty();
            $("#examinationrankingCommonID").append(html);
            $("#rankingData").show()
               //window.location.reload();
                           
            }
        }); 
});  


$(document).on("click", ".ranking-delete-class", function(e){
    var myID =$(this).val();
  
   

    // var splString = myID.split("-");
 
        
         var urlLink = "/examination/ranking_destroy/";
         if(confirm("Are you sure?")){
          $.ajax({
            url: urlLink ,
            data:
            {
                 id:myID
             },
            cache: false,
            success: function(html){
               window.location.reload();
                           
            }
        }); 
      }
      else{
        $(".ui-dialog-titlebar-close").click(); 
      }
});  


function myDesignationFunction(courseid){
    var urlLink = "/examination/designation_newData/";
      
        $.ajax({
            url: urlLink ,
            data:{"mg_course_id":courseid},
            cache: false,
            success: function(html){
                //alert("hii")
            console.log(html);
            $("#examinationDesignationID").empty();
            $("#examinationDesignationID").append(html);
            $("#rankingData").show()
        }
                }); 
    };

    $(document).on("click", ".designation-edit-class", function(e){
    var myID =$(this).attr('id');
    
   

    // var splString = myID.split("-");
 
        
         var urlLink = "/examination/designation_edit/";

          $.ajax({
            url: urlLink ,
            data:
            {
                 id:myID
             },
            cache: false,
            success: function(html){
              
            $("#examinationDesignationID").empty();
            $("#examinationDesignationID").append(html);
            //$("#rankingData").show()
               //window.location.reload();
                           
            }
        }); 
});  

    $(document).on("click", ".designation-delete-class", function(e){
    var myID =$(this).attr('id');
   

    // var splString = myID.split("-");
 
        
         var urlLink = "/examination/designation_destroy/";
         if(confirm("Are you sure?")){
          $.ajax({
            url: urlLink ,
            data:
            {
                 id:myID
             },
            cache: false,
            success: function(html){
               window.location.reload();
                           
            }
        }); 
        }else{
            $(".ui-dialog-titlebar-close").click(); 
        }
});  

    function myExamFunction(courseid){
    var urlLink = "/examination/exammanagement_new/";
     
        $.ajax({
            url: urlLink ,
            data:{"mg_course_id":courseid},
            cache: false,
            success: function(html){
                //alert("hii")
            console.log(html);
            $("#exammanagementID").empty();
            $("#exammanagementID").append(html);
            //$("#rankingData").show()
        }
                }); 
    };

//  $(document).on("click", ".exammination-new-class", function(e){
//     var myID =$(this).attr('id');
//     alert("hi");
//     alert(myID);

//     //var splString = myID.split("-");
 
        
//          var urlLink = "/examination/exammanagement_newLink/";

//           $.ajax({
//             url: urlLink ,
//             data:
//             {
//                  id:myID
//              },
//             cache: false,
//             success: function(html){

//                 $("#exammanagementID").empty();
//                 $("#exammanagementID").append(html);
            
//                //window.location.reload();
                           
//             }
//         }); 
// });  

function myExammanagementFunction(value){
   
    var urlLink = "/examination/exammanagement_addnewData/";
       
        $.ajax({
            url: urlLink ,
            
            cache: false,
            success: function(html){
                //alert("hii")
           // console.log(html);
             if (value=="grades0000")
                {
                    $("#test").hide();
                }
                else
                {
            $("#test").show();
        }
    
            //$("#examinationDesignationID").empty();
            //$("#examinationDesignationID").append(html);
            //$("#rankingData").show()
        }
    }); 
    }



function myAssaignFunction(courseid){
    var urlLink = "/examination/cceAssaignWeightages_new/";
        $.ajax({
            url: urlLink ,
            data:{"mg_course_id":courseid},
            cache: false,
            success: function(html){
                //alert("hii")
            //console.log(html);
            $("#examinationAssaignClassID").empty();
            $("#examinationAssaignClassID").append(html);
            
        }
                }); 
    };



    // function myAssaignFunction(courseid){
    // var urlLink = "/examination/cceAssaignWeightages_Edit/";
      
    //     $.ajax({
    //         url: urlLink ,
    //         data:{"mg_course_id":courseid},
    //         cache: false,
    //         success: function(html){
    //             //alert("hii")
    //         //console.log(html);
    //         $("#examinationAssaignClassID").empty();
    //         $("#examinationAssaignClassID").append(html);
            
    //     }
    //             }); 
    // };

function myCoCourseFunction(courseid){
    var urlLink = "/examination/Co_ScholasticCourseObservation_new/";
      
        $.ajax({
            url: urlLink ,
            data:{"mg_course_id":courseid},
            cache: false,
            success: function(html){
                //alert("hii")
            //console.log(html);
            $("#CoexaminationClassID").empty();
            $("#CoexaminationClassID").append(html);
            
        }
                }); 
    };
function myFaGroupsFunction(courseid){
    var urlLink = "/examination/ScholasticFaGroups_new/";
      
        $.ajax({
            url: urlLink ,
            data:{"mg_course_id":courseid},
            cache: false,
            success: function(html){
                //alert("hii")
            //console.log(html);
            $("#FaGroupsClassID").empty();
            $("#FaGroupsClassID").append(html);
            
        }
                }); 
    };


    function myFaGroupSubjectFunction(subjectid){
    var urlLink = "/examination/ScholasticFaGroups_newData/";
      
        $.ajax({
            url: urlLink ,
            data:{"mg_subject_id":subjectid},
            cache: false,
            success: function(html){
                //alert("hii")
            //console.log(html);
            $("#FaGroupsID").empty();
            $("#FaGroupsID").append(html);
            
        }
                }); 
    };


function myFaGroupsFunction(courseid){
    var urlLink = "/examination/ScholasticFaGroups_new/";
     
        $.ajax({
            url: urlLink ,
            data:{"mg_course_id":courseid},
            cache: false,
            success: function(html){
                //alert("hii")
            //console.log(html);
            $("#FaGroupsClassID").empty();
            $("#FaGroupsClassID").append(html);
            
        }
                }); 
    };



    $(document).on("click", ".grade-sets-data", function(e){
        var urlLink = "/examination/cceBasic_gradeSetsData/";
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            
            success: function(html){  
                    $('#gradeSetsData').dialog({
                    modal: true,
                    title: "New Grade Set",
                    minWidth: 250,
                    minHeight: 150,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
    $(document).on("click", ".cceGradesset-edit-class", function(e){
        var urlLink = "/examination/cceBasic_gradeSetsEditData/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#gradeEditSetsData').dialog({
                    modal: true,
                    title: "Edit Grade Set",
                    minWidth: 250,
                    minHeight: 150,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
    $(document).on("click", ".cceGradesset-delete-class", function(e){
        var urlLink = "/examination/cceBasic_gradeSetsDestroyData/";
        var myID =$(this).attr('id');
       if(confirm('Are you sure?')){
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
             window.location.reload();
            }
        });
       }
       else{
        $(".ui-dialog-titlebar-close").click();
       }
        //var batchId=$("#mg_batch_id").val();
});

  
    $(document).on("click", ".addGrade-sets-datas", function(e){
        var urlLink = "/examination/addGradeSet_newData/";
         var myID =$(this).attr('id');
      
        //var myID =$(this).attr('id');
        //alert(myID);
        //var batchId=$("#mg_batch_id").val();
 
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#addGrade_sets_newDatas').dialog({
                    modal: true,
                    title: "Add Grade",
                    minWidth: 250,
                    minHeight: 200,
                    
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".addGradeSet-edit-class", function(e){
        var urlLink = "/examination/addGradeSet_newDataEdit/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#addGrade_sets_newDatasEdit').dialog({
                    modal: true,
                    title: "Edit Grade",
                    minWidth: 250,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".addGradeSet-delete-class", function(e){
        var urlLink = "/examination/addGradeSet_newDataDestroy/";
        var myID =$(this).attr('id');
        if(confirm("Are you sure?")){
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                 window.location.reload();
            }
        });
        }else{
            $(".ui-dialog-titlebar-close").click(); 
        }
});
 $(document).on("click", ".cceExam-category-datas", function(e){
        var urlLink = "/examination/cceExamCategory_new/";
         //var myID =$(this).attr('id');
        //alert(myID);
        //var myID =$(this).attr('id');
        //alert(myID);
        //var batchId=$("#mg_batch_id").val();
 
        $.ajax({
            url: urlLink ,
            cache: false,
            // data:
            // {
            //      id:myID
            //  },
            success: function(html){  
                    $('#ccecategory_datas').dialog({
                    modal: true,
                    title: "New Academic Session",
                    minWidth: 250,
                    minHeight: 200,
                    maxHeight: 400,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 $(document).on("click", ".cceExamCategory-edit-class", function(e){
        var urlLink = "/examination/cceExamCategory_edit/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#cceExam_category_datasEdit').dialog({
                    modal: true,
                    title: "Edit Academic Session",
                    minWidth: 250,
                    minHeight: 200,
                    maxHeight: 400,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 $(document).on("click", ".cceExamCategory-delete-class", function(e){
        var urlLink = "/examination/cceExamCategory_destroy/";
        var myID =$(this).attr('id');
       
       if(confirm("Are you sure?")){
          $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                 window.location.reload();
            }
        });
       }
       else{
        $(".ui-dialog-titlebar-close").click();
       }
        //var batchId=$("#mg_batch_id").val();
      
});

 $(document).on("click", ".cce-Weightages-datas", function(e){
        var urlLink = "/examination/cceWeightages_new/";
         //var myID =$(this).attr('id');
        //alert(myID);
        //var myID =$(this).attr('id');
        //alert(myID);
        //var batchId=$("#mg_batch_id").val();
 
        $.ajax({
            url: urlLink ,
            cache: false,
            // data:
            // {
            //      id:myID
            //  },
            success: function(html){  
                    $('#cce_Weightages').dialog({
                    modal: true,
                    title: "New CCE Weightage",
                    minWidth: 250,
                    minHeight: 300,
                    
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 $(document).on("click", ".examCategory-edit-class", function(e){
        var urlLink = "/examination/cceWeightages_edit/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#cce_Weightages_edit').dialog({
                    modal: true,
                    title: "Edit CCE Weightages",
                    minWidth: 250,
                    minHeight: 300,

                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 $(document).on("click", ".examCategory-delete-class", function(e){
        var urlLink = "/examination/cceWeightages_destroy/";
        var myID =$(this).attr('id');
        if(confirm("Are you sure?")){
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                 window.location.reload();
            }
        });
    }
    else{
       $(".ui-dialog-titlebar-close").click(); 
    }
});

 $(document).on("click", ".Co-Scholastic-new-datas", function(e){
        var urlLink = "/examination/Co_Scholastic_newData/";
         //var myID =$(this).attr('id');
        //alert(myID);
        //var myID =$(this).attr('id');
        //alert(myID);
        //var batchId=$("#mg_batch_id").val();
 
        $.ajax({
            url: urlLink ,
            cache: false,
            // data:
            // {
            //      id:myID
            //  },
            success: function(html){  
                    $('#Co_Scholastic_datas').dialog({
                    modal: true,
                    title: "New Co-Scholastic Group",
                    minWidth: 250,
                    minHeight: 400,
                    maxHeight: 700,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 $(document).on("click", ".co-scholastic-edit-class", function(e){
        var urlLink = "/examination/Co_Scholastic_newDataEdit/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#Co_Scholastic_datasEdit').dialog({
                    modal: true,
                    title: "Edit Co-Scholastic Group",
                    minWidth: 250,
                    minHeight: 400,
                    maxHeight: 700,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".co-scholastic-delete-class", function(e){
        var urlLink = "/examination/Co_Scholastic_newDataDestroy/";
        var myID =$(this).attr('id');
       if(confirm("Are you sure?")){
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                     window.location.reload();
               
            }
        });
       }
       else{
        $(".ui-dialog-titlebar-close").click(); 
       }

        
});

 $(document).on("click", ".Co-Scholastic-new-datas", function(e){
        
         var myID =$(this).attr('id');
       
        var urlLink = "/examination/Co_Scholastic_criteriaNew/";
        //var myID =$(this).attr('id');
        //alert(myID);
        //var batchId=$("#mg_batch_id").val();
 
        $.ajax({
            url: urlLink ,
            cache: false,
             data:
             {
                 id:myID
              },
            success: function(html){  
                    $('#Co_Scholastic_sub_datas').dialog({
                    modal: true,
                    title: "New Coscholastic Criteria",
                    minWidth: 250,
                    minHeight: 200,
                    
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

 $(document).on("click", ".Co-Scholastic-sub-edit-class", function(e){
        var urlLink = "/examination/Co_Scholastic_criteriaEdit/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#Co_Scholastic_sub_datasEdit').dialog({
                    modal: true,
                    title: "Edit Coscholastic Criteria",
                    minWidth: 250,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
 $(document).on("click", ".Co-Scholastic-sub-delete-class", function(e){
        var urlLink = "/examination/Co_Scholastic_criteriaDestroy/";
        var myID =$(this).attr('id');
        if(confirm("Are you sure?")){
        
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                     window.location.reload();
               
            }
        });
    }
    else{
        $(".ui-dialog-titlebar-close").click(); 
    }
});
$(document).on("click", ".scholastics-settings-data", function(e){
      
         
        var urlLink = "/examination/scholastic_formativeAssessmentnewData/";
       
 
        $.ajax({
            url: urlLink ,
            cache: false,
             
            success: function(html){  
                    $('#assessment_group_id').dialog({
                    modal: true,
                    title: "New Formative Assessment",
                    minWidth: 250,
                    minHeight: 300,
                    
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".scholastic-edit-class", function(e){
        var urlLink = "/examination/scholastic_formativeAssessmentEdit/";
        var myID =$(this).attr('id');
        
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#assessment_group_newDatasEdit').dialog({
                    modal: true,
                    title: "Edit FA Group",
                    minWidth: 250,
                    minHeight: 300,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".scholastic-delete-class", function(e){
        var urlLink = "/examination/scholastic_formativeAssessmentDestroy/";
        var myID =$(this).attr('id');
      if(confirm("Are you sure?")){
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                     window.location.reload();
               
            }
        });
        }else{
            $(".ui-dialog-titlebar-close").click(); 
        }
});


$(document).on("click", ".Scholastic-new-datas", function(e){
        
         
        var urlLink = "/examination/scholastic_formativeCriteriaNew/";
       var myID =$(this).attr('id');
      
 
        $.ajax({
            url: urlLink ,
            cache: false,
              data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#Scholastic_sub_datas').dialog({
                    modal: true,
                    title: "New FA Criteria",
                    minWidth: 250,
                    minHeight: 200,
                    
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".Scholastics-sub-edit-class", function(e){
        var urlLink = "/examination/scholastic_formativeCriteriaEdit/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#Scholastic_sub_datasEdit').dialog({
                    modal: true,
                    title: "Edit FA Criteria",
                    minWidth: 250,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".Scholastics-sub-delete-class", function(e){
        var urlLink = "/examination/scholastic_formativeCriteriaDestroy/";
        var myID =$(this).attr('id');
        if(confirm("Are you sure?")){
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                     window.location.reload();
               
            }
        });
    }
    else{
        $(".ui-dialog-titlebar-close").click(); 
    }
});


$(document).on("click", ".Scholastic-indicator-datas", function(e){
        var urlLink = "/examination/scholastic_formativeIndicatorNewData/";
        var myID =$(this).attr('id');
     
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#indicator_group_id').dialog({
                    modal: true,
                    title: "New Descriptive Indicator",
                    minWidth: 250,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".Scholastics-indicator-edit-class", function(e){
        var urlLink = "/examination/scholastic_formativeIndicatorEdit/";
        var myID =$(this).attr('id');
        
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#indicator_group_newDatasEdit').dialog({
                    modal: true,
                    title: "Edit Descriptive Indicator",
                    minWidth: 250,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".Scholastics-indicator-delete-class", function(e){
        var urlLink = "/examination/scholastic_formativeIndicatorDestroy/";
        var myID =$(this).attr('id');
       if(confirm("Are you sure?")){
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                     window.location.reload();
               
            }
        });
    }
    else{
        $(".ui-dialog-titlebar-close").click(); 
    }
});


$(document).on("click", ".coScholastic-indicator-datas", function(e){
        var urlLink = "/examination/Co_Scholastic_newIndicatorNew/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  

                    $('#coIndicator_group_id').dialog({
                    modal: true,
                    title: "New Descriptive Indicator",
                    minWidth: 250,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});


$(document).on("click", ".coScholastics-indicator-edit-class", function(e){
        var urlLink = "/examination/Co_Scholastic_newIndicatorEdit/";
        var myID =$(this).attr('id');
        
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                    $('#coIndicator_group_newDatasEdit').dialog({
                    modal: true,
                    title: "Edit Descriptive Indicator",
                    minWidth: 250,
                    minHeight: 200,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});
$(document).on("click", ".coScholastics-indicator-delete-class", function(e){
        var urlLink = "/examination/Co_Scholastic_newIndicatorDestroy/";
        var myID =$(this).attr('id');
        if(confirm("Are you sure?")){

        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
                     window.location.reload();
               
            }
        });
        }else{
            $(".ui-dialog-titlebar-close").click(); 
        }
});
$(document).on("click", ".examinations-grade-class", function(e){
        var urlLink = "/examination/exammanagement_coScholasticGradeEntry/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
            $("#coscholastic_data_entry").empty();
            $("#coscholastic_data_entry").append(html);
             $(".exam-student-name-cls:first").click();
               
            }
        });
});

$(document).on("click", ".exammanagementGroups-new-datas", function(e){
        var urlLink = "/examination/exammanagement_examGroupsNew/";
        var myIDs =$(this).attr('id');
       var CurrentId=myIDs.split("-");

        var myID=CurrentId[0];
        var category_id=CurrentId[1];
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 "id":myID,
                 "CategoryId":category_id
             },
            success: function(html){  
            $('#exammanagementGroupsc_datas').dialog({
                    modal: true,
                    title: "New Exam",
                    minWidth: 250,
                    minHeight: 400,
                    maxHeight: 620,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
            }
        });
});

$(document).on("click", ".exammanagement-examGroups-edit-class", function(e){
        var urlLink = "/examination/exammanagement_examGroupsEdit/";
        var myIDs =$(this).attr('id');
        var CurrentId=myIDs.split("-");

        var myID=CurrentId[0];
        var category_id=CurrentId[1];
        
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                "id":myID,
                "category_id":category_id
             },
            success: function(html){  
                    $('#exammanagementGroupsc_datasEdit').dialog({
                    modal: true,
                    title: "Edit New Exam",
                    minWidth: 250,
                    minHeight: 400,
                    maxHeight: 620,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });
});

$(document).on("click", ".exammanagement-examGroups-delete-class", function(e){
        var urlLink = "/examination/exammanagement_examGroupsDestroy/";
        var myIDs =$(this).attr('id');
        if(confirm("Are you sure?")){
        //var batchId=$("#mg_batch_id").val();
        var CurrentId=myIDs.split("-");

        var myID=CurrentId[0];
        var category_id=CurrentId[1];
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 "id":myID,
                 "category_id":category_id
             },
            success: function(html){  
                     window.location.reload();
               
            }
        });
    }else{
        $(".ui-dialog-titlebar-close").click(); 
    }
});



$(document).on("click", "#full_course_all", function(e){

    var lb_checkboxValue=$(this).is(':checked');
    $(".connect-check-box-cls").prop('checked', false);
    $(".connect-input-cls").prop('disabled', true);

    if(lb_checkboxValue)
    {

        $(".connect-check-box-cls").prop('checked', true);
        $(".connect-input-cls").prop('disabled', false);
        
    }

});

$(document).on("click", ".connect-check-box-cls", function(e){

    var lb_checkboxValue=$(this).is(':checked');
    //$(".connect-check-box-cls").prop('checked', false);
    $(".connect-input-cls").prop('disabled', true);

    if(lb_checkboxValue)
    {

        //$(".connect-check-box-cls").prop('checked', true);
        $(".connect-input-cls").prop('disabled', false);
        
    }



});


function setGradeFromMarks(marksObj){
    var marks = marksObj.value;
   
    if(marks!=""){

       var batchId=$("#examResultEntryBatchId").val(); 
       //alert("Shr "+batchId);

       var urlLink="/examination/setGradeFromMarks/";

       $.ajax({
            url: urlLink ,
            //type:json
            cache: false,
            data:
            {
                 marks:marks,
                 batchId:batchId

             },
            success: function(data){  
                
                     console.log(data.gradeLevelId);
               //$(this).parent().next().next().firstChild().val(data.gradeLevel);
               //console.log($(this).parent().next().next().html());
               $(marksObj).parent().next().next().children()[0].value =data.gradeLevel;
               $(marksObj).parent().next().next().children()[1].value =data.gradeLevelId;
               //$(marksObj).parent().next().next().next().children()[0].value =data.gradeLevelId;
                //console.log($(this).parent().next().next().next().children().html());

            }
        });
    }
    
}


$(document).on("click", ".Exam-Fa-Class", function(e){
        var urlLink = "/examination/exammanagement_resultEntryShow/";
        var myID =$(this).attr('id');
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
            $("#coscholastic_Fa_data_entry").empty();
            $("#coscholastic_Fa_data_entry").append(html);

            $(".exam-Fa-student-name-cls:first").click();


               
            }
        });
});


$(document).on("click", ".exam-Fa-student-name-cls", function(e){
        var urlLink = "/examination/exammanagement_resultEntryShow/";
        var myID =$(this).attr('id');
        var studentName=$(this).text();

        var CurrentId=myID;
        CurrentId=CurrentId.split("-");

        var studentID=CurrentId[4];
        
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  
            $("#coscholastic_Fa_data_entry").empty();
            $("#coscholastic_Fa_data_entry").append(html);

            $("#mgFaStudentID").val(studentID);
            $("#studentFaNameDivId").empty();
            $("#studentFaNameDivId").append(studentName);

           // $(".exam-Fa-student-name-cls:first").click();


               
            }
        });
});

$(document).on("click", ".exam-student-name-cls", function(e){
        var urlLink = "/examination/exammanagement_coScholasticGradeEntry/";
        var myID =$(this).attr('id');
        var studentName=$(this).text();

        var CurrentId=myID;
        CurrentId=CurrentId.split("-");

        var studentID=CurrentId[2];
        
       
        //var batchId=$("#mg_batch_id").val();
        $.ajax({
            url: urlLink ,
            cache: false,
            data:
            {
                 id:myID
             },
            success: function(html){  

            $("#coscholastic_data_entry").empty();
            $("#coscholastic_data_entry").append(html);

            $("#mgStudentID").val(studentID);
            $("#studentNameDivId").empty();
            $("#studentNameDivId").append(studentName);
         
           // $(".exam-Fa-student-name-cls:first").click();


               
            }
        });
});


function minFromMidnight(tm){
  if(tm==''){
    return;
  }else{
  var ampm= tm.substr(-2)
   var clk = tm.substr(0, 4);
   var m  = parseInt(clk.match(/\d+$/)[0], 10);
   var h  = parseInt(clk.match(/^\d+/)[0], 10);
   h += (ampm.match(/pm/i))? 12: 0;
   return h*60+m;
  }

}


