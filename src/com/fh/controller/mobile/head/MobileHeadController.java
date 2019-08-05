package com.fh.controller.mobile.head;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.shiro.session.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fh.controller.base.BaseController;
import com.fh.entity.system.Role;
import com.fh.service.system.fhsms.FhsmsManager;
import com.fh.service.system.role.RoleManager;
import com.fh.service.system.user.UserManager;
import com.fh.service.system.userphoto.UserPhotoManager;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.Jurisdiction;
import com.fh.util.PageData;
import com.fh.util.Tools;

/**
 * 说明：手机获取基础信息
 * 作者：FH Admin Q313596790
 * 官网：www. fhadmin.org
 */
@Controller
@RequestMapping(value="/mobilehead")
public class MobileHeadController extends BaseController {
	
	@Resource(name="userService")
	private UserManager userService;	
	@Resource(name="userphotoService")
	private UserPhotoManager userphotoService;
	@Resource(name="roleService")
	private RoleManager roleService;
	@Resource(name="fhsmsService")
	private FhsmsManager fhsmsService;
	
	/**获取基本信息
	 * @return
	 */
	@RequestMapping(value="/getNowUser")
	@ResponseBody
	public Object getList() {
		PageData pd = new PageData();
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			pd = this.getPageData();
			Session session = Jurisdiction.getSession();
			PageData pds = new PageData();
			pds = (PageData)session.getAttribute(Const.SESSION_userpds);
			if(null == pds){
				pd.put(Const.SESSION_USERNAME, Jurisdiction.getUsername());//当前登录者用户名
				pds = userService.findByUsername(pd);
				session.setAttribute(Const.SESSION_userpds, pds);
			}
			map.put("user", pds);
			PageData pdPhoto = userphotoService.findById(pds);
			map.put("userPhoto", null == pdPhoto?"static/ace/avatars/user.jpg":pdPhoto.getString("PHOTO2"));//用户头像
			map.put("fhsmsCount", fhsmsService.findFhsmsCount(Jurisdiction.getUsername()).get("fhsmsCount").toString());//站内信未读总数
			String strWEBSOCKET = Tools.readTxtFile(Const.WEBSOCKET);	//读取WEBSOCKET配置
			if(null != strWEBSOCKET && !"".equals(strWEBSOCKET)){
				String strIW[] = strWEBSOCKET.split(",fh,");
				if(strIW.length == 7){
					map.put("wimadress", strIW[0]+":"+strIW[1]);		//即时聊天服务器IP和端口
					map.put("oladress", strIW[2]+":"+strIW[3]);			//在线管理和站内信服务器IP和端口
					map.put("FHsmsSound", strIW[4]);					//站内信提示音效配置
				}
			}
			Object RNUMBERS = session.getAttribute(Const.SESSION_RNUMBERS);
			if(null == RNUMBERS){
				session.setAttribute(Const.SESSION_RNUMBERS, getRnumbers()); //把当前用户的角色编码放入session
			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} finally {
			logAfter(logger);
		}
		return AppUtil.returnObject(pd, map);
	}
	
	/**通过角色ID数组获取角色列表拼接角色编码
	 * @return
	 * @throws Exception
	 */
	public String getRnumbers() throws Exception{
		PageData userpd = new PageData();
		userpd.put(Const.SESSION_USERNAME, Jurisdiction.getUsername());
		userpd = userService.findByUsername(userpd);		//通过用户名获取用户信息
		String ZROLE_ID = userpd.get("ROLE_ID").toString()+",fh,"+userpd.getString("ROLE_IDS");
		String arryROLE_ID[] = ZROLE_ID.split(",fh,");
		List<Role> rlist = roleService.getRoleByArryROLE_ID(arryROLE_ID);
		StringBuffer RNUMBERS = new StringBuffer();
		RNUMBERS.append("(");
		for(Role role:rlist){
			RNUMBERS.append("'"+role.getRNUMBER()+"'");
		}
		RNUMBERS.append(")");
		return RNUMBERS.toString();
	}
	
	/**判断当前用户角色编码符合过滤条件(用于新任务消息通知)
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/isNowRole")
	@ResponseBody
	public Object isNowRole() throws Exception{
		PageData pd = new PageData();
		pd = this.getPageData();
		Map<String,Object> map = new HashMap<String,Object>();
		if(Jurisdiction.getRnumbers().indexOf(pd.getString("RNUMBER"))!=-1){
			map.put("msg", "yes");
		}else{
			map.put("msg", "no");
		}
		return AppUtil.returnObject(pd, map);
	}
	
}


// F-H Q  3-135-9679-0 