package com.fh.dao;

import javax.annotation.Resource;

import org.springframework.data.redis.core.RedisTemplate;  
import org.springframework.data.redis.serializer.RedisSerializer;  

/**
 * 说明：redis Dao 
 * 作者：FH Admin Q313596790
 * 官网：www.fhadmin.org
 */
public abstract class AbstractBaseRedisDao<K, V> {  
      
    @Resource(name="redisTemplate")
    protected RedisTemplate<K, V> redisTemplate;
  
    /** 
     * 设置redisTemplate 
     * @param redisTemplate the redisTemplate to set 
     */  
    public void setRedisTemplate(RedisTemplate<K, V> redisTemplate) {
        this.redisTemplate = redisTemplate;  
    }  
      
    /** 
     * 获取 RedisSerializer 
     */  
    protected RedisSerializer<String> getRedisSerializer() {  
        return redisTemplate.getStringSerializer();  
    }  
}
