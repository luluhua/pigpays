package com.yy.flashpay.web.admin;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Date;
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

import com.yy.flashpay.entity.CollectAccount;
import com.yy.flashpay.entity.CollectAccountChannel;
import com.yy.flashpay.entity.User;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.ICollectAccountChannelService;
import com.yy.flashpay.service.ICollectAccountService;
import com.yy.flashpay.util.DateUtils;
import com.yy.flashpay.util.EncryptionTool;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.web.BaseController;
@Controller
@RequestMapping(value="/admin/collect_account")
public class CollectAccountController extends BaseController{

	private Logger logger = Logger.getLogger(CollectAccountController.class);
	
	@Autowired
	private ICollectAccountService p2AccountService;
	
	@Autowired
	private ICollectAccountChannelService p2AccountChannelService;
	
	
	@RequestMapping(value = "list", method = RequestMethod.GET)
	public String list(HttpServletRequest request, HttpServletResponse response){
		return "backend/collect_account/list";
	}
	
	
	@RequestMapping(value = "list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loadList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page<CollectAccount> page = new Page<CollectAccount>();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			
			CollectAccount p2Account = new CollectAccount();
			p2Account.setName(request.getParameter("name"));
			if(StringUtils.isNotEmpty(request.getParameter("status"))){
				p2Account.setStatus(NumberUtils.toByte(request.getParameter("status")));
			}
			page.setObjectT(p2Account);
			page = p2AccountService.getList(page);
			
			
			List<CollectAccount> list = page.getList();
			if(list != null) {
				for(CollectAccount account : list) {
					List<CollectAccountChannel> channels = p2AccountChannelService.getAccountChannels(account.getId());
					account.setChannels(channels);
				}
			}
			
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
		return "backend/collect_account/add";
	}
	
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String update(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		CollectAccount p2Account = p2AccountService.selectByPrimaryKey(id);
		model.addAttribute("account", p2Account);
		List<CollectAccountChannel> channels = p2AccountChannelService.getAccountChannels(id);
		model.addAttribute("channels", channels);
		return "backend/collect_account/update";
	}
	
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(CollectAccount account, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> result = new HashMap<>();
		try {
			if(account != null) {
				
				String[] paymethodList = request.getParameterValues("paymethod");
				String[] collectMinLimit = request.getParameterValues("collectMinLimit");
				String[] collectMaxLimit = request.getParameterValues("collectMaxLimit");
				String[] collectTotalLimit = request.getParameterValues("collectTotalLimit");
				String[] status = request.getParameterValues("status");
				String[] ids = request.getParameterValues("chnlid");
				String[] channelName = request.getParameterValues("channelName");
				String[] payType = request.getParameterValues("payType");
				String[] payTypeName = request.getParameterValues("payTypeName");
				
				if(paymethodList != null) {
					StringBuilder sb = new StringBuilder();
					for (int i = 0; i < paymethodList.length; i++) {
						sb.append(paymethodList[i]);
						if(i < paymethodList.length - 1) {
							sb.append(",");
						}
					}
					account.setConfig(sb.toString());
				}
				
				
				int affectCount = 0;
				if(account.getId() != null && account.getId() > 0){
					String pwd = request.getParameter("pwd");
					String confirmpwd = request.getParameter("confirmpwd");
					
					if(StringUtils.isNotEmpty(pwd)) {
						if(!pwd.equals(confirmpwd)) {
							result.put("code", "99");
							result.put("msg", "两次输入密码不一致！");
							return result;
						}
						account.setPassword(EncryptionTool.MD5(pwd));
					}else {
						account.setPassword(null);
					}
					
					
					account.setUpdateTime(new Date());
					affectCount = p2AccountService.updateByPrimaryKeySelective(account);
					if(affectCount == 1) {
						p2AccountChannelService.saveChannel(ids, status, collectMinLimit, collectMaxLimit, collectTotalLimit);
					}
				}else{
					
					String pwd = request.getParameter("pwd");
					String confirmpwd = request.getParameter("confirmpwd");
					
					if(pwd == null) {
						result.put("code", "99");
						result.put("msg", "请输入登录密码！");
						return result;
					}
					if(!pwd.equals(confirmpwd)) {
						result.put("code", "99");
						result.put("msg", "两次输入密码不一致！");
						return result;
					}
					
					
					User user = (User)request.getSession().getAttribute("user");
					account.setUserId(user.getId());
					account.setTotalAmount(new BigDecimal(0));
					account.setPassword(EncryptionTool.MD5(pwd));
					account.setSecretkey(EncryptionTool.MD5(System.currentTimeMillis()+account.getName()));
					account.setLastHeartBeat(0);
					account.setCreateTime(new Date());
					account.setLoginStatus((byte)0);
					affectCount = p2AccountService.insert(account);
					
					if(affectCount == 1) {
						p2AccountChannelService.createDefaultChannel(account.getId(), channelName, payType, payTypeName, status, collectMinLimit, collectMaxLimit, collectTotalLimit);
					}
					
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
	public Map<String, String> delete(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			CollectAccount collect = p2AccountService.selectByPrimaryKey(id);
			String basePath = request.getSession().getServletContext().getRealPath("/");
			int deleteCount = p2AccountService.delAccountInfo(id,null, basePath,collect.getUserId());
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
			CollectAccount record = new CollectAccount();
			record.setId(id);
			record.setStatus(status == null ? null : (byte)status.intValue());
			int flag = p2AccountService.updateByPrimaryKeySelective(record);
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
	
	@RequestMapping(value = "editInfo", method = RequestMethod.GET)
	public String editInfo(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		CollectAccount account = p2AccountService.selectByPrimaryKey(id);
		model.addAttribute("record", account);
		String field = request.getParameter("field");
		model.addAttribute("field", field);
		return "backend/collect_account/editInfo";
	}
	
	@RequestMapping(value = "editInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveEditInfo(CollectAccount account){
		p2AccountService.updateByPrimaryKeySelective(account);
		Map<String, Object> rsult = new HashMap<>();
		rsult.put("code", "00");
		rsult.put("msg", "修改成功！");
		return rsult;
	}
	
	
	@RequestMapping(value = "editAccount", method = RequestMethod.GET)
	public String editAccount(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		CollectAccountChannel record = p2AccountChannelService.selectByPrimaryKey(id);
		model.addAttribute("record", record);
		return "backend/collect_account/editAccount";
	}
	
	@RequestMapping(value = "editAccount", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveEditAccount(CollectAccountChannel record){
		p2AccountChannelService.updateByPrimaryKeySelective(record);
		Map<String, Object> rsult = new HashMap<>();
		rsult.put("code", "00");
		rsult.put("msg", "修改成功！");
		return rsult;
	}
	
	@RequestMapping(value = "changePaymethodStatus", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changePaymethodStatus(Integer id, Integer status, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> rsult = new HashMap<>();
		try {
			CollectAccountChannel clllect = p2AccountChannelService.selectByPrimaryKey(id);
			if(clllect.getChannelAccount()==null || clllect.getChannelAccount().equals("")) {
				rsult.put("code", "999");
				rsult.put("msg", "未设置收款账号名称");
			}else {
			
			CollectAccountChannel record = new CollectAccountChannel();
			record.setId(id);
			record.setStatus((byte)status.intValue());
			int flag = p2AccountChannelService.updateByPrimaryKeySelective(record);
			if(flag == 1) {
				rsult.put("code", "00");
				rsult.put("msg", "修改状态成功");
			}else{
				rsult.put("code", "99");
				rsult.put("msg", "修改状态失败！");
			}
			}
		} catch (Exception e) {
			rsult.put("code", 99);
			rsult.put("msg", "修改状态失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return rsult;
	}

	@RequestMapping(value = "channelSetting", method = RequestMethod.GET)
	public String channelSetting(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		List<CollectAccountChannel> channels = p2AccountChannelService.getAccountChannels(id);
		model.addAttribute("channels", channels);
		return "backend/collect_account/channel_setting";
	}
	@RequestMapping(value = "channelSetting", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> channelSettingPost(HttpServletRequest request, HttpServletResponse response, Model model){
		Map<String, Object> result = new HashMap<>();
		try {
			String[] ids = request.getParameterValues("chnlid");
			String[] status = request.getParameterValues("status");
			String[] collectMinLimits = request.getParameterValues("collectMinLimit");
			String[] collectMaxLimits = request.getParameterValues("collectMaxLimit");
			String[] collectTotalLimts = request.getParameterValues("collectTotalLimit");
			
			p2AccountChannelService.saveChannel(ids, status, collectMinLimits, collectMaxLimits, collectTotalLimts);
			
			result.put("code", "00");
			result.put("msg", "设置成功");
			
		} catch (Exception e) {
			result.put("code", 99);
			result.put("msg", "通道设置失败！");
			logger.error("通道设置失败", e);
		}
		return result;
	}
	
	
	@RequestMapping(value = "dailyreport", method = RequestMethod.GET)
	public String dailyreport(String chnlAcct, String fromDate, String toDate, HttpServletRequest request, HttpServletResponse response, Model model){
		if(StringUtils.isEmpty(fromDate)) {
			fromDate = DateUtils.formatDate(new Date(), "yyyy-MM-dd");
		}
		if(StringUtils.isEmpty(toDate)) {
			toDate = DateUtils.formatDate(new Date(), "yyyy-MM-dd");
		}
		chnlAcct = StringUtils.trimToEmpty(chnlAcct);
		
		List dataList = p2AccountChannelService.dailyReport(chnlAcct, fromDate, toDate);
		
		model.addAttribute("dataList", dataList);
		model.addAttribute("chnlAcct", chnlAcct);
		model.addAttribute("fromDate", fromDate);
		model.addAttribute("toDate", toDate);
		return "backend/collect_account/dailyreport";
	}
	
	
	@RequestMapping(value = "logout", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> logout(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> rsult = new HashMap<>();
		try {
			CollectAccount record = new CollectAccount();
			record.setId(id);
			record.setLoginStatus(Byte.valueOf("0"));
			int flag = p2AccountService.updateByPrimaryKeySelective(record);
			if(flag == 1) {
				rsult.put("code", "00");
				rsult.put("msg", "退出成功！");
			}else{
				rsult.put("code", "99");
				rsult.put("msg", "退出失败！");
			}
		} catch (Exception e) {
			rsult.put("code", 99);
			rsult.put("msg", "退出失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return rsult;
	}
	
}
