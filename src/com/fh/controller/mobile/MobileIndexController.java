package com.fh.controller.mobile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fh.controller.base.BaseController;
import com.fh.entity.system.Dictionaries;
import com.fh.service.system.dictionaries.DictionariesManager;
import com.fh.util.AppUtil;
import com.fh.util.PageData;
import com.fh.util.Tools;

/**
 * 说明：手机端
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
@Controller
@RequestMapping(value="/mobileindex")
public class MobileIndexController extends BaseController {
	
	@Resource(name="dictionariesService")
	private DictionariesManager dictionariesService;
	
	
	/**进入首页
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/index")
	public ModelAndView index()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/index");
		return mv;
	}
	
	/**进入站内信页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/fhsms")
	public ModelAndView fhsms()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/fhsms/fs_list");
		return mv;
	}
	
	/**进入我的通讯页面
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/myim")
	public ModelAndView myim()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/im/im_list");
		return mv;
	}
	
	/**进入个人中心
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/usercenter")
	public ModelAndView userCenter()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/user/user_center");
		return mv;
	}

	/**进入任务管理
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/tasklist")
	public ModelAndView taskList()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/task/task_list");
		return mv;
	}
	
	/**进入审批管理
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/oalist")
	public ModelAndView oaList()throws Exception{
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("mobile/oa/oa_list");
		return mv;
	}

	/**获取数据字典中的数据
	 * @return
	 */
	@RequestMapping(value="/getLevels")
	@ResponseBody
	public Object getLevels(){
		Map<String,Object> map = new HashMap<String,Object>();
		String errInfo = "success";
		PageData pd = new PageData();
		try{
			pd = this.getPageData();
			String DICTIONARIES_ID = pd.getString("DICTIONARIES_ID");
			DICTIONARIES_ID = Tools.isEmpty(DICTIONARIES_ID)?"0":DICTIONARIES_ID;
			List<Dictionaries>	varList = dictionariesService.listSubDictByParentId(DICTIONARIES_ID); //用传过来的ID获取此ID下的子列表数据
			List<PageData> pdList = new ArrayList<PageData>();
			for(Dictionaries d :varList){
				PageData pdf = new PageData();
				pdf.put("DICTIONARIES_ID", d.getDICTIONARIES_ID());
				pdf.put("BIANMA", d.getBIANMA());
				pdf.put("NAME", d.getNAME());
				pdList.add(pdf);
			}
			map.put("list", pdList);	
		} catch(Exception e){
			errInfo = "error";
			logger.error(e.toString(), e);
		}
		map.put("result", errInfo);				//返回结果
		return AppUtil.returnObject(new PageData(), map);
	}
	
}
