/**
 * lxg
 * 
 * 2016-08-15
 * 
 * 动态加载CSS,JS文件
 */
function loadjscssfile(filename,filetype){

    if(filetype == "js"){
        var fileref = document.createElement('script');
        fileref.setAttribute("type","text/javascript");
        fileref.setAttribute("src",filename);
    }else if(filetype == "css"){
    
        var fileref = document.createElement('link');
        fileref.setAttribute("rel","stylesheet");
        fileref.setAttribute("type","text/css");
        fileref.setAttribute("href",filename);
    }
   if(typeof fileref != "undefined"){
        document.getElementsByTagName("head")[0].appendChild(fileref);
    }
}


//获取当前地址路径
function loadurl(){
   var url = window.location.pathname;
   //截取.后面的内容
   newurl = url.substring(url.indexOf("."),url.length);
   
   if(newurl == ".jsp"){
	   loadjscssfile("resource/bootstrap/css/bootstrap.min.css","css");
	   loadjscssfile("resource/bootstrap/css/bootstrap-responsive.css","css");
	   loadjscssfile("resource/bootstrap/css/style.css","css");

	   //js框架和公共效果
	   loadjscssfile("resource/bootstrap/js/jquery.min.js","js");
	   loadjscssfile("resource/bootstrap/js/bootstrap.min.js","js");

	   //jQuery Validate插件
	   loadjscssfile("resource/jquery-validate/js/jquery.validate.min.js","js");
	   loadjscssfile("resource/jquery-validate/js/messages_zh.js","js");
	   loadjscssfile("resource/jquery-validate/js/custom.validation.js","js");
	   loadjscssfile("resource/jquery-validate/css/validation.css","css");

	   //My97日期时间插件
	   loadjscssfile("resource/My97DatePicker/WdatePicker.js","js");
	   loadjscssfile("resource/My97DatePicker/lang/zh-cn.js","js");

	   //图片上传插件
	   loadjscssfile("resource/uploadify/uploadify.css","css");
	   loadjscssfile("resource/uploadify/jquery.uploadify-3.1.min.js","js");
	   loadjscssfile("resource/uploadify/prompt.js","js");
   }
   else{
	   loadjscssfile("../resource/bootstrap/css/bootstrap.min.css","css");
	   loadjscssfile("../resource/bootstrap/css/bootstrap-responsive.css","css");
	   loadjscssfile("../resource/bootstrap/css/style.css","css");

	   //js框架和公共效果
	   loadjscssfile("../resource/bootstrap/js/jquery.min.js","js");
	   loadjscssfile("../resource/bootstrap/js/bootstrap.min.js","js");

	   //jQuery Validate插件
	   loadjscssfile("../resource/jquery-validate/js/jquery.validate.min.js","js");
	   loadjscssfile("../resource/jquery-validate/js/messages_zh.js","js");
	   loadjscssfile("../resource/jquery-validate/js/custom.validation.js","js");
	   loadjscssfile("../resource/jquery-validate/css/validation.css","css");

	   //My97日期时间插件
	   loadjscssfile("../resource/My97DatePicker/WdatePicker.js","js");
	   loadjscssfile("../resource/My97DatePicker/lang/zh-cn.js","js");

	   //图片上传插件
	   loadjscssfile("../resource/uploadify/uploadify.css","css");
	   loadjscssfile("../resource/uploadify/jquery.uploadify-3.1.min.js","js");
	   loadjscssfile("../resource/uploadify/prompt.js","js");
   }
}


loadurl();

