package com.wanda.credit.ds.dao;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wanda.credit.base.exception.ServiceException;
import com.wanda.credit.base.service.impl.BaseServiceImpl;
import com.wanda.credit.ds.dao.domain.YT_Regist_Result;
import com.wanda.credit.ds.dao.iface.IYTRegistService;
@Service
@Transactional
public class YTRegistServiceImpl  extends BaseServiceImpl<YT_Regist_Result> implements IYTRegistService{
	private final  Logger logger = LoggerFactory.getLogger(YTRegistServiceImpl.class);

	@Override
	public boolean inCached(String name, String cardNo,String status,String transType) {		
		String sql ="SELECT COUNT(1) CNT FROM CPDB_DS.T_DS_YITU_REGIST_RESULT WHERE CARD_NO = ? AND TRANS_TYPE=? AND NAME = ? AND STATUS = ?";
		Integer result = this.daoService.findOneBySql(sql, new Object[]{cardNo,transType,name,status},Integer.class);
		return result>0;
	}

	@Override
	public void batchSave(List<YT_Regist_Result> result) {
		try {
			this.add(result);
		} catch (ServiceException e) {
			logger.error("批量保存失败，详细信息:{}" , e.getMessage());
			e.printStackTrace();
		}
	}

}
