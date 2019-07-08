package com.yy.flashpay.web.admin;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.flashpay.service.ICollectAccountChannelService;
import com.yy.flashpay.service.ICollectAccountService;
import com.yy.flashpay.service.IMerchantService;
import com.yy.flashpay.service.IOrderService;
import com.yy.flashpay.service.IReportChannelService;
import com.yy.flashpay.service.IReportRechargeService;
import com.yy.flashpay.service.IReportTransMchService;
import com.yy.flashpay.service.IReportTransService;
import com.yy.flashpay.service.ISysConfigService;
import com.yy.flashpay.service.IUserService;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.util.RegExp;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping("/admin/index")
public class IndexController extends BaseController{
	private Logger logger = Logger.getLogger(MerchantController.class);
	@Autowired
	private IMerchantService merchantService;
	
	
	@Autowired
	private ISysConfigService sysConfigService;
	
	@Autowired
	private IOrderService orderService;
	
	@Autowired
	private IUserService userService;
	
	@Autowired
	private ICollectAccountChannelService p2AccountChannelService;
	
	@Autowired
	private IReportTransService reportTransService;
	
	@Autowired
	private IReportChannelService reportChannelService;
	
	@Autowired
	private IReportTransMchService reportTransMchService;
	
	@Autowired
	private IReportRechargeService reportRechargeService;
	
	@RequestMapping("/index")
	public String index() {
		return "backend/index/index";
	}
	

