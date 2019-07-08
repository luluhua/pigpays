//通过省ID加载市ID
function loadCity(obj){
	//市
	var city = '<option value="直辖区" selected="selected">直辖区</option>';
	$("#CityKey").empty(); //先清空
	$("#CityKey").append(city);//在追加
	//区
	var CountyKey = '<option value="" selected="selected">请选择区域</option>'
	//如果是直辖市就设置市的值固定为直辖市
	if(obj.value == '110000'){ //北京
		CountyKey += loadArea("110100");
		$("#CountyKey").empty();	
		$("#CountyKey").append(CountyKey);
	}else if(obj.value == '120000'){//天津
		CountyKey += loadArea("120100");
		$("#CountyKey").empty();	
		$("#CountyKey").append(CountyKey);
	}else if(obj.value == '310000'){//上海
		CountyKey += loadArea("310100");
		$("#CountyKey").empty();	
		$("#CountyKey").append(CountyKey);
	}else if(obj.value == '500000'){//重庆
		CountyKey += loadArea("500100");
		$("#CountyKey").empty();	
		$("#CountyKey").append(CountyKey);
	}else{
		city = '<option value="" selected="selected">请选择城市</option>';
		city += loadArea(obj.value);
		$("#CityKey").empty(); //先清空
		$("#CityKey").append(city);//在追加
	}
}
//通过市ID找到区ID
function loadCounty(obj){
	var County = '<option value="" selected="selected">请选择区域</option>';
	County += loadArea(obj.value);
	$("#CountyKey").empty(); //先清空
	$("#CountyKey").append(County);//在追加
}
//匹配国内电话号码(0511-4405222 或 021-87888822)   
function istell(str) {  
    var result = str.match(/\d{3}-\d{8}|\d{4}-\d{7}/);  
    if (result == null) return false;  
    return true;  
}  
//匹配身份证(15位或18位)   
function isidcard(str) {  
    var result = str.match(/\d{15}|\d{18}/);  
    if (result == null) return false;  
    return true;  
}  
//移动电话  
function checkMobile(str) {  
    if (!(/^1[3|5|8][0-9]\d{4,8}$/.test(str))) {  
        return false;  
    }  
    return true;  
}  
// 判断输入是否是一个由 0-9 / A-Z / a-z 组成的字符串   
function isalphanumber(str) {  
    var result = str.match(/^[a-zA-Z0-9]+$/);  
    if (result == null) return false;  
    return true;  
}  
// 判断输入是否是有效的电子邮件   
function isemail(str) {  
    var result = str.match(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/);  
    if (result == null) return false;  
    return true;  
}  
