

function zfetchStudentRecordForBatchz(that){

    var batchId=that.value;
    //alert(batchId);
     var urlLink="/cce_reports/getStudentRecordFromBatchId/";
    $("#studentListDivId").empty();

    $.ajax({
        url: urlLink ,
        //type:json
        cache: false,
        data:
        {
             batchId:batchId

         },
        success: function(data){

        	console.log(data);

        	var str='';
            for (var key in data.studentRecord) 
            {
                var d2 = data.studentRecord[key]
                studentName=d2.first_name;
                id=d2.id;
                str +=studentName+"<br/>"


                $("#studentListDivId").append("<a href='#' id="+id+" class='StudentId-cls'>"+studentName+"</a><br/>");
                str='';
            }

        }

    });


}


$(document).on("click",".zStudentId-clsz", function()
 {
 	var ID1 =$(this).attr('id');
 	var urlLink="/cce_reports/cce_report";
		$.ajax({
            url: urlLink ,
            cache: false,
            data:{studentId:ID1},
            success: function(html){  
                  $('#reportDivId').dialog({
                    modal: true,
                    title: "Student Report",
                    minWidth: 600,
                    minHeight: 500,
                    open: function () {
                        
                        $(this).html(html);
                    }
                }); 
               
            }
        });

});