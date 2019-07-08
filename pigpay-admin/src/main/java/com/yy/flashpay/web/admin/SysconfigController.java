package com.yy.flashpay.web.admin;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.flashpay.entity.SysConfig;
import com.yy.flashpay.service.ISysConfigService;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping("/admin/sysconfig")
public class SysconfigController extends BaseController{
	@Autowired
	private ISysConfigService sysConfigService;
	
	@RequestMapping("/settings")
	public String settings(Model model) {
		
		List<SysConfig> confList = sysConfigService.findAll();
		Map<String, String> confmap = new HashMap<String, String>();
		for(SysConfig conf : confList) {
			confmap.put(conf.getItemKey(), conf.getItemValue());
		}
		model.addAttribute("conf", confmap);
		return "backend/config/settings";
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public Map<String, String> save(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		Enumeration<String> nameList = request.getParameterNames();
		
		while (nameList.hasMoreElements()) {
			String itemKey = nameList.nextElement();
			String itemValue = StringUtils.trimToEmpty(request.getParameter(itemKey));
			sysConfigService.setValue(itemKey, itemValue);
		}
		
		sysConfigService.clear();
		
		result.put("code", "00");
		result.put("msg", "配置已保存");
		
		return result;
	}
	
}
