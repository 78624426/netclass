<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>用户资源管理</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/back-index.css" />
    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js" type="text/javascript" charset="utf-8"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap-paginator.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap-mypaginator.js"></script>
    <script src="${pageContext.request.contextPath}/js/template-web.js" type="text/javascript" ></script>
    <style>
    .file {
        position: relative;
        display: inline-block;
        background: #D0EEFF;
        border: 1px solid #99D3F5;
        border-radius: 4px;
        padding: 4px 12px;
        overflow: hidden;
        color: #1E88C7;
        text-decoration: none;
        text-indent: 0;
        line-height: 20px;
        width: 100%;
        text-align: center;
    }
    .file:hover {
        background: #AADFFD;
        border-color: #78C3F3;
        color: #004974;
        text-decoration: none;
    }
    .file:focus {
        background: #AADFFD;
        border-color: #78C3F3;
        color: #004974;
        text-decoration: none;
    }

    .width120 {
        min-width: 120px;
    }
    .width90 {
        min-width: 90px;
    }
    .width50 {
        min-width: 50px;
    }

    </style>
    <script type="text/javascript">
        $(function(){
            //显示
            ajaxLoadData(1);
            $(".resource-detail").on("click", function() {
                $('#frame-id', window.parent.document).attr('src', 'back_resourceDetailSet.html');
            });

            // 显示隐藏查询列表
            $('#show-user-resource-search').click(function() {
                $('#show-user-resource-search').hide();
                $('#upp-user-resource-search').show();
                $('.show-user-resource-search').slideDown(500);
            });
            $('#upp-user-resource-search').click(function() {
                $('#show-user-resource-search').show();
                $('#upp-user-resource-search').hide();
                $('.show-user-resource-search').slideUp(500);
            });
		});
		
		//后台修改用户状态禁用-启用
		function toggleStatus(id,status){
			var cp = myoptions.currentPage;
			$.ajax({
				url : '${pageContext.request.contextPath}/resource/toggleStatus.do',
				data : {
					"id":id,
					"status":status
				},
				type : 'post',
				dataType : 'json',
				success : function(data){
					ajaxLoadData(cp);
				},
			})
		}
		
		//分页加载数据
		function ajaxLoadData(page){
			var title =$("#user-resource-title-search").val();
			var user_name =$("#user-name-search").val();
			var status =$("#status-search option:selected").val();
			var file_type =$("#file-type-search option:selected").val();
			var create_start_date =$("#create-start-time-search").val();
			var create_end_date =$("#create-end-time-search").val();
			$.ajax({
					url:'${pageContext.request.contextPath}/resource/findBackResource.do',
					data:{
						"pageNo":page,
						"title":title,
						"user_name":user_name,
						"create_start_date":create_start_date,
						"create_end_date":create_end_date,
						"status":status,
						"file_type":file_type
					},
					dataType:'json',
					type:'post',
					success:function(data)
					{
						pageNo = data.pageNum; 
						myoptions.onPageClicked = function(event, originalEvent,type, page) {
							ajaxLoadData(page);
						};
						if(data.pages==0){
							myPaginatorFun("myPages", 1, 1);	
						}else{
							myPaginatorFun("myPages", pageNo, data.pages);
						}
						let $tr = $("#tb").children();
						$tr.remove();
						var html = template('resourceBack_template', data);
						$("#tb").append(html);
					}
				})
		}


    </script>
	<script type="text/html" id="resourceBack_template">
				{{each list item}}
                        <tr>
                            <td>{{item.id}}</td>
                            <td>{{item.title}}</td>
                            <td style="50px;">{{item.path}}</td>
                            <td>{{item.original_name}}</td>
                            <td>{{item.file_size}}bit</td>
                            <td>{{item.file_type}}</td>
                            <td>{{item.create_date}}</td>
                            {{if item.cost_type==0}}
							<td>积分</td>
							{{/if}}
                            {{if item.cost_type==1}}
							<td>金币</td>
							{{/if}}
                            <td>{{item.cost_number}}</td>
                            <td>{{item.user_name}}</td>
 							{{if item.status==0}}
							<td>启用</td>
							{{/if}}
 							{{if item.status==1}}
							<td>禁用</td>
							{{/if}}
                            <td class="text-center">
								{{if item.status==0}}
                                <input type="button" onclick="toggleStatus({{item.id}},1)" class="btn btn-danger btn-sm" value="禁用" />
								{{/if}}
								{{if item.status==1}}
								<input type="button" onclick="toggleStatus({{item.id}},0)" class="btn btn-success btn-sm" value="启用" />
                                {{/if}}
								{{if item.file_type == 'mp4'}}
								<a href="${pageContext.request.contextPath}/resource/play.do?path=${pageContext.request.contextPath}/upload{{item.path}}">
									<input type="button" class="btn btn-success btn-sm resource-detail" value="详情" />
								</a>
								{{/if}}
								{{if item.file_type != 'mp4'}}
                      			<a href="${pageContext.request.contextPath}/resource/down.do?resourceId={{item.id}}">
                            		<input type="button" class="btn btn-success btn-sm resource-detail" value="详情" />
                       			</a>
								{{/if}}

                            </td>
                        </tr>
				{{/each}}
	</script>
