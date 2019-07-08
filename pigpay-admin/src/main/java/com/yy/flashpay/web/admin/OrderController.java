package com.yy.flashpay.web.admin;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.flashpay.entity.Order;
import com.yy.flashpay.entity.User;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.IOrderService;
import com.yy.flashpay.util.DateUtils;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.web.BaseController;


@Controller
@RequestMapping(value="/admin/order")
public class OrderController extends BaseController{
	
	private Logger logger = Logger.getLogger(OrderController.class);
	
	@Autowired
	private IOrderService orderService;
	
	
	@RequestMapping(value = "list", method = RequestMethod.GET)
	public String loginMerchantPage(HttpServletRequest request, HttpServletResponse response, Model model){		
		return "backend/order/list";
	}
	
	@RequestMapping(value = "list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loadList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page page = new Page();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			Order order = new Order();
			order.setTransactionId(request.getParameter("orderNo"));
			order.setOrderNo(request.getParameter("orderNo"));
			order.setMchNo(request.getParameter("mchNo"));
			
			
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			if(StringUtils.isNotEmpty(timeStart)){
				page.setStartTime(DateUtils.format(timeStart + " 00:00:00", "yyyy-MM-dd HH:mm:ss"));
			}
			
			if(StringUtils.isNotEmpty(timeEnd)) {
				page.setEndTime(DateUtils.format(timeEnd+" 23:59:59", "yyyy-MM-dd HH:mm:ss"));
			}
			
			order.setStatus(request.getParameter("status"));
			page.setObjectT(order);
			page.setOrderClause(getOrderClause(request));
			
			page = orderService.getList(page);
			
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
	
	@RequestMapping(value = "detail", method = RequestMethod.GET)
	public String showDetail(Integer id, Model model) {
		Order order = orderService.selectByPrimaryKey(id);
		model.addAttribute("order", order);
		return "backend/order/detail";
	}
	
	
	@RequestMapping(value = "resendnotify", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> checkpay(Integer id,HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			if(id != null && id > 0){
				User operator = (User)request.getSession().getAttribute("user");
				String success = orderService.reSendNotify(id, operator);
				result.put("code", "00");
				result.put("msg", "补单成功,通知返回:" + success);
				
			}else{
				result.put("code", "99");
				result.put("msg", "参数错误！");
			}
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "补单通知失败！原因："+e.getMessage());
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	
	
	@RequestMapping(value = "confirmpay", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> confirmpay(Integer id,HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			if(id != null && id > 0){
				User operator = (User)request.getSession().getAttribute("user");
				String success = orderService.confirmpay(id, operator);
				result.put("code", "00");
				result.put("msg", "确认收款成功");
				
			}else{
				result.put("code", "99");
				result.put("msg", "确认收款失败！原因：参数错误！");
			}
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "确认收款失败！原因："+e.getMessage());
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	
	@RequestMapping(value = "dailyReportByChannel", method = RequestMethod.GET)
	public String dailyReportByChannel(HttpServletRequest request, HttpServletResponse response, Model model){
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		String startTimestr = sdf1.format(cal.getTime());
		String endTimestr = sdf1.format(cal.getTime());
		
		model.addAttribute("startTime", startTimestr);
		model.addAttribute("endTime", endTimestr);
		return "backend/order/dailyReportByChannel";
	}
	
	@RequestMapping(value = "dailyReportByChannel", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> dailyReportByChannel(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			
			
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			if(StringUtils.isNotEmpty(timeStart)){
				timeStart = timeStart + " 00:00:00";
			}
			
			if(StringUtils.isNotEmpty(timeEnd)) {
				timeEnd = timeEnd+" 23:59:59";
			}
			
			
			Map result = orderService.dailyReportByChannel(timeStart, timeEnd);
			
	    	map.put("recordsTotal", result.get("total"));
	    	map.put("recordsFiltered",  result.get("total"));
	    	map.put("data", result.get("list"));
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
	
	
	@RequestMapping(value = "totalReportByChannel", method = RequestMethod.GET)
	public String totalReportByChannel(HttpServletRequest request, HttpServletResponse response, Model model){
		return "backend/order/totalReportByChannel";
	}
	
	@RequestMapping(value = "totalReportByChannel", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> totalReportByChannel(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			
			Map result = orderService.totalReportByChannel();
			
			map.put("recordsTotal", result.get("total"));
	    	map.put("recordsFiltered",  result.get("total"));
	    	map.put("data", result.get("list"));
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
	
	
	
	@RequestMapping(value = "dailyReportByMch", method = RequestMethod.GET)
	public String dailyReportByMch(HttpServletRequest request, HttpServletResponse response, Model model){
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		String startTimestr = sdf1.format(cal.getTime());
		String endTimestr = sdf1.format(cal.getTime());
		
		model.addAttribute("startTime", startTimestr);
		model.addAttribute("endTime", endTimestr);
		return "backend/order/dailyReportByMch";
	}
	
	@RequestMapping(value = "dailyReportByMch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> dailyReportByMch(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			
			String mchName = StringUtils.trimToEmpty(request.getParameter("mchname"));
			String timeStart = StringUtils.trimToEmpty(request.getParameter("startTime"));
			String timeEnd = StringUtils.trimToEmpty(request.getParameter("endTime"));
			if(StringUtils.isNotEmpty(timeStart)){
				timeStart = timeStart + " 00:00:00";
			}
			
			if(StringUtils.isNotEmpty(timeEnd)) {
				timeEnd = timeEnd+" 23:59:59";
			}
			
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer length = NumberUtils.toInt(request.getParameter("length"), 30);
	    	
			Map result = orderService.dailyReportByMch(mchName, timeStart, timeEnd, start, length);
			
	    	map.put("recordsTotal", result.get("total"));
	    	map.put("recordsFiltered",  result.get("total"));
	    	map.put("data", result.get("list"));
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
	
	
	@RequestMapping(value = "totalReportByMch", method = RequestMethod.GET)
	public String totalReportByMch(HttpServletRequest request, HttpServletResponse response, Model model){
		
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		String startTimestr = sdf1.format(cal.getTime());
		String endTimestr = sdf1.format(cal.getTime());
		
		model.addAttribute("startTime", startTimestr);
		model.addAttribute("endTime", endTimestr);
		
		return "backend/order/totalReportByMch";
	}
	
	@RequestMapping(value = "totalReportByMch", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> totalReportByMch(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			
			String mchName = StringUtils.trimToEmpty(request.getParameter("mchname"));
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer length = NumberUtils.toInt(request.getParameter("length"), 30);
			Map result = orderService.totalReportByMch(mchName, start, length);
			
			map.put("recordsTotal", result.get("total"));
	    	map.put("recordsFiltered",  result.get("total"));
	    	map.put("data", result.get("list"));
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
	
	
	
	
	
}
