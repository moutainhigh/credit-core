package com.wanda.credit.ds.dao.domain.juxinli.mobile;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import org.codehaus.jackson.map.annotate.JsonSerialize;
import org.hibernate.annotations.GenericGenerator;

import com.wanda.credit.base.domain.BaseDomain;
/**
 * 运营商原始数据-短信信息
 * @author xiaobin.hou
 *
 */
@Entity
@Table(name = "CPDB_DS.T_DS_JXL_OPER_MSG")
@JsonIgnoreProperties(value = { "hibernateLazyInitializer"})
@JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
public class MobileRawDataSmsesPojo extends BaseDomain {
	
	private static final long serialVersionUID = 1L;
	/**
	 * 获取 主键
	 */
	@Id
	@GeneratedValue(generator = "system-uuid")
	@GenericGenerator(name = "system-uuid", strategy = "uuid")
	@Column(name = "SEQID", unique = true, nullable = false, length = 32)
	private String seqId;
	private String requestId;
	private String start_time;
	@Column(name="DEAL_TIME")
	private String update_time;
	private String init_type;
	private String place;
	private String cell_phone;
	private String other_cell_phone;
	private String subtotal;
	private Date crt_time;
	private Date upd_time;
	private String fk_seqId;
//	@ManyToOne(cascade = {CascadeType.MERGE,CascadeType.REFRESH }, optional = true) 
//	@JoinColumn(name="FK_SEQID",referencedColumnName="seqId")
//	private MobileRawDataOwnerPojo owerInfo;

	public String getSeqId() {
		return seqId;
	}

	public void setSeqId(String seqId) {
		this.seqId = seqId;
	}

	public String getRequestId() {
		return requestId;
	}

	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	public String getStart_time() {
		return start_time;
	}

	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}

	public String getInit_type() {
		return init_type;
	}

	public void setInit_type(String init_type) {
		this.init_type = init_type;
	}

	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	public String getCell_phone() {
		return cell_phone;
	}

	public void setCell_phone(String cell_phone) {
		this.cell_phone = cell_phone;
	}

	public String getOther_cell_phone() {
		return other_cell_phone;
	}

	public void setOther_cell_phone(String other_cell_phone) {
		this.other_cell_phone = other_cell_phone;
	}

	public String getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(String subtotal) {
		this.subtotal = subtotal;
	}

	public Date getCrt_time() {
		return crt_time;
	}

	public void setCrt_time(Date crt_time) {
		this.crt_time = crt_time;
	}

	public Date getUpd_time() {
		return upd_time;
	}

	public void setUpd_time(Date upd_time) {
		this.upd_time = upd_time;
	}

//	public MobileRawDataOwnerPojo getOwerInfo() {
//		return owerInfo;
//	}
//
//	public void setOwerInfo(MobileRawDataOwnerPojo owerInfo) {
//		this.owerInfo = owerInfo;
//	}

	public String getUpdate_time() {
		return update_time;
	}

	public void setUpdate_time(String update_time) {
		this.update_time = update_time;
	}

	public String getFk_seqId() {
		return fk_seqId;
	}

	public void setFk_seqId(String fk_seqId) {
		this.fk_seqId = fk_seqId;
	}	

}
