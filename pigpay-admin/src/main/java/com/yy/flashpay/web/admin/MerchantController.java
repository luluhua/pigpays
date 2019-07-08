package com.yy.flashpay.web.admin;

import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
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

import com.yy.flashpay.entity.Merchant;
import com.yy.flashpay.entity.User;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.IMerchantService;
import com.yy.flashpay.service.IUserService;
import com.yy.flashpay.util.EncryptionTool;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.util.RegExp;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping(value="/admin/merchant")
public class MerchantController extends BaseController{
	private Logger logger = Logger.getLogger(MerchantController.class);
	@Autowired
	private IMerchantService merchantService;
	@Autowired
	private IUserService userService;
	

	@RequestMapping(value = "list", method = RequestMethod.GET)
	public String list(HttpServletRequest request, HttpServletResponse response){
		return "backend/merchant/list";
	}
	
	
	@RequestMapping(value = "list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loadList1(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page<Merchant> page = new Page<Merchant>();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			Merchant merchantInfo = new Merchant();
			merchantInfo.setMchName(request.getParameter("name"));
			page.setObjectT(merchantInfo);
			page = merchantService.getList(page);
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
	
//	@RequestMapping(value = "list", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> loadList(HttpServletRequest request, HttpServletResponse response){
//		Map<String, Object> map = new HashMap<String, Object>();
//		try {
//			Page<Merchant> page = new Page<Merchant>();
//			Integer start = NumberUtils.toInt(request.getParameter("offset"), 0);
//	    	Integer lendth = NumberUtils.toInt(request.getParameter("limit"), 30);
//	    	
//	    	int pageNum  = start/lendth + 1;
//			page.getPage().setCurrentPage(pageNum);
//			page.getPage().setPageSize(lendth);
//			Merchant merchantInfo = new Merchant();
//			merchantInfo.setMchName(request.getParameter("name"));
//			page.setObjectT(merchantInfo);
//			page.setOrderClause(getOrderClause(request));
//			page = merchantService.getList(page);
//			
//			map.put("total", page.getPage().getTotalRecord());
//			map.put("rows", page.getList());
//			
//		} catch (Exception e) {
//			e.printStackTrace();
//			LoggerUtil.printExceptionLog(logger,e);
//		}
//		
//    	 return map;
//	}
	
	
	@RequestMapping(value = "add", method = RequestMethod.GET)
	public String add(HttpServletRequest request, HttpServletResponse response, Model model){
		return "backend/merchant/add";
	}
	
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String update(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		Merchant merchantInfo = merchantService.selectByPrimaryKey(id);
		model.addAttribute("merchant", merchantInfo);
		model.addAttribute("mid", id);
		
		return "backend/merchant/update";
	}
	
	
	@RequestMapping(value = "detail", method = RequestMethod.GET)
	public String detail(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		Merchant merchantInfo = merchantService.selectByPrimaryKey(id);
		User user = userService.selectByPrimaryKey(merchantInfo.getUserId());
		model.addAttribute("user", user);
		model.addAttribute("merchant", merchantInfo);
		
		return "backend/merchant/detail";
	}
	
	
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(String username, String realname, String pwd, String confirmpwd, Merchant merchantInfo, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> result = new HashMap<>();
		try {
			if(merchantInfo != null) {
				int affectCount = 0;
				if(merchantInfo.getId() != null && merchantInfo.getId() > 0){
					merchantInfo.setUpdateTime(new Date());
					affectCount = merchantService.updateByPrimaryKeySelective(merchantInfo);
				}else{
					
					if(StringUtils.isEmpty(username)) {
						result.put("code", "99");
						result.put("msg", "登录账号不能为空");
						return result;
					}else {
						User user = userService.findByUsername(username);
						if(user!=null) {
							result.put("code", "99");
							result.put("msg", "登录账号已存在");
							return result;
						}
						
					}
					
					if(StringUtils.isEmpty(pwd)) {
						result.put("code", "99");
						result.put("msg", "登录密码不能为空");
						return result;
					}
					if(!pwd.equals(confirmpwd)) {
						result.put("code", "99");
						result.put("msg", "两次输入的密码不一致");
						return result;
					}
			
					if(merchantInfo.getMobile() !="" || merchantInfo.getMobile()!=null) {
						if(!RegExp.isMobile(merchantInfo.getMobile())) {
							result.put("code", "99");
							result.put("msg", "手机号码格式不正确");
							return result;
						}
					}
					
					if(merchantInfo.getEmail() !="" || merchantInfo.getEmail() !=null) {
						if(!RegExp.isEmail(merchantInfo.getEmail())) {
							result.put("code", "99");
							result.put("msg", "邮箱号格式不正确");
							return result;
						}
						
					}
					
					
					// 创建系统账号
					User user = new User();
					user.setUsername(username);
					user.setPassword(EncryptionTool.MD5(pwd));
					user.setRealname(realname);
					user.setNickname(realname);
					
					affectCount = merchantService.createAccount(user, merchantInfo, getLoginUser(request));
				}
				
				if(affectCount == 1) {
					result.put("code", "00");
					result.put("msg", "保存商户成功！");
				}else {
					result.put("code", "99");
					result.put("msg", "保存商户失败！");
				}
				
			}else {
				result.put("code", "99");
				result.put("msg", "商户参数无效！");
			}
			
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "保存商户失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteChannel(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			
			int deleteCount = merchantService.deleteAccount(id, getLoginUser(request));
			
			if(deleteCount == 1){
				result.put("code", "00");
				result.put("msg", "删除商户成功！");
			}else{
				result.put("code", "99");
				result.put("msg", "删除商户失败！");
			}
		}catch (RuntimeException e) {
			result.put("code", "99");
			result.put("msg", e.getMessage());
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "删除商户失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	
	@RequestMapping(value = "updateStatus", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateChannelStatus(Integer id, Integer status, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> rsult = new HashMap<>();
		try {
			
			Merchant record = new Merchant();
			record.setId(id);
			record.setStatus((byte)status.intValue());
			int flag = merchantService.updateByPrimaryKeySelective(record);
			if(flag == 1) {
				rsult.put("code", "00");
				rsult.put("msg", "修改商户状态成功！");
			}else{
				rsult.put("code", "99");
				rsult.put("msg", "修改商户状态失败！");
			}
		} catch (Exception e) {
			rsult.put("code", 99);
			rsult.put("msg", "修改商户状态失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return rsult;
	}
	
	@RequestMapping(value = "providerlist", method = RequestMethod.GET)
	public String providerlist(HttpServletRequest request, HttpServletResponse response){
		return "backend/merchant/providerlist";
	}
	@RequestMapping(value = "addprovider", method = RequestMethod.GET)
	public String addprovider(HttpServletRequest request, HttpServletResponse response, Model model){
		return "backend/merchant/addprovider";
	}
	
	
	

}
