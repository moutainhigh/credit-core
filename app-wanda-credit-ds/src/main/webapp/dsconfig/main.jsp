<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String jssesionID = (String)request.getParameter("jssesionID");
if(jssesionID == null || jssesionID.trim().equals("")){
  response.sendRedirect(path+"/dsconfig/login.jsp");
  return;
}
%>

<head>
<base href="<%=basePath%>"> 
  <meta charset="utf-8" /> 
  <meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
  <meta name="viewport" content="width=device-width, initial-scale=1" /> 
  <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags --> 
  <meta name="description" content="" /> 
  <meta name="author" content="" /> 
  <title>数据源可视化配置平台</title> 
  <link rel="stylesheet" href="dsconfig/adminLTE/css/AdminLTE2.css" /> 
  <link rel="stylesheet" href="dsconfig/bootstrap/v3_3_7/dist/css/bootstrap.min.css" /> 

  <link rel="stylesheet" href="dsconfig/table/css/bootstrap-table.css"/> 
  <link rel="stylesheet" href="dsconfig/table/css/bootstrap-editable.css" /> 

  <!--link href="../../assets/css/ie10-viewport-bug-workaround.css" rel="stylesheet" /> 
  <script src="../../assets/js/ie-emulation-modes-warning.js"></script--> 
  <link rel="stylesheet" href="dsconfig/css/font-awesome.min.css" /> 
  <link rel="stylesheet" href="dsconfig/css/ionicons.min.css" /> 

  <link rel="stylesheet" href="dsconfig/adminLTE/css/skins/_all-skins.min.css" /> 
  <style>
		body,button, input, select, textarea,h1 ,h2, h3, h4, h5, h6 {
			font-family: Microsoft YaHei,'宋体' , Tahoma, Helvetica, Arial, "\5b8b\4f53", sans-serif;
		}

		fieldset {
			padding: .35em .625em .75em;
			margin: 0 2px;
			border: 1px solid silver
		}

		legend {
			padding: .5em;
			border: 0;
			width: auto
		}

		.list {
			height: 380px;
			overflow: auto;
		}

		.item {
			background: orange;
		}

		.list-complete-item {
			padding: 4px;
			margin-top: 4px;
			border: solid 1px;
			transition: all 1s;
		}

		.list-complete-enter,
			  .list-complete-leave-active {
			opacity: 0;
		}

		.glyphicon-move {
			cursor: move;
		}

		.sortable-ghost {
			background: green;
			color: black;
			opacity: 0.5;
		}

		.fixedLayer {
			position: fixed;
			right: 30px;
			bottom: 20px;
			width: 150px;
			z-index: 99;
		}

		.dd {
			background-color: #ecf0f5;
			//background: #f0f0f0;
			border: 1px solid #ddd;
			-webkit-box-shadow: none;
			box-shadow: none;
		}

		.box-title-small {
			display: inline-block;
			font-size: 15px;
			margin: 0;
			line-height: 1;
		}

		.panel-actions {
			margin-top: -20px;
			margin-bottom: 0;
			text-align: right;
		}

		.panel-actions a {
			color: #333;
		}

		.panel-fullscreen {
			display: block;
			z-index: 9999;
			position: fixed;
			width: 100%;
			height: 100%;
			top: 0;
			right: 0;
			left: 0;
			bottom: 0;
			overflow: auto;
		}

		.tooltip.top .tooltip-inner {
			background-color: #0099ff;
			font-size: 14px;
		}

		.tooltip.top .tooltip-arrow {
			border-top-color: #0066ff;
		}

		.input-group-addon {
			min-width: 90px;
			text-align: left;
		}

		.box-title2 {
			color: white;
			display: inline-block;
			font-size: 14px;
			margin: 0;
			line-height: 1;
		}

		.whitefont {
			color: white;
		}
</style> 
  <!-- ======================================start import outter js script=========================--> 
  <script type="text/javascript" src="dsconfig/jquery/jquery-latest.js"></script> 
  <script type="text/javascript" src="dsconfig/jquery/jquery-ui.min.js"></script> 
  <script type="text/javascript" src="dsconfig/bootstrap/v3_3_7/dist/js/bootstrap.min.js"></script> 
  <script type="text/javascript" src="dsconfig/table/js/bootstrap-table.js"></script> 

  <script type="text/javascript" src="dsconfig/table/bootstrap-editable.js"></script> 
  <script type="text/javascript" src="dsconfig/table/bootstrap-table-editable.js"></script> 
  <!--script type="text/javascript" src="https://unpkg.com/vue"></script--> 
  <script type="text/javascript" src="dsconfig/vue/vue.js"></script> 
  <script type="text/javascript" src="dsconfig/jquery/Sortable.js"></script> 
  <script type="text/javascript" src="dsconfig/jquery/draggable.js"></script> 
  <script type="text/javascript" src="dsconfig/adminLTE/js/app.js"></script> 
  <!-- ======================================end import outter js script=========================--> 
  <script>
var jssesionID = "<%=jssesionID%>";  
var startid = 0;
var copiedData;
function getUniqId() {
    return++startid;
}
function addUniqid(params, initid) {
    var newparams = [];
    $.each(params,
    function(ind, item) {
        var newitem = jQuery.extend(true, {},
        item);
        newitem['id'] = ++initid;
        newparams.push(newitem);
    });
    return newparams;
}

function delUniqid(params) {
    var newparams = [];
    $.each(params,
    function(ind, item) {
        var newitem = jQuery.extend(true, {},
        item);
        newitem['id'] = undefined;
        newparams.push(newitem);
    });
    return newparams;
}
/**/
var preExprTypes = ['fmr:', 'freemarker:', 'cont:', 'constant:'];
function getExprStr(str) {
    if(!str)return str;
    for (var i = 0; i < preExprTypes.length; i++) {
        var item = preExprTypes[i];
        var ind = str.indexOf(item);
        if (ind == 0) {
            return str.substring(item.length, str.length)
        }
    }
    return str;
}

function getExprType(str) {
    if(!str)return str;
    for (var i = 0; i < preExprTypes.length; i++) {
        var item = preExprTypes[i];
        var ind = str.indexOf(preExprTypes[i]);
        if (ind == 0) {
            return standardExprType(item.substring(0, item.length - 1));
        }
    }
    return "fmr";
}
function standardExprType(str) {
    if (str == 'freemarker') return 'fmr';
    else if (str == 'cont') return 'constant';
    else return str;
}

function blendExprAndType(exprObj){
      if(!exprObj || !exprObj.exprStr)return null;
      if(exprObj.exprType =='cont' || exprObj.exprType =='constant'){
	     return 'cont:'+exprObj.exprStr;
	   }
	   //fmr 省略
	   return exprObj.exprStr;
  }
  var componentmap = {
   'com.wanda.credit.dsconfig.model.expression.HttpRequestCondExpr':'httprequestcomp',   'com.wanda.credit.dsconfig.model.action.QueryCacheQuickAction':'smartcachecomp',   'com.wanda.credit.dsconfig.model.action.VarDefineAction':'vardefinitioncomp', 
   'com.wanda.credit.dsconfig.model.action.TagAction':'tagcomp',   'com.wanda.credit.dsconfig.model.action.ExceptionAction':'exceptioncomp',
   'com.wanda.credit.dsconfig.model.action.LogAction':'logcomp',   
   'com.wanda.credit.dsconfig.model.action.RetDataAction':'retdatacomp',
   'com.wanda.credit.dsconfig.model.expression.LoggingCondExpr':'logcomp',
   'com.wanda.credit.dsconfig.model.expression.ConditionExpr':'commcomp',
'com.wanda.credit.dsconfig.model.action.ExitAction':'exitcomp',
   };
  function getComponentTag(key){
     return componentmap[key]
   }
  function swapItemPosInArray(array, from, to) {
	if (to === from) return array;

	var target = array[from];
	var increment = to < from ? -1 : 1;

	for (var k = from; k != to; k += increment) {
		array[k] = array[k + increment];
	}
	array[to] = target;
	return array;
  }
  
  function postData(url,data,succ,fail){
    if(data){
      data["jssesionID"] = jssesionID;
    }
    $.ajax({
	   url: baseURL+"/"+url,//json文件位置
	   type: "POST",//请求方式为post
	   data:data,
	   dataType: "JSON", //返回数据格式为json
	   success: succ//请求成功完成后要执行的方法 
	 });
  }
   
  function postJsnData(url,data,succ,fail){
    if(data){
      data["jssesionID"] = jssesionID;
    }
    $.post(baseURL+"/"+url,data,succ,'json');
  }
  var baseURL= "<%=request.getContextPath()%>/dscfg";
  console.log('baseURL',baseURL);
  
  function error(msg){
     $("#span_warnmsg").text(msg);
	 $("#div_warn").slideDown();
	 setTimeout(function(){$("#div_warn").slideUp()},5000);	 
  }
  
  function postFormData(url,data,succ,fail){
	  if(data){
	      data["jssesionID"] = jssesionID;
	    }
      var formdata = "jssesionID="+jssesionID+"&cfgjsn="+escape(encodeURIComponent(data.cfgjsn)) 
	    $.ajax({
          type: "post",
          dataType: "JSON",
          url:baseURL+"/"+url,
          data:formdata,
          success:succ
      });
   }
  
  function popmsg(msg,lasttime){
     if(!lasttime){
       lasttime = 5000;
     }
     $("#span_warnmsg").text(msg);
	 $("#div_warn").slideDown();
	 setTimeout(function(){$("#div_warn").slideUp()},lasttime);	 
  }
  
  function getSelectedIdxFromBoostrapTable(selectitemname){
    var idx = -1;
	$('input[name='+selectitemname+']:checked').each(function() {
		idx = $(this).data('index');			
	  });
    return idx;
  }
  
   </script>
 </head>  
 <body class="dd"> 
  <!-- Bootstrap core JavaScript
    ================================================== --> 
  <!-- Placed at the end of the document so the pages load faster --> 
  <!-- ======================数据源基本属性 component start=============================----> 
  <template id="basicInfoCompTpl"> 
   <div class="box box-info collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true" v-show="!dataobj.fixed"></span> 
     <h5 class="box-title-small">数据源基本信息</h5> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" data-widget="remove" v-show="!dataobj.fixed"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <div class="row"> 
      <div class="col-md-6"> 
       <div class="input-group "> 
        <span class="input-group-addon">数据源ID</span> 
        <input name="dsId" type="text" class="form-control disabled" placeholder="这里输入数据源ID" v-model="dsId" :disabled="readonly || !isNew"/> 
       </div> 
      </div> 
      <div class="col-md-6"> 
       <div class="input-group"> 
        <span class="input-group-addon">数据源名称</span> 
        <input name="dsName" type="text" class="form-control" placeholder="这里输入数据源名称" v-model="dsName" :disabled="readonly || !isNew"/> 
       </div> 
      </div> 
     </div> 
     <br /> 
     <div class="input-group"> 
      <span class="input-group-addon">请求地址</span> 
      <input name="reqUrl" type="text" class="form-control" placeholder="请求URL,不是必输的" v-model="reqUrl" :disabled="readonly"/> 
     </div> 
     <br /> 
     <div class="col-md-12"> 
     </div> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" style="padding-bottom:5px" role="toolbar"> 
      <div class="btn-group btn-group-sm"  v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertEmpty"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
