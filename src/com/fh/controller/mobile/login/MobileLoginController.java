package com.fh.controller.mobile.login;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.system.User;
import com.fh.service.system.buttonrights.ButtonrightsManager;
import com.fh.service.system.fhbutton.FhbuttonManager;
import com.fh.service.system.fhlog.FHlogManager;
import com.fh.service.system.user.UserManager;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.DateUtil;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;
import com.fh.util.Tools;

/**
 * 说明：手机端总入口
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
@Controller
@RequestMapping(value="/mobile")
public class MobileLoginController extends BaseController {
	
	@Resource(name="userService")
	private UserManager userService;
	@Resource(name="buttonrightsService")
	private ButtonrightsManager buttonrightsService;
	@Resource(name="fhbuttonService")
	private FhbuttonManager fhbuttonService;
	@Resource(name="fhlogService")
	private FHlogManager FHLOG;
	
	/**访问登录页
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/login")
	public ModelAndView toLogin()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		mv.setViewName("mobile/login");
		mv.addObject("pd",pd);
		return mv;
	}
	
	/**请求登录，验证用户
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/login_login" ,produces="application/json;charset=UTF-8")
	@ResponseBody
	public Object login()throws Exception{
		Map<String,String> map = new HashMap<String,String>();
		PageData pd = new PageData();
		pd = this.getPageData();
		String errInfo = "";
		String KEYDATA[] = pd.getString("KEYDATA").replaceAll("qq313596790fh", "").split(",fh,");
		if(null != KEYDATA && KEYDATA.length == 2){
			String USERNAME = KEYDATA[0];	//登录过来的用户名
			String PASSWORD  = KEYDATA[1];	//登录过来的密码
			pd.put("USERNAME", USERNAME);
			String passwd = new SimpleHash("SHA-1", USERNAME, PASSWORD).toString();	//密码加密
			pd.put("PASSWORD", passwd);
			pd = userService.getUserByNameAndPwd(pd);	//根据用户名和密码去读取用户信息
			if(pd != null){
				Session session = Jurisdiction.getSession();
				this.removeSession(USERNAME);//请缓存
				pd.put("LAST_LOGIN",DateUtil.getTime().toString());
				userService.updateLastLogin(pd);
				User user = new User();
				user.setUSER_ID(pd.getString("USER_ID"));
				user.setUSERNAME(pd.getString("USERNAME"));
				user.setPASSWORD(pd.getString("PASSWORD"));
				user.setNAME(pd.getString("NAME"));
				user.setRIGHTS(pd.getString("RIGHTS"));
				user.setROLE_ID(pd.getString("ROLE_ID"));
				user.setLAST_LOGIN(pd.getString("LAST_LOGIN"));
				user.setIP(pd.getString("IP"));
				user.setSTATUS(pd.getString("STATUS"));
				session.setAttribute(Const.SESSION_USER, user);			//把用户信息放session中
				//shiro加入身份验证
				Subject subject = SecurityUtils.getSubject(); 
			    UsernamePasswordToken token = new UsernamePasswordToken(USERNAME, PASSWORD); 
			    try { 
			        subject.login(token); 
			    } catch (AuthenticationException e) { 
			    	errInfo = "身份验证失败！";
			    }
			}else{
				errInfo = "usererror"; 				//用户名或密码有误
				logBefore(logger, USERNAME+"手机端登录系统密码或用户名错误");
				FHLOG.save(USERNAME, "手机端登录系统密码或用户名错误");
			}
			if(Tools.isEmpty(errInfo)){
				errInfo = "success";					//验证成功
				FHLOG.save(USERNAME, "手机端登录系统");
			}
		}else{
			errInfo = "error";	//缺少参数
		}
		map.put("result", errInfo);
		return AppUtil.returnObject(new PageData(), map);
	}
	
	/**登录成功后访问的页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/main")
	public ModelAndView main()throws Exception{
		ModelAndView mv = this.getModelAndView();
		try{
			Session session = Jurisdiction.getSession();
			User user = (User)session.getAttribute(Const.SESSION_USER);						//读取session中的用户信息(单独用户信息)
			if (user != null) {
				User userr = (User)session.getAttribute(Const.SESSION_USERROL);				//读取session中的用户信息(含角色信息)
				if(null == userr){
					user = userService.getUserAndRoleById(user.getUSER_ID());				//通过用户ID读取用户信息和角色信息
					session.setAttribute(Const.SESSION_USERROL, user);						//存入session	
				}else{
					user = userr;
				}
				String USERNAME = user.getUSERNAME();
				session.setAttribute(Const.SESSION_USERNAME, USERNAME);						//放入用户名到session
				session.setAttribute(Const.SESSION_U_NAME, user.getNAME());					//放入用户姓名到session
				
				if(null == session.getAttribute(USERNAME + Const.SESSION_QX)){
					session.setAttribute(USERNAME + Const.SESSION_QX, this.getUQX(USERNAME));	//主职角色按钮权限放到session中
				}
				
				
				mv.setViewName("mobile/index");
			}else {
				mv.setViewName("mobile/login");												//session失效后跳转登录页面
			}
		} catch(Exception e){
			mv.setViewName("system/index/login");
		}
		return mv;
	}
	
	/**获取用户权限
	 * @param session
	 * @return
	 */
	public Map<String, String> getUQX(String USERNAME){
		PageData pd = new PageData();
		Map<String, String> map = new HashMap<String, String>();
		try {
			pd.put(Const.SESSION_USERNAME, USERNAME);
			PageData userpd = new PageData();
			userpd = userService.findByUsername(pd);	//通过用户名获取用户信息
			String ROLE_ID = userpd.get("ROLE_ID").toString();
			String ROLE_IDS = userpd.getString("ROLE_IDS");
			pd.put("ROLE_ID", ROLE_ID);					//获取角色ID
			List<PageData> buttonQXnamelist = new ArrayList<PageData>();
			if("admin".equals(USERNAME)){
				buttonQXnamelist = fhbuttonService.listAll(pd);						//admin用户拥有所有按钮权限
			}else{
				if(Tools.notEmpty(ROLE_IDS)){//(主副职角色综合按钮权限)
					ROLE_IDS = ROLE_IDS + ROLE_ID;
					String arryROLE_ID[] = ROLE_IDS.split(",fh,");
					buttonQXnamelist = buttonrightsService.listAllBrAndQxnameByZF(arryROLE_ID);
				}else{	//(主职角色按钮权限)
					buttonQXnamelist = buttonrightsService.listAllBrAndQxname(pd);	//此角色拥有的按钮权限标识列表
				}
			}
			for(int i=0;i<buttonQXnamelist.size();i++){
				map.put(buttonQXnamelist.get(i).getString("QX_NAME"),"1");			//按钮权限
			}
		} catch (Exception e) {
		}	
		return map;
	}
	
	/**
	 * 用户注销
	 * @param session
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/logout")
	public ModelAndView logout() throws Exception{
		String USERNAME = Jurisdiction.getUsername();	//当前登录的用户名
		FHLOG.save(USERNAME, "手机端退出系统");
		ModelAndView mv = this.getModelAndView();
		this.removeSession(USERNAME);					//清缓存
		//shiro销毁登录
		Subject subject = SecurityUtils.getSubject(); 
		subject.logout();
		mv.setViewName("mobile/login");
		return mv;
	}
	
	/**
	 * 清理session
	 */
	public void removeSession(String USERNAME){
		Session session = Jurisdiction.getSession();	//以下清除session缓存
		session.removeAttribute(Const.SESSION_USER);
		session.removeAttribute(USERNAME + Const.SESSION_ROLE_RIGHTS);
		session.removeAttribute(USERNAME + Const.SESSION_QX);
		session.removeAttribute(Const.SESSION_userpds);
		session.removeAttribute(Const.SESSION_USERNAME);
		session.removeAttribute(Const.SESSION_U_NAME);
		session.removeAttribute(Const.SESSION_USERROL);
		session.removeAttribute(Const.SESSION_RNUMBERS);
		session.removeAttribute("DEPARTMENT_IDS");
		session.removeAttribute("DEPARTMENT_ID");
	}
	
}
