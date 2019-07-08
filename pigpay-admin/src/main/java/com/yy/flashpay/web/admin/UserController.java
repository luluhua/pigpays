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
import com.yy.flashpay.service.IUserService;
import com.yy.flashpay.util.EncryptionTool;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.util.RegExp;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping(value="/admin/user")
public class UserController extends BaseController{
	private Logger logger = Logger.getLogger(UserController.class);
	@Autowired
	private IUserService userService;
	

	@RequestMapping(value = "list", method = RequestMethod.GET)
	public String list(HttpServletRequest request, HttpServletResponse response){
		return "backend/user/list";
	}
	
	
	@RequestMapping(value = "list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loadList(Byte userType,HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page<User> page = new Page<User>();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			User user = new User();
			user.setUsername(request.getParameter("username"));
			user.setUserType(userType);
			page.setObjectT(user);
			page = userService.getList(page);
			
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
	
	
	@RequestMapping(value = "add", method = RequestMethod.GET)
	public String add(HttpServletRequest request, HttpServletResponse response, Model model){
		return "backend/user/add";
	}
	
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String update(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		User user = userService.selectByPrimaryKey(id);
		model.addAttribute("user", user);
		return "backend/user/update";
	}
	
	
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(User user,String confirmpwd, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> result = new HashMap<>();
		Date createTime = new Date();
		try {
			if(user != null) {
				int affectCount = 0;
				if(user.getId() != null && user.getId() > 0){
					affectCount = userService.updateByPrimaryKeySelective(user);
				}else{
				
					if(StringUtils.isEmpty(user.getUsername())) {
						result.put("code", "11");
						result.put("msg", "登录账号不能为空");
						return result;
					}else {
						User usern = userService.findByUsername(user.getUsername());
						if(usern != null) {
							result.put("code", "00");
							result.put("msg", "登录账号已存在");
							return result;
						}
					}
					
					if(StringUtils.isEmpty(user.getPassword())) {
						result.put("code", "11");
						result.put("msg", "登录密码不能为空");
						return result;
					}
					if(!user.getPassword().equals(confirmpwd)) {
						result.put("code", "11");
						result.put("msg", "两次输入的密码不一致");
						return result;
					}
					
					if(user.getMobile() != null || user.getMobile() !="") {
						if(!RegExp.isMobile(user.getMobile())) {
							result.put("code", "99");
							result.put("msg", "手机号码格式不正确");
							return result;
						}
					}
					if(user.getEmail() != null || user.getEmail() !="") {
						if(!RegExp.isEmail(user.getEmail())) {
							result.put("code", "99");
							result.put("msg", "邮箱号格式不正确");
							return result;
						}
					}
					
					if(user.getUserType()!=null) {
						user.setUserType(Byte.valueOf(user.getUserType()));
						User  agentUser= userService.findByUsername(user.getAgentName());
						if(agentUser==null) {
							result.put("code", "99");
							result.put("msg", "推荐人不存在");
							return result;
						}else {
							user.setAgentId(agentUser.getId());
						}
					}else {
						user.setUserType(Byte.valueOf("1"));
					}
					user.setPassword(EncryptionTool.MD5(user.getPassword()));
					user.setSex(Byte.valueOf("0"));
					user.setQrcodeCount(0);
					user.setAcctCount(0);
					user.setStatus(Byte.valueOf("1"));
					user.setCreateTime(createTime);
					
					if(user.getAcctCountLimit() == null) {
						user.setAcctCountLimit(0);
					}
					if(user.getQrcodeCountLimit() == null) {
						user.setQrcodeCountLimit(0);
					}
					
					affectCount = userService.insertSelective(user);
					
				}
				
				if(affectCount == 1) {
					result.put("code", "00");
					result.put("msg", "保存成功！");
				}else {
					result.put("code", "99");
					result.put("msg", "保存失败！");
				}
				
			}else {
				result.put("code", "99");
				result.put("msg", "参数无效！");
			}
			
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "保存失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteUser(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			
			int deleteCount = userService.deleteByPrimaryKey(id);
			if(deleteCount == 1){
				result.put("code", "00");
				result.put("msg", "删除成功！");
			}else{
				result.put("code", "99");
				result.put("msg", "删除失败！");
			}
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "删除失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	
	@RequestMapping(value = "updateStatus", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateStatus(Integer id, Integer status, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> rsult = new HashMap<>();
		try {
			
			User record = new User();
			record.setId(id);
			record.setStatus((byte)status.intValue());
			int flag = userService.updateByPrimaryKeySelective(record);
			if(flag == 1) {
				rsult.put("code", "00");
				rsult.put("msg", "修改状态成功！");
			}else{
				rsult.put("code", "99");
				rsult.put("msg", "修改状态失败！");
			}
		} catch (Exception e) {
			rsult.put("code", 99);
			rsult.put("msg", "修改状态失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return rsult;
	}
	
	
	@RequestMapping(value = "resetpwd", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> resetpwd(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> rsult = new HashMap<>();
		try {
			
			User record = new User();
			record.setId(id);
			record.setPassword(EncryptionTool.MD5("123456"));
			int flag = userService.updateByPrimaryKeySelective(record);
			if(flag == 1) {
				rsult.put("code", "00");
				rsult.put("msg", "重置密码成功！");
			}else{
				rsult.put("code", "99");
				rsult.put("msg", "重置密码失败！");
			}
		} catch (Exception e) {
			rsult.put("code", 99);
			rsult.put("msg", "重置密码失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return rsult;
	}
	
	@RequestMapping(value = "updateprovider", method = RequestMethod.GET)
	public String updateProvider(Integer id,HttpServletRequest request, HttpServletResponse response, Model model){
		User user = userService.selectByPrimaryKey(id);
		model.addAttribute("user", user);
		return "backend/merchant/updateprovider";
	}

}