// 注册
Vue.component('basicinfocomp', {
    props: ['puniqid','dataobj'],
    template: '#basicInfoCompTpl',
    data: function() {
        return {
		    uniqid: this.puniqid,
            paramTable: null,
            rowuniqid: 1,
            dsId: null,
            dsName: null,
            reqUrl: null,
            isNew:false,
			readonly : this.dataobj.readonly,
            params: [{
                "id": -1,
                "name": null,
                "initValue": null,
                "desc": null
            },
            {
                "id": -2,
                "name": null,
                "initValue": null,
                "desc": null
            }]
        }
    },
    mounted: function() {
        this.initialize();

    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
        clear:function(){
          this.dsId = null;
          this.dsName = null;
          this.reqUrl = null;         
          this.insertRow({
                "name": null,
                "initValue": null,
                "desc": null,
                "persisted":true
            });          
        },
        initData: function(obj) {
		    var basicinfo = null;
		    if(obj && obj.basicInfo){
			   basicinfo = obj.basicInfo;
			}else{
			   return;
			}
            this.dsId = basicinfo.dsId;
            this.dsName = basicinfo.dsName;
            this.reqUrl = basicinfo.reqUrl;
			this.paramTable.bootstrapTable('removeAll');
			this.resetIsPersisted(basicinfo.params);
            this.insertRows(addUniqid(basicinfo.params, this.rowuniqid));
        },
        resetIsPersisted : function(params){
            $.each(params,
             function(ind, item) {       
               var value = item.persisted;
               if(value == null || value == 'undefined' || value == ''){
               item['persisted'] = true;
                }
             });
        },
        getPostData: function() {
            return {
                'basicInfo': {
                    'dsId': this.dsId,
                    'dsName': this.dsName,
                    'reqUrl': this.reqUrl,
                    'params': delUniqid(this.params)
                }
            };
        },
		insertRows:function(params){
		  var parent= this;
		  $.each(params,function(ind,item){
          var end = parent.params ? parent.params.length: 0;
		  parent.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: item
            });  
		  });
		},
		insertEmpty:function(){
        	this.insertRow(null);
        },
        insertRow: function(row) {
            var end = this.params ? this.params.length: 0;
            var empty ;
            if(row){
               empty = row;
               empty['id'] = ++this.rowuniqid;
            }else{
	             empty = {
	                "id": ++this.rowuniqid,
	                "name": null,
	                "initValue": null,
	                "persisted":true,
	                "desc": null
	            };
	        }
            this.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: empty
            });
        },
        deleteRow: function() {
           /* this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: [2]
            });*/
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            $('input[name="dsId"]').tooltip({
                'placement': 'top',
                'trigger': 'manual',
                'title': '数据源ID不能为空',
                delay: {
                    "show": 500,
                    "hide": 100
                }
            });

            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                idField: 'name',
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'name',
                    title: '参数名',
                    editable: {
                        mode: "inline",
                        type: 'text'
                    }
                },
                {
                    field: 'initValue',
                    title: '初始值',

                    editable: {
                        mode: "inline",
                        type: 'text'
                    }
                },
                {
                    field: 'persisted',
                    title: '记录参数',

                    editable: {
                        mode: "inline",
                        type: 'text'
                    }
                },
                {
                    field: 'desc',
                    title: '备注',
                    editable: {
                        clear: false,
                        mode: "inline",
                        title: '备注',
                        placement: 'right',
                        type: 'text'
                    }
                }]
            });
        },
        validate: function() {
            if (! ($.trim(this.dsId))) {
                return "数据源ID不能为空";
            } else if (! ($.trim(this.dsName))) {
                return "数据源名称不能为空";
            } else if (! ($.trim(this.reqUrl))) {
                return "请求地址不能为空";
            } else {
                if (!this.params || this.params.length == 0) {
                    return "输入参数不能为空";
                }
                for (var i = 0; i < this.params.length; i++) {
                    var item = this.params[i];
                    if (!item.name) {
                        return "参数名不能为空";
                    }
                }

                return null;
            }
        }

    }

});
</script> 
  <!-- ======================数据源基本属性 component end=============================----> 
  <!-- ======================变量声明 component start=============================----> 
  <template id="varDefinitionCompTpl"> 
   <div class="box box-info  collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true" v-show="!dataobj.fixed && !dataobj.readonly"></span> 
     <h3 class="box-title-small">变量声明</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove" v-show="!dataobj.fixed && !dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm" v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertEmpty"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" @click="deleteRow" class="btn btn-info" ><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" v-bind:data-select-item-name="'selectItemName'+uniqid"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
// 注册
Vue.component('vardefinitioncomp', {
    props: ['puniqid','dataobj'],
    template: '#varDefinitionCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
			readonly : this.dataobj.readonly,
            params: [{
                "id": -1,
				"condition" :null,
                "name": null,
                "value": null
            }]
        }
    },
    mounted: function() {
        this.initialize();
        if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}
    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });		
    },
    methods: {       
       clear:function(){	
       		this.paramTable.bootstrapTable('removeAll');        
	        this.insertRow({                
				"condition" :null,
                "name": null,
                "value": null
            });  
        },
	    remove:function(e){
			 e.preventDefault();
			 //setTimeout('this.removeChild()',500); 
			  /*var box = $(e.target).parents(".box").first();
			  box.slideUp(200); */
			  this.removeVueChild();			  
		},		
		removeVueChild:function(){
			  this.$parent.$emit('removechild', this, {
					'uniqid': this.uniqid
				  });
		},
        initData: function(obj){
		    this.paramTable.bootstrapTable('removeAll');
            //this.params = addUniqid(obj.params, this.rowuniqid);
			var outter ; var datalist;
			if(this.dataobj && this.dataobj.ismodule){
			  outter = obj.varDefineAction;
			}else{
			  outter = obj;
			}
			if(outter){
			  datalist = outter.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"name": item.name,
					"value":  blendExprAndType(item),
					"condition" : blendExprAndType(item.condition)
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
        },
		<%/*
		"varDefineAction": {
        "classType": "com.wanda.credit.dsconfig.model.action.VarDefineAction",
        "exprs": [
            {
                "classType": "com.wanda.credit.dsconfig.model.expression.VarDefineCondExpr",
                "exprStr": "mDuzUgGI5tVGY_wCmEuFS1IP",
                "exprType": "constant",
                "condition": null,
                "name": "key"
            }
        ],
        "conflicted": false
       }*/%>
        getPostData: function() {		   
            var retobj = {
                "classType": "com.wanda.credit.dsconfig.model.action.VarDefineAction",
                "conflicted": false
            };
            var exprs = [];
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.VarDefineCondExpr",
					"exprStr": getExprStr(item.value),
					"exprType": getExprType(item.value),
					"name": item.name,
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null)
                });
            });
            retobj['exprs'] = exprs;
			if(this.dataobj && this.dataobj.ismodule){
			  return {"varDefineAction":retobj};
			}else{
			  return retobj;
			}            
        },
        insertEmpty:function(){
        	this.insertRow(null);
        },
        insertRow: function(row) {        
            var selectitemname = "selectItemName"+this.uniqid;			
            var idx = getSelectedIdxFromBoostrapTable(selectitemname);
            if(idx == -1){
               idx = this.params ? this.params.length: 0;
            }
            var empty ;
            if(row){
               empty = row;
               empty['id'] = ++this.rowuniqid;
            }else{
	             empty = {
	                "id": ++this.rowuniqid,
	                "name": null,
	                "value": null
	            };
	        }    
            this.paramTable.bootstrapTable('insertRow', {
                index: idx,
                row: empty
            });
        },
        deleteRow: function() {
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                idField: 'name',
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'condition',
                    title: '条件',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'name',
                    title: '变量名',
                    editable: {
                        mode: "inline",
                        type: 'text'
                    }
                },
                {
                    field: 'value',
                    title: '变量值',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                }]
            });
        },
        validate: function() {
            if (!this.params || this.params.length == 0) {
                return "变量定义内容不能为空";
            }
            for (var i = 0; i < this.params.length; i++) {
                var item = this.params[i];
                if (!item.name) {
                    return "变量名不能为空";
                } else if (!item.value) {
                    return "变量值不能为空";
                }
            }

            return null;
        }

    }

});

</script> 
  <!-- ======================变量声明 component end=============================----> 
  <!-- ======================标签定义 component start=============================----> 
  <template id="tagCompTpl"> 
   <div class="box box-info  collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h3 class="box-title-small">标签处理</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove"  v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm"  v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" v-bind:data-select-item-name="'selectItemName'+uniqid"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
  // 注册
Vue.component('tagcomp', {
    props: ['puniqid','dataobj'],
    template: '#tagCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
			readonly : this.dataobj.readonly,
            params: [{
                "id": -1,
                "condition": null,
                "tag": null,
                "bizcode1":null
            }]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}

    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
	    remove:function(e) {
			 e.preventDefault();
			 this.removeVueChild();
		},		
		removeVueChild:function() {
			 this.$parent.$emit('removechild', this, {
							'uniqid': this.uniqid
		   });
		},
	
	<%/*{
                "classType": "com.wanda.credit.dsconfig.model.action.TagAction",
                "conflicted": true,
                "exprs": [
                    {
                        "classType": "com.wanda.credit.dsconfig.model.expression.TagCondExpr",
                        "exprStr": "tst_fail",
                        "exprType": "constant",
                        "condition": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "${!(rspData.code??) || !exist(rspData.code?c,'2001')}",
                            "exprType": "fmr"
                        }
                    }
                ]
            }*/%>
        initData: function(obj) {
            this.paramTable.bootstrapTable('removeAll');
            //this.params = addUniqid(obj.params, this.rowuniqid);
			 var datalist;			
			if(obj){
			  datalist = obj.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"tag": item.exprStr,
					"bizcode1":blendExprAndType(item.bizcode1),
					"condition" : blendExprAndType(item.condition)
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
		},
        getPostData: function() {
            var retobj = {
                "classType": "com.wanda.credit.dsconfig.model.action.TagAction",
                "conflicted": false
            };
            var exprs = [];
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.TagCondExpr",
                    "exprStr": item.tag,
                    "bizcode1":{
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.bizcode1,
                        "exprType": "fmr"
                    },
                    "exprType": "constant",
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null)
                });
            });
            retobj['exprs'] = exprs;
            return retobj;

        },
        insertRow: function() {
            var selectitemname = "selectItemName"+this.uniqid;			
            var end = getSelectedIdxFromBoostrapTable(selectitemname);
            if(end == -1){
               end = this.params ? this.params.length: 0;
            }
            var empty = {
                "id": ++this.rowuniqid,
                "condition": null,
                "bizcode1":null,
                "tag": null
            };
            this.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: empty
            });
        },
        deleteRow: function() {
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                idField: 'name',
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'condition',
                    title: '条件',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'tag',
                    title: '标签',

                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },{
                    field: 'bizcode1',
                    title: '业务码',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                }]
            });
        },
        validate: function() {
            if (!this.params || this.params.length == 0) {
                return "标签内容不能为空";
            }
            for (var i = 0; i < this.params.length; i++) {
                var item = this.params[i];
                if (!item.tag) {
                    return "标签内容不能为空";
                }
            }

            return null;
        }

    }

});
  </script> 
  <!-- ======================标签定义 component end=============================----> 
  <!-- ======================异常处理 component start=============================----> 
  <template id="exceptionCompTpl"> 
   <div class="box box-info collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h3 class="box-title-small">异常处理</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove" v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm"  v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" v-bind:data-select-item-name="'selectItemName'+uniqid"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
