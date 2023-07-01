<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>

    <script>

        function userSearch(ids) {
            var ids = ids.value;

            $.ajax({
                url: '${grailsApplication.config.systemLink.toString()}/secUser/search_udser',
                data: {'search_string': ids}, // change this to send js object
                type: "post",
                success: function (data) {
                    //document.write(data); just do not use document.write
                    $("#list-user").html(data);
                    //console.log(data);
                }
            });
        }
    </script>
</head>

<body>
<div class="register_dv expert">
    <div class="center panel_div_list_big">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link class="create" controller="home" action="index">
                        <i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">User list (${secUserCount})</span>
                    </g:link>
                </h5>
            </div>
            %{-- <sec:ifAnyGranted roles="ROLE_ADMIN">
                 <div class="page-title">
                     <g:link class="create" controller="user" action="messagesUsers"><button type="button"
                                                                                             class="btn bg-teal-400 btn-labeled"><b><i
                                 class="icon-envelop2"></i></b> Send Messages</button></g:link>

                 </div>
             </sec:ifAnyGranted>--}%

            <div class="heading-elements">
                <div class="col-md-7">
                    <div class="form-group">
                        <div class="has-feedback">
                            <input type="search" value="" name="search_text" class="form-control"
                                   onkeyup="userSearch(this)" placeholder="Search">

                        </div>
                    </div>
                </div>

            </div>
            %{--<sec:ifAnyGranted roles="ROLE_ADMIN">

                <div class="page-header-content">
                    <div class="heading-elements">
                        <button type="submit" class="btn bg-info-400 btn-labeled"><b><i
                                class="icon-file-text2"></i></b> PRINT PDF</button>
                    </div>

                </div>
            </sec:ifAnyGranted>--}%
        </div>

        <div id="list-user" class="content scaffold-list" role="main">



            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

                    <g:sortableColumn property="full_name"
                                      title="${message(code: 'company.name.label', default: 'Name')}"/>




                    <g:sortableColumn property="username"
                                      title="${message(code: 'company.name.label', default: 'Code')}"/>
                    <g:sortableColumn property="phone_number"
                                      title="${message(code: 'company.name.label', default: 'Phone No')}"/>
                    <th class="text-center">Customers No</th>
                    <th class="text-center">Float Amount(TZS)</th>

                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${secUserList}" status="i" var="userInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>
                            <% def offset = 0
                            if (params.offset) {
                                offset = Integer.parseInt(params.offset)
                            }
                            %>
                            ${i + 1 + offset}</td>
                        <td>${userInstance.full_name}</td>

                        <td>
                            %{--<g:if test="${userInstance.district_id}">
                                <g:link controller="user" action="index"
                                        params="[district: userInstance?.district_id?.id]">${fieldValue(bean: userInstance, field: "district_id.name")}</g:link>

                            </g:if>
                            <g:else>--}%
                            ${fieldValue(bean: userInstance, field: "username")}
                        </td>
                        <td>${fieldValue(bean: userInstance, field: "phone_number")}</td>

                        <td class="text-center">${kopafasta.SecUser.countByAgent_id(userInstance)}</td>
                        <td class="text-center"> ${fieldValue(bean: userInstance, field: "agent_float_amount")}</td>

                        <td class="text-center">

                            <g:link class="create" action="show" id="${userInstance.id}"
                                    resource="${this.userInstance}"><button class="btn btn-primary">Details <i
                                    class="icon-arrow-right14 position-right"></i></button></g:link>

                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
            <g:if test="${secUserCount > 10}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${secUserCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>



    </div>
</div>
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:mm'});
</script>
</body>
</html>