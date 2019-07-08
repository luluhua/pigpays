
function getQX(url){
	var identification = $('#identification').val();
	if(!identification){
		return;
	}

	$.ajax( {
		url : url+'/jurisdiction/getQX?identification='+identification,
		type : 'get',
		cache : false,
		async : false,
		success : function(data) {
			$.each($('body [mark]'),function(i,n){
				var bool = true;
				var mark = $(this).attr('mark');
				if(mark){
					if(data){
					$.each(data,function(i,value){
							if(value == mark){
								bool = false;
							}
						});
					}
					
					if(bool){
						if($(this).prop("tagName")=="A"){
							$(this).prop("href","#");
							$(this).attr("onclick","javascript:void(0);");
							$(this).attr("data-toggle","");
						   
						}else if($(this).prop("tagName")=="BUTTON"||$(this).prop("tagName")=="INPUT"||$(this).prop("tagName")=="SELECT"){
							
							$(this).prop('disabled','disabled');
						}
						$(this).css("cursor","not-allowed");
					}
				}
				
		    	});
			}
	});
}
