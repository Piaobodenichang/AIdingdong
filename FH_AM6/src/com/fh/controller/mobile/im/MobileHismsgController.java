package com.fh.controller.mobile.im;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.service.fhim.hismsg.HismsgManager;

/**
 * 说明：聊天记录(手机版)
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
@Controller
@RequestMapping(value="/mobilehismsg")
public class MobileHismsgController extends BaseController {
	
	@Resource(name="hismsgService")
	private HismsgManager hismsgService;
	
	/**打开聊天记录窗口
	 * @param page
	 * @throws Exception
	 */
	@RequestMapping(value="/himsglist")
	public ModelAndView himsgList(Page page) throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"打开聊天记录窗口");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("TOID", pd.getString("id"));						//目标(好友或者群)
		pd.put("TYPE", pd.getString("type"));					//类型
		pd.put("TITLE", new String(pd.getString("title").getBytes("iso8859-1"),"utf-8"));					//和谁聊天
		pd.put("USERNAME", Jurisdiction.getUsername());			//当前用户(发送者)
		page.setPd(pd);
		List<PageData>	varList = hismsgService.list(page);		//列出Hismsg列表
		mv.setViewName("mobile/im/hismsg_list");
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		return mv;
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(format,true));
	}
}
