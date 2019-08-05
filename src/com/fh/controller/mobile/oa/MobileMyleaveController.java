package com.fh.controller.mobile.oa;

import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.activiti.AcStartController;
import com.fh.entity.Page;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.util.Tools;
import com.fh.service.fhoa.myleave.MyleaveManager;

/**
 * 说明：请假申请(手机端)
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin. org
 */
@Controller
@RequestMapping(value="/mobilemyleave")
public class MobileMyleaveController extends AcStartController {
	
	@Resource(name="myleaveService")
	private MyleaveManager myleaveService;
	
	/**保存请假单
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/save")
	public ModelAndView save(){
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("MYLEAVE_ID", this.get32UUID());					//主键
		pd.put("USERNAME", Jurisdiction.getUsername());			//用户名
		try {
			/** 工作流的操作 **/
			Map<String,Object> map = new LinkedHashMap<String, Object>();
			map.put("请假人员", Jurisdiction.getU_name());			//当前用户的姓名
			map.put("开始时间", pd.getString("STARTTIME"));
			map.put("结束时间", pd.getString("ENDTIME"));
			map.put("请假时长", pd.getString("WHENLONG"));
			map.put("请假类型", pd.getString("TYPE"));
			map.put("请假事由", pd.getString("REASON"));
			map.put("USERNAME", Jurisdiction.getUsername());		//指派代理人为当前用户
			startProcessInstanceByKeyHasVariables("KEY_leave",map);	//启动流程实例(请假单流程)通过KEY
			myleaveService.save(pd);								//记录存入数据库
			mv.addObject("ASSIGNEE_",Jurisdiction.getUsername());	//用于给待办人发送新任务消息
			mv.addObject("msg","success");
		} catch (Exception e) {
			mv.addObject("errer","errer");
			mv.addObject("msgContent","请联系管理员部署相应业务流程!");
		}								
		mv.setViewName("redirect:/mobiletask/list.do?taskmsg=leave");	 //保存成功跳转到列表页面
		return mv;
	}
	
	/**删除
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out) throws Exception{
		PageData pd = new PageData();
		pd = this.getPageData();
		myleaveService.delete(pd);
		out.write("success");
		out.close();
	}
	
	/**修改
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/edit")
	public ModelAndView edit() throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		myleaveService.edit(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
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
		if(Tools.notEmpty(keywords))pd.put("keywords", keywords.trim());
		pd.put("USERNAME", "admin".equals(Jurisdiction.getUsername())?"":Jurisdiction.getUsername()); //除admin用户外，只能查看自己的数据
		page.setPd(pd);
		List<PageData>	varList = myleaveService.list(page);	//列出Myleave列表
		mv.setViewName("mobile/oa/m_myleave_list");
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**去新增页面
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		mv.setViewName("fhoa/myleave/myleave_edit");
		mv.addObject("msg", "save");
		mv.addObject("pd", pd);
		return mv;
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
		pd = myleaveService.findById(pd);	//根据ID读取
		mv.setViewName("fhoa/myleave/myleave_edit");
		mv.addObject("msg", "edit");
		mv.addObject("pd", pd);
		return mv;
	}
	
}