// 注册
Vue.component('exceptioncomp', {
    props: ['puniqid','dataobj'],
    template: '#exceptionCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
			readonly:this.dataobj.readonly,
            params: [{
                "id": -1,
                "condition": null,
                "errCode":null,
                "exception": null,
                "loglvl": "error",
                "log": null,
            }]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}

    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
	    remove:function(e){
		     e.preventDefault();			
             this.removeVueChild();			  
              			  
		},
		removeVueChild:function(){
		  this.$parent.$emit('removechild', this, {
				'uniqid': this.uniqid
			  });
		 },
        initData: function(obj) {
            this.paramTable.bootstrapTable('removeAll');
            //this.params = addUniqid(obj.params, this.rowuniqid);
			 var datalist;			
			if(obj){
			  datalist = obj.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"errCode":item.errCode,
					"exception": blendExprAndType(item),
					"condition" : blendExprAndType(item.condition),
					"loglvl" : item.loggingExpr?item.loggingExpr.level:null,
					"log":blendExprAndType(item.loggingExpr)					
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
        },
        <%/*
		{
                "classType": "com.wanda.credit.dsconfig.model.action.ExceptionAction",
                "conflicted": true,
                "exprs": [
                    {
                        "classType": "com.wanda.credit.dsconfig.model.expression.ExceptionCondExpr",
                        "exprStr": "数据源厂商返回异常",
                        "exprType": "fmr",
                        "condition": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "${exist(rspData.data.success,'False','false')}",
                            "exprType": "fmr"
                        },
                        "loggingExpr": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.LoggingCondExpr",
                            "exprStr": "数据源返回异常，详细信息:${(rspData.data.reason_code)!''}  ${(rspData.data.reason_desc)!''}",
                            "exprType": "fmr",
                            "level": "error"
                        },
                        "errCode": "STATUS_FAILED_SYS_DS_EXCEPTION"
                    }
                ]
            }
	*/%>
        getPostData: function() {
            var retobj = {
                "classType": "com.wanda.credit.dsconfig.model.action.ExceptionAction",
                "conflicted": true
            };
            var exprs = [];
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.ExceptionCondExpr",
                    "exprStr": getExprStr(item.exception),
                    "exprType": getExprType(item.exception),
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null),
                    "loggingExpr": (item.log ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.LoggingCondExpr",
                        "exprStr": getExprStr(item.log),
                        "exprType": getExprType(item.log),
                        "level": item.loglvl
                    } : null),
                    "errCode": item.errCode
                });
            });
            retobj['exprs'] = exprs;
            return retobj;

        },
        insertRow: function() {
            var selectitemname = "selectItemName"+this.uniqid;			
            var end = getSelectedIdxFromBoostrapTable(selectitemname);
            if(end == -1){
               end = this.params ? this.params.length: 0;
            }            
            var empty = {
                "id": ++this.rowuniqid,
                "errCode":null,
                "condition": null,
                "exception": null,
                "loglvl": null,
                "log": null
            };
            this.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: empty
            });
        },
        deleteRow: function() {
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'condition',
                    title: '条件',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'errCode',
                    title: '错误码',
                    editable: {
                        mode: "inline",
                        type: 'text'
                    }
                },{
                    field: 'exception',
                    title: '返回错误信息',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'loglvl',
                    title: '日志级别',
                    editable: {
                        mode: "inline",
                        type: 'text'
                    }
                },
                {
                    field: 'log',
                    title: '日志内容',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                }]
            });
        },
        validate: function() {
            if (!this.params || this.params.length == 0) {
                return "异常内容不能为空";
            }
            for (var i = 0; i < this.params.length; i++) {
                var item = this.params[i];
                if (!item.condition) {
                    return "异常条件不能为空";
                }else if (!item.errCode) {
                    return "错误码不能为空";
                } else if (!item.exception) {
                    return "异常内容不能为空";
                }
            }

            return null;
        }

    }

});
</script> 
  <!-- ======================异常处理 component end=============================----> 
  <!-- ======================httprequestaction component start=============================----> 
  <template id="httpRequestCompTpl"> 
   <div class="box box-info  collapsed-box">
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h2 class="box-title-small">发起http请求</h2> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool"  @click="remove" :testdata="uniqid"  v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <!-- /.box-header --> 
    <div class="box-body"> 
	<div class="input-group" style="padding-bottom:10px"> 
      <span class="input-group-addon" > 条&nbsp;&nbsp;件 </span> 
      <textarea class="form-control" v-model="condition" rows="1" :disabled="readonly"></textarea> 
     </div> 
       <div class="row" style="padding-bottom:10px"> 
		
				     <div class="col-md-6 " > 
     <div class="input-group">
         <span class="input-group-addon">请求类型</span> 
           <select class="form-control" v-model="reqType" :disabled="readonly">
			<option value="get_http">HTTP/GET</option>
			<option value="get_https">HTTPS/GET</option>
			<option value="post_http">HTTP/POST</option>
			<option value="post_https">HTTPS/POST</option>
			<option value="webservice">WEBSERVICE</option>
			</select>
		</div>        
     </div> 
      
	 <div class="col-md-6 " > 
		<div class="input-group">
         <span class="input-group-addon">响应数据格式</span> 

		 <select class="form-control" v-model="rspMsgStyle" :disabled="readonly">
			<option value="json" >JSON</option>
			<option value="xml">XML</option>
			<option value="unknown">未知</option>
		</select>
		</div>
		</div>
       </div> 
     <div class="input-group" style="padding-bottom:10px"> 
      <span class="input-group-addon">请求头参数</span> 
      <textarea class="form-control" v-model="headerParams" rows="2" :disabled="readonly"></textarea> 
     </div> 
     <div class="input-group" style="padding-bottom:10px"> 
      <span class="input-group-addon">请求体参数</span> 
      <textarea class="form-control" v-model="bodyParams" rows="2" :disabled="readonly"></textarea> 
     </div> 
     <div class="input-group" style="padding-bottom:10px"> 
      <span class="input-group-addon">请求全路径</span> 
      <input type="text" class="form-control" placeholder="请求URL,不是必输的" v-model="fullUrl" :disabled="readonly"/> 
     </div> 
     <div class="input-group" style="padding-bottom:10px"> 
      <span class="input-group-addon">Mock&nbsp;数据</span>
      <textarea class="form-control" v-model="mockRspData" rows="1" :disabled="readonly"></textarea> 
     </div> 
	 
	    <div class="row" style="padding-bottom:10px"> 
		
				     <div class="col-md-6 " > 
	 
	 
     <div class="input-group" style="padding-bottom:10px"> 
      <span class="input-group-addon">Api &nbsp;调用</span> 
      <input type="text" class="form-control" placeholder="请求URL,不是必输的" v-model="apiCall" :disabled="readonly"/> 
     </div> 
	 </div>
	  <div class="col-md-6 " >
     <div class="input-group " style="padding-bottom:15px"> 
      <span class="input-group-addon" style="width:50px"> &nbsp;超&nbsp;&nbsp;时&nbsp;</span> 
      <input type="text" class="form-control " placeholder="" v-model="timeout" :disabled="readonly"/> 
      <span class="input-group-addon"> 毫 秒 </span> 
     </div> 
     <!-- /.panel-heading -->  
    </div>
   </div> 
  </template> 
  <script>
Vue.component('httprequestcomp', {
    props: ['puniqid','dataobj'],
    template: '#httpRequestCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            condition: null,
            reqType: "post_http",
            rspMsgStyle: "json",
            headerParams: null,
            bodyParams: null,
            mockRspData: null,
            apiCall: null,
            fullUrl: null,
            timeout: 10000,
			readonly:this.dataobj.readonly
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){		  
		   this.initData(this.dataobj.initDataObj)
		}
		
     },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
	},
    methods: {
		remove:function(e){		 
				 e.preventDefault();
				<% //setTimeout('this.removeChild()',500); 
				  /*var box = $(e.target).parents(".box").first();
				  box.slideUp(200); */ %>
				  this.removeVueChild();			  
							  
			},
		removeVueChild:function(){
		  this.$parent.$emit('removechild', this, {
				'uniqid': this.uniqid
			  });
		 },
        initData: function(obj) {
		  if(obj && obj['exprs'] && obj['exprs'].length > 0 ){
		     var httpobj = obj['exprs'][0];
             this.reqType =  httpobj.reqType;
			 this.timeout = httpobj.timeout
		     this.rspMsgStyle = httpobj.rspMsgStyle;
			 var header = httpobj.headerParams;
			 if(header){
			    this.headerParams = blendExprAndType(header);
			 }
			 var body = httpobj.bodyParams;
			 if(body){
			    this.bodyParams = blendExprAndType(body);
			 }
			 var fullUrl = httpobj.fullUrl;
			 if(fullUrl){
			    this.fullUrl = blendExprAndType(fullUrl);
			 }
			 var condition = httpobj.condition;
			 if(condition){
			    this.condition = blendExprAndType(condition);
			 }
			 var apiCall = httpobj.apiCall;
			 if(apiCall){
			    this.apiCall = blendExprAndType(apiCall);
			 }
			 var mockRspData = httpobj.mockRspData;
			 if(mockRspData){
			    this.mockRspData = blendExprAndType(mockRspData);
			 }
		  }
        },
        <%/*{
                "classType": "com.wanda.credit.dsconfig.model.action.ConditionAction",
                "exprs": [                    
                    {
                        "classType": "com.wanda.credit.dsconfig.model.expression.HttpRequestCondExpr",
                        "reqType": "post_http",
                        "timeout": 10000,
                        "headerParams": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "<@map name='riskRortheaderparams' value={'Content-Type':'application/json','X-Access-Token':'${tokenservice.getNewToken()}'}></@map>",
                            "exprType": "fmr"
                        },
                        "bodyParams": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "<@map name='riskRortbodyparams' value=requestData?eval ></@map>",
                            "exprType": "fmr"
                        },
                        "fullUrl": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "${reqUrl}",
                            "exprType": "fmr"
                        },
                        "rspMsgStyle": "json",
                        "condition": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "${exist((rspStatus.code)!'','401') ||(rspData.code?? && exist(rspData.code?c,'401','000','001'))}",
                            "exprType": "fmr"
                        }
                    }
                ],
                "conflicted": false
            },*/%>
        getPostData: function() {
            var retobj = {
                "classType": "com.wanda.credit.dsconfig.model.action.ConditionAction",
                "conflicted": false
            };
            var exprs = [];
            exprs.push({
                "classType": "com.wanda.credit.dsconfig.model.expression.HttpRequestCondExpr",
                "reqType": this.reqType,
                "timeout": parseInt(this.timeout),
                "rspMsgStyle": this.rspMsgStyle,
                "condition":  (this.condition ? {
					"classType": "com.wanda.credit.dsconfig.model.expression.Expression",
					"exprStr": this.condition,
					"exprType": "fmr"
				} : null),
                "headerParams": (this.headerParams ? {
                    "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                    "exprStr": getExprStr(this.headerParams),
                    "exprType": getExprType(this.headerParams)
                } : null ),
                "bodyParams": (this.bodyParams ? {
                    "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                    "exprStr": getExprStr(this.bodyParams),
                    "exprType": getExprType(this.bodyParams)
                } : null),
                "fullUrl": (this.fullUrl ? {
                    "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                    "exprStr": getExprStr(this.fullUrl),
                    "exprType": getExprType(this.fullUrl)
                } : null),
                "apiCall": (this.apiCall ? {
                    "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                    "exprStr": getExprStr(this.apiCall),
                    "exprType": getExprType(this.apiCall)
                } : null),
				"mockRspData":(this.mockRspData ? {
					"classType" : "com.wanda.credit.dsconfig.model.expression.Expression",
					"exprStr" : getExprStr(this.mockRspData),
					"exprType" : getExprType(this.mockRspData)
				} : null)
            });
            retobj['exprs'] = exprs;
            return retobj;

        },
        initialize: function() {},
        validate: function() {
            if (!this.apiCall && !this.fullUrl  && !this.mockRspData) {
                return "请求地址\Api调用\Mock数据不能同时为空";
            } else if (!this.reqType) {
                return "请求类型不能为空";
            } else if (!this.rspMsgStyle) {
                return "响应数据格式不能为空";
            }
            return null;
        }

    }

});
</script> 
  <!-- ======================httprequestaction component end=============================----> 
  <!-- ======================返回处理 component start=============================----> 
  <template id="retDataCompTpl"> 
   <div class="box box-info collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h3 class="box-title-small">返回处理</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove"  v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm" v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" v-bind:data-select-item-name="'selectItemName'+uniqid"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
// 注册
Vue.component('retdatacomp', {
    props: ['puniqid','dataobj'],
    template: '#retDataCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
			readonly:this.dataobj.readonly,
            params: [{
                "id": -1,
                "condition": null,
                "tablename":null,
                "savedparams": null,
                "retdata": null,
                "prepare": null
			}]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}

    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
	    remove:function(e){
		     e.preventDefault();
			 <%//setTimeout('this.removeChild()',500); 
			  /*var box = $(e.target).parents(".box").first();
			  box.slideUp(200); */%>
              this.removeVueChild();			  
              			  
		},
		removeVueChild:function(){
		  this.$parent.$emit('removechild', this, {
				'uniqid': this.uniqid
			  });
		 },
        initData: function(obj) {
			this.paramTable.bootstrapTable('removeAll');
			var datalist;			
			if(obj){
			  datalist = obj.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,					
					"condition" : blendExprAndType(item.condition),
					"prepare":blendExprAndType(item.prepareExpr),				
					"retdata":blendExprAndType(item),
					"savedparams": item.savedParams,
					"tablename":item.tableName
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
        },
       <% /*
		{
      "classType" : "com.wanda.credit.dsconfig.model.action.RetDataAction",
      "conflicted" : true,
      "exprs" : [ {
        "classType" : "com.wanda.credit.dsconfig.model.expression.SaveRetDataCondExpr",
        "exprStr" : "{'totalCount': ${rspData.totalCount}<#if rspData.satparty??>,'satparty':${forjsn(rspData.satparty)}</#if><#if rspData.fdaparty??>,'fdaparty':${forjsn(rspData.fdaparty)}</#if><#if rspData.epbparty??>,'epbparty':${forjsn(rspData.epbparty)}</#if><#if rspData.qtsparty??>,'qtsparty':${forjsn(rspData.qtsparty)}</#if><#if rspData.xzhmd??>,'xzhmd':${forjsn(rspData.xzhmd)}</#if><#if rspData.mocparty??>,'mocparty':${forjsn(rspData.mocparty)}</#if><#if rspData.pbcparty??>,'pbcparty':${forjsn(rspData.pbcparty)}</#if>}",
        "exprType" : "fmr",
        "prepareExpr" : {
         "classType" : "com.wanda.credit.dsconfig.model.expression.Expression",
          "exprStr" : "${rmmapkey(rspData,'code','msg','searchSeconds')}",
          "exprType" : "fmr"

        },
        "condition" : {
          "classType" : "com.wanda.credit.dsconfig.model.expression.Expression",
          "exprStr" : "${exist(rspData.code!'','s')}",
          "exprType" : "fmr"
        },
        "querySqlPhase" : null,
        "saveRetDataFlag" : true,
        "savedParams" : "datatype;entryId",
        "tableName" : "CPDB_DS.T_DS_STORE_CLOB"
      }
	*/%>
        getPostData: function() {
            var retobj = {
                "classType": "com.wanda.credit.dsconfig.model.action.RetDataAction",
                "conflicted": true
            };
            var exprs = [];
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.SaveRetDataCondExpr",
                    "exprStr": item.retdata,
                    "exprType": "fmr",
                    "prepareExpr": (item.prepare ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.prepare,
                        "exprType": "fmr"

                    } : null),
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null),
                    "querySqlPhase": null,
                    "saveRetDataFlag": true,
                    "tableName":item.tablename,
                    "savedParams": item.savedparams
                });
            });
            retobj['exprs'] = exprs;
            return retobj;

        },
        insertRow: function() {
            var selectitemname = "selectItemName"+this.uniqid;			
            var end = getSelectedIdxFromBoostrapTable(selectitemname);
            if(end == -1){
               end = this.params ? this.params.length: 0;
            }            
            var empty = {
                "id": ++this.rowuniqid,
                "condition": null,
                "exception": null,
                "prepare": null,
                "tablename":null,
                "retdata": null
            };
            this.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: empty
            });
        },
        deleteRow: function() {
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
					width :'5%',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'condition',
                    title: '条件',
					width :'10%',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'prepare',
                    title: '预处理',
                    width :'10%',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'tablename',
                    title: '表名',
                    width :'10%',
					editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'savedparams',
                    title: '保存参数',
                    width :'15%',
					editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'retdata',
                    title: '返回内容',
					width :'50%',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                }]
            });
        },
        validate: function() {
            if (!this.params || this.params.length == 0) {
                return "返回内容不能为空";
            }
            for (var i = 0; i < this.params.length; i++) {
                var item = this.params[i];
                if (!item.retdata) {
                    return "返回内容不能为空";
                }
            }

            return null;
        }

    }

});
</script> 
  <!-- ======================返回处理 component end=============================----> 
  <!-- ======================数据校验 component start=============================----> 
  <template id="verifyCompTpl"> 
   <div class="box box-info collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true" v-show="!dataobj.fixed && !dataobj.readonly"></span> 
     <h3 class="box-title-small">数据校验</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove" v-show="!dataobj.fixed && !dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm" v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" v-bind:data-select-item-name="'selectItemName'+uniqid"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
