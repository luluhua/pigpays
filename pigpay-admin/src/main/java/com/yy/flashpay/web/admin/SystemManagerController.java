package com.yy.flashpay.web.admin;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.geom.Line2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.MalformedURLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yy.flashpay.entity.User;
import com.yy.flashpay.service.ISystemManagerService;
import com.yy.flashpay.service.IUserService;
import com.yy.flashpay.util.EncryptionTool;
import com.yy.flashpay.util.StringUtil;
import com.yy.flashpay.web.BaseController;


@Controller
@RequestMapping(value="/admin/system")
public class SystemManagerController extends BaseController{
	private Logger logger = Logger.getLogger(SystemManagerController.class);
	
	@Autowired
	private ISystemManagerService systemManagerService;
	@Autowired
	private IUserService userService;


	
	@RequestMapping(value="login",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> login(String account,String password,HttpServletRequest request,HttpServletResponse response) throws MalformedURLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		String verifyCode = request.getParameter("code");
		String randCheckCode = (String) request.getSession().getAttribute("randCheckCode");
		
		if(verifyCode.equalsIgnoreCase(randCheckCode)){
			User user = systemManagerService.findByAccount(account);
			//用户类型,0系统用户,1管理用户,2用户
			if(user == null || user.getUserType() > 1) {
				map.put("code", "-1");
				map.put("msg", "用户名或密码不正确");
				return map;
			}
			if(!password.equals(user.getPassword())){
				map.put("code", "-1");
				map.put("msg", "用户名或密码不正确");
				return map;
			}
			if(user.getStatus() != null && user.getStatus() == 0){
				map.put("code", "-1");
				map.put("msg", "账户未通过审核");
				return map;
			}
			if(user.getStatus() != null && user.getStatus() == 2){
				map.put("code", "-1");
				map.put("msg", "账户已被封禁");
				return map;
			}
			// 获取当前用户
			HttpSession session = request.getSession(true);
			session.setAttribute("user", user);
			map.put("code", "1");
			map.put("msg", "ok");

		}else{
			map.put("verifyCode", 0);
		}
		return map;
	}
	
	@RequestMapping(value = "main", method = RequestMethod.GET)
	public String Main(HttpServletRequest request) throws Exception {
		String url = StringUtil.getUrl(request);
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("user");
		
		if(user == null) {
			return "redirect:/admin/";
		}

		return "backend/main";
	}
	
	//点击退出销毁当前登录的信息
	@RequestMapping(value="logout",method=RequestMethod.POST)
	@ResponseBody
	public String loginOut(String account,String password,HttpServletRequest request,HttpServletResponse response) {
		request.getSession().removeAttribute("user");
		return "1";
	}
	
	
	@RequestMapping(value="changePassword",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateAccount(HttpServletRequest request,HttpServletResponse response) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		HttpSession session = request.getSession(true);
		User user = (User)session.getAttribute("user");
		
		if(user == null) {
			map.put("code", "-1");
			map.put("msg", "非法操作");
			return map;
		}
		
		
		String opwd = (String)request.getParameter("opwd");
		if(StringUtils.isEmpty(opwd)) {
			map.put("code", "-1");
			map.put("msg", "请输入原密码");
			return map;
		}
		
		String oldpassword = EncryptionTool.MD5(opwd);
		if(!oldpassword.equals(user.getPassword())) {
			map.put("code", "-1");
			map.put("msg", "密码错误");
			return map;
		}
		
		
		String npwd = (String) request.getParameter("npwd");
		String cpwd = (String) request.getParameter("cpwd");
		
		if(StringUtils.isEmpty(npwd)) {
			map.put("code", "-1");
			map.put("msg", "请输入新密码");
			return map;
		}
		
		if(!npwd.equals(cpwd)) {
			map.put("code", "-1");
			map.put("msg", "两次输入的密码不一致");
			return map;
		}
		
		
		String newPassword = EncryptionTool.MD5(npwd);
		
		User updateUser = new User();
		updateUser.setId(user.getId());
		updateUser.setPassword(newPassword);
		int flag = userService.updateByPrimaryKeySelective(updateUser);
		if(flag == 1) {
			session.invalidate();
			map.put("code", "1");
			map.put("msg", "修改密码成功");
			
		}else{
			map.put("code", "-1");
			map.put("msg", "修改密码失败");
		}
		
		return map;
	}
	
	
	@RequestMapping(value="changePassword",method=RequestMethod.GET)
	public String changePassword(HttpServletRequest request,HttpServletResponse response) {
		return "backend/account/change_password";
	}
	
	
	/**
	 * 验证码
	 * Verify Code
	 */
	@RequestMapping("/verifyCode")
	@ResponseBody
	 public void service(HttpServletRequest request, HttpServletResponse response)  
		     throws ServletException, IOException {  
		 //设置不缓存图片  
		 response.setHeader("Pragma", "No-cache");  
		 response.setHeader("Cache-Control", "No-cache");  
		 response.setDateHeader("Expires", 0);  
		 //指定生成的响应图片,一定不能缺少这句话,否则错误.  
		 response.setContentType("image/jpeg");  
		 int width=75,height=45;     //指定生成验证码的宽度和高度  
		 BufferedImage image=new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB); //创建BufferedImage对象,其作用相当于一图片  
		 Graphics g=image.getGraphics();     //创建Graphics对象,其作用相当于画笔  
		 Graphics2D g2d=(Graphics2D)g;       //创建Grapchics2D对象  
		 Random random=new Random();  
		 Font mfont=new Font("楷体",Font.BOLD,18); //定义字体样式  
		 g.setColor(getRandColor(200,250));  
		 g.fillRect(0, 0, width, height);    //绘制背景  
		 g.setFont(mfont);                   //设置字体  
		 g.setColor(getRandColor(180,200));  
		   
