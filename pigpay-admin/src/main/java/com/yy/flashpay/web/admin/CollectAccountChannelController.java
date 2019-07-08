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

import com.yy.flashpay.entity.CollectAccountChannel;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.ICollectAccountChannelService;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.web.BaseController;
@Controller
@RequestMapping(value="/admin/p2_acct_channel")
public class CollectAccountChannelController extends BaseController{

	private Logger logger = Logger.getLogger(CollectAccountChannelController.class);
	
	@Autowired
	private ICollectAccountChannelService p2AccountChannelService;
	
	
	@RequestMapping(value = "list", method = RequestMethod.GET)
	public String list(HttpServletRequest request, HttpServletResponse response){
		return "backend/p2_acct_channel/list";
	}
	
	
	@RequestMapping(value = "list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loadList(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page<CollectAccountChannel> page = new Page<CollectAccountChannel>();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			
			CollectAccountChannel p2AccountChannel = new CollectAccountChannel();
			p2AccountChannel.setChannelName(request.getParameter("name"));
			p2AccountChannel.setChannelAccount(request.getParameter("account"));
			if(StringUtils.isNotEmpty(request.getParameter("status"))){
				p2AccountChannel.setStatus((byte)NumberUtils.toInt(request.getParameter("status")));
			}
			page.setObjectT(p2AccountChannel);
			page = p2AccountChannelService.getList(page);
			
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
		return "backend/p2_acct_channel/add";
	}
	
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String update(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		CollectAccountChannel p2Account = p2AccountChannelService.selectByPrimaryKey(id);
		model.addAttribute("channel", p2Account);
		model.addAttribute("mid", id);
		return "backend/p2_acct_channel/update";
	}
	
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(CollectAccountChannel accountChannel, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> result = new HashMap<>();
		try {
			if(accountChannel != null) {
				
				int affectCount = 0;
				if(accountChannel.getId() != null && accountChannel.getId() > 0){
					accountChannel.setUpdateTime(new Date());
					affectCount = p2AccountChannelService.updateByPrimaryKeySelective(accountChannel);
				}else{
					accountChannel.setCreateTime(new Date());
					affectCount = p2AccountChannelService.insert(accountChannel);
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
	public Map<String, String> delete(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			int deleteCount = p2AccountChannelService.deleteByPrimaryKey(id);
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
			CollectAccountChannel record = new CollectAccountChannel();
			record.setId(id);
			record.setStatus(status == null? null : (byte)status.intValue());
			int flag = p2AccountChannelService.updateByPrimaryKeySelective(record);
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
	
}
