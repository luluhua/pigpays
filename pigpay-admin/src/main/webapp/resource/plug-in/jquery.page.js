//分页插件
/**
2014-08-05 ch
**/
(function($){
	var ms = {
		init:function(obj,args){
			return (function(){
				ms.fillHtml(obj,args);
				ms.bindEvent(obj,args);
			})();
		},
		//填充html
		fillHtml:function(obj,args){
			return (function(){
				obj.empty();
				
				var current = parseInt(args.current);
				var pageCount = parseInt(args.pageCount);
				//上一页
				if(current > 1){
					obj.append('<a href="javascript:;" class="prevPage">上一页</a>');
				}else{
					obj.remove('.prevPage');
					obj.append('<span class="disabled">上一页</span>');
				}
				//中间页码
				if(current != 1 && current >= 4 && pageCount != 4){
					obj.append('<a href="javascript:;" class="tcdNumber">'+1+'</a>');
				}
				if(current-2 > 2 && current <= pageCount && pageCount > 5){
					obj.append('<span class="xlhao">...</span>');
				}
				var start = current -2,end = current+2;
				if((start > 1 && current) < 4|| current == 1){
					end++;
				}
				if(current > (pageCount-4) && current >= pageCount){
					start--;
				}
				for (;start <= end; start++) {
					if(start <= pageCount && start >= 1){
						if(start != current){
							obj.append('<a href="javascript:;" class="tcdNumber">'+ start +'</a>');
						}else{
							obj.append('<span class="current">'+ start +'</span>');
						}
					}
				}
				if(current + 2 < pageCount - 1 && current >= 1 && pageCount > 5){
					obj.append('<span class="xlhao">...</span>');
				}
				if(current != pageCount && current < pageCount -2  && pageCount != 4){
					if( end != pageCount){
						obj.append('<a href="javascript:;" class="tcdNumber">'+pageCount+'</a>');
					}
				}
				//下一页
				if(current < pageCount){
					obj.append('<a href="javascript:;" class="nextPage">下一页</a>');
				}else{
					obj.remove('.nextPage');
					obj.append('<span class="disabled">下一页</span>');
				}
			})();
		},
		//绑定事件
		bindEvent:function(obj,args){
			return (function(){
				  obj.off('click',"a.tcdNumber");
				  obj.off('click',"a.prevPage");
				  obj.off('click',"a.nextPage");
				obj.on("click","a.tcdNumber",function(){
					var current = parseInt($(this).text());
					ms.fillHtml(obj,{"current":current,"pageCount":args.pageCount});
					if(typeof(args.backFn)=="function"){
						args.backFn(current);
					}
				});
				//上一页
				obj.on("click","a.prevPage",function(){
					var current = parseInt(obj.children("span.current").text());
					ms.fillHtml(obj,{"current":current-1,"pageCount":args.pageCount});
					if(typeof(args.backFn)=="function"){
						args.backFn(current-1);
					}
				});
				//下一页
				obj.on("click","a.nextPage",function(){
					var current = parseInt(obj.children("span.current").text());
					ms.fillHtml(obj,{"current":current+1,"pageCount":args.pageCount});
					if(typeof(args.backFn)=="function"){
						args.backFn(current+1);
					}
				}
				
				);
			})();
		}
	}
	$.fn.createPage = function(options){
		var args = $.extend({
			pageCount : 10,
			current : 1,
			backFn : function(){}
		},options);
		ms.init(this,args);
	}
})(jQuery);