package com.fh.controller.points.goods;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import com.fh.controller.base.BaseController;
import com.fh.entity.Page;
import com.fh.util.AppUtil;
import com.fh.util.Const;
import com.fh.util.ObjectExcelView;
import com.fh.util.PageData;
import com.fh.util.Jurisdiction;
import com.fh.util.Tools;
import com.fh.service.points.goods.GoodsManager;

/** 
 * 说明：商品管理
 * 创建人：FH Q313596790
 * 创建时间：2019-08-01
 */
@Controller
@RequestMapping(value="/goods")
public class GoodsController extends BaseController {
	
	String menuUrl = "goods/list.do"; //菜单地址(权限用)
	@Resource(name="goodsService")
	private GoodsManager goodsService;
	
	/**保存
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/save")
	public ModelAndView save() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"新增Goods");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "add")){return null;} //校验权限
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd.put("GOODS_PICTURE", pd.getString("FILEPATH"));
		pd.put("GOODS_ID", this.get32UUID());	//主键
		goodsService.save(pd);
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**删除
	 * @param out
	 * @throws Exception
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out) throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"删除Goods");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "del")){return;} //校验权限
		PageData pd = new PageData();
		pd = this.getPageData();
		goodsService.delete(pd);
		out.write("success");
		out.close();
	}
	
	/**修改
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/edit")
	public ModelAndView edit(HttpServletRequest req,@RequestParam("File_name") MultipartFile file) throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"修改Goods");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "edit")){return null;} //校验权限
		ModelAndView mv = this.getModelAndView();
		String GOODS_ID=req.getParameter("GOODS_ID");
		String GOODS_NAME=req.getParameter("GOODS_NAME");
		String GOODS_PRICE=req.getParameter("GOODS_PRICE");
		String GOODS_NUMBER=req.getParameter("GOODS_NUMBER");
		String GOODS_DESCRIBE=req.getParameter("GOODS_DESCRIBE");
		String GOODS_STATE=req.getParameter("GOODS_STATE");
		String oldFileName=req.getParameter("oldFileName");
		String name="";
		String suffixName="";
		 if (file.isEmpty()) {
	            
	        }else{
	            try {
	                File filet=new File(Const.FILEPATHGOODSIMG + oldFileName);
	                if(filet.exists()) {
	                    filet.delete();
	                }
	                String oldfileName = file.getOriginalFilename();  // 文件名
	                suffixName = oldfileName.substring(oldfileName.lastIndexOf("."));  // 后缀名
	                name = new java.text.SimpleDateFormat("yyyyMMddhhmmss").format(new Date());    //获取当前日期
                    name = name + (int)(Math.random()*90000+10000);
	                String destFileName = Const.FILEPATHGOODSIMG + name + suffixName;
	                //第一次运行的时候，这个文件所在的目录往往是不存在的，这里需要创建一下目录
	                File destFile = new File(destFileName);
	                destFile.getParentFile().mkdirs();
	                //把浏览器上传的文件复制到希望的位置
	                file.transferTo(destFile);
	                
	            } catch (FileNotFoundException e) {
	                e.printStackTrace();
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        }
		 
		 String FileName=name+suffixName;
        PageData pd = new PageData();
        pd.put("GOODS_ID", GOODS_ID); 
        pd.put("GOODS_NAME", GOODS_NAME); 
        pd.put("GOODS_PRICE", GOODS_PRICE); 
        pd.put("GOODS_NUMBER", GOODS_NUMBER); 
        pd.put("GOODS_DESCRIBE", GOODS_DESCRIBE); 
        pd.put("GOODS_STATE", GOODS_STATE);
        if(name!="") {
            pd.put("GOODS_PICTURE", FileName); 
        }       
        goodsService.edit(pd);
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
		logBefore(logger, Jurisdiction.getUsername()+"列表Goods");
		//if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;} //校验权限(无权查看时页面会有提示,如果不注释掉这句代码就无法进入列表页面,所以根据情况是否加入本句代码)
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String keywords = pd.getString("keywords");				//关键词检索条件
		if(null != keywords && !"".equals(keywords)){
			pd.put("keywords", keywords.trim());
		}
		page.setPd(pd);
		List<PageData>	varList = goodsService.list(page);	//列出Goods列表
		mv.setViewName("points/goods/goods_list");
		mv.addObject("varList", varList);
		mv.addObject("pd", pd);
		mv.addObject("QX",Jurisdiction.getHC());	//按钮权限
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
		mv.setViewName("points/goods/goods_edit");
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
		pd = goodsService.findById(pd);	//根据ID读取
		mv.setViewName("points/goods/goods_edit1");
		mv.addObject("msg", "edit");
		mv.addObject("pd", pd);
		return mv;
	}	
	
	/**批量上架
     * @param
     * @throws Exception
     */
    @RequestMapping(value="/editAlls")
    @ResponseBody
    public Object editAlls() throws Exception{
        logBefore(logger, Jurisdiction.getUsername()+"批量上架Goods");
        if(!Jurisdiction.buttonJurisdiction(menuUrl, "del")){return null;} //校验权限
        PageData pd = new PageData();       
        Map<String,Object> map = new HashMap<String,Object>();
        pd = this.getPageData();
        List<PageData> pdList = new ArrayList<PageData>();
        String DATA_IDS = pd.getString("DATA_IDS");
        if(null != DATA_IDS && !"".equals(DATA_IDS)){
            String ArrayDATA_IDS[] = DATA_IDS.split(",");
            goodsService.editAlls(ArrayDATA_IDS);
            pd.put("msg", "ok");
        }else{
            pd.put("msg", "no");
        }
        pdList.add(pd);
        map.put("list", pdList);
        return AppUtil.returnObject(pd, map);
    }
    
