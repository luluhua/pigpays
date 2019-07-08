package com.yy.flashpay.web.admin;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.yy.flashpay.util.EncryptionTool;
import com.yy.flashpay.util.json.DateUtil;
import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping("/admin/upload")
public class UploadController extends BaseController{
	@RequestMapping(value="/imgUpload", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> save(HttpServletRequest request,HttpServletResponse response) {
		
		String basePath = request.getServletContext().getRealPath("/");
		
		
		String savePath  = "uploads/" + DateUtil.getStringOfNowDate("YYMMdd")+"/";
		String uploadpath = basePath + savePath;
		File fileupload = new File(uploadpath);
		if(!fileupload.exists()){
			fileupload.mkdirs();
		}
		Map<String, Object> result = new HashMap<String, Object>();
		List<Map<String, String>> fileInfos = new ArrayList<Map<String, String>>();
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
				 Map<String, String> uploadinfo = new HashMap<String, String>();
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
		//return JSON.toJSONString(result);
		return result;
	}
	
	
	@RequestMapping(value="/upload", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> upload(HttpServletRequest request,HttpServletResponse response) {
		
		String basePath = request.getServletContext().getRealPath("/");
		
		
		String savePath  = "uploads/" + DateUtil.getStringOfNowDate("YYMMdd")+"/";
		String uploadpath = basePath + savePath;
		File fileupload = new File(uploadpath);
		if(!fileupload.exists()){
			fileupload.mkdirs();
		}
		Map<String, Object> result = new HashMap<String, Object>();
		List<Map<String, String>> fileInfos = new ArrayList<Map<String, String>>();
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
				 Map<String, String> uploadinfo = new HashMap<String, String>();
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
	
	
}
