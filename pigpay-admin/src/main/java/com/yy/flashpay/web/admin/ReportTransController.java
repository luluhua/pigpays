package com.yy.flashpay.web.admin;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.flashpay.entity.Merchant;
import com.yy.flashpay.entity.Order;
import com.yy.flashpay.entity.Recharge;
import com.yy.flashpay.entity.ReportChannel;
import com.yy.flashpay.entity.ReportChannelDaily;
import com.yy.flashpay.entity.ReportCollectTrans;
import com.yy.flashpay.entity.ReportCollectTransDaily;
import com.yy.flashpay.entity.ReportRecharge;
import com.yy.flashpay.entity.ReportRechargeDaily;
import com.yy.flashpay.entity.ReportTrans;
import com.yy.flashpay.entity.ReportTransDaily;
import com.yy.flashpay.entity.ReportTransMch;
import com.yy.flashpay.entity.ReportTransMchDaily;
import com.yy.flashpay.entity.User;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.IOrderService;
import com.yy.flashpay.service.IRechargeService;
import com.yy.flashpay.service.IReportChannelDailyService;
import com.yy.flashpay.service.IReportChannelService;
import com.yy.flashpay.service.IReportCollectTransDailyService;
import com.yy.flashpay.service.IReportCollectTransService;
import com.yy.flashpay.service.IReportRechargeDailyService;
import com.yy.flashpay.service.IReportRechargeService;
import com.yy.flashpay.service.IReportTransDailyService;
import com.yy.flashpay.service.IReportTransMchDailyService;
import com.yy.flashpay.service.IReportTransMchService;
import com.yy.flashpay.service.IReportTransService;
import com.yy.flashpay.util.DateUtils;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.util.RegExp;
import com.yy.flashpay.util.json.DateUtil;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping(value="/admin/trans")
public class ReportTransController extends BaseController{
	static int count = 0;
	private Logger logger = Logger.getLogger(ReportTransController.class);
	
	@Autowired
	private IOrderService orderService;
	
	@Autowired
	private IReportTransDailyService reportTransDailyService;
	@Autowired
	private IReportTransService reportTransService;
	
	@Autowired
	private IReportChannelDailyService reportChannelDailyService;
	
	@Autowired
	private IReportChannelService reportChannelService;
	
	@Autowired
	private IReportTransMchDailyService reportTransMchDailyService;
	
	@Autowired
	private IReportTransMchService reportTransMchService;
	
	@Autowired
	private IRechargeService rechargeService;
	
	@Autowired
	private IReportRechargeDailyService reportRechargeDailyService;
	
	@Autowired
	private IReportRechargeService reportRechargeService;
	
	@Autowired
	private IReportCollectTransService reportCollectTransService;
	
	@Autowired
	private IReportCollectTransDailyService reportCollectTransDailyService;
	