    /**批量下架
     * @param
     * @throws Exception
     */
    @RequestMapping(value="/editAllx")
    @ResponseBody
    public Object editAllx() throws Exception{
        logBefore(logger, Jurisdiction.getUsername()+"批量下架Goods");
        if(!Jurisdiction.buttonJurisdiction(menuUrl, "del")){return null;} //校验权限
        PageData pd = new PageData();       
        Map<String,Object> map = new HashMap<String,Object>();
        pd = this.getPageData();
        List<PageData> pdList = new ArrayList<PageData>();
        String DATA_IDS = pd.getString("DATA_IDS");
        if(null != DATA_IDS && !"".equals(DATA_IDS)){
            String ArrayDATA_IDS[] = DATA_IDS.split(",");
            goodsService.editAllx(ArrayDATA_IDS);
            pd.put("msg", "ok");
        }else{
            pd.put("msg", "no");
        }
        pdList.add(pd);
        map.put("list", pdList);
        return AppUtil.returnObject(pd, map);
    }
    
	 /**批量删除
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/deleteAll")
	@ResponseBody
	public Object deleteAll() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"批量删除Goods");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "del")){return null;} //校验权限
		PageData pd = new PageData();		
		Map<String,Object> map = new HashMap<String,Object>();
		pd = this.getPageData();
		List<PageData> pdList = new ArrayList<PageData>();
		String DATA_IDS = pd.getString("DATA_IDS");
		if(null != DATA_IDS && !"".equals(DATA_IDS)){
			String ArrayDATA_IDS[] = DATA_IDS.split(",");
			goodsService.deleteAll(ArrayDATA_IDS);
			pd.put("msg", "ok");
		}else{
			pd.put("msg", "no");
		}
		pdList.add(pd);
		map.put("list", pdList);
		return AppUtil.returnObject(pd, map);
	}
	
	 /**导出到excel
	 * @param
	 * @throws Exception
	 */
	@RequestMapping(value="/excel")
	public ModelAndView exportExcel() throws Exception{
		logBefore(logger, Jurisdiction.getUsername()+"导出Goods到excel");
		if(!Jurisdiction.buttonJurisdiction(menuUrl, "cha")){return null;}
		ModelAndView mv = new ModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		Map<String,Object> dataMap = new HashMap<String,Object>();
		List<String> titles = new ArrayList<String>();
		titles.add("商品名称");	//1
		titles.add("商品价格");	//2
		titles.add("商品数量");	//3
		titles.add("商品描述");	//4
		titles.add("商品状态");	//5
		titles.add("商品图片");	//6
		dataMap.put("titles", titles);
		List<PageData> varOList = goodsService.listAll(pd);
		List<PageData> varList = new ArrayList<PageData>();
		for(int i=0;i<varOList.size();i++){
			PageData vpd = new PageData();
			vpd.put("var1", varOList.get(i).getString("GOODS_NAME"));	    //1
			vpd.put("var2", varOList.get(i).getString("GOODS_PRICE"));	    //2
			vpd.put("var3", varOList.get(i).get("GOODS_NUMBER").toString());	//3
			vpd.put("var4", varOList.get(i).getString("GOODS_DESCRIBE"));	    //4
			vpd.put("var5", varOList.get(i).getString("GOODS_STATE"));	    //5
			vpd.put("var6", varOList.get(i).getString("GOODS_PICTURE"));	    //6
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
