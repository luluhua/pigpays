<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include  file="../header.jsp"%>
<body>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg" style="margin:0;">
            <div class="wrapper wrapper-content">
    			<div class="row">
                    <div class="col-lg-5">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-success pull-right">今天</span>
                                <h5>交易金额</h5>
                            </div>
                            <div class="ibox-content">
                                
                                <div class="row">                                	
                                	<div class="col-md-4">
		                               	<h2 class="no-margins" id="toDayAmount"></h2>
                                		<div class="font-bold text-success" id="net"></div>
                                		<small>新增</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="successAmount"></h2>
		                               <div class="font-bold text-navy" id=paymentRatioToday></div>
		                               <small>已支付</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="notAmount"></h2>
		                               <div class="font-bold text-navy" id="notPaymentRatioToday"></div>
		                                <small>未支付</small>
		                           </div>
		                       </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-5">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-info pull-right">今天</span>
                                <h5>交易订单</h5>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                	<div class="col-md-4">
		                              	<h2 class="no-margins" id="toDayCount"></h2>
                                		<div class="font-bold text-success" id="theTotalRatio"></div>
                                		<small>新增</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="successCount"></h2>
		                               <div class="font-bold text-navy" id="completedRatio"> </div>
		                               <small>已完成</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="notCount"></h2>
		                               <div class="font-bold text-navy" id="failureRatio"> </div>
		                               <small>未完成</small>
		                           </div>
		                       </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-danger pull-right">今天</span>
                                <h5>商户</h5>
                            </div>
                            <div class="ibox-content">
                                <h2 class="no-margins" id="toDayAddMerchant"></h2>
                                <div class="font-bold text-danger" id="MerchantTotalRatio"></div>
                                <small>新增商户</small>
                            </div>
                        </div>
                    </div>
        		</div>
        		
        		<div class="row">
                    <div class="col-lg-5">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-primary pull-right">今天</span>
                                <h5>支付通道</h5>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                	<div class="col-md-4">
		                               <h2 class="no-margins" id="toDayAddChannel"></h2>
                                		<div class="font-bold text-success" id="ChannelsRatio"></div>
                                		<small>新增通道</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="alipayCount"></h2>
		                               <div class="font-bold text-navy" id="alipayCountRatio"></div>
		                               <small>支付宝</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="wechatCount"></h2>
		                               <div class="font-bold text-navy" id="wechatCountRatio"></div>
		                               <small>微信</small>
		                           </div>
		                       </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-5">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-primary pull-right">今天</span>
                                <h5>收款</h5>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                	<div class="col-md-4">
		                               <h2 class="no-margins" id="gatheringAmount"></h2>
                                		<div class="font-bold text-success" id="collectionRatio"></div>
                                		<small>收款总额</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="alipayReceipt"></h2>
                                		<div class="font-bold text-navy" id="alipayCollectionRatio"></div>
                                		<small>支付宝</small>
		                           </div>
		                           <div class="col-md-4">
		                               <h2 class="no-margins" id="wechatReceipt"></h2>
                                		<div class="font-bold text-navy" id="wechatCollectionRatio"></div>
                                		<small>微信</small>
		                           </div>
		                       </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <span class="label label-danger pull-right">今天</span>
                                <h5>用户</h5>
                            </div>
                            <div class="ibox-content">
                                <h2 class="no-margins" id="TodayAddUser"></h2>
                                <div class="font-bold text-danger" id="theNewRate"></div>
                                <small>新增用户</small>
                            </div>
                        </div>
                    </div>
        		</div>
        		
        		<div class="row">
		            <div class="col-lg-6">
		                <div class="ibox float-e-margins">
		                    <div class="ibox-title">
		                        <span class="label label-primary pull-right">总</span>
		                        <h5>交易报表</h5>
		                    </div>
		                    <div class="ibox-content">
		                        <div class="row">
		                            <div class="col-md-4 channel12">
		                                <h2 class="no-margins"><span class="totalTransAmtByTrans">0</span>/<span class="succeedTransAmtByTrans">0</span></h2>
		                                <div class="font-bold text-navy">交易金额</div>
		                            </div>
		                            <div class="col-md-4 channel12">
		                                <h2 class="no-margins"><span class="totalTransCountByTrans">0</span>/<span class="succeedTransCountByTrans">0</span></h2>
		                                <div class="font-bold text-navy">交易笔数</div>
		                            </div>
		                            <div class="col-md-4 channel12">
		                                <h2 class="no-margins"><span class="totalFeeByTrans">0</span>/<span class="succeedFeeByTrans">0</span></h2>
		                                <div class="font-bold text-navy">交易费率</small></div>
		                            </div>
		                        </div>
		                    </div>
		                </div>
		            </div>
		            <div class="col-lg-6">
	                <div class="ibox float-e-margins">
	                    <div class="ibox-title">
	                        <span class="label label-primary pull-right">总</span>
	                        <h5>渠道报表</h5>
	                    </div>
	                    <div class="ibox-content">
	                        <div class="row">
	                            <div class="col-md-4 channel12">
	                                <h2 class="no-margins"><span class="totalTransAmtByChannel">0</span>/<span class="succeedTransAmtByChannel">0</span></h2>
	                                <div class="font-bold text-navy">交易金额</div>
	                            </div>
	                            <div class="col-md-4 channel12">
	                                <h2 class="no-margins"><span class="totalCountByChannel">0</span>/<span class="succeedCountByChannel">0</span></h2>
	                                <div class="font-bold text-navy">交易笔数</div>
	                            </div>
	                            <div class="col-md-4 channel12">
	                                <h2 class="no-margins"><span class="totalFeeByChannel">0</span>/<span class="succeedFeeByChannel">0</span></h2>
	                                <div class="font-bold text-navy">交易费率</small></div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	        
	        <div class="row">
		            <div class="col-lg-6">
		                <div class="ibox float-e-margins">
		                    <div class="ibox-title">
		                        <span class="label label-primary pull-right">总</span>
		                        <h5>商户报表</h5>
		                    </div>
		                    <div class="ibox-content">
		                        <div class="row">
		                            <div class="col-md-4 channel12">
		                                <h2 class="no-margins"><span class="totalTransAmtByMch">0</span>/<span class="succeedTransAmtByMch">0</span></h2>
		                                <div class="font-bold text-navy">交易金额</div>
		                            </div>
		                            <div class="col-md-4 channel12">
		                                <h2 class="no-margins"><span class="totalTransCountByMch">0</span>/<span class="succeedTransCountByMch">0</span></h2>
		                                <div class="font-bold text-navy">交易笔数</div>
		                            </div>
		                            <div class="col-md-4 channel12">
		                                <h2 class="no-margins"><span class="totalFeeByMch">0</span>/<span class="succeedFeeByMch">0</span></h2>
		                                <div class="font-bold text-navy">交易费率</small></div>
		                            </div>
		                        </div>
		                    </div>
		                </div>
		            </div>
		            <div class="col-lg-6">
	                <div class="ibox float-e-margins">
	                    <div class="ibox-title">
	                        <span class="label label-primary pull-right">总</span>
	                        <h5>充值报表</h5>
	                    </div>
	                    <div class="ibox-content">
	                        <div class="row">
	                            <div class="col-md-4 channel12">
	                                <h2 class="no-margins"><span class="totalTransByRecharge">0</span>/<span class="succeedTransByRecharge">0</span></h2>
	                                <div class="font-bold text-navy">总金额</div>
	                            </div>
	                            <div class="col-md-4 channel12">
	                                <h2 class="no-margins"><span class="wxTotalAmtByRecharge">0</span>/<span class="wxSucceedAmtByRecharge">0</span></h2>
	                                <div class="font-bold text-navy">微信充值</div>
	                            </div>
	                            <div class="col-md-4 channel12">
	                                <h2 class="no-margins"><span class="zfbTotalAmtByRecharge">0</span>/<span class="zfbSucceedAmtByRecharge">0</span></h2>
	                                <div class="font-bold text-navy">支付宝充值</small></div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
        		
            </div>
        
        </div>
	</div>
