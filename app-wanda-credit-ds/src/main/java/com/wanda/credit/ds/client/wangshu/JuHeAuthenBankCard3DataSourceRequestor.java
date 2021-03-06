package com.wanda.credit.ds.client.wangshu;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import com.wanda.credit.base.util.StringUtil;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;
import com.wanda.credit.api.dto.DataSource;
import com.wanda.credit.base.Conts;
import com.wanda.credit.base.annotation.DataSourceClass;
import com.wanda.credit.base.enums.CRSStatusEnum;
import com.wanda.credit.base.util.CardNoValidator;
import com.wanda.credit.base.util.ExceptionUtil;
import com.wanda.credit.common.log.ds.DataSourceLogEngineUtil;
import com.wanda.credit.common.log.ds.vo.DataSourceLogVO;
import com.wanda.credit.common.util.ParamUtil;
import com.wanda.credit.ds.client.dsconfig.commonfunc.CryptUtil;
import com.wanda.credit.ds.iface.IDataSourceRequestor;
@DataSourceClass(bindingDataSourceId="ds_juhe_AuthenBankCard3")
public class JuHeAuthenBankCard3DataSourceRequestor extends BaseJuHeAuthenBankCardDataSourceRequestor
implements IDataSourceRequestor {
	private final  Logger logger = LoggerFactory.getLogger(JuHeAuthenBankCard3DataSourceRequestor.class);
		
	@Override
	public Map<String, Object> request(String trade_id, DataSource ds){
		final String prefix = trade_id + " " + Conts.KEY_SYS_AGENT_HEADER;
		TreeMap<String, Object> retdata = new TreeMap<String, Object>();
		Map<String, Object> rets = new HashMap<String, Object>();
		DataSourceLogVO logObj = new DataSourceLogVO();
		Map<String, Object> reqparam = new HashMap<String, Object>();
		String resource_tag = Conts.TAG_SYS_ERROR;
		logObj.setReq_time(new Timestamp(System.currentTimeMillis()));
		try{	
			
			logObj.setDs_id(ds.getId());
			logObj.setReq_url(propertyEngine.readById("wdwsh_jhauthcard3url"));
			logObj.setState_code(DataSourceLogEngineUtil.TRADE_STATE_FAIL);
	 		String name = ParamUtil.findValue(ds.getParams_in(), "name").toString();   //姓名 
			String cardNo = ParamUtil.findValue(ds.getParams_in(), "cardNo").toString(); //身份证号码
			String cardId = ParamUtil.findValue(ds.getParams_in(), "cardId").toString(); //银行卡号
            String bankName = (String) ParamUtil.findValue(ds.getParams_in(),
                    "bankName");
            if(!StringUtil.isEmpty(bankName)){
                logObj.setBiz_code2(bankName);
            }
			reqparam.put("name", name);
			reqparam.put("cardNo", cardNo);
			reqparam.put("cardId", cardId);
			if(StringUtils.isNotEmpty(CardNoValidator.validate(cardNo))){
				logObj.setIncache("1");
				logObj.setState_msg("身份证号码不符合规范");
				rets.clear();
				rets.put(Conts.KEY_RET_STATUS, CRSStatusEnum.STATUS_FAILED_DS_JUXINLI_IDCARD_ERROR);
				rets.put(Conts.KEY_RET_MSG, "您输入的为无效身份证号码，请核对后重新输入!");
				rets.put(Conts.KEY_RET_TAG, new String[]{resource_tag});
				return rets;
			}			
			logObj.setIncache("0");
			
			String isEnc = propertyEngine.readById("encrypt_switch_142");
			String encCardNo = cardNo;
			String encCardId = cardId;
			if ("1".equals(isEnc)) {
				encCardNo = CryptUtil.encrypt(cardNo);
				encCardId = CryptUtil.encrypt(cardId);
			}
			/*//查询缓存
			Map<String, Object> cacheData = getCache(prefix,name, cardNo, cardId, null);
			if (cacheData != null) {
				logObj.setIncache("1");
				logObj.setState_code(DataSourceLogEngineUtil.TRADE_STATE_SUCC);
				resource_tag = Conts.TAG_INCACHE_TST_SUCCESS;
				rets.put(Conts.KEY_RET_TAG, new String[]{resource_tag});
				rets.put(Conts.KEY_RET_DATA, cacheData);
				rets.put(Conts.KEY_RET_STATUS, CRSStatusEnum.STATUS_SUCCESS);
				rets.put(Conts.KEY_RET_MSG, "采集成功!");
				return rets;
			}*/
			String url = buildRequestUrl(trade_id,name,cardNo,cardId);
			Map<String, Object> rspDataMap = doRequest(trade_id,url,false);
			int httpstatus = (Integer)rspDataMap.get("httpstatus");
			JSONObject rspData = JSONObject.parseObject((String) rspDataMap.get("rspstr"));
			if(needRetry(httpstatus,rspData)){
				logger.info("{} token失效 准备重试",trade_id);
				rspDataMap = doRequest(trade_id,url,true);
                rspData = JSONObject.parseObject((String) rspDataMap.get("rspstr"));
			}
			logObj.setBiz_code3(rspData.get("seq") + "");
			logObj.setBiz_code1(rspData.get("code") + "-" +rspData.get("msg"));
			logger.info("{} 返回数据 {}",trade_id,rspDataMap.get("rspstr"));
			logger.info("{} DMP返回结果为 {}" , prefix ,rspDataMap);
			if(isSuccess(rspData)){
//				juheAuthCardService.saveAuthCard3(trade_id,
//						name,cardNo,cardId,rspData);
				long saveStart = System.currentTimeMillis();

                String req_values = cardNo+"_"+cardId;

				allAuthCardService.savaJuHeAuthCard(ds.getId(), trade_id, name,
						encCardNo, encCardId,null, rspData.getJSONObject("data"), req_values);
				logger.info("{} 保存请求结果到数据库耗时为 {}" , prefix ,System.currentTimeMillis() - saveStart);
				resource_tag = buildTag(trade_id,rspData.getJSONObject("data"));
				logObj.setState_code(DataSourceLogEngineUtil.TRADE_STATE_SUCC);
				retdata.putAll(visitBusiData(trade_id,rspData.getJSONObject("data")));
				logger.info("处理成功" , prefix);
			}else if(isSupport(rspData)){
				logger.info("返回不支持" , prefix);
				resource_tag = Conts.TAG_TST_FAIL;
				logObj.setState_code(DataSourceLogEngineUtil.TRADE_STATE_FAIL);
				retdata.put("respCode", "03");
				retdata.put("respDesc", "暂不支持此银行卡");
			}else{
				logger.info("返回其他错误" , prefix);
				resource_tag = Conts.TAG_TST_FAIL;
				logObj.setState_code(DataSourceLogEngineUtil.TRADE_STATE_FAIL);
				logger.error("{} 厂商返回异常，收到响应信息 {}",trade_id,rspDataMap.get("rspstr"));
				throw new Exception();
			}			
			rets.put(Conts.KEY_RET_TAG, new String[]{resource_tag});
			rets.put(Conts.KEY_RET_DATA, retdata);
			rets.put(Conts.KEY_RET_STATUS, CRSStatusEnum.STATUS_SUCCESS);
			rets.put(Conts.KEY_RET_MSG, "采集成功!");			
		}catch(Exception ex){
			resource_tag = Conts.TAG_SYS_ERROR;
			rets.put(Conts.KEY_RET_STATUS, CRSStatusEnum.STATUS_FAILED_SYS_DS_EXCEPTION);
			rets.put(Conts.KEY_RET_MSG, "数据源处理时异常! 详细信息:"+ex.getMessage());
			logger.error(prefix+" 数据源处理时异常：{}",ex);
			if (ExceptionUtil.isTimeoutException(ex)) {
				resource_tag = Conts.TAG_SYS_TIMEOUT;
				logObj.setState_code(DataSourceLogEngineUtil.TRADE_STATE_TIMEOUT);
			} else {
				logObj.setState_code(DataSourceLogEngineUtil.TRADE_STATE_FAIL);
				logObj.setState_msg("数据源处理时异常! 详细信息:" + ex.getMessage());
			}
			rets.put(Conts.KEY_RET_TAG, new String[]{resource_tag});
		}finally {
			logObj.setRsp_time(new Timestamp(System.currentTimeMillis()));
			logObj.setTag(resource_tag);
			DataSourceLogEngineUtil.writeLog(trade_id, logObj);
			DataSourceLogEngineUtil.writeParamIn(trade_id, reqparam, logObj);
		}
		return rets;
	}
	
	public String buildRequestUrl(String trade_id, String name, String cardNo,
			String cardId) {
		String url = propertyEngine.readById("wdwsh_jhauthcard3url");
		StringBuilder sb = new StringBuilder();
		sb.append(url).append("?");		
		sb.append("idcard=").append(cardNo).append("&realname=").append(name).append("&bankcard=").append(cardId);		
		return sb.toString();
	}

	public static void main(String[] args) {		
	}
}