	@Scheduled(cron = "0 13 22 ? * *") // 每天凌晨1点执行 
	public void reportTrans(){
		int affectCount=0;
		int information=0;
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<Order> orderlist= orderService.getListBydate(RegExp.getNextDay());
			if(orderlist.size()>0) {
				for(int i=0;i<orderlist.size();i++) {
					Map transactionAmount= orderService.getTradeStatisticByDate(orderlist.get(i).getUserId(),RegExp.getNextDay());
					if(transactionAmount !=null) {
					ReportTransDaily reportTransDaily = new ReportTransDaily();
					reportTransDaily.setUserId(orderlist.get(i).getUserId());
					reportTransDaily.setUserName(orderlist.get(i).getUserName());
					reportTransDaily.setMchId(orderlist.get(i).getMchId().toString());
					reportTransDaily.setMchName(transactionAmount.get("mchName").toString());
					reportTransDaily.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
					reportTransDaily.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
					reportTransDaily.setTotalTransCount(((BigDecimal) transactionAmount.get("totalTransCount")).intValue());
					reportTransDaily.setSucceedTransCount(((BigDecimal) transactionAmount.get("succeedTransCount")).intValue());
					reportTransDaily.setWxTransAmt((BigDecimal) transactionAmount.get("wxTransAmt"));
					reportTransDaily.setWxSucceedTransAmt((BigDecimal) transactionAmount.get("wxSucceedTransAmt"));
					reportTransDaily.setZfbTransAmt((BigDecimal) transactionAmount.get("zfbTransAmt"));
					reportTransDaily.setZfbSucceedTransAmt((BigDecimal) transactionAmount.get("zfbSucceedTransAmt"));
					reportTransDaily.setWxTransCount(((BigDecimal) transactionAmount.get("wxTransCount")).intValue());
					reportTransDaily.setWxSucceedTransCount(((BigDecimal) transactionAmount.get("wxSucceedTransCount")).intValue());
					reportTransDaily.setZfbTransCount(((BigDecimal)  transactionAmount.get("zfbTransCount")).intValue());
					reportTransDaily.setZfbSucceedTransCount(((BigDecimal) transactionAmount.get("zfbSucceedTransCount")).intValue());
					reportTransDaily.setTotalFee((BigDecimal) transactionAmount.get("totalFee"));
					reportTransDaily.setSucceedFee((BigDecimal) transactionAmount.get("succeedFee"));
					reportTransDaily.setWxTotalFee((BigDecimal) transactionAmount.get("wxTotalFee"));
					reportTransDaily.setWxSucceedFee((BigDecimal) transactionAmount.get("wxSucceedFee"));
					reportTransDaily.setZfbTotalFee((BigDecimal) transactionAmount.get("zfbTotalFee"));
					reportTransDaily.setZfbSucceedFee((BigDecimal) transactionAmount.get("zfbSucceedFee"));
					reportTransDaily.setReportTime(new Date());
					reportTransDaily.setReportDate(transactionAmount.get("reportDate").toString());
					reportTransDaily.setReportYear(DateUtil.formatDate(new Date(), "yyyy"));
					reportTransDaily.setReportMonth(DateUtil.formatDate(new Date(), "MM"));
					reportTransDaily.setReportDay(DateUtil.formatDate(new Date(), "dd"));
					affectCount = reportTransDailyService.insert(reportTransDaily);
					ReportTransMchDaily reportTransMchDaily = new ReportTransMchDaily();
					reportTransMchDaily.setMchId(orderlist.get(i).getChnlId());
					reportTransMchDaily.setMchNo(orderlist.get(i).getMchNo());
					reportTransMchDaily.setMchName(transactionAmount.get("mchName").toString());
					reportTransMchDaily.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
					reportTransMchDaily.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
					reportTransMchDaily.setTotalTransCount(((BigDecimal) transactionAmount.get("totalTransCount")).intValue());
					reportTransMchDaily.setSucceedTransCount(((BigDecimal) transactionAmount.get("succeedTransCount")).intValue());
					reportTransMchDaily.setTotalFee((BigDecimal) transactionAmount.get("totalFee"));
					reportTransMchDaily.setSucceedFee((BigDecimal) transactionAmount.get("succeedFee"));
					reportTransMchDaily.setReportTime(new Date());
					reportTransMchDaily.setReportDate(DateUtil.formatDate(new Date(), "yyyy-MM-dd"));
					reportTransMchDaily.setReportYear(DateUtil.formatDate(new Date(), "yyyy"));
					reportTransMchDaily.setReportMonth(DateUtil.formatDate(new Date(), "MM"));
					reportTransMchDaily.setReportDay(DateUtil.formatDate(new Date(), "dd"));
					information = reportTransMchDailyService.insert(reportTransMchDaily);
					if(affectCount==1) {
						ReportTrans ReportTrans = new ReportTrans();
						ReportTrans.setUserId(orderlist.get(i).getUserId());
						ReportTrans.setUserName(orderlist.get(i).getUserName());
						ReportTrans.setMchId(orderlist.get(i).getMchId().toString());
						ReportTrans.setMchName(transactionAmount.get("mchName").toString());
						ReportTrans.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
						ReportTrans.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
						ReportTrans.setTotalTransCount(((BigDecimal) transactionAmount.get("totalTransCount")).intValue());
						ReportTrans.setSucceedTransCount(((BigDecimal) transactionAmount.get("succeedTransCount")).intValue());
						ReportTrans.setWxTransAmt((BigDecimal) transactionAmount.get("wxTransAmt"));
						ReportTrans.setWxSucceedTransAmt((BigDecimal) transactionAmount.get("wxSucceedTransAmt"));
						ReportTrans.setZfbTransAmt((BigDecimal) transactionAmount.get("zfbTransAmt"));
						ReportTrans.setZfbSucceedTransAmt((BigDecimal) transactionAmount.get("zfbSucceedTransAmt"));
						ReportTrans.setWxTransCount(((BigDecimal) transactionAmount.get("wxTransCount")).intValue());
						ReportTrans.setWxSucceedTransCount(((BigDecimal) transactionAmount.get("wxSucceedTransCount")).intValue());
						ReportTrans.setZfbTransCount(((BigDecimal)  transactionAmount.get("zfbTransCount")).intValue());
						ReportTrans.setZfbSucceedTransCount(((BigDecimal) transactionAmount.get("zfbSucceedTransCount")).intValue());
						ReportTrans.setTotalFee((BigDecimal) transactionAmount.get("totalFee"));
						ReportTrans.setSucceedFee((BigDecimal) transactionAmount.get("succeedFee"));
						ReportTrans.setWxTotalFee((BigDecimal) transactionAmount.get("wxTotalFee"));
						ReportTrans.setWxSucceedFee((BigDecimal) transactionAmount.get("wxSucceedFee"));
						ReportTrans.setZfbTotalFee((BigDecimal) transactionAmount.get("zfbTotalFee"));
						ReportTrans.setZfbSucceedFee((BigDecimal) transactionAmount.get("zfbSucceedFee"));
						ReportTrans.setReportTime(new Date());
						ReportTrans reportTransList=reportTransService.getReportTransByUserId(ReportTrans.getUserId());
						if(reportTransList !=null) {
							int insertRepor = reportTransService.refreshReportData(ReportTrans); 
						}else {
							int insertRepor = reportTransService.insert(ReportTrans); 
						}
						if(information==1) {
							ReportTransMch reportTransMch = new ReportTransMch();
							reportTransMch.setMchId(orderlist.get(i).getMchId());
							reportTransMch.setMchNo(orderlist.get(i).getMchNo());
							reportTransMch.setMchName(transactionAmount.get("mchName").toString());
							reportTransMch.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
							reportTransMch.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
							reportTransMch.setTotalTransCount(((BigDecimal) transactionAmount.get("totalTransCount")).intValue());
							reportTransMch.setSucceedTransCount(((BigDecimal) transactionAmount.get("succeedTransCount")).intValue());
							reportTransMch.setTotalFee((BigDecimal) transactionAmount.get("totalFee"));
							reportTransMch.setSucceedFee((BigDecimal) transactionAmount.get("succeedFee"));
							reportTransMch.setReportTime(new Date());
							ReportTransMch reportTransMchList =reportTransMchService.getReportTransBymchId(reportTransMch.getMchId());
							if(reportTransMchList !=null) {
								reportTransMchService.refreshReportData(reportTransMch);
							}else {
								reportTransMchService.insert(reportTransMch);
							}
						}
						
						
						
					}
					
				}
			}
		}
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
	}
	
