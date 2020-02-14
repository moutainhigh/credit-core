package com.wanda.credit.ds.dao.impl.yitu;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wanda.credit.base.exception.ServiceException;
import com.wanda.credit.base.service.impl.BaseServiceImpl;
import com.wanda.credit.ds.dao.domain.yitu.Yitu_auth_option;
import com.wanda.credit.ds.dao.iface.yitu.IYTAuthOptionService;
@Service
@Transactional
public class YTAuthOptionServiceImpl  extends BaseServiceImpl<Yitu_auth_option> implements IYTAuthOptionService{
	private final  Logger logger = LoggerFactory.getLogger(YTAuthOptionServiceImpl.class);

	@Override
	public void batchSave(List<Yitu_auth_option> result) {
		try {
			this.add(result);
		} catch (ServiceException e) {
			logger.error("批量保存失败，详细信息:{}" , e.getMessage());
			e.printStackTrace();
		}
	}
}
