package com.fh.entity.weixin;

/**
 * 说明： view类型的菜单对象
 * 作者：FH Admin Q 3 135 96790
 * 官网：www.fhadmin .org
 */
public class ViewButton extends Button{
	private String type;		//菜单类型
	private String url;			//view路径值
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
}
