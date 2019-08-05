package com.fh.entity.weixin;

/**
 * 说明： 一级菜单
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
public class ComplexButton {
	
	private String name;			//菜单名称
	private Button[] sub_button;	//子级菜单
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Button[] getSub_button() {
		return sub_button;
	}
	public void setSub_button(Button[] sub_button) {
		this.sub_button = sub_button;
	}
}