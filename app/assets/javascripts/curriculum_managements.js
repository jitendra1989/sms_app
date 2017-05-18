

function myBatchSubjectFunction(batchid){
    var urlLink = "/curriculum_managements/batchsubject_new/";
       alert(batchid);
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
    var urlLink = "/curriculum_managements/batchsubject_syllabus";
       alert(subjectid);
        $.ajax({
            url: urlLink ,
            data:{"mg_subjects_id":subjectid},
            cache: false,
            success: function(html){
                alert("success");
                //alert("hii")
            //console.log(html);
            $("#SubjectID").empty();
            $("#SubjectID").append(html);
            
        }
                }); 
    };

    function mySubjectFunction(subjectid){
    var urlLink = "/curriculum_managements/student_syllabus";
       alert(subjectid);
        $.ajax({
            url: urlLink ,
            data:{"mg_subjects_id":subjectid},
            cache: false,
            success: function(html){
                alert("success");
                //alert("hii")
            //console.log(html);
            $("#TopicClassID").empty();
            $("#TopicClassID").append(html);
            
        }
                }); 
    };

    function myEmployeeSubjectFunction(employeeid){
    var urlLink = "/curriculum_managements/employee_subject";
       alert(employeeid);
        $.ajax({
            url: urlLink ,
            data:{"mg_employee_id":employeeid},
            cache: false,
            success: function(html){
                alert("success");
                //alert("hii")
            //console.log(html);
            $("#EmployeeClassID").empty();
            $("#EmployeeClassID").append(html);
            
        }
                }); 
    };


    function myEmployeeTopicFunction(subjectid){
    var urlLink = "/curriculum_managements/employee_topic";
       alert(subjectid);
        $.ajax({
            url: urlLink ,
            data:{"mg_subjects_id":subjectid},
            cache: false,
            success: function(html){
                alert("successtopic");
                //alert("hii")
            //console.log(html);
            $("#EmploTopicID").empty();
            $("#EmploTopicID").append(html);
            
        }
                }); 
    };
    
   
    