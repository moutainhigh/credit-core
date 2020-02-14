package com.wanda.credit.ds.client.guozt;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.ws.RequestWrapper;
import javax.xml.ws.ResponseWrapper;

/**
 * This class was generated by Apache CXF 2.7.11
 * 2015-12-24T16:28:31.381+08:00
 * Generated source version: 2.7.11
 * 
 */
@WebService(targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn", name = "QueryValidatorServices")
@XmlSeeAlso({ObjectFactory.class})
public interface QueryValidatorServices {

    @WebResult(name = "querySingleReturn", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
    @RequestWrapper(localName = "querySingle", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn", className = "cn.id5.gboss.businesses.validator.service.app.QuerySingle")
    @WebMethod
    @ResponseWrapper(localName = "querySingleResponse", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn", className = "cn.id5.gboss.businesses.validator.service.app.QuerySingleResponse")
    public java.lang.String querySingle(
        @WebParam(name = "userName_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String userName,
        @WebParam(name = "password_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String password,
        @WebParam(name = "type_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String type,
        @WebParam(name = "param_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String param
    );

    @WebResult(name = "queryBatchReturn", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
    @RequestWrapper(localName = "queryBatch", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn", className = "cn.id5.gboss.businesses.validator.service.app.QueryBatch")
    @WebMethod
    @ResponseWrapper(localName = "queryBatchResponse", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn", className = "cn.id5.gboss.businesses.validator.service.app.QueryBatchResponse")
    public java.lang.String queryBatch(
        @WebParam(name = "userName_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String userName,
        @WebParam(name = "password_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String password,
        @WebParam(name = "type_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String type,
        @WebParam(name = "param_", targetNamespace = "http://app.service.validator.businesses.gboss.id5.cn")
        java.lang.String param
    );
}
