package com.yy.flashpay.web.admin;

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

import com.yy.flashpay.entity.AppIssue;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.IAppControllerService;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping("/admin/app")
public class AppController extends BaseController{
	private Logger logger = Logger.getLogger(MerchantController.class);
	@Autowired
	private IAppControllerService appControllerService;
	
	@RequestMapping("/index")
	public String index() {
		return "backend/app/index";
	}
	
	
	@RequestMapping("/download")
	public String download(Model model) {
		List<AppIssue> list = appControllerService.getApplatestVersion();
		AppIssue appIssue = null;
		if(list != null && !list.isEmpty()) {
			appIssue = list.get(0);
		}
		model.addAttribute("appIssue", appIssue);
		return "backend/app/download";
	}
	
	@RequestMapping("/add")
	public String add() {
		return "backend/app/add";
	}
	
	@RequestMapping("/update")
	public String update() {
		return "backend/app/update";
	}
	
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(String title,String version,String url,String info,Boolean forceInstall, String pubUser, AppIssue merchantInfo,HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> result = new HashMap<>();
		try {
			if(merchantInfo != null) {
			int affectCount = 0;
			if(merchantInfo.getId() != null && merchantInfo.getId() > 0){
//				merchantInfo.setUpdateTime(new Date());
				affectCount = appControllerService.updateByPrimaryKeySelective(merchantInfo);
			
			}else {
			if(StringUtils.isEmpty(title)) {
				result.put("code", "00");
				result.put("msg", "标题不能为空");
				return result;
			}
			if(StringUtils.isEmpty(version)) {
				result.put("code", "00");
				result.put("msg", "版本号不能为空");
				return result;
			}else {
			List merchant = appControllerService.getAppIssueByVersion(version);
			if(merchant.size() !=0) {
				result.put("code", "00");
				result.put("msg", "版本号已存在");
				return result;
			}
			if(StringUtils.isEmpty(url)) {
				result.put("code", "00");
				result.put("msg", "下载地址不能为空");
				return result;
			}
			if(StringUtils.isEmpty(info)) {
				result.put("code", "00");
				result.put("msg", "请填写升级说明");
				return result;
			}
			
			System.out.println(merchant);
			AppIssue appissue = new AppIssue();
			appissue.setTitle(title);
			appissue.setVersion(version);
			appissue.setUrl(url);
			appissue.setInfo(info);
			appissue.setCreateTime(new Date());  //创建时间
			appissue.setPubStatus(false);  //是否发布
			appissue.setForceInstall(forceInstall);
			appissue.setPubUser(pubUser);
			affectCount=appControllerService.insert(appissue);
			}
			}
			if(affectCount == 1) {
				result.put("code", "001");
				result.put("msg", "保存版本成功！");
			}else {
				result.put("code", "99");
				result.put("msg", "保存版本失败！");
			}
			
			}
		}catch (Exception e) {
			
		}
		
		return result;

}

	@RequestMapping(value = "list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> AppclonterList1(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page<AppIssue> page = new Page<AppIssue>();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 30);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			AppIssue appissue = new AppIssue();
			appissue.setVersion(request.getParameter("version"));
			page.setObjectT(appissue);
			page = appControllerService.getList(page);
			
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
	
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String update(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		AppIssue appIssue = appControllerService.selectByPrimaryKey(id);
		model.addAttribute("appIssue", appIssue);
		model.addAttribute("mid", id);
		return "backend/app/update";
	}
	
	@RequestMapping(value = "delete", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteChannel(Integer id, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			int deleteCount = appControllerService.deleteByPrimaryKey(id);
			if(deleteCount == 1){
				result.put("code", "00");
				result.put("msg", "删除版本成功！");
			}else{
				result.put("code", "99");
				result.put("msg", "删除版本失败！");
			}
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "删除版本失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	//
	@RequestMapping(value = "issue", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> issueChannel(Integer id, HttpServletRequest request, HttpServletResponse response){
		AppIssue appissue = new AppIssue();
		appissue.setId(id);
		Map<String, String> result = new HashMap<String, String>();
		try {
			AppIssue appIssue = appControllerService.selectByPrimaryKey(id);
			if(appIssue.getPubStatus() == false) {
				appissue.setPubStatus(true); //未发布
				appissue.setPubTime(new Date());
			}
			int deleteCount = appControllerService.issueByPrimaryKey(appissue);
			if(deleteCount == 1){
				result.put("code", "00");
				result.put("msg", "发布版本成功！");
			}else{
				result.put("code", "99");
				result.put("msg", "发布版本失败！");
			}
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "发布版本失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
}
