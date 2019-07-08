$(document).ready(function(){
	//cookie记录当前页
	pageNumItem = getCookie('pageNumItem');
	if(pageNumItem==undefined || pageNumItem=="undefined" || pageNumItem==''){
		pageNumItem = 1;
	}
});
//cookie页面之间传值
function getCookie(cname){
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++){
    var c = ca[i].trim();
    if (c.indexOf(name)==0) return unescape(c.substring(name.length,c.length));
  }
  return "";
}
function setCookie(cname,cvalue,exdays){
	var d = new Date();
	d.setTime(d.getTime()+(exdays*24*60*60*1000));
	var expires = "expires="+d.toGMTString();
	document.cookie = cname+"="+escape(cvalue)+"; "+expires;
}

//免费入驻合作城市点击效果和常见问题页面查看合作城市点击效果
$(document).ready(function(){ 
  $(".register-wenzi2").click(function(){
      $(".register-hz").show();
  });
  $(".register-x").click(function(){
      $(".register-hz").hide();
  });
});

//头部商家下载APP的箭头效果
$(document).ready(function(){ 
  $(".head-appa").hover(function(){
      $(".head-appa .gg-caret").toggleClass('gg-caret1');
  });
});

//头部账号的箭头效果
$(document).ready(function(){ 
  $(".head-appa1").hover(function(){
      $(".head-appa1 .gg-caret").toggleClass('gg-caret1');
  });
});

//登录页面手机号码 change事件判断手机格式效果
$(document).ready(function(){ 
  $("#login_username").change(function(){
    var mobile = $("#login_username").val();
    if(!/^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\d{8}$/i.test(mobile))
    {
      $(".login-gs").show();  //错就出现文字提示
    }else{
      $(".login-gs").hide();  //对就隐藏文字提示
    }
  });
});

//左侧菜单当前高亮和二级下拉菜单效果
$(document).ready(function(){ 
  $(".sidebar > li > a.sidebar-bt").click(function(){
    $(this).addClass("selected").parents().siblings().find(".sidebar-bt").removeClass("selected");
    $(".sidebar-none li").removeClass("sidebar-back");
    $(".sidebar-none li a").removeClass("sidebar-cull");
    $(this).next().find("li:first-child a").toggleClass("sidebar-cull");
    $(this).parents().siblings().find(".sidebar-none").slideUp(600);
    $(this).siblings(".sidebar-none").slideDown(600);    
    $(this).siblings().find("li").eq(1).addClass("sidebar-back");
  });
  $(".sidebar-none > li > a").click(function(){
    $(this).addClass("sidebar-cull").parents().siblings().find("a").removeClass("sidebar-cull");
    $(".sidebar-none li").removeClass("sidebar-back");
    $(this).parent().next().addClass("sidebar-back");
  });
});

//菜单管理页面的当前高亮和二级下拉菜单效果
$(document).ready(function(){ 
  $(".menu-navig .menu-yj").click(function(){
    $('.menu-yj').removeClass('menu-dq');
    $('.menu-navig .menu-ej a').removeClass('menu-cull');
    $(this).addClass("menu-dq");
    $(this).siblings('.menu-ej').slideToggle(600);
  });
  $(".menu-navig .menu-ej a").click(function(){
    $(this).addClass("menu-cull").parents().siblings().find("a").removeClass("menu-cull");
  });
});

//tad切换效果
$(document).ready(function(){ 
  $("#myTab a").click(function(e) {
    e.preventDefault();//阻止a链接的跳转行为
    $(this).tab('show');//显示当前选中的链接及关联的content
  });
});

//问号提示效果
$(document).ready(function(){ 
  $('[data-toggle="tooltip"]').tooltip();
});


//阻止a链接的跳转行为
$(document).ready(function(){ 
  $(".bs-docs-container [href=#]").click(function(a){
    a.preventDefault();//阻止a链接的跳转行为
  });
});

//菜单管理页面的点击左侧菜单把右侧内容显示出来
$(document).ready(function(){ 
  $('.menu-navig').click(function(){
    $('.menu-ma').show();
  });
});


// 项目单品提交mask
function por_mask(){
  $('.psub-mask').hide();
  $('.psub-mok').show();
  setTimeout(function(){
    window.location = "project-myproject.html";
  },10000);
}

