package com.wanda.credit.ds.client.juxinli.bean.reportNew.vo;

import java.util.List;
/**
 * 用户申请表检测之金融服务类机构黑名单检查
 * @author xiaobin.hou
 *
 */
public class FinancialBlacklist {

	private String arised;

	private List<String> black_type;

	public String getArised() {
		return arised;
	}

	public void setArised(String arised) {
		this.arised = arised;
	}

	public List<String> getBlack_type() {
		return black_type;
	}

	public void setBlack_type(List<String> black_type) {
		this.black_type = black_type;
	}

	@Override
	public String toString() {
		return "financialBlacklist [arised=" + arised + ", black_type=" + black_type + "]";
	}

}