// 注册
Vue.component('verifycomp', {
    props: ['puniqid','dataobj'],
    template: '#verifyCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
			readonly:this.dataobj.readonly,
            params: [{
                "id": -1,
                "condition": null,
                "fields": null,
                "rule": null,
                "errmsg": null
            }]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}

    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
         clear:function(){	         
	        this.paramTable.bootstrapTable('removeAll');	         
	        this.insertRow({
                "condition": null,
                "fields": null,
                "rule": null,
                "errmsg": null
            });  
        },
	    remove:function(e) {
			 e.preventDefault();			 
			  this.removeVueChild();
		},		
		removeVueChild:function() {
			 this.$parent.$emit('removechild', this, {
							'uniqid': this.uniqid
		   });
		}, 
        initData: function(obj) {
            this.paramTable.bootstrapTable('removeAll');
			var datalist;			
			if(this.dataobj && this.dataobj.ismodule){
			  if(obj.verifyModule && obj.verifyModule.actions){
			  		datalist = obj.verifyModule.actions[0].exprs;

			   }
			}else{
			       datalist = obj.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"errmsg": blendExprAndType(item),
					"fields" : item.fields,
					"rule":blendExprAndType(item.ruleName),
                    "condition":blendExprAndType(item.condition)					
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
		},
		insertRows:function(params){
		  var parent= this;
		  $.each(params,function(ind,item){
          var end = parent.params ? parent.params.length: 0;
		  parent.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: item
            });  
		  });
		},
        <%/*
		"verifyModule" : {
    "classType" : "com.wanda.credit.dsconfig.model.module.VerifyModule",
    "actions" : [ {
      "classType" : "com.wanda.credit.dsconfig.model.action.ValidityAction",
      "exprs" : [ {
        "classType" : "com.wanda.credit.dsconfig.model.expression.ValidityCondExpr",
        "exprStr" : "传入参数不符合要求：待查询的数据类型不能为空",
        "exprType" : "fmr",
        "ruleName" : {
          "classType" : "com.wanda.credit.dsconfig.model.expression.Expression",
          "exprStr" : "required",
          "exprType" : "constant"
        },
        "fields" : "datatype",
        "errCode" : "STATUS_WARN_DS_POLICE_PARAM_FAILED"
      }, {
        "classType" : "com.wanda.credit.dsconfig.model.expression.ValidityCondExpr",
        "exprStr" : "传入参数不符合要求：entryId不能为空",
        "exprType" : "constant",
        "ruleName" : {
          "classType" : "com.wanda.credit.dsconfig.model.expression.Expression",
          "exprStr" : "required",
          "exprType" : "constant"
        },
        "fields" : "entryId",
        "errCode" : "STATUS_WARN_DS_POLICE_PARAM_FAILED"
      }]
    } ]
  },
	*/%>
        getPostData: function() {            
           var action = {
					"classType": "com.wanda.credit.dsconfig.model.action.ValidityAction"
				};
            var exprs = [];
            action['exprs'] = exprs;
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.ValidityCondExpr",
                    "exprStr": getExprStr(item.errmsg),
                    "exprType": getExprType(item.errmsg),
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null),
                    "ruleName": {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": getExprStr(item.rule),
                        "exprType": getExprType(item.rule),
                    },
                    "fields": item.fields,
                    "errCode": "STATUS_WARN_DS_POLICE_PARAM_FAILED"
                });
            });
			if(this.dataobj && this.dataobj.ismodule){
			   var retobj = {};
			   var module = {
                    "classType": "com.wanda.credit.dsconfig.model.module.VerifyModule"
                };
			   retobj['verifyModule'] = module;
				var actions = [];
				actions.push(action);
				module['actions'] = actions;
				return retobj;	
			}else{
			    return action;
			}
			
            

        },
        insertRow: function(row) {
            var selectitemname = "selectItemName"+this.uniqid;			
            var end = getSelectedIdxFromBoostrapTable(selectitemname);
            if(end == -1){
               end = this.params ? this.params.length: 0;
            }            
            var empty ;
            if(row){
               empty = row;
               empty['id'] = ++this.rowuniqid;
            }else{
	             empty = {
	                "id": ++this.rowuniqid,
	                "condition": null,
	                "fields": null,
	                "rule": null,
	                "errmsg": null
	            };
            }
            this.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: empty
            });
        },
        deleteRow: function() {
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'condition',
                    title: '条件',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'fields',
                    title: '字段',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'rule',
                    title: '校验规则',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'errmsg',
                    title: '错误信息',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                }]
            });
        },
        validate: function() {
            if (!this.params || this.params.length == 0) {
                return "数据校验内容不能为空";
            }
            for (var i = 0; i < this.params.length; i++) {
                var item = this.params[i];
                if (!item.fields) {
                    return "校验字段不能为空";
                } else if (!item.rule) {
                    return "校验规则不能为空";
                } else if (!item.errmsg) {
                    return "错误信息不能为空";
                }
            }

            return null;
        }

    }

});
</script> 
  <!-- ======================数据校验 component end=============================----> 
  <!-- ======================智能缓存 component start=============================----> 
  <template id="smartCacheCompTpl"> 
   <div class="box box-info collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h3 class="box-title-small">智能缓存</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove"  v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm" v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" v-bind:data-select-item-name="'selectItemName'+uniqid"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
// 注册
Vue.component('smartcachecomp', {
    props: ['puniqid','dataobj'],
    template: '#smartCacheCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
            needcache: false,
            conflicted: true,
			readonly:this.dataobj.readonly,
            params:[{'id':1,'cachesql':null,'tag':null}]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}
    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
        initData: function(obj) {
		    this.paramTable.bootstrapTable('removeAll');
			var datalist;			
			if(this.dataobj && this.dataobj.ismodule){
			  if(obj.cacheModule && obj.cacheModule.actions){
			  		datalist = obj.cacheModule.actions[0].exprs;

			   }
			}else{
			       datalist = obj.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"tag" : item.tag,
					"cachesql":blendExprAndType(item.querySqlPhase),
                    "condition":blendExprAndType(item.condition)					
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
        },
        <%/*
		    "cacheModule" : {
    "classType" : "com.wanda.credit.dsconfig.model.module.CacheModule",
    "needCache" : true,
    "actions" : [ {
      "classType" : "com.wanda.credit.dsconfig.model.action.QueryCacheQuickAction",
      "conflicted" : true,
      "exprs" : [ {
        "classType" : "com.wanda.credit.dsconfig.model.expression.QueryCacheQuickCondExpr",
        "exprStr" : null,
        "exprType" : "fmr",
        "condition" : null,
        "querySqlPhase" : {
          "classType" : "com.wanda.credit.dsconfig.model.expression.Expression",
          "exprStr" : "select content from CPDB_DS.T_DS_STORE_CLOB a where a.ds_id='ds_fahai_riskmanage_queryDetail' and a.qry1='${datatype}' and a.qry2='${entryId}'",
          "exprType" : "fmr"
        },
        "tag" : "incache_found"
      } ]
    } ]
  }
	*/%>
        getPostData: function() {            
            var action = {
                "classType": "com.wanda.credit.dsconfig.model.action.QueryCacheQuickAction","conflicted": this.conflicted,
            };
            var exprs = [];
            action['exprs'] = exprs;
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.QueryCacheQuickCondExpr",
                    "exprStr": null,
                    "exprType": "fmr",
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null),
                    "querySqlPhase": (item.cachesql ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": getExprStr(item.cachesql),
                        "exprType": getExprType(item.cachesql)
                    } : null),
                    "tag": item.tag
                });
            });
			
			if(this.dataobj.ismodule){
				var retobj = {};
				var module = {
					"classType": "com.wanda.credit.dsconfig.model.module.CacheModule",
					"needCache": true
				};
				var actions = [];				
				module['actions'] = actions;
                actions.push(action);
				retobj['cacheModule'] = module;
				return retobj;

			}else{
			    return action;
			}
        

    },
    insertRow: function() {
         var selectitemname = "selectItemName"+this.uniqid;			
         var end = getSelectedIdxFromBoostrapTable(selectitemname);
         if(end == -1){
             end = this.params ? this.params.length: 0;
         }   
            
        var empty = {
            "id": ++this.rowuniqid,
            "condition": null,
            "cachesql": "SELECT content FROM CPDB_DS.T_DS_STORE_CLOB a WHERE a.ds_id='${ds_id}' AND a.qry1='${param1}' AND a.qry2='${param2}'",
            "tag": "incache_found"
        };
        this.paramTable.bootstrapTable('insertRow', {
            index: end,
            row: empty
        });
    },
    deleteRow: function() {
        var delids = [];
        $.each(this.paramTable.bootstrapTable('getSelections'),
        function(index, item) {
            delids.push(item.id);
        });
        this.paramTable.bootstrapTable('remove', {
            field: 'id',
            values: delids
        });
    },
	remove:function(e){
		 e.preventDefault();		 
		 this.removeVueChild();			  
	},		
	removeVueChild:function(){
		  this.$parent.$emit('removechild', this, {
				'uniqid': this.uniqid
			  });
	},
    initialize: function() {
        var tableid = 'table' + this.uniqid;
        var tablesel = "[name=" + tableid + "]";
        this.paramTable = $(this.$el.querySelector(tablesel));
		var params = this.params
        this.paramTable.bootstrapTable({
            data: params,
            columns: [{
                field: 'state',
                title: '选择',
                width:'5%'
            },
            {
                field: 'id',
                visible: false
            },
            {
                field: 'condition',
                title: '条件',
                editable: {
                    mode: "inline",
                    type: 'textarea'
                },
                width:'30%'
            },
            {
                field: 'cachesql',
                title: 'SQL语句',
                editable: {
                    mode: "inline",
                    type: 'textarea'
                },
                width:'50%'
            },
            {
                field: 'tag',
                title: '标签',
                editable: {
                    mode: "inline",
                    type: 'text'
                },
                width:'15%'
            }]
        });
    },
    validate: function() {
	
        if (!this.params || this.params.length == 0) {
            return "缓存SQL查询语句不能为空";
        }
		for (var i = 0; i < this.params.length; i++) {
            var item = this.params[i];
            if (!item.cachesql) {
                return "缓存SQL查询语句不能为空";
            } else if (!item.tag) {
                return "缓存标签不能为空";
            }
     }
        return null;
        }

    }

});
</script> 
  <!-- ======================数据校验 component end=============================----> 
  <!-- ======================记录日志 component start=============================----> 
<template id = "logCompTpl">
  <div class="box box-info collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h3 class="box-title-small">记录日志</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove"  v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" v-bind:data-select-item-name="'selectItemName'+uniqid"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