$(document).ready(function() { 
  
  //文字向上轮播
  setInterval(function(){
    $('#txtUp').find('ul').animate({marginTop: '-30px'}, 500, function() { 
    $(this).css({ marginTop: '0px' }).find('li:first').appendTo(this);}); 
  }, 5000);


  // 下拉列表
  $('.sd-lia a').click(function(){
    $(this).parents('.slide-date').find('.sdl-html').val($(this).html());
  });
  $('#labelHide').click(function(){$('.activity-map').hide();});
  // 添加删除元素
  
  $(document).on("click",".add-td",function(){
	  
      var a = $(this).parents('.project-parent-tr').index();
        if($(this).parents('.project-parent-tr').find('input')[0].value!="" && $(this).parents('.project-parent-tr').find('input')[1].value!="" && $(this).parents('.project-parent-tr').find('input')[2].value!="" && $(this).parents('.project-parent-tr').find('input')[3].value!=""){
          $('.no-check').hide();
          $('.project-parent-tr').eq(a-1).clone(true)
            .find('input.pptd-inp1').attr({
                "id":'smalProductName',
                "name":'smalProductName'
              }).val("").end()
            .find('input.pptd-inp2').attr({
                "id":'smalProductQty',
                "name":'smalProductQty'
              }).val("").end()
            .find('input.pptd-inp3').attr({
                "id":'smalProductUnit',
                "name":'smalProductUnit'
              }).val("").end()
            .find('input.pptd-inp4').attr({
                "id":'smalProductPrice',
                "name":'smalProductPrice'
              }).val("").end()
	        .find('td:first-child').text($('.project-parent-tr').length+1).end()
            .appendTo($(this).parents('.table'));
          	$(this).parents('.project-parent-tr').find('.del-td').css('visibility','visible');
            $(this).removeClass().addClass('disable-bbb');
            
        }else{
          $('.no-check').show();
        }
    }); 
  $(document).on("click",".del-td",function(){ 
	  	var aFnextAll = $(this).parents('.project-parent-tr').nextAll('.project-parent-tr');//当前删除元素的后面tr的个数
	    var aFAll = $('.project-parent-tr').length-aFnextAll.length;//当前的数值
	    for (var i = 0; i < aFnextAll.length; i++) {
	      aFnextAll.eq(i).find('td:first-child').text(i+aFAll).end()
	      	.find('input.pptd-inp1').attr({
	      		 	"id":'smalProductName',
	                "name":'smalProductName'
		      	}).end()
	      	.find('input.pptd-inp2').attr({
		      		"id":'smalProductQty',
	                "name":'smalProductQty'
		      	}).end()
	      	.find('input.pptd-inp3').attr({
		      		"id":'smalProductUnit',
		      		"name":'smalProductUnit'
		      	}).end()
	      	.find('input.pptd-inp4').attr({
		      		"id":'smalProductPrice',
		      		"name":'smalProductPrice'
		      	});
	    };
	    if($(this).parents('tr').siblings().length !== 1){
	      $(this).parents('.project-parent-tr').remove();
	    }
	});

  // 文字省略
  var tHs = $('.text-hiding');
  for (var i = 0; i < tHs.length; i++) {
    textHiding(tHs[i]);
  }
  function textHiding(tH){
    tH.innerHTML = tH.innerHTML.substr(0,38) + '...';
  }

  // 套餐详细信息2
  //用餐人数
  $('.paq-num').hide();
  $('.pa-quantity .gg-input').click(function(){
    $('.paq-num').hide();
    $(this).addClass('paq-curr').siblings().removeClass('paq-curr');
  });
  $('#customNum').click(function(){
    $('.paq-num').show();
    $('.paq-num').focus();
  });
  $('.paq-num').click(function(){
    $('#customNum').addClass('paq-curr');
    $(this).removeClass('paq-curr');
    $(this).show();
    $(this).focus();
  });

  // 加减数量
  $('.pat-3r').click(function(){
    $(this).prev().val($(this).prev().val()*1 + 1);
  });
  $('.pat-3l').click(function(){
    if($(this).next().val() == 0){
      $(this).next().val()==0;
    }else{
      $(this).next().val($(this).next().val()*1 - 1);
    }
  });

  // 删除
  $('.pat-del').click(function(){
    if($(this).parents('tr').siblings().length > 2){
      $(this).parent().remove();
    }
  });

  // 排序
  $('.pat-up').click(function(){
    if($(this).parents('tr').index() !== 1){
      $(this).parents('tr').prev().before($(this).parents('tr'));
    }
  });
  $('.pat-down').click(function(){
    if($(this).parents('tr').index() !== ($(this).parents('tr').siblings().length-1)){
      $(this).parents('tr').next().after($(this).parents('tr'));
    }
  });

  // 我的商铺添加电话号码
   $('.shops-tjia').click(function(){
    var a = $('.tel-del-fa').length;
    if(a == 0){
      var createDiv = $("<div class='tel-del-fa'><a href='#' class='tel-del'></a><div/>");
      createDiv.css("padding-top","58px");
      createDiv.prepend($(this).parent().siblings().clone());
      $(this).parent().before(createDiv);
      $('.tel-del').click(function(){
        $(this).parent().remove();
        $('#shopsAdd').css("visibility","visible");
      });
    }else if(a == 1){
      $(this).parent().before($(this).parent().siblings('div.tel-del-fa').clone(true).css("padding-top","20px"));
      $('.tel-del').click(function(){
        $(this).parent().remove();
        $('div.tel-del-fa').css("padding-top","58px");
        $('#shopsAdd').css("visibility","visible");
      });
      $(this).parent().css("visibility","hidden");
    }
  });
   
   

  // 单品套餐日期添加删除  
  $('.date-add').click(function(){
    var a = $(this).parent().index();
    if(a == 1){
      var dateDel = $("<a href='javascript:;' class='date-del'>删除</a>");   
      $(this).parent().after($(this).parent().clone(true).append(dateDel));
    }else{
      $(this).parent().after($(this).parent().clone(true));
    }
    $('.date-del').click(function(){
      $(this).parent().remove();
    });
  });

  // 活动发布活动-活动详情/行程详情添加删除
  $('.act-add').click(function(){
    if($('.add-textarea2').length == 0 && $('.add-textarea1').css('display') == 'none'){
      $('.add-textarea1').css('display','block');
    }else{
      $('.add-textarea').before($("<div class='add-textarea2'></div>"));
      $('.add-textarea1').eq(0).clone(true).find('textarea').attr("placeholder","请输入行程详情~（最多限制200字）").end().css('display','block').appendTo('.add-textarea2:last'); 
    } 
  });
  $('.act-del').click(function(){
    $(this).parents('.add-textarea2').remove();
    $(this).parents('.add-textarea1').css('display','none');
  });

  // 活动发布活动-活动详情--添加删除
  $('.act-added').click(function(){
    actAddClick();
  });
  $('.act-added1').click(function(){
    actAddClick();
  });
  function actAddClick(){
    var actAdd = $('.activity-flow').eq(1).clone(true);
    actAdd.find('div:first').text($('.activity-flow').length+1).end().css('display','block');
    $('.activity-flow:last').after(actAdd);
  }
  $('.act-dele').click(function(){ 
    var aFnextAll = $(this).parents('.activity-flow').nextAll('.activity-flow');
    var aFAll = $('.activity-flow').length-aFnextAll.length;
    for (var i = 0; i < aFnextAll.length; i++) {
      aFnextAll.eq(i).find('div:first').text(i+aFAll);
    };
    $(this).parents('.activity-flow').remove();
  });

  
  // 证件审核下拉列表隐藏文本域
  $('#state').change(function(){
    if($(this).val()==2){
      $('#shnone').show();
    }else{
      $('#shnone').hide();
    }
    if($(this).val()==1){
        $('#zengsognjf').show();
      }else{
        $('#zengsognjf').hide();
      }
  });



});