</head>

<body>
    <div  class="panel panel-default" id="userPic">
        <div class="panel-heading">
            <h3 class="panel-title">用户资源管理</h3>
        </div>
        <div>
            <input type="button" onclick="ajaxLoadData(1)" value="查询" class="btn btn-success" id="doSearch" style="margin: 5px 5px 5px 15px;" />
            <input type="button" class="btn btn-primary" id="show-user-resource-search" value="展开搜索" />
            <input type="button" value="收起搜索" class="btn btn-primary" id="upp-user-resource-search" style="display: none;" />
        </div>

        <div class="panel-body">
            <div class="show-user-resource-search" style="display: none;">
                <form class="form-horizontal">
                    <div class="form-group">
                        <div class="form-group col-xs-6">
                            <label for="user-resource-title-search" class="col-xs-3 control-label">标题：</label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="user-resource-title-search" placeholder="请输入标题" />
                            </div>
                        </div>
                        <div class="form-group col-xs-6">
                            <label for="user-name-search" class="col-xs-3 control-label">用户名：</label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="user-name-search" placeholder="请输入用户名" />
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="form-group col-xs-6">
                            <label class="col-xs-3 control-label">开始日期：</label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="create-start-time-search" placeholder="请输入开始时间:2017-10-10" />
                            </div>
                        </div>
                        <div class="form-group col-xs-6">
                            <label class="col-xs-3 control-label">结束日期：</label>
                            <div class="col-xs-8">
                                <input type="text" class="form-control" id="create-end-time-search" placeholder="请输入结束时间:2017-10-12" />
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="form-group col-xs-6">
                            <label class="col-xs-3 control-label">状态：</label>
                            <div class="col-xs-8">
                                <select class="form-control" id="status-search">
                                    <option value="-1" >全部</option>
                                    <option value="0" >启用</option>
                                    <option value="1" >禁用</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group col-xs-6">
                            <label class="col-xs-3 control-label">文件类型：</label>
                            <div class="col-xs-8">
                                <select class="form-control" id="file-type-search">
                                    <option value="-1" >全部</option>
                                    <option value="mp4" >mp4</option>
                                    <option value="pdf" >pdf</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                </form>
            </div>

            <!--  -->
            <div class="show-list">
                <table class="table table-bordered table-hover" style="text-align: center;">
                    <thead>
                        <tr class="text-danger">
                            <th class="text-center width50">编号</th>
                            <th class="text-center">资源标题</th>
                            <th class="text-center">资源相对路径</th>
                            <th class="text-center">文件原始名称</th>
                            <th class="text-center width50">文件大小</th>
                            <th class="text-center width50">文件类型</th>
                            <th class="text-center width90">上传时间</th>
                            <th class="text-center width50">消费类型</th>
                            <th class="text-center width50">消费值</th>
                            <th class="text-center width50">上传用户</th>
                            <th class="text-center width50">状态</th>
                            <th class="text-center width120">操作</th>
                        </tr>
                    </thead>
                    <tbody id="tb">
                        <tr>
                            <td>1</td>
                            <td>简单介绍java语法</td>
                            <td>/java/sdgafjkiqrjtkaasf.mp4</td>
                            <td>java基础语法01</td>
                            <td>102400</td>
                            <td>mp4</td>
                            <td>2017-10-10 12:00:00</td>
                            <td>积分</td>
                            <td>20</td>
                            <td>tom</td>
                            <td>启用</td>
                            <td class="text-center">
                                <input type="button" class="btn btn-danger btn-sm" value="禁用" />
                                <input type="button" class="btn btn-success btn-sm resource-detail" value="详情" />
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>简单介绍java语法</td>
                            <td>/java/sdsdsffaasf.mp4</td>
                            <td>java基础语法02</td>
                            <td>142400</td>
                            <td>mp4</td>
                            <td>2017-10-15 12:00:00</td>
                            <td>积分</td>
                            <td>20</td>
                            <td>tom</td>
                            <td>禁用</td>
                            <td class="text-center">
                                <input type="button" class="btn btn-success btn-sm" value="启用" />
                                <input type="button" class="btn btn-success btn-sm resource-detail" value="详情" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- 分页 -->
            <div style="text-align: center;" >
                <ul id="myPages" ></ul>
            </div>

        </div>
    </div>

    <div class="modal fade" tabindex="-1" id="courseReourceModal" >
        <!-- 窗口声明 -->
        <div class="modal-dialog modal-lg">
            <!-- 内容声明 -->
            <div class="modal-content">
                <!-- 头部、主体、脚注 -->
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title" >用户资源</h4>
                </div>
                <div class="modal-body text-center">
                    
                    <input type="hidden" name="course_id" value=""  />
                    <div class="row text-right" id="course-resource-id-input" >
                        <label for="course-resource-id" class="col-xs-4 control-label">章节编号：</label>
                        <div class="col-xs-4">
                            <input type="text" class="form-control" id="course-resource-id" readonly="true" />
                        </div>
                    </div>
                    <br>
                    <div class="row text-right">
                        <label for="course-resource-title" class="col-xs-4 control-label">章节标题：</label>
                        <div class="col-xs-4">
                            <input type="text" class="form-control" id="course-resource-title" />
                        </div>
                    </div>
                    <br>
                    <div class="row text-right">
                        <label for="course-resource-context" class="col-xs-4 control-label">内容详情：</label>
                        <div class="col-xs-4">
                            <input type="text" class="form-control" id="course-resource-context" />
                        </div>
                    </div>
                    <br>
                    <p/>
                    <div class="row text-right">
                        <label class="col-xs-4 control-label">资源：</label>
                        <div class="col-xs-4">
                            <a href="javascript:fileUpload('#course-resource-file');" class="file" >选择文件</a>
                            <input type="file" name="course_resource_file" style="display: none;" onchange="fileChange(this)" id="course-resource-file" />
                        </div>
                    </div>
                    <br/>
                    <div class="row text-right">
                        <label for="course-resource-file-title" class="col-xs-4 control-label">资源标题：</label>
                        <div class="col-xs-4">
                            <input type="text" class="form-control" id="course-resource-file-title" />
                        </div>
                    </div>
                    <br>
                    <div class="row text-right">
                        <label for="file-cost-type" class="col-xs-4 control-label">查看资源花费类型：</label>
                        <div class="col-xs-4">
                            <select class="form-control" id="file-cost-type" name="file_cost_type_id" >
                                <option value="-1" >请选择</option>
                                <option value="1" >积分</option>
                                <option value="2" >金币</option>
                            </select>
                        </div>
                    </div>
                    <br>
                    <div class="row text-right">
                        <label for="file-cost-type-val" class="col-xs-4 control-label">花费值：</label>
                        <div class="col-xs-4">
                            <input type="text" class="form-control" id="file-cost-type-val" />
                        </div>
                    </div>
                    <br>
                    <div class="row text-right">
                        <label for="resource-type-id" class="col-xs-4 control-label">资源类型：</label>
                        <div class="col-xs-4">
                            <select class="form-control" id="resource-type-id" name="resource_type_id" >
                                <option value="-1" >请选择</option>
                                <option value="1" >mp4</option>
                                <option value="2" >pdf</option>
                            </select>
                        </div>
                    </div>
                    <br>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary course-reource-btn">确定</button>
                    <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
                </div>
            </div>
        </div>
    </div>
</body>

</html>