package com.fh.util.express;

/**
 * 充值地址：https://market.aliyun.com/products/56928004/cmapi022273.html
 * 快递查询中间商有可能下架此商品，根据情况择换其它中间商
 * 
 * 说明：快递物流查询接口
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
import com.fh.util.express.HttpUtils;

import org.apache.http.HttpResponse;
import org.apache.http.util.EntityUtils;

import java.util.HashMap;
import java.util.Map;

public class GetExpressMsg {
	
	 public static String get(String number) throws Exception{
        String host = "http://kdwlcxf.market.alicloudapi.com";
        String path = "/kdwlcx";
        String method = "GET";
        String appcode = "d344b934e51846c095b95c6b26903b7e";  //替换这里填写你自己的AppCode 请在买家中心查看 （只替换这一个就行）
        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Authorization", "APPCODE " + appcode); 
        Map<String, String> querys = new HashMap<String, String>();
        querys.put("no", number);							//快递单号
        HttpResponse response = HttpUtils.doGet(host, path, method, headers, querys);
        return EntityUtils.toString(response.getEntity()); //输出json
    }
	 
}