Vue.component('logcomp', {
  props: ['puniqid','dataobj'],
  template: '#logCompTpl',
  data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
            needcache: false,
            conflicted: false,
			readonly:this.dataobj.readonly,
            params:[{'id':1,'msg':null,'level':'info'}]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}
    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
	    remove:function(e){
			e.preventDefault();			
			this.removeVueChild();			  
		},		
		removeVueChild:function(){
			this.$parent.$emit('removechild', this, {
					'uniqid': this.uniqid
				  });
		},
        initData: function(obj) {
		    this.paramTable.bootstrapTable('removeAll');
			var datalist;			
			datalist = obj.exprs;
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"level" : item.level,
					"msg":blendExprAndType(item),
                    "condition":blendExprAndType(item.condition)					
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
        },
        <%/*
		    {
                "classType": "com.wanda.credit.dsconfig.model.action.ConditionAction",
                "exprs": [
                    {
                        "classType": "com.wanda.credit.dsconfig.model.expression.LoggingCondExpr",
                        "exprStr": "请求url:${fahaiFullPath}",
                        "exprType": "fmr",
                        "level": "info"
                    }
                ]
            }
	*/%>
        getPostData: function() {            
            var action = {
                "classType": "com.wanda.credit.dsconfig.model.action.ConditionAction","conflicted": this.conflicted,
            };
            var exprs = [];
            action['exprs'] = exprs;
            $.each(this.params,
            function(index, item) {
                exprs.push({
                   "classType": "com.wanda.credit.dsconfig.model.expression.LoggingCondExpr",
					"exprStr":  getExprStr(item.msg),
					"exprType": getExprType(item.msg),
					"level": item.level,
					"condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null)
                });
            });
			return action;
    },
    insertRow: function() {
         var selectitemname = "selectItemName"+this.uniqid;			
         var end = getSelectedIdxFromBoostrapTable(selectitemname);
         if(end == -1){
            end = this.params ? this.params.length: 0;
         } 
        var empty = {
            "id": ++this.rowuniqid,
            "condition": null,
            "msg": null,
            "level": "info"
        };
        this.paramTable.bootstrapTable('insertRow', {
            index: end,
            row: empty
        });
    },
    deleteRow: function() {
        var delids = [];
        $.each(this.paramTable.bootstrapTable('getSelections'),
        function(index, item) {
            delids.push(item.id);
        });
        this.paramTable.bootstrapTable('remove', {
            field: 'id',
            values: delids
        });
    },	
    initialize: function() {
        var tableid = 'table' + this.uniqid;
        var tablesel = "[name=" + tableid + "]";
        this.paramTable = $(this.$el.querySelector(tablesel));
		var params = this.params
        this.paramTable.bootstrapTable({
            data: params,
            columns: [{
                field: 'state',
                title: '选择',
            },
            {
                field: 'id',
                visible: false
            },
            {
                field: 'condition',
                title: '条件',
                editable: {
                    mode: "inline",
                    type: 'textarea'
                }
            },
            {
                field: 'level',
                title: '日志级别',
                editable: {
                    mode: "inline",
                    type: 'text'
                }
            },
            {
                field: 'msg',
                title: '日志内容',
                editable: {
                    mode: "inline",
                    type: 'textarea'
                }
            }]
        });
    },
    validate: function() {
	
        if (!this.params || this.params.length == 0) {
            return "日志内容不能为空";
        }
		for (var i = 0; i < this.params.length; i++) {
            var item = this.params[i];
            if (!item.level) {
                return "日志级别不能为空";
            } else if (!item.msg) {
                return "日志内容不能为空";
            }
     }
        return null;
        }

    }

});
</script>  
  <!-- ======================记录日志 component END=============================----> 

<!--================================SDK 信息 start============================================-->
<template id = "sdkCompTpl">
  <div class="box box-info collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h3 class="box-title-small">SDK 信息</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove"  v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"  v-if="!readonly"> 
      <div class="btn-group btn-group-sm"> 
       <button type="button" class="btn btn-info" @click="insertServiceRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteServiceRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'serviceTable'+uniqid" class="table table-striped  table-hover"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
Vue.component('sdkcomp', {
  props: ['puniqid','dataobj'],
  template: '#sdkCompTpl',
  data: function() {
        return {
		    uniqid : this.puniqid,
            serviceTable: null,
            rowuniqid: 1,
            needcache: false,
            conflicted: false,
			readonly:this.dataobj.readonly,
            serviceParams:[{'id':1,'refName':null,'beanId':null,'script':null}]
        }
    },
    mounted: function() {
	    console.log("before ..")
        this.initialize();
	    console.log("after ..")
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}
    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
	    remove:function(e){
			e.preventDefault();			
			this.removeVueChild();			  
		},		
		removeVueChild:function(){
			this.$parent.$emit('removechild', this, {
					'uniqid': this.uniqid
				  });
		},
        initData: function(obj) {
		    this.serviceTable.bootstrapTable('removeAll');
			var datalist;			
			datalist = obj.services;
			if(datalist){
			  var params = this.serviceParams;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"refName" : item.refName,
					"beanId":item.beanId,
                    "script":item.script				
				};
				p.serviceTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
        },
        <%/*
		    "sdkInfo": {
				"services": [
					{
						"refName": "tokenservice",
						"beanId": "wdWangShuTokenService"
					}
				],
				"resources": []
    }
	*/%>
        getPostData: function() {  
          	var sdkInfo = {};	
            var retobj = {
                'sdkInfo':sdkInfo
            };
            var services = [];
            sdkInfo['services'] = services;
            $.each(this.serviceParams,
            function(index, item) {
                services.push({
                    "refName":item.refName,
					"beanId":item.beanId,
					"script":item.script
                });
            });
			
		return retobj;
    },
    insertServiceRow: function() {
        var end = this.serviceParams ? this.serviceParams.length: 0;
        var empty = {
            "id": ++this.rowuniqid,
            "refName": null,
            "beanId": null,
            "script": null
        };
        this.serviceTable.bootstrapTable('insertRow', {
            index: end,
            row: empty
        });
    },
    deleteServiceRow: function() {
        var delids = [];
        $.each(this.serviceTable.bootstrapTable('getSelections'),
        function(index, item) {
            delids.push(item.id);
        });
        this.serviceTable.bootstrapTable('remove', {
            field: 'id',
            values: delids
        });
    },	
    initialize: function() {
        var tableid = 'serviceTable' + this.uniqid;
        var tablesel = "[name=" + tableid + "]";
        this.serviceTable = $(this.$el.querySelector(tablesel));
		var params = this.serviceParams;
        this.serviceTable.bootstrapTable({
            data: params,
            columns: [{
                field: 'state',
                title: '选择',
            },
            {
                field: 'id',
                visible: false
            },
            {
                field: 'refName',
                title: '引用标识',
                editable: {
                    mode: "inline",
                    type: 'text'
                }
            },
            {
                field: 'beanId',
                title: 'Bean标识',
                editable: {
                    mode: "inline",
                    type: 'text'
                }
            },
            {
                field: 'script',
                title: '实例化语句',
                editable: {
                    mode: "inline",
                    type: 'textarea'
                }
            }]
        });
    },
    validate: function() {	
        if (this.serviceParams && this.serviceParams.length > 0) {
            for (var i = 0; i < this.serviceParams.length; i++) {
            var item = this.serviceParams[i];
            if (!item.refName) {
                return "引用标识不能为空";
            } else if (!item.beanId && !item.script) {
                return "Bean标识和实例语句不能同时为空";
            }
          }
	    }

        return null;
        }

    }

});
</script>  
<!--======================================SDK 信息 end=====================================-->
<!-- ======================通用操作 component start=============================----> 
  <template id="commCompTpl"> 
   <div class="box box-info  collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"  v-show="!dataobj.readonly"></span> 
     <h3 class="box-title-small">通用操作</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove"  v-show="!dataobj.readonly"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm"  v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
  // 注册
Vue.component('commcomp', {
    props: ['puniqid','dataobj'],
    template: '#commCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
			readonly : this.dataobj.readonly,
            params: [{
                "id": -1,
                "condition": null,
                "exprStr": null
            }]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}

    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
	    remove:function(e){
			e.preventDefault();			
			this.removeVueChild();			  
		},		
		removeVueChild:function(){
			this.$parent.$emit('removechild', this, {
					'uniqid': this.uniqid
				  });
		}, 
	<%/*{
                "classType": "com.wanda.credit.dsconfig.model.action.ConditionAction",
                "conflicted": true,
                "exprs": [
                    {
                        "classType": "com.wanda.credit.dsconfig.model.expression.ConditionExpr",
                        "exprStr": "${service.doOperate()}",
                        "exprType": "fmr",
                        "condition": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "${!(rspData.code??) || !exist(rspData.code?c,'2001')}",
                            "exprType": "fmr"
                        }
                    }
                ]
            }*/%>
        initData: function(obj) {
            this.paramTable.bootstrapTable('removeAll');
            //this.params = addUniqid(obj.params, this.rowuniqid);
			 var datalist;			
			if(obj){
			  datalist = obj.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"exprStr": blendExprAndType(item),
					"condition" : blendExprAndType(item.condition)
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
		},
        getPostData: function() {
            var retobj = {
                "classType": "com.wanda.credit.dsconfig.model.action.ConditionAction",
                "conflicted": false
            };
            var exprs = [];
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.ConditionExpr",
                    "exprStr": getExprStr(item.exprStr),
                    "exprType":  getExprType(item.exprStr),
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null)
                });
            });
            retobj['exprs'] = exprs;
            return retobj;

        },
        insertRow: function() {
            var end = this.params ? this.params.length: 0;
            var empty = {
                "id": ++this.rowuniqid,
                "condition": null,
                "exprStr": null
            };
            this.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: empty
            });
        },
        deleteRow: function() {
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                idField: 'name',
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'condition',
                    title: '条件',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                },
                {
                    field: 'exprStr',
                    title: '操作',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                }]
            });
        },
        validate: function() {
            if (!this.params || this.params.length == 0) {
                return "操作内容不能为空";
            }
            for (var i = 0; i < this.params.length; i++) {
                var item = this.params[i];
                if (!item.exprStr) {
                    return "操作内容不能为空";
                }
            }

            return null;
        }

    }

});
  </script> 
  <!-- ======================通用操作 component end=============================----> 
  <!-- ======================退出流程 component start=============================----> 
  <template id="exitCompTpl"> 
   <div class="box box-info  collapsed-box"> 
    <div class="box-header with-border"> 
     <span class="glyphicon glyphicon-move" aria-hidden="true"></span> 
     <h3 class="box-title-small">退出流程</h3> 
     <div class="box-tools pull-right"> 
      <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
      <button type="button" class="btn btn-box-tool" @click="remove"><i class="fa fa-times"></i></button> 
     </div> 
    </div> 
    <div class="box-body"> 
     <!-- /.panel-heading --> 
     <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group btn-group-sm"  v-if="!readonly"> 
       <button type="button" class="btn btn-info" @click="insertRow"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button> 
       <button type="button" class="btn btn-info" @click="deleteRow"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
      </div> 
     </div> 
     <div class="table-responsive"> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover"> 
       <thead> 
        <tr> 
         <th data-field="state" data-checkbox="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
    </div> 
   </div> 
  </template> 
  <script>
  // 注册
Vue.component('exitcomp', {
    props: ['puniqid','dataobj'],
    template: '#exitCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
            paramTable: null,
            rowuniqid: 1,
			readonly : this.dataobj.readonly,
            params: [{
                "id": -1,
                "condition": null
            }]
        }
    },
    mounted: function() {
        this.initialize();
		if(this.dataobj && this.dataobj.initDataObj){
		   this.initData(this.dataobj.initDataObj)
		}

    },
    created: function() {
        this.$parent.$emit('addchild', this, {
            'uniqid': this.uniqid
        });
    },
    methods: {
	    remove:function(e){
			e.preventDefault();			
			this.removeVueChild();			  
		},		
		removeVueChild:function(){
			this.$parent.$emit('removechild', this, {
					'uniqid': this.uniqid
				  });
		},
	<%/*{
                "classType": "com.wanda.credit.dsconfig.model.action.ExitAction",
                "conflicted": true,
                "exprs": [
                    {
                        "classType": "com.wanda.credit.dsconfig.model.expression.ConditionExpr",
                        "exprStr": null,
                        "exprType": null,
                        "condition": {
                            "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                            "exprStr": "${!(rspData.code??) || !exist(rspData.code?c,'2001')}",
                            "exprType": "fmr"
                        }
                    }
                ]
            }*/%>
        initData: function(obj) {
            this.paramTable.bootstrapTable('removeAll');
            //this.params = addUniqid(obj.params, this.rowuniqid);
			 var datalist;			
			if(obj){
			  datalist = obj.exprs;
			}
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
			    var end = params ? params.length: 0;
				var row = {
					"id": ++p.rowuniqid,
					"condition" : blendExprAndType(item.condition)
				};
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
		},
        getPostData: function() {
            var retobj = {
                "classType": "com.wanda.credit.dsconfig.model.action.ExitAction",
                "conflicted": true
            };
            var exprs = [];
            $.each(this.params,
            function(index, item) {
                exprs.push({
                    "classType": "com.wanda.credit.dsconfig.model.expression.ConditionExpr",
                    "condition": (item.condition ? {
                        "classType": "com.wanda.credit.dsconfig.model.expression.Expression",
                        "exprStr": item.condition,
                        "exprType": "fmr"
                    } : null)
                });
            });
            retobj['exprs'] = exprs;
            return retobj;

        },
        insertRow: function() {
            var end = this.params ? this.params.length: 0;
            var empty = {
                "id": ++this.rowuniqid,
                "condition": null
            };
            this.paramTable.bootstrapTable('insertRow', {
                index: end,
                row: empty
            });
        },
        deleteRow: function() {
            var delids = [];
            $.each(this.paramTable.bootstrapTable('getSelections'),
            function(index, item) {
                delids.push(item.id);
            });
            this.paramTable.bootstrapTable('remove', {
                field: 'id',
                values: delids
            });
        },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                idField: 'name',
                data: this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'id',
                    visible: false
                },
                {
                    field: 'condition',
                    title: '条件',
                    editable: {
                        mode: "inline",
                        type: 'textarea'
                    }
                }]
            });
        },
        validate: function() {
            if (!this.params || this.params.length == 0) {
                return "退出流程内容不能为空";
            }
            for (var i = 0; i < this.params.length; i++) {
                var item = this.params[i];
                if (!item.condition) {
                    return "退出条件不能为空";
                }
            }

            return null;
        }

    }

});
  </script> 
  <!-- ======================退出流程 component end=============================----> 
