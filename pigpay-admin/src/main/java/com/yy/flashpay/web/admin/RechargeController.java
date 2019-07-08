package com.yy.flashpay.web.admin;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.flashpay.entity.Recharge;
import com.yy.flashpay.entity.User;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.IRechargeService;
import com.yy.flashpay.service.IUserService;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping(value="/admin/recharge")
public class RechargeController  extends BaseController{
	
	private Logger logger = Logger.getLogger(RechargeController.class);
	
	@Autowired
	private IRechargeService rechargeService;
	@Autowired
	private IUserService userService;
	
	@RequestMapping("/dealList")
	public String dealList() {
		return "backend/order/dealList";
	}
	@RequestMapping("/dealDetails")
	public String dealDetails() {
		return "backend/order/dealDetails";
	}
	
	
	@RequestMapping(value = "dealList", method = RequestMethod.POST)
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
			Recharge recharge = new Recharge();
			recharge.setSerialNo(request.getParameter("serialNo"));  //单号
			recharge.setStatus(NumberUtils.toByte(request.getParameter("status")));    //充值状态
			recharge.setRechargeType(NumberUtils.toByte(request.getParameter("rechargeType")));  //充值方式
			page.setObjectT(recharge);
			page.setOrderClause(getOrderClause(request));
			page = rechargeService.getList(page);
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
	
	
	@RequestMapping(value = "dealDetails", method = RequestMethod.GET)
	public String dealDetails(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		Recharge recharge = rechargeService.selectByPrimaryKey(id);
		User user = userService.selectByPrimaryKey(recharge.getUserId());
		model.addAttribute("recharge", recharge);
		model.addAttribute("user", user);
		return "backend/order/dealDetails";
	}
	
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			int deleteCount = rechargeService.deleteByPrimaryKey(id);
			if(deleteCount == 1){
				result.put("code", "00");
				result.put("msg", "删除信息成功！");
			}else{
				result.put("code", "99");
				result.put("msg", "删除信息失败！");
			}
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "删除信息失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
}
