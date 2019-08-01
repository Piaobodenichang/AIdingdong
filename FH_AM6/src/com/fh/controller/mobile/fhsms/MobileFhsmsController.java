package com.fh.controller.mobile.fhsms;

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
import com.fh.util.DateUtil;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.service.system.fhsms.FhsmsManager;

/**
 * 说明：站内信(手机端)
 * 作者：FH Admin Q313596790
 * 官网：www. fhadmin .org
 */
@Controller
@RequestMapping(value="/mobilefhsms")
public class MobileFhsmsController extends BaseController {
	
	@Resource(name="fhsmsService")
	private FhsmsManager fhsmsService;
	
	/**发送站内信
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/save")
	@ResponseBody
	public Object save() throws Exception{
		PageData pd = new PageData();
		pd = this.getPageData();
		Map<String,Object> map = new HashMap<String,Object>();
		String msg = "ok";		//发送状态
		int count = 0;			//统计发送成功条数
		int zcount = 0;			//理论条数
		String USERNAME = pd.getString("USERNAME");				//对方用户名
		if(null != USERNAME && !"".equals(USERNAME)){
			USERNAME = USERNAME.replaceAll("；", ";");
			USERNAME = USERNAME.replaceAll(" ", "");
			String[] arrUSERNAME = USERNAME.split(";");
			zcount = arrUSERNAME.length;
			try {
				pd.put("STATUS", "2");										//状态
				for(int i=0;i<arrUSERNAME.length;i++){
					pd.put("SANME_ID", this.get32UUID());					//共同ID
					pd.put("SEND_TIME", DateUtil.getTime());				//发送时间
					pd.put("FHSMS_ID", this.get32UUID());					//主键1
					pd.put("TYPE", "2");									//类型2：发信
					pd.put("FROM_USERNAME", Jurisdiction.getUsername());	//发信人
					pd.put("TO_USERNAME", arrUSERNAME[i]);					//收信人
					fhsmsService.save(pd);									//存入发信
					pd.put("FHSMS_ID", this.get32UUID());					//主键2
					pd.put("TYPE", "1");									//类型1：收信
					pd.put("FROM_USERNAME", arrUSERNAME[i]);				//发信人
					pd.put("TO_USERNAME", Jurisdiction.getUsername());		//收信人
					fhsmsService.save(pd);
					count++;
				}
				msg = "ok";
			} catch (Exception e) {
				msg = "error";
			}
		}else{
			msg = "error";
		}
		map.put("msg", msg);
		map.put("count", count);						//成功数
		map.put("ecount", zcount-count);				//失败数
		return AppUtil.returnObject(pd, map);
	}
	
	/**删除
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out) throws Exception{
		PageData pd = new PageData();
		pd = this.getPageData();
		fhsmsService.delete(pd);
		out.write("success");
		out.close();
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
		if(!"2".equals(pd.getString("TYPE"))){					//1：收信箱 2：发信箱
			pd.put("TYPE", 1);
			mv.setViewName("mobile/fhsms/fhsms_s_list");
		}else{
			mv.setViewName("mobile/fhsms/fhsms_f_list");
		}
		pd.put("FROM_USERNAME", Jurisdiction.getUsername()); 	//当前用户名
		page.setPd(pd);	
		List<PageData>	varList = fhsmsService.list(page);		//列出Fhsms列表
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		mv.addObject("QX",Jurisdiction.getHC());				//按钮权限
		return mv;
	}
	
	/**去发站内信界面
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd()throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		mv.setViewName("system/fhsms/fhsms_edit");
		mv.addObject("msg", "save");
		mv.addObject("pd", pd);
		return mv;
	}	
	
	 /**去查看页面
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/goView")
	@ResponseBody
	public Object goView()throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		PageData pd = new PageData();
		pd = this.getPageData();
		if("1".equals(pd.getString("TYPE")) && "2".equals(pd.getString("STATUS"))){ //在收信箱里面查看未读的站内信时去数据库改变未读状态为已读
			fhsmsService.edit(pd);
		}
		pd = fhsmsService.findById(pd);	//根据ID读取
		map.put("pd", pd);
		return AppUtil.returnObject(pd, map);
	}	
	
}