<!--=================================数据源列表组件 start======================================== -->	
<template id="dslistCompTpl"> 
     <div class="box  box-warning box-solid"> 
      <div class="box-header  with-border"> 
       <h3 class="box-title">数据源列表</h3> 
       <div class="box-tools pull-right"> 
        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i> </button> 
        <a href="#" id="list-fullscreen" role="button" title="Toggle fullscreen"><i class="glyphicon glyphicon-resize-full"></i></a> 
       </div> 
      </div> 
      <!-- /.box-header --> 
     <div class="box-body"> 
	   <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group"> 
       <button type="button" class="btn btn-warning"data-toggle="tooltip"  @click="createDs"
        title="创建新的数据源"><span class="fa fa-plus" aria-hidden="true"></span></button> 
	   <button type="button" class="btn btn-warning"data-toggle="tooltip" @click="viewDs"
        title="查看数据源详细配置"><span class="fa fa-eye" aria-hidden="true" ></span></button> 
		<button type="button" class="btn btn-warning"data-toggle="tooltip" @click="editDs"
        title="编辑数据源的配置信息"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></button>
       <button type="button" class="btn btn-warning"data-toggle="tooltip" @click="deleteDs"
        title="删除选中的数据源"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
	   <button type="button" class="btn btn-warning"data-toggle="tooltip" @click="publishDs"
        title="发布并生效数据源"><span class="glyphicon glyphicon-check" aria-hidden="true"></span></button>
	   <button type="button" class="btn btn-warning" data-toggle="tooltip" @click="refreshList"
        title="刷新数据源列表"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></button> 
	   <button type="button" class="btn btn-warning" data-toggle="tooltip" @click="viewHisDs"
        title="查看数据源历史发布版本"><span class="fa fa-history" aria-hidden="true"></span></button>
       <button type="button" class="btn btn-warning"data-toggle="tooltip" @click="copyDsContent"
        title="复制数据源配置信息"><span class="glyphicon glyphicon-paste" aria-hidden="true"></span></button> 
      </div>  
     </div> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover" > 
       <thead> 
        <tr> 
         <th data-field="state" data-radio="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 
     <!-- /.box-body --> 
     </div> 
	  </template> 
  <script>
// 注册
Vue.component('dslistcomp', {
    props: ['uniqid'],
    template: '#dslistCompTpl',
    data: function() {
        return {
            "paramTable": null,
			"data" : [{
                    "ds_id": "ds_qh_blacklist_2_0",
                    "ds_name": "前海黑名单查询升级版",
                    "creator": "吴常胜",
                    "create_time": "2017-03-15 13:12:13",
                    "modfier": "吴常胜",
                    "update_time": "2017-03-15-13:12:13"
                }]
        }
    },
    mounted: function() {
        this.initialize();	
        this.refreshList();	
    },
    created: function() {
	    
    },
    methods: {
	    createDs : function(){
		   var dscfg = this.$parent.$refs.dscfgcompref;
		   dscfg.oper = 'add';
		   dscfg.createDs();
		},
		viewDs : function(){
		   var dscfg =  this.$parent.$refs.dscfgcompref;
		   var selection = this.getSelected();
		   if(!selection)return ;
		   $('#waitDialog').modal('show');
		   postData("queryContent/"+selection.ds_id,{},function(data){
			  if(data.code == '00'){
			      dscfg.dsId = selection.ds_id;
				  dscfg.oper = 'view';
				  dscfg.subtitle = "-> 查看"+selection.ds_name+"(工作区)";		 
				  dscfg.viewDs(JSON.parse(data.data));				  
			  }else{
				error(data.msg);
			  }
			  $('#waitDialog').modal('hide');
		   });
		},
		editDs : function(){
		   var dscfg =  this.$parent.$refs.dscfgcompref;
		   var selection = this.getSelected();
		   if(!selection)return ;
		   $('#waitDialog').modal('show');
		   postData("queryContent/"+selection.ds_id,{},function(data){
			  if(data.code == '00'){
			     dscfg.dsId = selection.ds_id;
				 dscfg.oper = 'update';
				 dscfg.subtitle = "-> 编辑"+selection.ds_name+"(工作区)";				 
				 dscfg.editDs(JSON.parse(data.data));				  
			  }else{
				error(data.msg);
			  }
			  $('#waitDialog').modal('hide');
		   });
		},
		deleteDs:function(){
		   var selection = this.getSelected();
		   if(!selection)return ;
		   var $this = this;
		   postData("delDs/"+selection.ds_id,{},function(data){
		      if(data.code == '00'){
			    $this.refreshList();
			    popmsg("删除成功",1000);  
			  }else{
			    error(data.msg);
			  }
		   });
		},
		publishDs:function(){
		var selection = this.getSelected();
		   if(!selection)return ;
		   var $this = this;
		   postData("publish/"+selection.ds_id,{},function(data){
		      if(data.code == '00'){
			    $this.viewHisDs();  
			    popmsg("发布成功",1000);
			  }else{
			    error(data.msg);
			  }
		   });
		},
		viewHisDs:function(){
		  var dshis =  this.$parent.$refs.dshiscompref;
		  var selection = this.getSelected();
		  if(!selection)return ;
		  dshis.refreshList(selection.ds_id);
		},
		refreshList:function(){
		  var $this = this;
		  postData("queryList",{},function(data){
		      if(data.code == '00'){
			    $this.resetTableData(data.data);  
			    //popmsg("刷新成功",1000);
			  }else{
			    error(data.msg);
			  }
		   });
		},
		resetTableData:function(datalist){
			this.paramTable.bootstrapTable('removeAll');				
			if(datalist){
			  var params = this.params;
			  var p = this;
			  $.each(datalist,function(ind,item){
				var end = params ? params.length: 0;
				var row = item;
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
			  });
			}
		},
		getSelected:function(){
		  var selections = this.paramTable.bootstrapTable('getSelections');
		  if(selections){
		    return selections[0];
		  }else{
		    error("请先选择要操作的数据源记录")
		    return null; 
		  }
		},
		copyDsContent: function(){		 
		    var selection = this.getSelected();
			if (!selection) return;
			postData("queryContent/" + selection.ds_id, {},
			function(data) {
			    if (data.code == '00') {
			        copiedData = data.data;
			        popmsg("配置信息拷贝成功", 3000);
			    } else {
			        error(data.msg);
			    }
			}); 
    	 },
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                "pagination": true,
                "pageSize": 20,
                "data": this.data,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'ds_id',
                    title: '数据源ID'
                },
                {
                    field: 'ds_name',
                    title: '数据源名称'
                },
                {
                    field: 'creator',
                    title: '创建者'
                },
                {
                    field: 'create_time',
                    title: '创建时间'
                },
                {
                    field: 'modfier',
                    title: '最后修改者'
                },
                {
                    field: 'update_time',
                    title: '最后修改时间'
                }]
            });
        }
    }

});
</script>  
<!-- ================================数据源列表组件 end=========================================-->	 
<!-- =========================数据源历史版本组件 start============================-->
  <template id="dshisCompTpl"> 
     <div class="box box-success box-solid collapsed-box"> 
      <div class="box-header  with-border"> 
       <h3 class="box-title whitefont">历史版本</h3> 
       <div class="box-tools pull-right"> 
        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
        <a href="#" id="list-fullscreen" role="button" title="Toggle fullscreen"><i class="glyphicon glyphicon-resize-full"></i></a> 
       </div> 
      </div> 
      <!-- /.box-header --> 
     <div class="box-body"> 
	   <div class="btn-toolbar" role="toolbar" style="padding-bottom:5px"> 
      <div class="btn-group">       
	   <button type="button" class="btn btn-success"data-toggle="tooltip"
        title="查看数据源详细配置" @click="viewHisDs"><span class="fa fa-eye" aria-hidden="true" ></span></button>
	   <button type="button" class="btn btn-success" data-toggle="tooltip"
        title="生效选中的数据源" @click="effective"><span class="glyphicon glyphicon-check" aria-hidden="true"></span></button>
       <button type="button" class="btn btn-success"data-toggle="tooltip" @click="deleteHisDs"
        title="删除选中的数据源"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span></button> 
       <button type="button" class="btn btn-success"data-toggle="tooltip" @click="resumeHisDs"
        title="恢复当前版本到工作区"><span class="glyphicon glyphicon-share" aria-hidden="true"></span></button>  
       <button type="button" class="btn btn-success"data-toggle="tooltip" @click="copyDsContent"
        title="复制数据源配置信息"><span class="glyphicon glyphicon-paste" aria-hidden="true"></span></button> 
      </div>  
     </div> 
      <table v-bind:name="'table'+uniqid" class="table table-striped  table-hover"> 
       <thead> 
        <tr> 
         <th data-field="state" data-radio="true"></th> 
        </tr> 
       </thead> 
      </table> 
     </div> 

      <!-- /.box-body --> 
     </div>  
	  </template> 
  <script>
