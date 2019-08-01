package com.fh.controller.mobile.im;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.util.AppUtil;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.service.fhim.friends.FriendsManager;

/**
 * 说明：好友管理(手机版)
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
@Controller
@RequestMapping(value="/mobilefriends")
public class MobileFriendsController extends BaseController {
	
	@Resource(name="friendsService")
	private FriendsManager friendsService;
	
	/**列表
	 * @param page
	 * @throws Exception
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(Page page) throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String keywords = pd.getString("keywords");				//关键词检索条件
		if(null != keywords && !"".equals(keywords)){
			pd.put("keywords", keywords.trim());
		}
		pd.put("USERNAME", Jurisdiction.getUsername());
		page.setPd(pd);
		List<PageData>	varList = friendsService.list(page);	//列出Friends列表
		mv.setViewName("mobile/im/friends_list");
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**去添聊天首页
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goIm")
	public ModelAndView goIm()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/im/im");
		return mv;
	}
	
	/**去添加好友页面
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/im/friends_add");
		return mv;
	}
	
	/**添加好友检索
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/search")
	public ModelAndView search()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String keywords = pd.getString("keywords");				//关键词检索条件
		if(null != keywords && !"".equals(keywords)){
			pd.put("keywords", keywords.trim());
		}
		pd.put("USERNAME", Jurisdiction.getUsername());			//不检索自己
		List<PageData>	varList = friendsService.listAllToSearch(pd);
		mv.setViewName("mobile/im/friends_add");
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**删除
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping(value="/deletefromlist")
	public void deletefromlist(PrintWriter out) throws Exception{
		PageData pd = new PageData();
		pd = this.getPageData();
		friendsService.delete(pd);
		out.write("success");
		out.close();
	}
	
	/**拉黑
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping(value="/pullblackfromlist")
	public void pullblackfromlist(PrintWriter out) throws Exception{
		PageData pd = new PageData();
		pd = this.getPageData();
		friendsService.delete(pd);						//删除自己好友栏
		pd.put("USERNAME", Jurisdiction.getUsername());	//用户名
		friendsService.pullblack(pd);					//删除对方好友栏
		out.write("success");
		out.close();
	}
	
	 /**去修改页面
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goEdit")
	public ModelAndView goEdit()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd = friendsService.findById(pd);	//根据ID读取
		mv.setViewName("mobile/im/friends_edit");
		mv.addObject("msg", "edit");
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**修改
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/edit")
	@ResponseBody
	public Object edit() throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		String errInfo = "success";
		PageData pd = new PageData();
		pd = this.getPageData();
		friendsService.edit(pd);
		map.put("result", errInfo);				//返回结果
		return AppUtil.returnObject(new PageData(), map);
	}
	
}
