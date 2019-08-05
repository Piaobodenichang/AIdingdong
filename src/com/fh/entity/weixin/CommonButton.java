package com.fh.entity.weixin;

/**
 * 说明： 二级菜单
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
public class CommonButton extends Button{
	
	private String type;		//菜单类型
	private String key;			//key值
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
}