// 注册
Vue.component('dshiscomp', {
    props: ['puniqid'],
    template: '#dshisCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
			dsId:null,
            "paramTable": null,
			params:[{
			        "id":"1",
                    "ds_id": "ds_qh_blacklist_2_0",
                    "ds_name": "前海黑名单查询升级版",
                    "creator": "吴常胜",
                    "create_time": "2017-03-15 13:12:13",
                    "status": "PUBLISHED",
					"version":"1.0"
                },{
			        "id":"2",
                    "ds_id": "ds_qh_blacklist_2_0",
                    "ds_name": "前海黑名单查询升级版",
                    "creator": "吴常胜",
                    "create_time": "2017-03-15 13:12:13",
                    "status": "EFFECTIVE",
					"version":"2.0"
                }]

        }
    },
    mounted: function() {
        this.initialize();

    },
    created: function() {
    },
    methods: {
        copyDsContent: function() {
		    var dsObj = this.getSelected();
		    if (dsObj == null) return;
		    postData("queryHisContent/" + dsObj.ds_id + "/" + dsObj.version, {},
		    function(data) {
		        //console.log('rsp data',JSON.stringify(data));
		        if (data.code == '00') {
		            copiedData = data.data;
		            popmsg("配置信息拷贝成功", 3000);
		        } else {
		            error(data.msg);
		        }
		    });
         },        
	    resumeHisDs: function() {
		    // /resume/{dsId}/{version}
		    var dsObj = this.getSelected();
		    if (dsObj == null) return;
		    postData("resume/" + dsObj.ds_id + "/" + dsObj.version, {},
		    function(data) {
		        if (data.code == '00') {
		            popmsg("恢复成功", 1000);
		        } else {
		            error(data.msg);
		        }
		    });
	    },	
		deleteHisDs: function() {
		    // /resume/{dsId}/{version}
		    var dsObj = this.getSelected();
		    if (dsObj == null) return;
		    if (dsObj.status != 'PUBLISHED') {
		        popmsg("只能删除发布版本数据源", 2000);
		        return;
		    }
		    var p = this;
		    postData("delRepoDs/" + dsObj.ds_id + "/" + dsObj.version, {},
		    function(data) {
		        if (data.code == '00') {
		            popmsg("删除成功", 1000);
                    p.refreshList(dsObj.ds_id);
		        } else {
		            error(data.msg);
		        }
		    });
		},
	    viewHisDs : function(){
		   var dscfg = this.$parent.$refs.dscfgcompref;	
		   var dsObj = this.getSelected();
           if(dsObj == null)return;	
		   //console.log("queryHisContent/"+dsObj.ds_id+"/"+dsObj.version+"/st_fakefake");
		   $('#waitDialog').modal('show');
		   postData("queryHisContent/"+dsObj.ds_id+"/"+dsObj.version,{},function(data){
			      //console.log('rsp data',JSON.stringify(data));
			      if(data.code == '00'){
					dscfg.subtitle = "-> 查看"+dsObj.ds_name+"_V"+dsObj.version;
					dscfg.oper = 'view';
					dscfg.dsId = dsObj.ds_id;
				    dscfg.viewDs(JSON.parse(data.data));	
				  }else{
				    error(data.msg);
				  }		
				  $('#waitDialog').modal('hide');		  
		   });            
		},
		effective : function(){
		   var dsObj = this.getSelected();
           if(dsObj == null)return;	
		   $this = this;
           postData("effective/"+dsObj.ds_id+"/"+dsObj.version,{},function(data){
			      //console.log('rsp data',JSON.stringify(data));
			      if(data.code == '00'){
				    $this.refreshList($this.dsId);
					error("数据源成功生效");
				  }else{
				    error(data.msg);
				  }				  
		   }); 
		},
	    refreshList : function(dsId){
		  if(dsId){
		    this.dsId = dsId;
		  }else return;
		  $this = this;
		  postData("queryHisList/"+this.dsId,{},function(data){
				 //console.log('rsp data',JSON.stringify(data));
		         if(data.code == '00'){
				    $this.resetTableData(data.data);
				  }else{
				    error(data.msg);
				  }				  
		   });
		},		
		resetTableData : function(data){
		  this.paramTable.bootstrapTable('removeAll');
			if(data){
			  var params = this.params;
			  var p = this;
			  $.each(data,function(ind,item){
			    var end = params ? params.length: 0;
				var row = item;
				p.paramTable.bootstrapTable('insertRow', {
					index: end,
					row: row
				});
              });
			}
		},
		getSelected : function(){
		   var selections = this.paramTable.bootstrapTable("getSelections");
		   if(selections && selections.length > 0){
		      return selections[0];
		   }else{
		     $("#span_warnmsg").text("请先选择要操作的数据源记录");
			 $("#div_warn").show(300);
			 return null;
		   }
		},
        initialize: function() {
            var tableid = 'table' + this.uniqid;
            var tablesel = "[name=" + tableid + "]";
            this.paramTable = $(this.$el.querySelector(tablesel));
            this.paramTable.bootstrapTable({
                "pagination": true,
                "pageSize": 20,
				"data":this.params,
                columns: [{
                    field: 'state',
                    title: '选择',
                },
                {
                    field: 'ds_id',
                    title: '数据源ID'
                },
                {
                    field: 'ds_name',
                    title: '数据源名称'
                },
                {
                    field: 'version',
                    title: '版本'
                },
                {
                    field: 'status',
                    title: '状态'
                },
                {
                    field: 'creator',
                    title: '发布者'
                },
                {
                    field: 'create_time',
                    title: '发布时间'
                }]
            });
        }
    }
});
</script>  
<!--=================================数据源历史版本组件 end======================================== -->	 
 <!--=========================数据源配置开始==================== -->
    <!-- =========================数据源历史版本组件 start============================-->
  <template id="dscfgCompTpl"> 
      <div class="box box-info box-solid  collapsed-box"> 
      <div class="box-header with-border"> 
       <h3 class="box-title whitefont">数据源配置信息</h3> 
       <h6 class="box-title2">{{subtitle}}</h6>
	   <div class="box-tools pull-right"> 
        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
         <a href="#" id="his-fullscreen" role="button" title="Toggle fullscreen"><i class="glyphicon glyphicon-resize-full"></i></a>
       </div> 
       <!-- /.box-tools --> 
      </div> 
      <!-- /.box-header --> 
      <div class="box-body"> 
        <ul style="padding-left:5px"> 
          <li :is="item.component" v-for="item in fixeditems" :puniqid="item.uniqid" :dataobj="item.dataobj"></li> 
         <section class="connectedSortable" id="appsection"> 
          <li :is="item.component" v-for="item in items" :puniqid="item.uniqid" :dataobj="item.dataobj" :key="item.uniqid"></li> 
         </section> 
        </ul>
        <div  class="span7 text-center" style="width:100%;" v-if="!readonly"> 
         <button id="btn_post" type="button" class="btn btn-info" v-on:click="getPostData" style="width:200px"> <span class="glyphicon glyphicon-ok" aria-hidden="true"></span> 提 交 </button> 
         <!--button id="btn_post" type="button" class="btn btn-success" v-on:click="initTestData" style="width:200px"> <span class="glyphicon glyphicon-ok" aria-hidden="true"></span>初始化 </button--> 
		 <button id="btn_post" type="button" class="btn btn-success" v-on:click="pasteDsContent" style="width:200px"> <span class="glyphicon glyphicon-copy" aria-hidden="true"></span> 粘 贴 </button>   
		</div> 
      </div>    	   	  
     </div> 
	 
	  </template> 
  <script>
// 注册
Vue.component('dscfgcomp', {
    props: ['puniqid'],
    template: '#dscfgCompTpl',
    data: function() {
        return {      
		              readonly:false,
					  subtitle:null,
					  oper:'add',
					  dsId:null,
					  dragPos:[],
		              uniqid : this.puniqid,
					  "fixeditems": [			         		          
					  ],
					  basicinfocompref:null,
					  'items':[]
        }
    },
    mounted: function() {
	    $this = this;
	    //alert(this.uniqid)
		$(".connectedSortable").sortable({
			placeholder: "sort-highlight",
			connectWith: ".connectedSortable",
			handle: ".glyphicon-move, .nav-tabs",
			forcePlaceholderSize: true,
			zIndex: 99,
			update: function(event, ui) { 
				$this.dragPos[1] = ui.item.index();
				swapItemPosInArray($this.items,$this.dragPos[0],$this.dragPos[1]);
				console.log("swap success",$this.dragPos);
			},
			start: function(event, ui) { 
			    $this.dragPos[0] = ui.item.index();
			}			
		});		
		$(".connectedSortable .box-header, .connectedSortable .nav-tabs-custom").css("cursor", "move");		
		$("#appsection").droppable({
			accept: "#actionset li",
			drop: function(event, ui) {
				$this.add($(ui.draggable).attr("data-code"), {
					'readonly': $this.readonly
				});
			}
		});
		
       $( ".connectedSortable" ).disableSelection();		
	},
    created: function() {      
      this.$on('addchild',this.addChild);
      this.$on('removechild',this.removeChild);
	  <%/**初始化后创建fixed items*/%>
	  this.fixeditems.push({'component':'basicinfocomp','uniqid':++this.uniqid,'dataobj':{'fixed':true}}),
	  this.fixeditems.push({'component':'verifycomp','uniqid':++this.uniqid,'dataobj':{'fixed':true,'ismodule':true}});
	  this.fixeditems.push({'component':'vardefinitioncomp','uniqid':++this.uniqid,'dataobj':{'fixed':true,'ismodule':true}});
   },
    methods: {
	   addChild :function(child,dataobj){  
	     var $this = this;
	     var allitems = this.fixeditems.concat(this.items);
	     $.each(allitems,function(index,item){
			 if(item.uniqid == dataobj.uniqid){			  
			   item["ref"] = child;
			 }
		});
       },
	 removeChild :function(child,dataobj){	
		  var ind=0;
		  var items = this.items;
			var ids = []
			$.each(this.items,function(index,item){
			 ids.push(item.uniqid);
		  });
		  console.log("before>>>"+ids)
		  $.each(this.items,function(index,item){
			 if(item.uniqid == dataobj.uniqid){
			   item.ref.$destroy();
			   items.splice(index,1);
			   return false;
			 }
			 ind++;
		  });
			var ids1 = [];
			$.each(this.items,function(index,item){
			 ids1.push(item.uniqid);
		  });
		  console.log("after>>>"+ids1)
  }, 
  initTestData : function(){
    $this = this;
    $.ajax({
	   url: "mock/exc_log_comm.jsn",
	   type: "GET",
	   dataType: "json", 
	   success: function(data) {
             $this.render(data,false);
	   }
	 });	
  },
  
  render : function(obj,readonly){
     var isreadonly = false;
     if(readonly){
	    isreadonly = true;
	 }
     this.readonly = isreadonly;
	 
     this.clearupComps();  
	 var allitems = this.fixeditems.concat(this.items);
     $.each(allitems,function(index,item){
            var componentTag = item.component;
            if(componentTag == 'basicinfocomp'){
			   item.ref.initData({'basicInfo':obj.basicInfo})
			}else if(componentTag == 'vardefinitioncomp'){
			   item.ref.initData({'varDefineAction':obj.varDefineAction})
			}else if(componentTag == 'verifycomp'){
			   item.ref.initData({'verifyModule':obj.verifyModule})
			}
	  });

	   if(obj.cacheModule){
	      var smartcachecomp = this.add('smartcachecomp',
	       {'readonly':isreadonly,'fixed':true,'ismodule':true,
	         initDataObj:{'cacheModule':obj.cacheModule}});	
	    }

		if(obj.gathererModule && obj.gathererModule.actions){

	      $this = this;
	      $.each(obj.gathererModule.actions,function(ind,item){
		  			    console.log("item.classType>>>",item.classType)

		     var componentTag = componentmap[item.classType];
			 if(componentTag){                			 
			  }else{
			     if(item.classType == 'com.wanda.credit.dsconfig.model.action.ConditionAction'){
				    componentTag = componentmap[item.exprs[0].classType];
				 }
			  }
			  if(componentTag){
			    console.log("add componentTag>>>",componentTag)
			    $this.add(componentTag,{'readonly':isreadonly,'fixed':false,'ismodule':false,'initDataObj':item});
			  }else{
			    console.log("can't found appropriate  component for "+ JSON.stringify(item))
			  }
		  });	     
	   }
	   if(obj.sdkInfo){
	      $this.add("sdkcomp",{'readonly':isreadonly,'fixed':false,'ismodule':false,'initDataObj':obj.sdkInfo});
	   }
  },
  validate:function(){
      var allitems = this.fixeditems.concat(this.items);
	  for(var i=0;i<allitems.length;i++){  
	   var ref = allitems[i].ref;
		  var errmsg = ref.validate();
		  if(errmsg){
			 $("#span_warnmsg").text(errmsg);
			 $("#div_warn").slideDown();
			 setTimeout(function(){$("#div_warn").slideUp()},5000);			 
			 return false;		 
		  }
      }
      return true;	  
  },
  getPostData:function(){    
	if(!this.validate()){return;}
	var actions = [];
	var gathererModule = {
        "classType": "com.wanda.credit.dsconfig.model.module.GathererModule",
        "actions":actions
	};
	var retobj = {'gathererModule':gathererModule};
	var allitems = this.fixeditems.concat(this.items);
	$.each(allitems,function(index,item){
		  var postedData = item.ref.getPostData()
		  if(postedData.basicInfo){
			 retobj['basicInfo'] = postedData.basicInfo;
		   }else if(postedData.varDefineAction){
			 retobj['varDefineAction'] = postedData.varDefineAction;
		   }else if(postedData.verifyModule){
			 retobj['verifyModule'] = postedData.verifyModule;
		   }else if(postedData.cacheModule){
			 retobj['cacheModule'] = postedData.cacheModule;
		   }else if(postedData.sdkInfo){
			 retobj['sdkInfo'] = postedData.sdkInfo;
		   }else {
			 actions.push(postedData);
		   }      
    });
	var jsn = JSON.stringify(retobj);
	console.log("post jsn content >>>",jsn);
	if(!this.dsId && this.oper == 'update'){
	    error("请先选择要操作的数据源记录");
		return;
	 }
	$('#waitDialog').modal('show');
	if(this.oper == 'add'){
		postFormData("createDs",{'cfgjsn': jsn},function(data){
			  //console.log('rsp data',JSON.stringify(data));
			  if(data.code == '00'){
				error("数据源创建成功");
			  }else{
				error(data.msg);
			  }
	   $('#waitDialog').modal('hide');				  
	   }); 
	}else if(this.oper == 'update'){
		postFormData("editDs/"+this.dsId,{'cfgjsn': jsn},function(data){
			  //console.log('rsp data',JSON.stringify(data));
			  if(data.code == '00'){
				error("数据源修改成功");
			  }else{
				error(data.msg);
			  }	
	   $('#waitDialog').modal('hide');				       				  
	   }); 
	}
 },
	 add(component, dataobj) {
			  this.items.push({
				'component': component,
				'dataobj': dataobj,
				'uniqid':'compuniqid'+(++this.uniqid),
				'ref':null
			  });
		 console.log("add-->",component,dataobj)

	     return this.items[this.items.length-1];	
		},		
	
   clearupComps:function(){		
	   this.items.splice(0,this.items.length);
     },    	 
   closeTip:function(){
		$("#div_warn").slideUp();
	},
   createDs : function(){
      if(this.readonly)
	    {this.readonly = false;}		
      this.clearupComps();
	  /*
	  console.log("before addDefaultComps");
	  this.addDefaultComps();
      console.log("after addDefaultComps");
      */
      this.enableFixedItems(true);
   },
   addDefaultComps : function(){
      this.add('smartcachecomp',{});
	  this.add('httprequestcomp',{});
	  this.add('exceptioncomp',{});
	  this.add('tagcomp',{});
	  this.add('retdatacomp',{});
	},
   editDs : function(obj){
      console.log("start to init dsconfig info");
      this.render(obj,false);
      console.log("end to init dsconfig info");
      this.enableFixedItems(false);
   },
   viewDs : function(obj){
      this.render(obj,true);
      this.disableFixedItems();
   },
   pasteDsContent : function(){
     if(!copiedData){
        popmsg("请先拷贝要粘贴的数据源配置");
       }              
     else{
     
     }
   },
   disableFixedItems:function(){
        $.each(this.fixeditems,function(index,item){
        item['ref'].readonly=true;
        item['ref'].dataobj.readonly=true;        
     });
   },
   enableFixedItems:function(isNew){
     $.each(this.fixeditems,function(index,item){
        item['ref'].readonly=false;
        item['ref'].dataobj.readonly=false;    
        if(isNew){
          item['ref'].clear();
        }    
        if(item.component=='basicinfocomp'){
           item['ref'].isNew = isNew;
        }
     });
   }
  }
});
</script>  
	 
 <!--=========================数据源配置结束==================== -->	

 <!-- ==============================Test Window Start===========================================-->	 
  <template id="testrunCompTpl"> 
     <div class="box box-danger box-solid collapsed-box"> 
      <div class="box-header  with-border"> 
       <h3 class="box-title whitefont">测试运行</h3> 
       <div class="box-tools pull-right"> 
        <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i> </button> 
        <a href="#" id="list-fullscreen" role="button" title="Toggle fullscreen"><i class="glyphicon glyphicon-resize-full"></i></a> 
       </div> 
      </div> 
      <!-- /.box-header --> 
     <div class="box-body"> 	  
	   <div class="row"> 
      <div class="col-md-6"> 
	      <select v-model="dsId" class="form-control"  v-on:change="onSelectDs()">
	          <option value="selecttip">请选择数据源</option>
			  <option v-for="option in dslist" v-bind:value="option.ds_id">
			    {{ option.ds_name }}
			  </option>
			</select>
      </div> 
      <div class="col-md-6">
        <div class="input-group" style="width:100%">   
	          <select v-model="selectedVersion" class="form-control" style="width:50%"> 
	             <option value="-1">请选择版本信息</option> 
	             <option v-for="option in versionlist" v-bind:value="option.version"> 
	                {{ option.version }} </option> 
	          </select>
	          <button id="btn_post" type="button" class="btn btn-danger pull-right" style="width:50%" 
	            v-on:click="runtest" style="width:40%">
			   <i class="glyphicon glyphicon-send"></i>&nbsp;&nbsp;Go . . .
	           </button>    
        </div>         
      </div> 
      </div>
     </br>	  
	 <div class="row"> 
      <div class="col-md-6"> 
        <textarea name="dsId" type="textarea" class="form-control disabled" 
          placeholder="输入JSON格式的请求数据"  rows="8" v-model="params"> </textarea> 
      </div> 
      <div class="col-md-6"> 
              <textarea class="form-control" rows="8" v-model="rspdata"></textarea> 
      </div> 
      </div> 
	  </br>
      <div class="box collapsed-box"  style="background-color:#336666;color: #FFF;">
        <div class="box-header with-border">
          <h3 class="box-title" style="color: #FFF;">控制台</h3>
          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="" data-original-title="Collapse">
              <i class="fa fa-plus"></i></button>           
          </div>
        </div>
        <div class="box-body" style="display: none;">
           <textarea class="form-control" rows="24" style="background-color:#336666;color: #FFF;width:100%" v-model="logs"></textarea>
        </div>
        <!-- /.box-footer-->
      </div>
     </div> 

      <!-- /.box-body --> 
     </div>  
	  </template> 
  <script>