/* 点击显示 */
$(document).ready(function(){
	$(".merchant-profit").hide();

});

//发布活动选择
$(document).ready(function(){
  $(".myactivity-tab table tbody tr").click(function(){
    $(this).find("input:radio").prop("checked",true);
  });
});

//编辑攻略详情
var shop_id = 0;
function shdaD(){
  shop_id++;
  $(".bjgl_xinazeng").append('<div class="shop_con shop-delete" id="shop_'+shop_id+'"><div class="shop-content  bj-content"><input type="text" value="" name="" class="shop_title" placeholder="请输入标题" /><div class="bj-xq-ul shlb-shop" contenteditable="true"></div></div><div class="bj-raiders-ul shop_trigger clearfix"><button type="button" name="">插入图片</button><a class="shop_increase" onclick="shopID()">新增</a><a href="#" class="bj-red bj-delete">删除</a></div></div>');
};

//tad切换高亮
$(document).ready(function(){ 
  $('.wdhd_qh li').click(function(){
    $(this).addClass('active').siblings('li').removeClass('active');
  });
});

//删除
$(document).ready(function(){
  $(document).on("click",".bj-delete",function(){
    $(this).parents('.shop-delete').remove();
  });
});


//0812项目页面改动
$(document).ready(function(){
  $('.sorp1').click(function(){
    $('.pack-show').hide();
  });
  
  $('.sorp2').click(function(){
    $('.pack-show').show();
  });
  // 发布项目页面显示隐藏
  $('.project-released').eq(0).addClass('project-curr');
  //  上一步按钮
  $('.project-a1').hide();
  $('.project-a1').click(function(){
	  $('.w-auto').parent().scrollTop(0);
	  $('.produ').show();
	  if($(".project-curr").index()==2){
		  $('.project-a1').hide();
	    }
    $('.project-curr').prev('.project-released').addClass('project-curr').end().removeClass('project-curr');
    $('.single1').removeClass().addClass('single1 single'+($(".project-curr").index()));
    $('.single1 span').removeClass('sfff').eq($('.project-curr').index()-1).addClass('sfff');
  });
  //  下一步按钮
  $('.project-a').click(function(){
	  $('.w-auto').parent().scrollTop(0);
    $('.project-a1').show();
    $(this).parents('.project-released').removeClass('project-curr');
    $('.project-released').eq(1).addClass('project-curr');
    $('.single1').removeClass().addClass('single1 single'+($(".project-curr").index()));
    $('.single1 span').removeClass('sfff').eq($('.project-curr').index()-1).addClass('sfff');
    if($(".project-curr").index()==3){
        $('.project-submit').hide();
      }
    //编辑动态获取数据的时候，文本框的禁用与赋值
    $(".project-disable input[type='radio']:checked").siblings("input[type='text']").css("background","#fff");
    $(".project-disable input[type='radio']:checked").parent().siblings().find("input[type='text']").attr("readonly",true);
  });
  $('.project-a3').click(function(){
	  	$('.w-auto').parent().scrollTop(0);
	    $('.project-a1').show();
	    $('.produ').hide();
	    $(this).parents('.project-released').removeClass('project-curr');
	    $('.project-released').eq(3).addClass('project-curr');
	    $('.single1').removeClass().addClass('single1 single'+($(".project-curr").index()));
	    $('.single1 span').removeClass('sfff').eq($('.project-curr').index()-1).addClass('sfff');
	    if($(".project-curr").index()==3){
	        $('.project-submit').hide();
	      }
	    //编辑动态获取数据的时候，文本框的禁用与赋值
	    $(".project-disable input[type='radio']:checked").siblings("input[type='text']").css("background","#fff");
	    $(".project-disable input[type='radio']:checked").parent().siblings().find("input[type='text']").attr("readonly",true);
	  });
   //  下一步按钮
  $('.project-aa').click(function(){
	  $('.w-auto').parent().scrollTop(0);
    $('.project-a1').show();
    $(this).parents('.project-released').removeClass('project-curr').next('.project-released').addClass('project-curr');
    $('.single1').removeClass().addClass('single1 single'+($(".project-curr").index()));
    $('.single1 span').removeClass('sfff').eq($('.project-curr').index()-1).addClass('sfff');
    if($(".project-curr").index()==3){
        $('.project-submit').hide();
      }
    //编辑动态获取数据的时候，文本框的禁用与赋值
    $(".project-disable input[type='radio']:checked").siblings("input[type='text']").css("background","#fff");
    $(".project-disable input[type='radio']:checked").parent().siblings().find("input[type='text']").attr("readonly",true);
  });
   //  下一步按钮
  $('.project-abtn').click(function(){
	  $('.w-auto').parent().scrollTop(0);
      $('.project-header').hide();
      $('.project-information').hide();
      $('.project-submit').show();
  });
  
  //  标题文字背景变化
  $('.psub-link a').click(function(){
	  if($(this).index()==0){
		  $('.project-a1').hide();
	  }
	  if($(this).index() == 3){
		  $('.produ').hide();
	  }else{
		  $('.produ').show();
	  }
    $('.project-released').eq($(this).index()).addClass('project-curr').siblings('.project-released').removeClass('project-curr');
    $('.single1').removeClass().addClass('single1 single'+($(".project-curr").index()));
    $('.single1 span').removeClass('sfff').eq($('.project-curr').index()-1).addClass('sfff');
    $('.project-header').show();
    $('.project-button').show();
    $('.project-information').show();
    $('.project-submit').hide();
    
  });
  // 活动设置更改
  $('.trip-pic-close').click(function(){
    $(this).parent().remove();
  });
  
  //发布项目赋值与禁用
  var projectDisableVal = "";
  $(".project-disable input[type='radio']:checked").siblings("input[type='text']").css("background","#fff");
  $(".project-disable input[type='radio']:checked").parent().siblings().find("input[type='text']").attr("readonly",true).val(projectDisableVal);
  $(".project-disable input[type='radio']").click(function(){
    $(this).attr("checked","checked").siblings("input[type='text']").css("background","#fff");
    $(this).siblings().attr("readonly",false);
    $(this).parent().siblings().find("input[type='text']").attr("readonly",true).val(projectDisableVal).css("background","#f0f0f0");
  });
  //点击文本框选择单选按钮，获取焦点
  $(".project-disable input[type='text']").click(function(){
    $(this).parent().find("input[type='radio']").click();
  });
  
  //发布产品-民宿-商家服务 复选框
  $(".product_ject .project_checkbox label").click(function(){
	  if( $(this).find("input[type='checkbox']").is(':checked') == true){
		  $(this).find("input[type='text']").css("background-color","#fff");
	  }else{
		  $(this).find("input[type='text']").val("").css("background-color","#f0f0f0");
	  }
  });
  $(".project_checkbox input[type='text']").click(function(){
	  $(this).siblings("input[type='text']").css("background-color","#fff");
	  $(this).siblings("input[type='checkbox']").prop("checked",true);
  });
  $(".product_ject .project_radio label").click(function(){
	  $(this).parents(".project_radio").find("input[type='text'],select").css("background-color","#f0f0f0");
	  $(this).find("input[type='text'],select").css("background-color","#fff");
  });
  $(".project_radio input[type='text'],.project_radio select").click(function(){
	  $(this).parents(".project_radio").find("input[type='text'],select").css("background-color","#f0f0f0");
	  $(this).siblings("input[type='radio']").prop("checked",true);
	  $(this).siblings("input[type='text'],select").css("background-color","#fff");
  });
  
  
  //活动详情---上一步按钮  
  $('.activity-travel-prev').click(function(){
	  $('.activity-travel').hide();
	  $('.activity-released').show();
  });
  //攻略维护编辑---下一步按钮
  $('.strategy-edit-next').click(function(){
	  $('.strategy-edit').css('display','none');
	  $('.strategy-details').show();
  });
  //攻略维护编辑---上一步按钮
  $('.strategy-details-prev').click(function(){
	  $('.strategy-edit').css('display','block');
	  $('.strategy-details').hide();
  });
  //攻略维护编辑---新增按钮
  $('.strategy-add-btn').click(function(){
	  $('.strategy-add').css('display','block');
	  $(".text_wenzi").text("新增攻略详情");
  });
  //攻略维护编辑---新增--关闭按钮
  $('.strategy-add-close').click(function(){
	  $('.strategy-add').css('display','none');
  });
  
  //模态框滚动条位置
  $("[data-dismiss='modal']").click(function(){
	  if($('.shlb-shop').length!=0){
		  $('.shlb-shop').scrollTop(0);
	  }
	  if($('.sph375').length!=0){
		  $('.sph375').scrollTop(0);
	  }
	  if($('textarea').length!=0){
		  $('textarea').scrollTop(0);
	  }
  });
  
});


