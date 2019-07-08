package com.yy.flashpay.web.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yy.flashpay.web.BaseController;

@Controller
@RequestMapping(value="/admin/role")
public class RoleController extends BaseController{
//	private Logger logger = Logger.getLogger(RoleController.class);
//	@Autowired
//	private IRoleService roleService;
//	
//	
//	@RequestMapping(value="roleSearch",method=RequestMethod.GET) 
//	public String roleSearch(){
//		return "Permissions/new_roleManagement";
//	}
//	
//	/**
//	 * @description:查找角色列表
//	 * @author     :CJ
//	 * @date       :2015-09-15
//	 * @return
//	 * @throws MalformedURLException 
//	 * @throws Exception
//	 */
//	@SuppressWarnings("unchecked")
//	@RequestMapping(value="getRole", method=RequestMethod.GET)
//	@ResponseBody
//	public void getRole(HttpServletRequest request,HttpServletResponse response){
//		try {
//			logger.info("进入getRole方法,查询角色列表");
//			logger.info("接收到参数"+LoggerUtil.getRequestParam(request));
//			//获取前端查询参数
//	        String page = request.getParameter("page");
//			String name = request.getParameter("name");
//			String type = request.getParameter("type");
//			Page<Role> rolePage = new Page<Role>();
//			//设置当前页数
//			rolePage.getPage().setCurrentPage(Integer.parseInt(page));
//			//设置每页的记录数
//			rolePage.getPage().setPageSize(Constant.pageSize);
//			
//			Role role =new Role();
//			//设置查询条件
//			role.setName(name);
//			if(!StringUtil.isEmpty(type)){
//				role.setType(Integer.parseInt(type));
//			}
//			rolePage.setObjectT(role);
//			//调用service查询方法
//			rolePage = roleService.getRole(rolePage);
//			//通过JSON传值到前端
//			HtmlUtil.writerJson(response, rolePage);
//		} catch (Exception e) {
//			e.printStackTrace();
//			LoggerUtil.printExceptionLog(logger, e);
//		}
//	}
//	/**
//	 * @description:得到角色类型
//	 * @author     :CJ
//	 * @date       :2015-09-15
//	 * @return
//	 * @throws MalformedURLException 
//	 * @throws Exception
//	 */
//	@SuppressWarnings("unchecked")
//	@RequestMapping(value="getRoleType",method=RequestMethod.GET)
//	@ResponseBody
//	public List<Map> getRoleType() throws MalformedURLException{
//		//查询角色类型
//		return roleService.getRoleType();
//	}
//	/**
//	 * @description:新增角色
//	 * @author     :CJ
//	 * @date       :2015-10-05
//	 * @return
//	 * @throws Exception
//	 */
//	@RequestMapping(value="addRole",method=RequestMethod.POST)
//	public void addRole(HttpServletRequest request,HttpServletResponse response){
//		try {
//			logger.info("进入addRole方法,添加角色");
//			logger.info("接收到参数"+LoggerUtil.getRequestParam(request));
//	        String name = request.getParameter("role_name");
//			String type = request.getParameter("role_type");
//			String state = request.getParameter("role_state");
//			HttpSession session = request.getSession(true);
//			String merchantId =session.getAttribute("merchantId").toString();
//			
//			Map<String, String> comunication=new HashMap<String,String>();
//			comunication.put("name", name);
//			comunication.put("type", type);
//			comunication.put("state", state);
//			comunication.put("merchantId", merchantId);
//			
//			String msg = "";
//			int i = roleService.addRole(comunication);
//			if(i>0){
//				msg = "1";
//			}else{
//				msg = "0";
//			}
//			HtmlUtil.writerHtml(response, msg);
//		} catch (Exception e) {
//			e.printStackTrace();
//			LoggerUtil.printExceptionLog(logger, e);
//		}
//	}
//	/**
//	 * @description:修改角色
//	 * @author     :CJ
//	 * @date       :2015-10-05
//	 * @return
//	 * @throws Exception
//	 */
//	@RequestMapping(value="updateRole",method=RequestMethod.POST)
//	public void updateRole(HttpServletRequest request,HttpServletResponse response){
//		try {
//			logger.info("进入updateRole方法,修改角色");
//			logger.info("接收到参数"+LoggerUtil.getRequestParam(request));
//			//获取前端参数
//	        String id = request.getParameter("id");
//	        String name = request.getParameter("role_name");
//			String type = request.getParameter("role_type");
//			String state = request.getParameter("role_state");
//			//获取用户ID
//			HttpSession session = request.getSession(true);
//			String merchantId =session.getAttribute("merchantId").toString();
//			
//			Map<String, String> comunication=new HashMap<String,String>();
//			comunication.put("id", id);
//			comunication.put("name", name);
//			comunication.put("type", type);
//			comunication.put("state", state);
//			comunication.put("merchantId", merchantId);
//			
//			String msg = "";
//			int i = roleService.updateRole(comunication);
//			if(i>0){
//				msg = "1";
//			}else{
//				msg = "0";
//			}
//			HtmlUtil.writerHtml(response, msg);
//		} catch (Exception e) {
//			e.printStackTrace();
//			LoggerUtil.printExceptionLog(logger, e);
//		}
//	}
//	/**
//	 * @description:删除角色
//	 * @author     :CJ
//	 * @date       :2015-10-05
//	 * @return
//	 * @throws Exception
//	 */
//	@RequestMapping(value="deleteRoleById",method=RequestMethod.POST)
//	public void deleteRoleById(HttpServletRequest request,HttpServletResponse response)throws Exception{
//		try {
//			logger.info("进入deleteRoleById方法,删除角色");
//			logger.info("接收到参数"+LoggerUtil.getRequestParam(request));
//			
//			//获取角色ID
//	        String id = request.getParameter("id").toString();
//			
//			String msg = "";
//			int i = roleService.deleteRoleById(id);
//			if(i>0){
//				msg = "1";
//			}else{
//				msg = "0";
//			}
//		
//			HtmlUtil.writerHtml(response, msg);
//		} catch (Exception e) {
//			e.printStackTrace();
//			LoggerUtil.printExceptionLog(logger, e);
//		}
//	}
//	/**
//	 * @description:获取模块列表
//	 * @author     :zhenghaibing
//	 * @date       :2015-10-05
//	 * @param request
//	 * @param response
//	 * @return
//	 * @throws Exception
//	 */
//	@SuppressWarnings("unchecked")
//	@RequestMapping(value="getModuleList",method=RequestMethod.GET)
//	@ResponseBody
//	public List getModuleList(HttpServletRequest request,HttpServletResponse response)throws Exception{
//		logger.info("进入getModuleList方法,获取菜单按钮列表用于授权");
//		logger.info("接收到参数"+LoggerUtil.getRequestParam(request));
//		String roleId = request.getParameter("roleId");
//		//通过角色ID获取角色的权限菜单
//		return roleService.getModuleList(roleId);
//	}
//	
//	/**
//	 * @description:设置用户权限
//	 * @author     :CJ
//	 * @date       :2015-10-08
//	 * @return
//	 * @throws Exception
//	 */
//	@RequestMapping(value="savePermissions",method=RequestMethod.POST)
//	@SuppressWarnings("unchecked")
//	public void savePermissions(HttpServletRequest request,HttpServletResponse response){
//		try {
//			logger.info("进入savePermissions方法,保存角色授权信息");
//			logger.info("接收到参数"+LoggerUtil.getRequestParam(request));
//			
//			HttpSession session = request.getSession(true);
//			Map<String, Object> merchantInfo = (Map<String, Object>)session.getAttribute("merchant");
//			
//	        String id = request.getParameter("id");
//			String moduleIds = request.getParameter("moduleId");
//			
//			//String merchantId =session.getAttribute("merchantId").toString();
//			String merchantId = merchantInfo.get("merId") + "";
//			
//			
//			Map<String, String> comunication=new HashMap<String,String>();
//			comunication.put("id", id);
//			comunication.put("moduleIds", moduleIds);
//			comunication.put("merchantId", merchantId);	
//	        
//			String msg = "";
//			//保存角色的权限信息
//			Map<String, Object> comunicationResult=roleService.savePermissions(comunication);
//			int i = (Integer)comunicationResult.get("count");
//			//存储角色的权限信息到Session
//			Map<String,List<String>> qx = (Map<String, List<String>>)comunicationResult.get("qx") ;
//			request.getSession().setAttribute("qx", qx);
//			if(i>0){
//				msg = "1";
//			}else{
//				msg = "0";
//			}
//			
//			HtmlUtil.writerHtml(response, msg);
//		} catch (Exception e) {
//			e.printStackTrace();
//			LoggerUtil.printExceptionLog(logger, e);
//		}
//	}
	
}
