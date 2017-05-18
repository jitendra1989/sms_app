$(document).on("click", "#checkAllCheckBoxInCurriculumId", function(e){

        $(".auto-ckeckbox-fee-particular-batch-cls").prop('checked', true);
        e.preventDefault();
        
  });

  $(document).on("click", "#unCheckAllCheckBoxInCurriculumId", function(e){

        $(".auto-ckeckbox-fee-particular-batch-cls").prop('checked', false);
        e.preventDefault();
  });

function myBatchSubjectFunction(batchid){
    var urlLink = "/curriculum/batchsubject_new/";
      
        $.ajax({
            url: urlLink ,
            data:{"mg_batch_id":batchid},
            cache: false,
            success: function(html){
                //alert("hii")
            //console.log(html);
            $("#BatchClassID").empty();
            $("#BatchClassID").append(html);
            
        }
                }); 
    };

    function myBatchSubjectsFunction(subjectid){
    var urlLink = "/curriculum/batchsubject_syllabus";
       
        $.ajax({
            url: urlLink ,
            data:{"mg_subjects_id":subjectid},
            cache: false,
            success: function(html){
               
                //alert("hii")
            //console.log(html);
            $("#SubjectID").empty();
            $("#SubjectID").append(html);
            
        }
                }); 
    };

    function mySubjectFunction(subjectid){
    var urlLink = "/curriculum/student_syllabus";
      
        $.ajax({
            url: urlLink ,
            data:{"mg_subjects_id":subjectid},
            cache: false,
            success: function(html){
               
                //alert("hii")
            //console.log(html);
            $("#TopicClassID").empty();
            $("#TopicClassID").append(html);
            
        }
                }); 
    };

    function myEmployeeSubjectFunction(employeeid){
    var urlLink = "/curriculum/employee_subject";
       
        $.ajax({
            url: urlLink ,
            data:{"mg_employee_id":employeeid},
            cache: false,
            success: function(html){
               
                //alert("hii")
            //console.log(html);
            $("#EmployeeClassID").empty();
            $("#EmployeeClassID").append(html);
            
        }
                }); 
    };


    function myEmployeeTopicFunction(subjectid){
    var urlLink = "/curriculum/employee_topic";
      
        $.ajax({
            url: urlLink ,
            data:{"mg_subjects_id":subjectid},
            cache: false,
            success: function(html){
               
                //alert("hii")
            //console.log(html);
            $("#EmploTopicID").empty();
            $("#EmploTopicID").append(html);
            
        }
                }); 
    };
    
   
    