//帐号管理更换手机页面
$(document).ready(function(){ 
  $(".accountsPhone").click(function(){
    $(this).parents(".accounts").css("display","none").siblings().css("display","block");
  });
});

//点击指定的属性把 display-po类添加或删除css样式
$(document).on("click","[data-toggle='modal']",function(){
  var id = $(this).attr("data-target");
  $(id).css("display","block");
  $(".display-po").css("display","block");
  $(".user_hideqdian").css("display","block");
});
$(document).on("click","[data-dismiss='modal']",function(){
  $(".display-po").css("display","none");
  $(".contain-dck-ma").css("display","none");
  $(".modal-dialog").css("display","none");
  $(".user_hidetshi").css("display","none");
  $(".modal-backdrop").remove();
});

//弹出框提示, flag标志  0:成功 1:错误警告； msg:提示的内容；url:点击确定后刷新页面的地址
function getAlert(flag, msg, url){
	//0：成功弹框   灰色出弹框  有标题 有确定按钮  有链接  没取消按钮
	if(parseInt(flag) == 0){
		$('body').append('<div id="popupMain"><div class="gg-dck-ma popup_ceten"><div class="gg-wenzi"><div class="gg_back gg-dck-fse"></div><p id="popupHuise" class="popup_input">'+msg+'</p></div><div class="gg-lingj"><a id="succOk" href="#" class="popup_close">确定</a></div></div></div>');
		//给A标签更换地址，点击确定后立即刷新页面
		if(url != undefined && url != ""){
			$("#succOk").attr("href",url); 
		}
	}
	//2：红色弹出框  有标题 有确定按钮  有取消按钮  没链接
	else if(parseInt(flag) == 2){
		$('body').append('<div id="popupMain"><div class="gg-dck-ma popup_ceten"><div class="gg-wenzi"><div class="gg_back gg-dck-hongse"></div><p id="popupHongse" class="popup_input">'+msg+'</p></div><div class="gg-lingj"><a href="#" class="popup_close">确定</a><a href="#" class="popup_close">取消</a></div></div></div>');
	}
	//3：红色弹出框 有标题 有链接 有确定按钮  有取消按钮
	else if( parseInt(flag) == 3 ){
		$('body').append('<div id="popupMain"><div class="contain-dck-ma gg-dck-ma popup_ceten"><div class="gg-wenzi"><div class="gg_back gg-dck-hongse"></div><p id="popupHongse"  class="popup_input">'+msg+'</p></div><div class="gg-lingj"><a href="'+url+'" class="popup_close">确定</a><a href="#" class="popup_close">取消</a></div></div></div>');
	}
	//4:确定触发onclick事件   url= noclick里的方法     红色弹出框  有标题  有确定按钮   有取消按钮  有onclick事件
	else if( parseInt(flag) == 4 ){
		$('body').append('<div id="popupMain"><div class="contain-dck-ma gg-dck-ma popup_ceten"><div class="gg-wenzi"><div class="gg_back gg-dck-hongse"></div><p id="popupHongse"  class="popup_input">'+msg+'</p></div><div class="gg-lingj"><a onclick="'+url+'" class="popup_close" id="cityAjax">确定</a><a href="#" class="popup_close">取消</a></div></div></div>');
	}
	//5: 灰色弹出框  有标题  有确定按钮   没取消按钮  有onclick事件   有关闭全部弹出框效果
	else if( parseInt(flag) == 5 ){
		$('body').append('<div id="popupMain"><div class="gg-dck-ma popup_ceten"><div class="gg-wenzi"><div class="gg_back gg-dck-fse"></div><p id="popupHuise" class="popup_input">'+msg+'</p></div><div class="gg-lingj"><a id="succOk" onclick="'+url+'" class="popup_close" data-dismiss="modal">确定</a></div></div></div>');
	}
	//1：失败、警告弹框  红色弹出框 有标题  有确定按钮 没取消按钮 没链接
	else{
		$('body').append('<div id="popupMain"><div class="gg-dck-ma popup_ceten"><div class="gg-wenzi"><div class="gg_back gg-dck-hongse"></div><p id="popupHongse" class="popup_input">'+msg+'</p></div><div class="gg-lingj"><a href="#" class="popup_close" id="succOk">确定</a></div></div></div>');
		if(url != undefined && url != ""){
			$("#succOk").attr("href",url); 
		}
	} 
};

