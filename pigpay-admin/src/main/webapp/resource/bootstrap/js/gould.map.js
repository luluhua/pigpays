//定义地图
map = new AMap.Map("map",{
	 center:[116.39,39.9],
     zoom:11
});

//搜索关键词
AMap.plugin(['AMap.Autocomplete','AMap.PlaceSearch'],function(){
    autocomplete= new AMap.Autocomplete({ 
    	input: "searchbox",
    	citylimit: true
    });	 //输入下拉列表提示
    placeSearch = new AMap.PlaceSearch({   //构造地点查询类
    	pageSize: 1,
    	pageIndex: 1,
    	extensions: "all",
        citylimit: true
    });
    var distr = "";
    AMap.event.addListener(autocomplete, "select", function(e){
    	distr = e.poi.district;
    });
    //点击查询关键词
    $("#searchmap").click(function(){
    	var searchbox = $("#searchbox").val();
        if( searchbox != ""){
        	placeSearch.search(searchbox, function(status, result) {
        		if (status === 'complete' && result.info === 'OK') {
        			if( distr != ""){
        	    		jus = distr + searchbox;
        	    	}else{
        	    		jus = $("#ProvinceKey option:selected").text() + $("#CityKey option:selected").text() + result.poiList.pois[0].adname + searchbox;
        	    	}
        			tagging(jus,result.poiList.pois[0].location);
			    }else{
			    	getAlert(1,"搜索不到地址！","###");
			    	return false;
			    }
    		});
        }else{
        	getAlert(1,"搜索框不能为空！","###");
        	return false;
        }  
    });
});

//加载解析地址插件
AMap.service('AMap.Geocoder',function(){
	//定义解析地址
    geocoder = new AMap.Geocoder({
        extensions: "all",
        radius: 1000,
    });
    //地图点击事件
    map.on('click',function(e){	
    	//解析逆地址
		geocoder.getAddress(e.lnglat,function(status,result){
			if(status=='complete' && result.info === 'OK'){
				var porder ="";
				if( result.regeocode.addressComponent.city == ""){
					if( result.regeocode.addressComponent.province == "澳門特別行政區"){
						porder = "澳门特别行政区";
					}else if( result.regeocode.addressComponent.province == "香港特別行政區"){
						porder = "香港特别行政区";
					}else{
						porder = result.regeocode.addressComponent.province;
					}
				}else{
					if($("#ProvinceKey").size()>0){
						porder = result.regeocode.addressComponent.province + result.regeocode.addressComponent.city;
					}else{
						porder = result.regeocode.addressComponent.city;
					}
				}
				$("#mapCity").val(porder);
				tagging(result.regeocode.formattedAddress,e.lnglat,porder);	
			}else{
				alert("搜索不到地址");
				return false;
			}			
	    });
    });
});

//自定义地址id
function address(id){
	addressid = id;
}

function tagging(address,lnglat){
	map.clearMap();
	//定义窗口
    var infoWindow = new AMap.InfoWindow({
        content: address,
        offset: {x: 0, y: -30}
    });
    //定义标注点
    var marker = new AMap.Marker({
        map:map,
        bubble:true
    });
    //在地图加上窗口信息
    infoWindow.open(map,lnglat);
    //在地图加上标注点
    marker.setPosition(lnglat);
    //平移动画到地图中心
    map.panTo(lnglat);
    
    $(addressid).val(address);
    $("#locationLng").val(lnglat.lng); 
    $("#locationLat").val(lnglat.lat); 
}