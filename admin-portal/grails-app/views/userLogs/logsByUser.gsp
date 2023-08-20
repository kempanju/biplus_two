<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <g:set var="entityName" value="${message(code: 'userLogs.label', default: 'UserLogs')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
<div class="register_dv expert" style="max-width: 1200px;">
    <div class="center panel_div_list_big">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <a href="/">
                        <i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">User logs (${userLogsCount})</span>
                    </a>
                </h5>
            </div>
            <a href="#list-userLogs" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>

            <div id="list-userLogs" class="content scaffold-list" role="main">
                <g:if test="${flash.message}">
                    <div class="message" role="status">${flash.message}</div>
                </g:if>

                <table class="table datatable-basic">
                    <thead>
                    <tr>
                        <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}" />
                        <g:sortableColumn property="user_id" title="${message(code: 'company.name.category', default: 'Username')}" />

                        <g:sortableColumn property="message" title="${message(code: 'company.name.label', default: 'Message')}" />
                        <g:sortableColumn property="created_at" title="${message(code: 'company.name.label', default: 'Time')}" />



                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userLogsList}" status="i" var="secLogListInstance">
                        <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                            <td>

                                <% def offset = 0
                                if (params.offset) {
                                    offset = Integer.parseInt(params.offset)
                                }
                                %>
                                ${i + 1 + offset}

                            </td>
                            <td>
                                <g:link class="create" controller="secUser" action="show" id="${secLogListInstance?.user_id?.id}">
                                    ${fieldValue(bean: secLogListInstance, field: "user_id.full_name")}
                                </g:link>
                            </td>
                            <td>
                                <% String message=secLogListInstance.message
                                        message=message.replace(","," , ")
                                %>
                                <p style="max-width: 400px">${message}</p></td>
                            <td>${fieldValue(bean: secLogListInstance, field: "created_at")}</td>

                        </tr>
                    </g:each>

                    </tbody>
                </table>


                <g:if test="${userLogsCount > 10}">
                    <div class="col-md-10 text-center" style="margin-top: 20px">
                        <div class="pagination">
                            <g:paginate total="${userLogsCount ?: 0}" params="[id:params.id]"/>
                        </div>
                    </div>
                </g:if>
            </div>
        </div>
    </div>
</div>
</body>
</html>