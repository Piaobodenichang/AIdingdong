package com.fh.controller.points.order;

import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang.builder.StandardToStringStyle;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.util.AppUtil;
import com.fh.util.ObjectExcelView;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.util.Tools;
import com.fh.service.points.order.OrderManager;

/** 
 * 说明：订单发货审核
 * 创建人：FH Q313596790
 * 创建时间：2019-08-01
 */
@Controller
@RequestMapping(value="/order")
public class OrderController extends BaseController {
	
	String menuUrl = "order/list.do"; //菜单地址(权限用)
	@Resource(name="orderService")
	private OrderManager orderService;
	
	/**发货
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out) throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"修改Order");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "edit")){return;} //校验权限
		PageData pd = new PageData();
		pd = this.getPageData();
		orderService.edit(pd);
		out.write("success");
		out.close();
	}
	
	/**列表
	 * @param page
	 * @throws Exception
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(Page page) throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"列表Order");
		//if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;} //校验权限(无权查看时页面会有提示,如果不注释掉这句代码就无法进入列表页面,所以根据情况是否加入本句代码)
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String keywords = pd.getString("keywords");				//关键词检索条件
		if(null != keywords && !"".equals(keywords)){
			pd.put("keywords", keywords.trim());
		}
		String lastLoginStart = pd.getString("lastStart");   //开始时间
        String lastLoginEnd = pd.getString("lastEnd");     //结束时间
        if(lastLoginStart != null && !"".equals(lastLoginStart)){
            pd.put("lastLoginStart", lastLoginStart+" 00:00:00");
        }
        if(lastLoginEnd != null && !"".equals(lastLoginEnd)){
            pd.put("lastLoginEnd", lastLoginEnd+" 00:00:00");
        } 
		page.setPd(pd);
		List<PageData>	varList = orderService.list(page);	//列出Order列表
		mv.setViewName("points/order/order_list");
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		mv.addObject("QX",Jurisdiction.getHC());	//按钮权限
		return mv;
	}
	
	 /**批量发货
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/updateAll")
	@ResponseBody
	public Object deleteAll() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"批量发货Order");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "edit")){return null;} //校验权限
		PageData pd = new PageData();		
		Map<String,Object> map = new HashMap<String,Object>();
		pd = this.getPageData();
		List<PageData> pdList = new ArrayList<PageData>();
		String DATA_IDS = pd.getString("DATA_IDS");
		List<PageData> pdList2 =orderService.findByStatus(pd);
		String ORDER_IDS[] = new String[pdList2.size()];
		if(null != pdList2){   
	        for (int i=0;i<pdList2.size();i++) {
	            ORDER_IDS[i] = pdList2.get(i).get("ORDER_ID").toString();
	        }
		}
		if(null != DATA_IDS && !"".equals(DATA_IDS)){
			String ArrayDATA_IDS[] = DATA_IDS.split(",");
			if(null != ORDER_IDS){
			    String SAME[]= getSame(ORDER_IDS, ArrayDATA_IDS);
			    String DIFFERENT[] = getC(SAME, ArrayDATA_IDS);
			    if(DIFFERENT.length>0){
			        orderService.updateAll(DIFFERENT);
			        pd.put("msg", "nok");
			    }else {
			        pd.put("msg", "null");

                }
			}else {
			    orderService.updateAll(ArrayDATA_IDS);
			    pd.put("msg", "ok");
            }				
		}else{
			pd.put("msg", "no");
		}
		pdList.add(pd);
		map.put("list", pdList);
		return AppUtil.returnObject(pd, map);
	}
	
	private static String[] getSame(String[] m, String[] n)
    {
	    List<String> rs = new ArrayList<String>();

        // 将较长的数组转换为set
        Set<String> set = new HashSet<String>(Arrays.asList(m.length > n.length ? m : n));

        // 遍历较短的数组，实现最少循环
        for (String i : m.length > n.length ? n : m)
        {
            if (set.contains(i))
            {
                rs.add(i);
            }
        }

        String[] arr = {};
        return rs.toArray(arr);
    }
	 private static String[] getC(String[] m, String[] n)
	    {
	        // 将较长的数组转换为set
	        Set<String> set = new HashSet<String>(Arrays.asList(m.length > n.length ? m : n));

	        // 遍历较短的数组，实现最少循环
	        for (String i : m.length > n.length ? n : m)
	        {
	            // 如果集合里有相同的就删掉，如果没有就将值添加到集合
	            if (set.contains(i))
	            {
	                set.remove(i);
	            } else
	            {
	                set.add(i);
	            }
	        }

	        String[] arr = {};
	        return set.toArray(arr);
	    }
	
	 /**导出到excel
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/excel")
	public ModelAndView exportExcel() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"导出Order到excel");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;}
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		List<String> titles = new ArrayList<String>();
		titles.add("用戶名");	//1
		titles.add("商品名");	//2
		titles.add("联系方式");	//3
		titles.add("创建时间");	//4
		titles.add("当前状态");//5
		dataMap.put("titles", titles);
		List<PageData> varOList = orderService.listAll(pd);
		List<PageData> varList = new ArrayList<PageData>();
		for(int i=0;i<varOList.size();i++){
			PageData vpd = new PageData();
			vpd.put("var1", varOList.get(i).getString("NAME"));	    //1
			vpd.put("var2", varOList.get(i).getString("GOODS_NAME"));	//2
			vpd.put("var3", varOList.get(i).getString("PHONE"));	    //3
			vpd.put("var4", varOList.get(i).getString("ORDER_TIME"));	    //4
			if(varOList.get(i).get("STATUS").equals("0")) {
			    vpd.put("var5","未发货");    
			}else if(varOList.get(i).get("STATUS").equals("1")) {
			    vpd.put("var5","已发货");   
			}else {
			    vpd.put("var5","已签收");   
            }
			varList.add(vpd);
		}
		dataMap.put("varList", varList);
		ObjectExcelView erv = new ObjectExcelView();
		mv = new ModelAndView(erv,dataMap);
		return mv;
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder){
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(format,true));
	}
}