	@RequestMapping(value = "dailyReportByTrans", method = RequestMethod.GET)
	public String dailyReportByTrans(HttpServletRequest request, HttpServletResponse response, Model model){	
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		String startTimestr = sdf1.format(cal.getTime());
		String endTimestr = sdf1.format(cal.getTime());
		model.addAttribute("startTime", startTimestr);
		model.addAttribute("endTime", endTimestr);
		return "backend/order/dailyReportByTrans";
	}
	
	@RequestMapping(value = "dailyReportByTransList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> dailyReportList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
				Order order = new Order();
				if(StringUtils.isNotEmpty(timeStart)){
					timeStart = timeStart + " 00:00:00";
					page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
				}
				
				if(StringUtils.isNotEmpty(timeEnd)) {
					timeEnd = timeEnd+" 23:59:59";
					page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
				}
				if(request.getParameter("endTime")==RegExp.getThatDay() || request.getParameter("endTime").equals(RegExp.getThatDay())) {
				order.setStatus(request.getParameter("status"));
				page.setObjectT(order);
				page.setOrderClause(getOrderClause(request));
				page = orderService.getListByPage(page);
				List<Order> orderlist =  page.getList();
				if(orderlist.size()>0) {
					List<ReportTransDaily> ReportList = new ArrayList<ReportTransDaily>();
					for(int i=0;i<orderlist.size();i++) {
						Map transactionAmount = orderService.getReportList(orderlist.get(i).getUserId(),timeStart,timeEnd);
						ReportTransDaily reportTransDaily = new ReportTransDaily();
						reportTransDaily.setUserId(orderlist.get(i).getUserId());
						reportTransDaily.setUserName(orderlist.get(i).getUserName());
						reportTransDaily.setMchId(orderlist.get(i).getMchId().toString());
						reportTransDaily.setMchName(transactionAmount.get("mchName").toString());
						reportTransDaily.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
						reportTransDaily.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
						reportTransDaily.setTotalTransCount(((BigDecimal) transactionAmount.get("totalTransCount")).intValue());
						reportTransDaily.setSucceedTransCount(((BigDecimal) transactionAmount.get("succeedTransCount")).intValue());
						reportTransDaily.setWxTransAmt((BigDecimal) transactionAmount.get("wxTransAmt"));
						reportTransDaily.setWxSucceedTransAmt((BigDecimal) transactionAmount.get("wxSucceedTransAmt"));
						reportTransDaily.setZfbTransAmt((BigDecimal) transactionAmount.get("zfbTransAmt"));
						reportTransDaily.setZfbSucceedTransAmt((BigDecimal) transactionAmount.get("zfbSucceedTransAmt"));
						reportTransDaily.setWxTransCount(((BigDecimal) transactionAmount.get("wxTransCount")).intValue());
						reportTransDaily.setWxSucceedTransCount(((BigDecimal) transactionAmount.get("wxSucceedTransCount")).intValue());
						reportTransDaily.setZfbTransCount(((BigDecimal)  transactionAmount.get("zfbTransCount")).intValue());
						reportTransDaily.setZfbSucceedTransCount(((BigDecimal) transactionAmount.get("zfbSucceedTransCount")).intValue());
						reportTransDaily.setTotalFee((BigDecimal) transactionAmount.get("totalFee"));
						reportTransDaily.setSucceedFee((BigDecimal) transactionAmount.get("succeedFee"));
						reportTransDaily.setWxTotalFee((BigDecimal) transactionAmount.get("wxTotalFee"));
						reportTransDaily.setWxSucceedFee((BigDecimal) transactionAmount.get("wxSucceedFee"));
						reportTransDaily.setZfbTotalFee((BigDecimal) transactionAmount.get("zfbTotalFee"));
						reportTransDaily.setZfbSucceedFee((BigDecimal) transactionAmount.get("zfbSucceedFee"));
						reportTransDaily.setReportTime(new Date());
						ReportList.add(reportTransDaily);
					}
					map.put("recordsTotal", page.getPage().getTotalRecord());
			    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
			    	map.put("data", ReportList);
			    	  return map;
				}
			
			}else {
				ReportTransDaily ReportTransDaily = new ReportTransDaily();
				ReportTransDaily.setUserName(request.getParameter("userName"));
				page.setObjectT(ReportTransDaily);
				page.setOrderClause(getOrderClause(request));
				page = reportTransDailyService.getList(page);
		    	map.put("recordsTotal", page.getPage().getTotalRecord());
		    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
		    	map.put("data", page.getList());
		    	return map;
			}
	      
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}

	
	