// 注册
Vue.component('testruncomp', {
    props: ['puniqid'],
    template: '#testrunCompTpl',
    data: function() {
        return {
		    uniqid : this.puniqid,
			dsId:'selecttip',
			rspdata:null,
			params:null,
			logs:null,
			"versionlist":[],
            "selectedVersion":"-1",
			dslist:[{'ds_id':'initid','ds_name':'initname'}]

        }
    },
    mounted: function() {      
       var p = this;
       postData("queryList",{},function(data){
		      if(data.code == '00'){
		        console.log(">>>dslist",JSON.stringify(data.data));
			    p.dslist = data.data;
			  }else{
			    error(data.msg);
			  }
		   });
    },
    created: function() {
    },
    methods: {
     onSelectDs:function(){
       var p = this;
       if(!this.dsId || this.dsId=='selecttip'){
       	return;
       }
       postData("queryHisList/"+this.dsId,{},function(data){
	      if(data.code == '00'){
		    p.versionlist = data.data;
		  }else{
		    error(data.msg);
		  }
	   });
      },
      runtest : function(){
       if(!this.dsId || this.dsId=='selecttip'){
          error("请选择待测试的数据源");
          return;
       }else if(!this.params){
          error("输入参数不能为空");
          return;
       }
       $this = this;
       if(!this.selectedVersion){
          this.selectedVersion = "-1";
       }
	   var t1 =window.setInterval("$this.getLogs()",300); 
       postJsnData("runtest/"+this.dsId+"/"+this.selectedVersion,{"params":this.params},function(data){
              var rspdata =  JSON.stringify(data, null, "\t");
			  //console.log('rsp data',rspdata);
			  $this.rspdata = rspdata;
			  $this.getLogs();
			  window.clearInterval(t1);		  
	   }); 	   
      },
      getLogs:function(){
	      postJsnData("getlogs",{},function(data){
	              var rspdata =  JSON.stringify(data, null, "\t");
				  console.log('logs data',rspdata);
				  $this.logs = data.data;
		   }); 
      }
    }
});
</script>  
 <!-- ==============================Test Window End===========================================-->	 
  <!-- ==========================start the main app div=========================--> 
 <div style="padding: 10px 10px 10px;"> 
  <div id="app" class="row">
    <div class="col-md-6" style="padding: 5px 5px 5px 5px">
      <dslistcomp :puniqid="uniqid++" ref="dslistcompref" style="margin-bottom:10px"></dslistcomp>
      <dshiscomp :puniqid="uniqid++" ref="dshiscompref"></dshiscomp>
    </div>
    <div class="col-md-6" style="padding:5px 5px 5px 5px">
      <div :is="dscfgcomp" :puniqid="uniqid++" ref="dscfgcompref" style="margin-bottom:10px"></div>
      <testruncomp :puniqid="uniqid++" ref="testruncompref"></testruncomp>
    </div>
     <div class="span7 text-center" style="width:100%;"> 
    <button id="btn_post" type="button" class="btn btn-info" v-on:click="test" style="width:200px"> <span class="glyphicon glyphicon-ok" aria-hidden="true"></span>测 试 </button></div> 
  </div>
   <script>  
$(function(){
var vueapp = new Vue({
    el: '#app',
    data: {
	  uniqid : 0,
	  uniqid2 : 0,

      items: [],
	  dscfgcomp : 'dscfgcomp',
	  profile :'profile'
  },  
  computed: {
    increUniqId: function () {
	  this.uniqid = this.uniqid+1;
      return  this.uniqid;
    }
  },
  methods: {
     getDsCompRef:function(){
	    return this.$refs.dscfgcompref;
	 },
	 closeTip:function(){
		$("#div_warn").slideUp();
	},
     test : function(){
	 $('#waitDialog').modal('show');
	 }
  }});
});
  </script> 
   <!-- ==========================end the main app div=========================--> 
   <!-- ==========================start widgets set ============================--> 
    <!-- sidebar: style can be found in sidebar.less --> 
    <section class="sidebar fixedLayer thumbnail" style="padding-bottom:5px"> 
     <ul class="sidebar-menu" > 
      <li class="treeview"> <a href="#" id="aa" class="bg-yellow" > <span class="glyphicon glyphicon-th-large"> 组件集</span>  </a> 
       <ul id="actionset" class="treeview-menu"> 
	    <li data-code="verifycomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 数据校验</a></li> 
        <li data-code="vardefinitioncomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 变量声明</a></li>  
        <li data-code="smartcachecomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 智能缓存</a></li> 
        <li data-code="httprequestcomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> Http请求</a></li> 
        <li data-code="dsrequestcomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 数据源请求</a></li> 
        <li data-code="exceptioncomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 异常处理</a></li> 
        <li data-code="tagcomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 标签处理
		</a></li>
		<li data-code="commcomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 通用操作</a></li> 
        <li><a href="#"><i class="glyphicon glyphicon-leaf"></i> 循环操作</a></li> 
        <li data-code="logcomp"><a href="#"><i class="glyphicon glyphicon-leaf" data-code="logcomp"></i> 打印日志</a></li> 
        <li data-code="exitcomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 退出流程</a></li>         
        <li data-code="retdatacomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> 数据返回</a></li> 
		<li data-code="sdkcomp"><a href="#"><i class="glyphicon glyphicon-leaf"></i> SDK信息</a></li> 
		
       </ul> </li> 
     </ul> 
    </section> 
   <!-- ==========================start widgets set ============================--> 
   <script>
<%/***设置窗口最大化函数****/%>
$(document).ready(function() {
    //Toggle fullscreen
    $("#list-fullscreen,#his-fullscreen,#cfg-fullscreen").click(function(e) {
        e.preventDefault();
        var $this = $(this);
        if ($this.children('i').hasClass('glyphicon-resize-full')) {
            $this.children('i').removeClass('glyphicon-resize-full');
            $this.children('i').addClass('glyphicon-resize-small');
        } else if ($this.children('i').hasClass('glyphicon-resize-small')) {
            $this.children('i').removeClass('glyphicon-resize-small');
            $this.children('i').addClass('glyphicon-resize-full');
        }
        $(this).closest('.box').toggleClass('panel-fullscreen');
    });
});

<%/******设置组建集的动态添加组件功能******/%>
$(function() {
    function ini_events(ele) {
        ele.each(function() {
            var eventObject = {
                title: $.trim($(this).text())
            };
            $(this).data('eventObject', eventObject);
            $(this).draggable({
                cursor: "move",
                helper: function(event) {
                    return $('<div class="external-event bg-blue" >添加组件</div>');
                },
                zIndex: 9999,
                revert: true,
                revertDuration: 0 
            });

        });
    }

    ini_events($('#actionset li'));
});
</script>
    <div id="div_warn" class="alert alert-danger" style="position:fixed;top:0px;left:10px;right:10px;width:100%;z-index:10000" hidden>
	  <button type="button" class="close" aria-hidden="true" id="div_warn_close">&times;</button>
	  <i class="icon fa fa-warning"></i>
	  <span id="span_warnmsg"></span>
	</div> 
	<!-- Modal Start here-->
	<div class="modal fade bs-example-modal-sm" id="waitDialog" tabindex="-1"
		role="dialog" aria-hidden="true" data-backdrop="static">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">
						<span class="glyphicon glyphicon-time" id="waitMsg">
						    处理中，请稍后
						</span>
					 </h4>
				</div>
				<div class="modal-body">
					<div class="progress">
						<div class="progress-bar progress-bar-info
						progress-bar-striped active"
						style="width: 100%">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div id="confirmBox" class="alert alert-warning hidden alert-dismissible fade in" style="position:fixed;top:0px;left:10px;right:10px;width:100%;z-index:10000"> 
	   <button type="button" class="close" aria-hidden="true" id="confirmBox_close">&times;</button> 
	   <i class="icon fa fa-warning"></i> 
	   <span id="confirmBox-body" style="font-size: 16px">该粘贴操作将可能修改当前数据源或新增一个新的数据源</span> 
	   <div class="btn-group pull-right" style="font-size: 18px"> 
	    <button type="button" class="btn btn-outline">我要粘贴</button> 
	    <button type="button" class="btn btn-outline">我后悔了</button> 
	   </div> 
	  </div> 
	  
	<!-- Modal ends Here -->
	<script>
	 $(function() {
		$("#div_warn_close").click(function(){
			$("#div_warn").slideUp();
		});
		$("#confirmBox_close").click(function(){
			$("#confirmBox").slideUp();
		});
		$('input[rel="111111"]').tooltip({ 'placement':'top','trigger': 'focus', 'title': 'dddddddddddddd' });
		
    }); 
	</script>
	 <form name="cfgForm" id="cfgForm" method="POST">
            <input id="jssesionID" type="hidden">                                        
            <input id="cfgjsn" type="hidden">                                       
     </form>
  </body>
</html>