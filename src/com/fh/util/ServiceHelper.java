package com.fh.util;

import com.fh.service.system.menu.impl.MenuService;
import com.fh.service.system.role.impl.RoleService;
import com.fh.service.system.user.UserManager;

/**
 * 说明：获取Spring容器中的service bean
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
public final class ServiceHelper {
	
	public static Object getService(String serviceName){
		//WebApplicationContextUtils.
		return Const.WEB_APP_CONTEXT.getBean(serviceName);
	}
	
	public static UserManager getUserService(){
		return (UserManager) getService("userService");
	}
	
	public static RoleService getRoleService(){
		return (RoleService) getService("roleService");
	}
	
	public static MenuService getMenuService(){
		return (MenuService) getService("menuService");
	}
}
