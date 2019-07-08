package com.yy.flashpay.web.admin;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.yy.flashpay.entity.CollectAccountChannel;
import com.yy.flashpay.entity.CollectionQrcode;
import com.yy.flashpay.entity.CollectionQrcodeExample;
import com.yy.flashpay.page.Page;
import com.yy.flashpay.service.ICollectAccountChannelService;
import com.yy.flashpay.service.ICollectAccountService;
import com.yy.flashpay.service.ICollectQrcodeService;
import com.yy.flashpay.util.EncryptionTool;
import com.yy.flashpay.util.LoggerUtil;
import com.yy.flashpay.util.QRCodeOCR;
import com.yy.flashpay.util.StringUtil;
import com.yy.flashpay.util.json.DateUtil;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping(value="/admin/collect_qrcode")
public class CollectQrcodeController extends BaseController{
	
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private ICollectAccountService p2AccountService;
	@Autowired
	private ICollectAccountChannelService p2AccountChannelService;
	
	@Autowired
	private ICollectQrcodeService p2QrcodeService;
	
	@RequestMapping(value = "list", method = RequestMethod.GET)
	public String list(Integer accountId, HttpServletRequest request, HttpServletResponse response, Model model){
		
		Integer channelId = NumberUtils.toInt(request.getParameter("channelId"));
		List<CollectAccountChannel> channles = p2AccountChannelService.getAccountChannels(accountId);
		if(channelId == 0 && channles != null && !channles.isEmpty()){
			channelId = channles.get(0).getId();
		}
		model.addAttribute("accountId", accountId);
		model.addAttribute("channelId", channelId);
		model.addAttribute("channles", channles);
		return "backend/qrcode/list";
	}
	