//删除id=popupMain 弹出的模态框
$(document).on("click",".popup_close",function(){
	$('#popupMain').remove();
	$('.popupgong').hide();
});

//popupgong类的模态框
$(document).on("click",".getmtak",function(){
	$('.popupgong').show();
});

$(document).ready(function(){ 
	//提现审批的全选
	$("#withCheckId").click(function() {
		 var isChecked = $(this).prop("checked");
		 $("input[name='checkWith']").prop("checked", isChecked);
	});
	
	//主题管理的全选
	$("#checkSuje").click(function() {
		var isChecked = $(this).prop("checked");
		$("input[name='checkMan']").prop("checked", isChecked);
	});
	
	//判断审核下拉框     2==审核失败
	$('.sh_select').change(function(){
		if( $(this).val() == 2 ){
			$('.sh_hide').show();
		}
		else{
			$('.sh_hide').hide();
		}
	});
	
	$('.sh_select0').change(function(){
		if( $(this).val() == 0 ){
			$('.sh_hide').show();
		}
		else{
			$('.sh_hide').hide();
		}
	});
	//推广申请input整数限制
	$('.positive-integer').blur(function () {
		var nuM = /^[1-9]\d{0,8}$/;
	    if (!(nuM.test(this.value))) {
	        $('.positive-integer-red').show();
	    }else{
	    	$('.positive-integer-red').hide();
	    }
	});
	//验证管理-消费验证文本框四位空格
	$("#OredeState,.index-blyj input,.inquiries-input").keyup(function () {
	    //如果输入非数字，则替换为''，如果输入数字，则在每4位之后添加一个空格分隔
	    this.value = this.value.replace(/[^\d]/g, '').replace(/(\d{4})(?=\d)/g, "$1 ").substring(0,17);
	});
	
});