<script src="${basePath }assets/js/jquery-2.1.1.js"></script>
<script src="${basePath}/assets/js/jquery.cookie.js"></script>
<%@ include  file="../scripts.jsp"%>
	<script>
	$(function() {
  			$.post(basePath+"admin/index/index", function(res){
  				$("#toDayAmount").html(res.todayAmount);
  				$("#net").html(res.totalRatio+'<i class="fa fa-bolt"></i>');
  				$("#successAmount").html(res.successAmount);
  				$("#paymentRatioToday").html(res.paymentRatioToday+'<i class="fa fa-level-up"></i>');
  				$("#notAmount").html(res.notAmount);
  				$("#notPaymentRatioToday").html(res.notPaymentRatioToday+'<i class="fa fa-level-up"></i>');
  				$("#toDayCount").html(res.todayCount);
  				$("#theTotalRatio").html(res.theTotalRatio+'<i class="fa fa-bolt"></i>');
  				$("#successCount").html(res.successCount);
  				$("#completedRatio").html(res.completedRatio+'<i class="fa fa-level-up"></i>');
  				$("#notCount").html(res.notCount);
  				$("#failureRatio").html(res.failureRatio+'<i class="fa fa-level-up"></i>');
  				$("#toDayAddMerchant").html(res.todayAddMerchant);
  				$("#MerchantTotalRatio").html(res.merchantTotalRatio+'<i class="fa fa-level-up"></i>');
  				$("#toDayAddChannel").html(res.todayAddChannel);
  				$("#ChannelsRatio").html(res.channelsRatio+'<i class="fa fa-bolt"></i>');
  				$("#wechatCount").html(res.wechatCount);
  				$("#wechatCountRatio").html(res.wechatCountRatio+'<i class="fa fa-level-up"></i>');
  				$("#alipayCount").html(res.alipayCount);
  				$("#alipayCountRatio").html(res.alipayCountRatio+'<i class="fa fa-level-up"></i>');
  				$("#gatheringAmount").html(res.successAmount);
  				$("#collectionRatio").html(res.collectionRatio+'<i class="fa fa-bolt"></i>');
  				$("#wechatReceipt").html(res.wechatReceipt);
  				$("#wechatCollectionRatio").html(res.wechatCollectionRatio+'<i class="fa fa-level-up"></i>');
  				$("#alipayReceipt").html(res.alipayReceipt);
  				$("#alipayCollectionRatio").html(res.alipayCollectionRatio+'<i class="fa fa-level-up"></i>');
  				$("#TodayAddUser").html(res.todayAddUser);
  				$("#theNewRate").html(res.theNewRate+'<i class="fa fa-level-up"></i>');
  				
  				$(".totalTransAmtByTrans").html(res.totalTransAmtByTrans);
  				$(".succeedTransAmtByTrans").html(res.succeedTransAmtByTrans);
  				$(".totalTransCountByTrans").html(res.totalTransCountByTrans);
  				$(".succeedTransCountByTrans").html(res.succeedTransCountByTrans);
  				$(".totalFeeByTrans").html(res.totalFeeByTrans);
  				$(".succeedFeeByTrans").html(res.succeedFeeByTrans);
  				
  				$(".totalTransAmtByChannel").html(res.totalTransAmtByChannel);
  				$(".succeedTransAmtByChannel").html(res.succeedTransAmtByChannel);
  				$(".totalCountByChannel").html(res.totalCountByChannel);
  				$(".succeedCountByChannel").html(res.succeedCountByChannel);
  				$(".totalFeeByChannel").html(res.totalFeeByChannel);
  				$(".succeedFeeByChannel").html(res.succeedFeeByChannel);
  				
  				$(".totalTransAmtByMch").html(res.totalTransAmtByMch);
  				$(".succeedTransAmtByMch").html(res.succeedTransAmtByMch);
  				$(".totalTransCountByMch").html(res.totalTransCountByMch);
  				$(".succeedTransCountByMch").html(res.succeedTransCountByMch);
  				$(".totalFeeByMch").html(res.totalFeeByMch);
  				$(".succeedFeeByMch").html(res.succeedFeeByMch);
  				
  				$(".wxTotalAmtByRecharge").html(res.wxTotalAmtByRecharge);
  				$(".wxSucceedAmtByRecharge").html(res.wxSucceedAmtByRecharge);
  				$(".zfbTotalAmtByRecharge").html(res.zfbTotalAmtByRecharge);
  				$(".zfbSucceedAmtByRecharge").html(res.zfbSucceedAmtByRecharge);
  				$(".totalTransByRecharge").html(res.totalTransByRecharge);
  				$(".succeedTransByRecharge").html(res.succeedTransByRecharge);
  				
			}); 
            	
            	
            	
			
			
		});
			
	</script>

</body>
</html>