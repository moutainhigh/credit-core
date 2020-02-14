package com.wanda.credit.ds.dao.iface.huifa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.wanda.credit.base.dao.DaoService;
import com.wanda.credit.base.service.impl.BaseServiceImpl;
import com.wanda.credit.ds.dao.domain.huifa.DishonestPer;
import com.wanda.credit.ds.dao.iface.huifa.inter.IDishonestPerService;

@Service
@Transactional
public class DishonestPerService extends BaseServiceImpl<DishonestPer> implements IDishonestPerService{
	@Autowired
    private DaoService daoService;
	public void write(DishonestPer dishonestPer){
		daoService.create(dishonestPer);
	}
}