//判断容器宽度是否大于容器里的文字宽度 删除鼠标当前类的title属性  例子：系统维护下的APP反馈反馈信息
$(document).on("mouseover",".scrollWidth",function(){
	var width = parseFloat($(this)[0].style.width);
	if ( width > this.scrollWidth){
		$(this).removeAttr("title");
	}
});

$(document).ready(function(){ 
	indexRight();
	scrollWidth($(".scrollWidth"));
});
window.onresize =function(){
	indexRight();
	scrollWidth($(".scrollWidth"));
};

//表格省略号 .scrollWidth内容溢出宽度
function scrollWidth(pItem){
	var id = pItem;
	for(var i=0;i<id.length;i++){
		$(id[i]).width($(id[i]).parents('table').parent().width()*($(id[i]).parents('table').find('th').eq($(id[i]).parent().index())[0].width.replace('%', '')-1) / 100);
	}
}

//验证管理-消费验证公告   目前商家后台 PC:1.1 版本 不需要这个效果
function indexRight(){
	//var mar_right = $('.index-right').width() + 11;
	//$('.contain-index').css("margin-right",mar_right);
}


/**
 * 设置未来(全局)的AJAX请求默认选项
 * 主要设置了AJAX请求遇到Session过期的情况
 */
$.ajaxSetup({
 
  complete: function(xhr,status) {
    var sessionStatus = xhr.getResponseHeader('sessionstatus');
    if(sessionStatus == 'timeout') {
    //  var top = getTopWinow();
  
      var url = xhr.getResponseHeader("contextPath");
      getAlert(3,"由于您长时间没有操作, 登录已过期, 请重新登录.","javascript:loadLogin('"+url+"')");
     // $("#succOk").attr("target","_parent");
     /* var yes = confirm('由于您长时间没有操作, session已过期, 请重新登录.');
      if (yes) {
        win.location.href = xhr.getResponseHeader("contextPath");
        
      }*/
    }
  }
});

function loadLogin(url){
	var win = window;
    while (win != win.top){
    win = win.top;
    }
    win.location.href = url;
}

//财务报表 年月份搜索效果
$(function(){
	$(".finradio").click(function(){
		var index = $(this).index();
		$(this).find("input:radio").prop("checked", true);
		$(".finan input").val("").css("display","none").removeClass("cull").eq(index).css("display","block").addClass("cull");
	});
});

//兼容ie9以下的input placeholder属性
$(function(){
	if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/7./i)=="7."){
		 $('input[type="text"], textarea').placeholder();
	}else if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/8./i)=="8."){
		 $('input[type="text"], textarea').placeholder();
	}else if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/9./i)=="9."){
		 $('input[type="text"], textarea').placeholder();
	}
});