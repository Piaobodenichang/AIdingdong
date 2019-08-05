package com.fh.controller.mobile.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.shiro.crypto.hash.SimpleHash;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.activiti.AcStartController;
import com.fh.entity.Page;
import com.fh.entity.system.Role;
import com.fh.service.system.fhlog.FHlogManager;
import com.fh.service.system.role.RoleManager;
import com.fh.service.system.user.UserManager;
import com.fh.service.system.userphoto.UserPhotoManager;
import com.fh.util.AppUtil;
import com.fh.util.DelAllFile;
import com.fh.util.ImageAnd64Binary;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;
import com.fh.util.PathUtil;
import com.fh.util.Tools;

/**
 * 说明：用户(手机端)
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin. org
 */
@Controller
@RequestMapping(value="/mobileuser")
public class MobileUserController extends AcStartController {
	
	@Resource(name="userService")
	private UserManager userService;
	@Resource(name="roleService")
	private RoleManager roleService;
	@Resource(name="userphotoService")
	private UserPhotoManager userphotoService;
	@Resource(name="fhlogService")
	private FHlogManager FHLOG;
	
	/**显示用户列表(弹窗选择用)
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/listUsersForWindow")
	public ModelAndView listUsersForWindow(Page page)throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String keywords = pd.getString("keywords");				//关键词检索条件
		if(null != keywords && !"".equals(keywords)){
			pd.put("keywords", keywords.trim());
		}
		String lastLoginStart = pd.getString("lastLoginStart");	//开始时间
		String lastLoginEnd = pd.getString("lastLoginEnd");		//结束时间
		if(lastLoginStart != null && !"".equals(lastLoginStart)){
			pd.put("lastLoginStart", lastLoginStart+" 00:00:00");
		}
		if(lastLoginEnd != null && !"".equals(lastLoginEnd)){
			pd.put("lastLoginEnd", lastLoginEnd+" 00:00:00");
		} 
		page.setPd(pd);
		List<PageData>	userList = userService.listUsersBystaff(page);	//列出用户列表(弹窗选择用)
		pd.put("ROLE_ID", "1");
		List<Role> roleList = roleService.listAllRolesByPId(pd);//列出所有系统用户角色
		mv.setViewName("mobile/user/window_user_list");
		mv.addObject("userList", userList);
		mv.addObject("roleList", roleList);
		mv.addObject("pd", pd);
		return mv;
	}
	
	/** 选择角色(弹窗选择用)
	 * @param 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/roleListWindow")
	public ModelAndView roleListWindow(Page page)throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String keywords = pd.getString("keywords");					//关键词检索条件
		if(null != keywords && !"".equals(keywords)){
			pd.put("keywords", keywords.trim());
		}
		page.setPd(pd);
		List<PageData> roleList = roleService.roleListWindow(page);//列出所有角色
		mv.addObject("pd", pd);
		mv.addObject("roleList", roleList);
		mv.setViewName("mobile/user/window_role_list");
		return mv;
	}
	
	/**进入修改头像页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/goEditPhoto")
	public ModelAndView goEditPhoto()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/user/user_photo");
		return mv;
	}
	
	/**保存用户头像
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/saveUserPhoto")
	@ResponseBody
	public Object saveUserPhoto() throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		String errInfo = "success";
		PageData pd = new PageData();
		pd = this.getPageData();
		String USERNAME = Jurisdiction.getUsername();//用户名
		String userphoto = "uploadFiles/uploadUserPhoto/"+USERNAME+"_photo.jpg";
		String imgData = pd.getString("PHOTODATA").replace("data:image/jpeg;base64,", "");
		String pathimg = PathUtil.getClasspath()+userphoto;
		ImageAnd64Binary.generateImage(imgData, pathimg);
		pd.put("USERNAME", USERNAME);	
		pd.put("PHOTO0", "");			//原图
		pd.put("PHOTO1", userphoto);	//头像1
		pd.put("PHOTO2", userphoto);	//头像2
		pd.put("PHOTO3", userphoto);	//头像3
		map.put("userPhoto",pd.getString("PHOTO2"));
		PageData ypd = userphotoService.findById(pd);
		if(null == ypd){				//没有数据就新增，否则就修改
			pd.put("USERPHOTO_ID", this.get32UUID());		//主键
			userphotoService.save(pd);
		}else{
			userphotoService.edit(pd);
			String PHOTO0 = ypd.getString("PHOTO0");
			String PHOTO1 = ypd.getString("PHOTO1");
			String PHOTO2 = ypd.getString("PHOTO2");
			String PHOTO3 = ypd.getString("PHOTO3");
			if(!userphoto.equals(PHOTO1)){
				if(Tools.notEmpty(PHOTO0)){
					DelAllFile.delFolder(PathUtil.getClasspath()+ PHOTO0); //删除原图
				}
				DelAllFile.delFolder(PathUtil.getClasspath()+ PHOTO1); //删除图1
				DelAllFile.delFolder(PathUtil.getClasspath()+ PHOTO2); //删除图2
				DelAllFile.delFolder(PathUtil.getClasspath()+ PHOTO3); //删除图3
			}
		}
		map.put("result", errInfo);				//返回结果
		return AppUtil.returnObject(new PageData(), map);
	}
	
	/**进入修改资料页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/goEditUser")
	public ModelAndView index()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("ROLE_ID", "1");
		List<Role> roleList = roleService.listAllRolesByPId(pd);	//列出所有系统用户角色
		pd.put("USERNAME", Jurisdiction.getUsername());
		pd = userService.findByUsername(pd);						//根据用户名读取
		mv.addObject("msg", "editU");
		mv.addObject("pd", pd);
		mv.addObject("roleList", roleList);
		mv.setViewName("mobile/user/user_info");
		return mv;
	}
	
	/**
	 * 修改用户
	 */
	@RequestMapping(value="/editU")
	public ModelAndView editU() throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		if(!Jurisdiction.getUsername().equals(pd.getString("USERNAME"))){		//如果当前登录用户修改用户资料提交的用户名非本人
			FHLOG.save(Jurisdiction.getUsername(), "恶意修改用户资料："+pd.getString("USERNAME"));
			return null;
		}else{	//如果当前登录用户修改用户资料提交的用户名是本人，则不能修改本人的角色ID
			PageData upd = new PageData();
			upd = userService.findByUsername(pd);
			pd.put("USER_ID", upd.getString("USER_ID")); //对ID还原本人ID，防止串改
			pd.put("ROLE_ID", upd.getString("ROLE_ID")); //对角色ID还原本人角色ID
			pd.put("ROLE_IDS", Tools.notEmpty(upd.getString("ROLE_IDS"))?upd.get("ROLE_IDS"):""); //对角色ID还原本人副职角色ID
		}
		if(pd.getString("PASSWORD") != null && !"".equals(pd.getString("PASSWORD"))){
			pd.put("PASSWORD", new SimpleHash("SHA-1", pd.getString("USERNAME"), pd.getString("PASSWORD")).toString());
		}
		userService.editU(pd);	//执行修改
		FHLOG.save(Jurisdiction.getUsername(), "修改个人资料："+pd.getString("USERNAME"));
		mv.addObject("msg","editUsuccess");
		mv.setViewName("mobile/user/user_center");
		return mv;
	}
	
	/**判断邮箱是否存在
	 * @return
	 */
	@RequestMapping(value="/hasE")
	@ResponseBody
	public Object hasE(){
		Map<String,String> map = new HashMap<String,String>();
		String errInfo = "success";
		PageData pd = new PageData();
		try{
			pd = this.getPageData();
			if(userService.findByUE(pd) != null){
				errInfo = "error";
			}
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
		map.put("result", errInfo);				//返回结果
		return AppUtil.returnObject(new PageData(), map);
	}
	
}