	@RequestMapping(value = "list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loadList(Integer channelId, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Page<CollectionQrcode> page = new Page<CollectionQrcode>();
			Integer start = NumberUtils.toInt(request.getParameter("start"), 0);
	    	Integer lendth = NumberUtils.toInt(request.getParameter("length"), 10);
	    	int pageNum  = start/lendth + 1;
			page.getPage().setCurrentPage(pageNum);
			page.getPage().setPageSize(lendth);
			CollectionQrcode p2Qrcode = new CollectionQrcode();
			
			String status = request.getParameter("status");
			if(StringUtils.isNotEmpty(status)){
				p2Qrcode.setStatus(NumberUtils.toByte(status));
			}
			
			String remark = request.getParameter("remark");
			String amount = request.getParameter("amount");
			
			if(StringUtils.isNotEmpty(remark)) {
				p2Qrcode.setRemark(remark);
			}
			if(StringUtils.isNotEmpty(amount)) {
				p2Qrcode.setAmount(NumberUtils.toInt(amount));
			}
			
			p2Qrcode.setChannelId(channelId);
			
			page.setObjectT(p2Qrcode);
			page.setOrderClause(getOrderClause(request));
			
			page = p2QrcodeService.getList(page);
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
	public String add(HttpServletRequest request,Integer channelId, HttpServletResponse response, Model model){
		CollectAccountChannel channel = p2AccountChannelService.selectByPrimaryKey(channelId);
		model.addAttribute("channel", channel);
		return "backend/qrcode/add";
	}
	
	
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String update(Integer id, HttpServletRequest request, HttpServletResponse response, Model model){
		CollectionQrcode p2Qrcode = p2QrcodeService.selectByPrimaryKey(id);
		CollectAccountChannel accountChannel = p2AccountChannelService.selectByPrimaryKey(p2Qrcode.getChannelId());
		model.addAttribute("p2Qrcode", p2Qrcode);
		model.addAttribute("accountChannel", accountChannel);
		return "backend/qrcode/update";
	}
	
	
	@RequestMapping(value = "save", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(CollectionQrcode p2Qrcode, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> result = new HashMap<>();
		try {
			if(p2Qrcode != null) {
				if(p2Qrcode.getId() != null) {
					try {
						p2Qrcode.setStatus((byte)1);
						p2Qrcode.setCollectStatus((byte)1);
						int updated = p2QrcodeService.updateByPrimaryKeySelective(p2Qrcode);
						result.put("code", "00");
						result.put("msg", "保存成功！");
					}catch(Exception e) {
						result.put("code", "99");
						result.put("msg", e.getMessage());
					}
				}else{
					
					try {
						p2Qrcode.setStatus((byte)1);
						p2Qrcode.setCollectStatus((byte)1);
						int inserted = p2QrcodeService.insert(p2Qrcode);
						result.put("code", "00");
						result.put("msg", "保存成功！");
					}catch(Exception e) {
						e.printStackTrace();
						result.put("code", "99");
						result.put("msg", e.getMessage());
					}
					
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
	
	@RequestMapping(value = "saveAll", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveAll(Integer channelId, String data, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> result = new HashMap<>();
		try {
			if(channelId != null && channelId > 0) {
					try {
						CollectAccountChannel accountChannel = p2AccountChannelService.selectByPrimaryKey(channelId);
						JSONArray dataList = JSON.parseArray(data);
						CollectionQrcode qrcode = null;
						for (int i = 0; i < dataList.size(); i++) {
							JSONObject dataJSON = dataList.getJSONObject(i);
							qrcode = new CollectionQrcode();
							qrcode.setQrcodeUrl(dataJSON.getString("qrcodeUrl"));
							qrcode.setQrcodeData(dataJSON.getString("qrcodeData"));
							qrcode.setAccountId(accountChannel.getAccountId());
							qrcode.setChannelId(accountChannel.getId());
							qrcode.setCreateTime(new Date());
							BigDecimal qrMoney = new BigDecimal(dataJSON.getString("money"));
							qrcode.setMoney(qrMoney);
							qrcode.setAmount(qrMoney.intValue());
							qrcode.setRemark(dataJSON.getString("remark"));
							qrcode.setStatus((byte)1);
							qrcode.setCollectStatus((byte)1);
							p2QrcodeService.insertSelective(qrcode);
						}
						
						result.put("code", "00");
						result.put("msg", "保存成功！");
					}catch(Exception e) {
						logger.error("保存二维码失败", e);
						result.put("code", "99");
						result.put("msg", "保存失败");
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
		String basePath = request.getServletContext().getRealPath("/");
		try {
			CollectionQrcode qrcode = p2QrcodeService.selectByPrimaryKey(id);
			
			int deleteCount = p2QrcodeService.deleteByPrimaryKey(id);
			
			if(deleteCount == 1){
				File file = new File(basePath, qrcode.getQrcodeUrl());
				if(file.exists()) {
					file.delete();
				}
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
	
	@RequestMapping(value = "deleteAll", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteAll(Integer channelId, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		String basePath = request.getServletContext().getRealPath("/");
		try {
			
			int deleteCount = p2QrcodeService.deleteAllByChannelId(basePath, channelId);
			
			if(deleteCount >= 1){
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
	public Map<String, String> upstatus(Integer id, String status, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			CollectionQrcode  collectQrcode = new  CollectionQrcode();
			collectQrcode.setId(id);
			collectQrcode.setStatus(NumberUtils.toByte(status));
			int deleteCount = p2QrcodeService.updateByPrimaryKeySelective(collectQrcode);
			if(deleteCount == 1){
				result.put("code", "00");
				result.put("msg", "操作成功！");
			}else{
				result.put("code", "99");
				result.put("msg", "操作失败！");
			}
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "操作失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	}
	
	
	
	@RequestMapping(value = "batchUpdate", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> batchUse(String ids, String status, HttpServletRequest request, HttpServletResponse response){
		Map<String, String> result = new HashMap<String, String>();
		try {
			if(!StringUtil.isNullOrEmpty(ids)) {
				String[] idArr = ids.split(",");
				for(int i=0;i<idArr.length;i++){
					CollectionQrcode record = new CollectionQrcode();
					record.setStatus(NumberUtils.toByte(status));
					CollectionQrcodeExample example = new CollectionQrcodeExample();
					example.createCriteria().andIdEqualTo(Integer.parseInt(idArr[i]));
					p2QrcodeService.updateByExample(record, example);
				}
				result.put("code", "00");
				result.put("msg", "操作成功！");
			}else{
				result.put("code", "99");
				result.put("msg", "参数错误！");
			}
			
		} catch (Exception e) {
			result.put("code", "99");
			result.put("msg", "操作失败！");
			e.printStackTrace();
			LoggerUtil.printExceptionLog(logger,e);
		}
		return result;
	} 
	
	
	
	
	@RequestMapping(value="/upload", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(HttpServletRequest request,HttpServletResponse response) {
		
		String basePath = request.getServletContext().getRealPath("/");
		String savePath  = "uploads/qrcode/" + DateUtil.getStringOfNowDate("YYMMdd")+"/";
		String uploadpath = basePath + savePath;
		File fileupload = new File(uploadpath);
		if(!fileupload.exists()){
			fileupload.mkdirs();
		}
		
		String payType = request.getParameter("payType");
		
		Map<String, Object> result = new HashMap<String, Object>();
		List<Map<String, Object>> fileInfos = new ArrayList<Map<String, Object>>();
		try {
			CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());  
			if(multipartResolver.isMultipart(request)){
				 MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;
				 Iterator<String> it = multiRequest.getFileNames();
				 MultipartFile file = null;
				 String ext = "";
				 String originalFilename;
				 File localFile;
				 String newFilename;
				 Map<String, Object> uploadinfo = new HashMap<String, Object>();
				 while(it.hasNext()){
					  file = multiRequest.getFile(it.next());
					  if(file != null){
						  originalFilename = file.getOriginalFilename();
						  ext = originalFilename.substring(originalFilename.lastIndexOf("."));
						  newFilename = EncryptionTool.MD5(originalFilename+System.currentTimeMillis());
						  localFile = new File(uploadpath + newFilename + ext);  
		                  file.transferTo(localFile);
		                  
		                  uploadinfo.put("path", savePath+newFilename+ext);
		                  uploadinfo.put("name", originalFilename);
		                  // 识别二维码数据
		                  try {
		                	  Map<String, String> qrMap = new HashMap<String, String>();
		                	  if("10".equals(payType)){
		                		  qrMap = QRCodeOCR.getWechatQrcodeInfo(localFile);
		                	  }else if("12".equals(payType)){
		                		  qrMap = QRCodeOCR.getAlipayQrcodeInfo(localFile);
		                	  }
		                	  uploadinfo.put("qrcode", qrMap);
		                  }catch (Exception e) {
		                	  e.printStackTrace();
		                  }
		                 
		                  
		                  fileInfos.add(uploadinfo);
					  }
				 }
			}
			
			result.put("success", true);
			result.put("msg", "上传成功");
			result.put("data", fileInfos);
		
		}catch (Exception e){
			result.put("success", false);
			result.put("msg", "上传失败");
			result.put("data", e.getMessage());
		}
		return result;
	}
	
	@RequestMapping(value="/deleteQrcodeFile", method=RequestMethod.POST)
	@ResponseBody
	public String deleteQrcodeFile(HttpServletRequest request,HttpServletResponse response) {
		String basePath = request.getServletContext().getRealPath("/");
		String filepath = request.getParameter("path");
		File file = new File(basePath, filepath);
		if(file.exists()) {
			file.delete();
		}
		Map<String, String> result = new HashMap<String, String>();
		result.put("code", "1");
		result.put("msg", "ok");
		return JSON.toJSONString(result);
		
	}
	
	
	
}