	@RequestMapping(value = "totalReportByTrans", method = RequestMethod.GET)
	public String totalReportByTrans(HttpServletRequest request, HttpServletResponse response, Model model){		
		return "backend/order/totalReportByTrans";
	}
	
	@RequestMapping(value = "totalReportByTransList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> totalReportByTransList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			
			if(StringUtils.isNotEmpty(timeStart)){
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			
			if(StringUtils.isNotEmpty(timeEnd)) {
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			page.setOrderClause(getOrderClause(request));
			page = reportTransService.getList(page);
	    	map.put("recordsTotal", page.getPage().getTotalRecord());
	    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
	    	map.put("data", page.getList());
			
	        return map;
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}
	
	@Scheduled(cron = "0 59 13 ? * *") // 每天凌晨1点执行 
	public void reportChannel(){
		int affectCount=0;
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<Order> orderlist= orderService.getListBydate(RegExp.getNextDay());
			if(orderlist.size()>0) {
				for(int i=0;i<orderlist.size();i++) {
					Map transactionAmount= orderService.getChannelListBydate(orderlist.get(i).getChnlId(),RegExp.getNextDay());
					ReportChannelDaily reportChannelDaily = new ReportChannelDaily();
					reportChannelDaily.setChannelId(orderlist.get(i).getChnlId());
					reportChannelDaily.setChannelName(transactionAmount.get("channelName").toString());
					reportChannelDaily.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
					reportChannelDaily.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
					reportChannelDaily.setTotalCount(((BigDecimal) transactionAmount.get("totalCount")).intValue());
					reportChannelDaily.setSucceedCount(((BigDecimal) transactionAmount.get("succeedCount")).intValue());
					reportChannelDaily.setTotalFee(((BigDecimal) transactionAmount.get("totalFee")).intValue());
					reportChannelDaily.setSucceedFee(((BigDecimal) transactionAmount.get("succeedFee")).intValue());
					reportChannelDaily.setReportTime(new Date());
					reportChannelDaily.setReportDate(transactionAmount.get("reportDate").toString());
					int information = reportChannelDailyService.insert(reportChannelDaily);
					if(information==1) {
						ReportChannel reportChannel = new ReportChannel();
						reportChannel.setChannelId((Integer) transactionAmount.get("channelId"));
						reportChannel.setChannelName(transactionAmount.get("channelName").toString());
						reportChannel.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
						reportChannel.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
						reportChannel.setTotalCount(((BigDecimal) transactionAmount.get("totalCount")).intValue());
						reportChannel.setSucceedCount(((BigDecimal) transactionAmount.get("succeedCount")).intValue());
						reportChannel.setTotalFee(((BigDecimal) transactionAmount.get("totalFee")).intValue());
						reportChannel.setSucceedFee(((BigDecimal) transactionAmount.get("succeedFee")).intValue());
						reportChannel.setReportTime(new Date());
						ReportChannel report = reportChannelService.getReportChannelByChannelId(reportChannel.getChannelId());
						if(report !=null) {
							reportChannelService.refreshReportChanne(reportChannel);
						}else {
							reportChannelService.insert(reportChannel);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
	}
	
	@RequestMapping(value = "dailyReportByChannelList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> dailyReportByChannelList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			
			if(StringUtils.isNotEmpty(timeStart)){
				timeStart = timeStart + " 00:00:00";
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			if(StringUtils.isNotEmpty(timeEnd)) {
				timeEnd = timeEnd+" 23:59:59";
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			if(request.getParameter("endTime")==RegExp.getThatDay() || request.getParameter("endTime").equals(RegExp.getThatDay())) {
				Map result = orderService.dailyReportByChannel(timeStart, timeEnd);
		    	map.put("recordsTotal", result.get("total"));
		    	map.put("recordsFiltered",  result.get("total"));
		    	map.put("data", result.get("list"));
		        return map;
			}else {
			page.setOrderClause(getOrderClause(request));
			page = reportChannelDailyService.getList(page);
	    	map.put("recordsTotal", page.getPage().getTotalRecord());
	    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
	    	map.put("data", page.getList());
	    	return map;
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}
	
	@RequestMapping(value = "totalReportByChannelList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> totalReportByChannelList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			
				ReportChannel reportChannel = new ReportChannel();
				reportChannel.setChannelName(request.getParameter("channelName"));
			if(StringUtils.isNotEmpty(timeStart)){
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			
			if(StringUtils.isNotEmpty(timeEnd)) {
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			page.setObjectT(reportChannel);
			page.setOrderClause(getOrderClause(request));
			
			page = reportChannelService.getList(page);
			
	    	map.put("recordsTotal", page.getPage().getTotalRecord());
	    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
	    	map.put("data", page.getList());
			
	        return map;
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}
	
	@RequestMapping(value = "dailyReportByMchList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> dailyReportByMchList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String mchName = StringUtils.trimToEmpty(request.getParameter("mchname"));
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
	
			if(StringUtils.isNotEmpty(timeStart)){
				timeStart = timeStart + " 00:00:00";
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			if(StringUtils.isNotEmpty(timeEnd)) {
				timeEnd = timeEnd+" 23:59:59";
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			if(request.getParameter("endTime")==RegExp.getThatDay() || request.getParameter("endTime").equals(RegExp.getThatDay())) {
				Map result = orderService.dailyReportByMch(mchName, timeStart, timeEnd, start, lendth);
				map.put("recordsTotal",result.get("total"));
		    	map.put("recordsFiltered",  result.get("total"));
		    	map.put("data", result.get("list"));
		        return map;
			}else {
			page.setOrderClause(getOrderClause(request));
			page = reportTransMchDailyService.getList(page);
	    	map.put("recordsTotal", page.getPage().getTotalRecord());
	    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
	    	map.put("data", page.getList());
	    	return map;
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}
	
	@RequestMapping(value = "totalReportByMchList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> totalReportByMchList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			
			ReportTransMch reportTransMch = new ReportTransMch();
			reportTransMch.setMchNo(request.getParameter("mchNo"));
			if(StringUtils.isNotEmpty(timeStart)){
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			
			if(StringUtils.isNotEmpty(timeEnd)) {
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			page.setObjectT(reportTransMch);
			page.setOrderClause(getOrderClause(request));
			
			page = reportTransMchService.getList(page);
			
	    	map.put("recordsTotal", page.getPage().getTotalRecord());
	    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
	    	map.put("data", page.getList());
			
	        return map;
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}
	
	@Scheduled(cron = "0 00 00 ? * *") // 每天凌晨1点执行 
	public void reportRecharge(){
		int affectCount=0;
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<Recharge> rechargeList= rechargeService.getListBydate(RegExp.getNextDay());
			if(rechargeList.size()>0) {
				for(int i=0;i<rechargeList.size();i++) {
					Map reportRechargeList = rechargeService.getRechargeListBydate(rechargeList.get(i).getUserId());
					ReportRechargeDaily reportRechargeDaily = new ReportRechargeDaily();
					reportRechargeDaily.setUserId((Integer) reportRechargeList.get("userId"));
					reportRechargeDaily.setWxTotalAmt((BigDecimal) reportRechargeList.get("wxTotalAmt"));
					reportRechargeDaily.setZfbTotalAmt((BigDecimal) reportRechargeList.get("zfbTotalAmt"));
					reportRechargeDaily.setWxSucceedAmt((BigDecimal) reportRechargeList.get("wxSucceedAmt"));
					reportRechargeDaily.setZfbSucceedAmt((BigDecimal) reportRechargeList.get("zfbSucceedAmt"));
					reportRechargeDaily.setReportTime(new Date());
					reportRechargeDaily.setReportDate(DateUtil.formatDate(new Date(), "yyyy-MM-dd"));
					reportRechargeDaily.setReportYear(reportRechargeList.get("reportDate").toString());
					reportRechargeDaily.setReportMonth(DateUtil.formatDate(new Date(), "MM"));
					reportRechargeDaily.setReportDay(DateUtil.formatDate(new Date(), "dd"));
					affectCount = reportRechargeDailyService.insert(reportRechargeDaily);
					if(affectCount==1) {
						ReportRecharge reportRecharge = new ReportRecharge();
						reportRecharge.setUserId((Integer) reportRechargeList.get("userId"));
						reportRecharge.setWxTotalAmt((BigDecimal) reportRechargeList.get("wxTotalAmt"));
						reportRecharge.setZfbTotalAmt((BigDecimal) reportRechargeList.get("zfbTotalAmt"));
						reportRecharge.setWxSucceedAmt((BigDecimal) reportRechargeList.get("wxSucceedAmt"));
						reportRecharge.setZfbSucceedAmt((BigDecimal) reportRechargeList.get("zfbSucceedAmt"));
						reportRecharge.setReportTime(new Date());
						ReportRecharge report= reportRechargeService.getReportRechargeByUserId(reportRecharge.getUserId());
						if(report != null) {
						reportRechargeService.refreshReportRecharge(reportRecharge);
						}else {
						reportRechargeService.insert(reportRecharge);
						}
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
	}
	@RequestMapping(value = "dailyReportByRecharge", method = RequestMethod.GET)
	public String dailyReportByRecharge(HttpServletRequest request, HttpServletResponse response, Model model){	
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		String startTimestr = sdf1.format(cal.getTime());
		String endTimestr = sdf1.format(cal.getTime());
		
		model.addAttribute("startTime", startTimestr);
		model.addAttribute("endTime", endTimestr);
		return "backend/order/dailyReportByRecharge";
	}
	
	@RequestMapping(value = "dailyReportByRechargeList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> dailyReportByRechargeList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
	
			if(StringUtils.isNotEmpty(timeStart)){
				timeStart = timeStart + " 00:00:00";
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			if(StringUtils.isNotEmpty(timeEnd)) {
				timeEnd = timeEnd+" 23:59:59";
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			if(request.getParameter("endTime")==RegExp.getThatDay() || request.getParameter("endTime").equals(RegExp.getThatDay())) {
				Map result = rechargeService.dailyReport(timeStart, timeEnd, start, lendth);
		    	map.put("recordsTotal", result.get("total"));
		    	map.put("recordsFiltered",  result.get("total"));
		    	map.put("data", result.get("list"));
		        return map;
			}else {
			page.setOrderClause(getOrderClause(request));
			page = reportRechargeDailyService.getList(page);
	    	map.put("recordsTotal", page.getPage().getTotalRecord());
	    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
	    	map.put("data", page.getList());
	    	return map;
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}
	
	@RequestMapping(value = "totalReportByRecharge", method = RequestMethod.GET)
	public String totalReportByRecharge(HttpServletRequest request, HttpServletResponse response, Model model){	
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		String startTimestr = sdf1.format(cal.getTime());
		String endTimestr = sdf1.format(cal.getTime());
		model.addAttribute("startTime", startTimestr);
		model.addAttribute("endTime", endTimestr);
		return "backend/order/totalReportByRecharge";
	}
	@RequestMapping(value = "totalReportByRechargeList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> totalReportByRechargeList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			
			if(StringUtils.isNotEmpty(timeStart)){
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			
			if(StringUtils.isNotEmpty(timeEnd)) {
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			page.setOrderClause(getOrderClause(request));
			
			page = reportRechargeService.getList(page);
			
	    	map.put("recordsTotal", page.getPage().getTotalRecord());
	    	map.put("recordsFiltered",  page.getPage().getTotalRecord());
	    	map.put("data", page.getList());
			
	        return map;
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		map.put("recordsTotal", 0);
    	map.put("recordsFiltered",  0);
    	map.put("data", Collections.EMPTY_LIST);
    	 return map;
	}
	
	@Scheduled(cron = "0 00 00 ? * *") // 每天凌晨1点执行 
	public void reportCollect(){
		int affectCount=0;
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<Order> orderlist= orderService.getListBydate(RegExp.getNextDay());
			if(orderlist.size()>0) {
				for(int i=0;i<orderlist.size();i++) {
					Map transactionAmount= orderService.getCollectListBydate(orderlist.get(i).getChnlId(),orderlist.get(i).getUserId(),RegExp.getNextDay());
					ReportCollectTransDaily reportCollectTransDaily = new ReportCollectTransDaily();
					reportCollectTransDaily.setUserId((Integer) transactionAmount.get("userId"));
					reportCollectTransDaily.setCollectAcctId((Integer) transactionAmount.get("collectAcctId"));
					reportCollectTransDaily.setCollectAcctName(transactionAmount.get("collectAcctName").toString());
					reportCollectTransDaily.setChannelName(transactionAmount.get("channelName").toString());
					reportCollectTransDaily.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
					reportCollectTransDaily.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
					reportCollectTransDaily.setTotalTransCount(((BigDecimal) transactionAmount.get("totalTransCount")).intValue());
					reportCollectTransDaily.setSucceedTransCount(((BigDecimal) transactionAmount.get("succeedTransCount")).intValue());
					reportCollectTransDaily.setTotalFee((BigDecimal) transactionAmount.get("totalFee"));
					reportCollectTransDaily.setSucceedFee((BigDecimal) transactionAmount.get("succeedFee"));
					reportCollectTransDaily.setReportTime(new Date());
					reportCollectTransDaily.setReportDate(DateUtil.formatDate(new Date(), "yyyy-MM-dd"));
					reportCollectTransDaily.setReportYear(DateUtil.formatDate(new Date(), "yyyy"));
					reportCollectTransDaily.setReportMonth(DateUtil.formatDate(new Date(), "MM"));
					reportCollectTransDaily.setReportDay(DateUtil.formatDate(new Date(), "dd"));
					int information = reportCollectTransDailyService.insert(reportCollectTransDaily);
					if(information==1) {
						ReportCollectTrans reportCollectTrans = new ReportCollectTrans();
						reportCollectTrans.setUserId((Integer) transactionAmount.get("userId"));
						reportCollectTrans.setCollectAcctId((Integer) transactionAmount.get("collectAcctId"));
						reportCollectTrans.setCollectAcctName(transactionAmount.get("collectAcctName").toString());
						reportCollectTrans.setChannelName(transactionAmount.get("channelName").toString());
						reportCollectTrans.setTotalTransAmt((BigDecimal) transactionAmount.get("totalTransAmt"));
						reportCollectTrans.setSucceedTransAmt((BigDecimal) transactionAmount.get("succeedTransAmt"));
						reportCollectTrans.setTotalTransCount(((BigDecimal) transactionAmount.get("totalTransCount")).intValue());
						reportCollectTrans.setSucceedTransCount(((BigDecimal) transactionAmount.get("succeedTransCount")).intValue());
						reportCollectTrans.setTotalFee((BigDecimal) transactionAmount.get("totalFee"));
						reportCollectTrans.setSucceedFee((BigDecimal) transactionAmount.get("succeedFee"));
						reportCollectTrans.setReportTime(new Date());
						ReportCollectTrans report = reportCollectTransService.getReportRechargeByUserId(reportCollectTrans.getUserId());
						if(report==null) {
							reportCollectTransService.refreshreportCollect(reportCollectTrans);
						}else {
							reportCollectTransService.insert(reportCollectTrans);
						}
					}
					
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
	}

}