		 //绘制100条颜色和位置全部为随机产生的线条,该线条为2f  
		 for(int i=0;i<100;i++){  
		     int x=random.nextInt(width-1);  
		     int y=random.nextInt(height-1);  
		     int x1=random.nextInt(6)+1;  
		     int y1=random.nextInt(12)+1;  
		     BasicStroke bs=new BasicStroke(2f,BasicStroke.CAP_BUTT,BasicStroke.JOIN_BEVEL); //定制线条样式  
		     Line2D line=new Line2D.Double(x,y,x+x1,y+y1);  
		     g2d.setStroke(bs);  
		     g2d.draw(line);     //绘制直线  
		 }  
		 //输出由英文，数字，和中文随机组成的验证文字，具体的组合方式根据生成随机数确定。  
		 String sRand="";  
		 String ctmp="";  
		 int itmp=0;  
		 //制定输出的验证码为四位  
		 for(int i=0;i<4;i++){  
		     switch(random.nextInt(3)){  
		         case 1:     //生成A-Z的字母  
		              itmp=random.nextInt(26)+65;  
		              ctmp=String.valueOf((char)itmp);  
		              break;  
		         default:  
		              itmp=random.nextInt(10)+48;  
		              ctmp=String.valueOf((char)itmp);  
		              break;  
		     }  
		     sRand+=ctmp;  
		     Color color=new Color(20+random.nextInt(110),20+random.nextInt(110),random.nextInt(110));  
		     g.setColor(color);  
		     //将生成的随机数进行随机缩放并旋转制定角度 PS.建议不要对文字进行缩放与旋转,因为这样图片可能不正常显示  
		     /*将文字旋转制定角度*/  
		     Graphics2D g2d_word=(Graphics2D)g;  
		     AffineTransform trans=new AffineTransform();  
		     trans.rotate((45)*3.14/180,15*i+8,7);  
		     /*缩放文字*/  
		     float scaleSize=random.nextFloat()+0.8f;  
		     if(scaleSize>1f) scaleSize=1f;  
		     trans.scale(scaleSize, scaleSize);  
		     g2d_word.setTransform(trans);  
		     g.drawString(ctmp, 15*i+20, 18);  
		 }  
		 HttpSession session=request.getSession(true);  
		 session.setAttribute("randCheckCode", sRand);
		 g.dispose();    //释放g所占用的系统资源  
		 ImageIO.write(image,"JPEG",response.getOutputStream()); //输出图片  
		}  
	
	   /*该方法主要作用是获得随机生成的颜色*/   
	    public Color getRandColor(int s,int e){  
	        Random random=new Random ();  
	        if(s>255) s=255;  
	        if(e>255) e=255;  
	        int r,g,b;  
	        r=s+random.nextInt(e-s);    //随机生成RGB颜色中的r值  
	        g=s+random.nextInt(e-s);    //随机生成RGB颜色中的g值  
	        b=s+random.nextInt(e-s);    //随机生成RGB颜色中的b值  
	        return new Color(r,g,b);  
	    } 
	
	
}