	@RequestMapping(value = "index", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object>  dealSum(HttpServletRequest request, HttpServletResponse response,Model model){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			 Map transactionAmount = orderService.getTradeStatistic();
			 BigDecimal totalAmount = (BigDecimal) transactionAmount.get("totalAmount");  //交易总额
			 BigDecimal todayAmount = (BigDecimal) transactionAmount.get("todayAmount");  //今天交易总额
			 BigDecimal successAmount = (BigDecimal) transactionAmount.get("successAmount");  //今天成功总额
			 BigDecimal notAmount = (BigDecimal) transactionAmount.get("notAmount");         // 今天失败总额
			 String  totalRatio = RegExp.getMoneyRate(todayAmount, totalAmount);  //交易总额比率
			 String paymentRatioToday = RegExp.getMoneyRate(successAmount, todayAmount); // 今天成功比率
			 String notPaymentRatioToday = RegExp.getMoneyRate(notAmount, todayAmount);  //今天失败比率
			 
			 BigDecimal totalCount = (BigDecimal) transactionAmount.get("totalCount"); //全部订单数
			 BigDecimal todayCount = (BigDecimal) transactionAmount.get("todayCount");  //今天新增数
			 BigDecimal successCount = (BigDecimal) transactionAmount.get("successCount");  //已完成数
			 BigDecimal notCount  = (BigDecimal) transactionAmount.get("notCount"); //失败数
			 String theTotalRatio = RegExp.getQuantityRate(todayCount, totalCount);         // 交易订单比率
			 String completedRatio = RegExp.getQuantityRate(successCount, todayCount);      //今天成功比率
			 String failureRatio = RegExp.getQuantityRate(notCount, todayCount);            //今天失败比率
			 
			 
			 Map merchant = merchantService.getThoseBusinesses();       //商户
			 BigDecimal totalMerchant = (BigDecimal) merchant.get("totalCount");   //全部商户
			 BigDecimal todayAddMerchant = (BigDecimal) merchant.get("todayCount");  //今天新增数
		     String merchantTotalRatio = RegExp.getQuantityRate(todayAddMerchant, totalMerchant);  //新增比率
		     
		     
		     Map user = userService.getUserStatistics();    //用户
		     BigDecimal totalUser = (BigDecimal) user.get("totalCount");  //全部用户
		     BigDecimal todayAddUser = (BigDecimal) user.get("todayCount");  //今天新增
		     String theNewRate = RegExp.getQuantityRate(todayAddUser, totalUser);   //新增比率
		     
		     BigDecimal wechatReceipt = (BigDecimal) transactionAmount.get("wechatReceipt");  //微信收款
		     BigDecimal alipayReceipt = (BigDecimal) transactionAmount.get("alipayReceipt");  //支付宝收款
		     String collectionRatio = RegExp.getMoneyRate(successAmount, totalAmount); //  收款比率
		     String wechatCollectionRatio = RegExp.getMoneyRate(wechatReceipt, successAmount); //  微信收款比率
		     String alipayCollectionRatio = RegExp.getMoneyRate(alipayReceipt, successAmount); //  支付宝收款比率
			    
		     
		     Map  aymentChannels = p2AccountChannelService.getChannelStatistics(); 
		     BigDecimal totalChannel = (BigDecimal) aymentChannels.get("totalCount");  //全部通道
		     BigDecimal todayAddChannel = (BigDecimal) aymentChannels.get("todayCount");  //新增
		     BigDecimal wechatCount = (BigDecimal) aymentChannels.get("wechatCount");  //微信
		     BigDecimal alipayCount = (BigDecimal) aymentChannels.get("alipayCount");  //支付宝
		     String channelsRatio = RegExp.getQuantityRate(todayAddChannel, totalChannel); //  新增比率
		     String wechatCountRatio = RegExp.getQuantityRate(wechatCount, todayAddChannel); //  微信比率
		     String alipayCountRatio = RegExp.getQuantityRate(alipayCount, todayAddChannel); //  支付宝比率
		      
		     Map reportTrans = reportTransService.getTransStatistics();
		     if(reportTrans==null) {
		    	 	map.put("totalTransAmtByTrans", "0" );
				    map.put("succeedTransAmtByTrans", "0");
				    map.put("totalTransCountByTrans", "0");
				    map.put("succeedTransCountByTrans","0");
				    map.put("totalFeeByTrans","0");
				    map.put("succeedFeeByTrans","0");
		     }else {
		    	 BigDecimal totalTransAmtByTrans = (BigDecimal) reportTrans.get("totalTransAmt"); 
			     BigDecimal succeedTransAmtByTrans = (BigDecimal) reportTrans.get("succeedTransAmt"); 
			     BigDecimal totalTransCountByTrans = (BigDecimal) reportTrans.get("totalTransCount"); 
			     BigDecimal succeedTransCountByTrans = (BigDecimal) reportTrans.get("succeedTransCount"); 
			     BigDecimal totalFeeByTrans = (BigDecimal) reportTrans.get("totalFee"); 
			     BigDecimal succeedFeeByTrans = (BigDecimal) reportTrans.get("succeedFee"); 
			     	map.put("totalTransAmtByTrans", totalTransAmtByTrans );
				    map.put("succeedTransAmtByTrans", succeedTransAmtByTrans);
				    map.put("totalTransCountByTrans", totalTransCountByTrans);
				    map.put("succeedTransCountByTrans",succeedTransCountByTrans);
				    map.put("totalFeeByTrans",totalFeeByTrans);
				    map.put("succeedFeeByTrans",succeedFeeByTrans);
		     }
		     Map reportChannel = reportChannelService.getChannelStatistics();
		     if(reportChannel==null) {
		    	 	map.put("totalTransAmtByChannel", "0" );
				    map.put("succeedTransAmtByChannel", "0");
				    map.put("succeedCountByChannel", "0");
				    map.put("succeedTransCountByTrans","0");
				    map.put("totalFeeByChannel","0");
				    map.put("succeedFeeByChannel","0");
		     }else {
		    	 BigDecimal totalTransAmtByChannel = (BigDecimal) reportChannel.get("totalTransAmt"); 
			     BigDecimal succeedTransAmtByChannel = (BigDecimal) reportChannel.get("succeedTransAmt"); 
			     BigDecimal totalCountByChannel = (BigDecimal) reportChannel.get("totalCount"); 
			     BigDecimal succeedCountByChannel = (BigDecimal) reportChannel.get("succeedCount"); 
			     BigDecimal totalFeeByChannel = (BigDecimal) reportChannel.get("totalFee"); 
			     BigDecimal succeedFeeByChannel = (BigDecimal) reportChannel.get("succeedFee"); 
			     	map.put("totalTransAmtByChannel", totalTransAmtByChannel );
				    map.put("succeedTransAmtByChannel", succeedTransAmtByChannel);
				    map.put("totalCountByChannel", totalCountByChannel);
				    map.put("succeedCountByChannel",succeedCountByChannel);
				    map.put("totalFeeByChannel",totalFeeByChannel);
				    map.put("succeedFeeByChannel",succeedFeeByChannel);
		     }
		     Map reportTransMch = reportTransMchService.getMchStatistics();
		     if(reportTransMch==null) {
		    	 	map.put("totalTransAmtByMch", "0" );
				    map.put("succeedTransAmtByMch", "0");
				    map.put("totalTransCountByMch", "0");
				    map.put("succeedTransCountByMch","0");
				    map.put("totalFeeByMch","0");
				    map.put("succeedFeeByMch","0");
		     }else {
		    	 BigDecimal totalTransAmtByMch = (BigDecimal) reportTransMch.get("totalTransAmt"); 
			     BigDecimal succeedTransAmtByMch = (BigDecimal) reportTransMch.get("succeedTransAmt"); 
			     BigDecimal totalTransCountByMch = (BigDecimal) reportTransMch.get("totalTransCount"); 
			     BigDecimal succeedTransCountByMch = (BigDecimal) reportTransMch.get("succeedTransCount"); 
			     BigDecimal totalFeeByMch = (BigDecimal) reportTransMch.get("totalFee"); 
			     BigDecimal succeedFeeByMch = (BigDecimal) reportTransMch.get("succeedFee"); 
			     	map.put("totalTransAmtByMch", totalTransAmtByMch );
				    map.put("succeedTransAmtByMch", succeedTransAmtByMch);
				    map.put("totalTransCountByMch", totalTransCountByMch);
				    map.put("succeedTransCountByMch",succeedTransCountByMch);
				    map.put("totalFeeByMch",totalFeeByMch);
				    map.put("succeedFeeByMch",succeedFeeByMch);
		     }
		     
		     Map reportRecharge = reportRechargeService.getRechargrStatistics();
		     if(reportTransMch==null) {
		    	 	map.put("wxTotalAmtByRecharge", "0" );
				    map.put("wxSucceedAmtByRecharge", "0");
				    map.put("zfbTotalAmtByRecharge", "0");
				    map.put("zfbSucceedAmtByRecharge","0");
				    map.put("totalTransByRecharge","0");
				    map.put("succeedTransByRecharge","0");
		     }else {
		    	 BigDecimal wxTotalAmtByRecharge = (BigDecimal) reportRecharge.get("wxTotalAmt"); 
			     BigDecimal wxSucceedAmtByRecharge = (BigDecimal) reportRecharge.get("wxSucceedAmt"); 
			     BigDecimal zfbTotalAmtByRecharge = (BigDecimal) reportRecharge.get("zfbTotalAmt"); 
			     BigDecimal zfbSucceedAmtByRecharge = (BigDecimal) reportRecharge.get("zfbSucceedAmt"); 
			     BigDecimal totalTransByRecharge = wxTotalAmtByRecharge.add(zfbTotalAmtByRecharge);
			     BigDecimal succeedTransByRecharge = wxSucceedAmtByRecharge.add(zfbSucceedAmtByRecharge);
			     	map.put("wxTotalAmtByRecharge", wxTotalAmtByRecharge );
				    map.put("wxSucceedAmtByRecharge", wxSucceedAmtByRecharge);
				    map.put("zfbTotalAmtByRecharge", zfbTotalAmtByRecharge);
				    map.put("zfbSucceedAmtByRecharge",zfbSucceedAmtByRecharge);
				    map.put("totalTransByRecharge",totalTransByRecharge);
				    map.put("succeedTransByRecharge",succeedTransByRecharge);
		     }
		     
		     
		    
		     
		     
		     
		        //交易金额
		        map.put("todayAmount", todayAmount !=null?todayAmount:"0" );
			    map.put("totalRatio", totalRatio !=null?totalRatio:"0");
			    map.put("successAmount", successAmount !=null?successAmount:"0");
			    map.put("paymentRatioToday",paymentRatioToday !=null?paymentRatioToday:"0%");
			    map.put("notAmount", notAmount !=null?notAmount:"0");
			    map.put("notPaymentRatioToday", notPaymentRatioToday !=null?notPaymentRatioToday:"0%");
			    
			    //交易订单统计
			    map.put("todayCount", todayCount !=null?todayCount:"0");
			    map.put("theTotalRatio", theTotalRatio !=null?theTotalRatio:"0%");
			    map.put("successCount", successCount !=null?successCount:"0");
			    map.put("completedRatio", completedRatio !=null?completedRatio:"0%");
			    map.put("notCount", notCount !=null?notCount:"0");
			    map.put("failureRatio", failureRatio !=null?failureRatio:"0%");
			    
			    //商户
			    map.put("todayAddMerchant", todayAddMerchant !=null?todayAddMerchant:"0");
			    map.put("merchantTotalRatio", merchantTotalRatio !=null?merchantTotalRatio:"0%");
			    
			  //支付通道
			    map.put("todayAddChannel", todayAddChannel !=null?todayAddChannel:"0");
			    map.put("channelsRatio", channelsRatio !=null?channelsRatio:"0%");
			    map.put("wechatCount", wechatCount !=null?wechatCount:"0");
			    map.put("wechatCountRatio", wechatCountRatio !=null?wechatCountRatio:"0%");
			    map.put("alipayCount", alipayCount !=null?alipayCount:"0");
			    map.put("alipayCountRatio", alipayCountRatio !=null?alipayCountRatio:"0%");
			    
			  //收款
//			    map.put("successAmount", successAmount);
			    map.put("collectionRatio", collectionRatio !=null?collectionRatio:"0%");
			    map.put("wechatReceipt", wechatReceipt !=null?wechatReceipt:"0");
			    map.put("wechatCollectionRatio", wechatCollectionRatio !=null?wechatCollectionRatio:"0%");
			    map.put("alipayReceipt", alipayReceipt !=null?alipayReceipt:"0");
			    map.put("alipayCollectionRatio", alipayCollectionRatio !=null?alipayCollectionRatio:"0%");
			    
			    //用户
			    map.put("todayAddUser", todayAddUser !=null?todayAddUser:"0");
			    map.put("theNewRate", theNewRate !=null?theNewRate:"0%");
		     
			
			 return  map;
			
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		
    	 return map;
	}

}
