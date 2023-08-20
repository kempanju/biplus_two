<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'userLogs.label', default: 'UserLogs')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">
    <div class="center panel_div_list_big">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link class="create" controller="home" action="index">
                        <i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Logs list (${userLogsCount})</span>
                    </g:link>
                </h5>
            </div>
        </div>
     %{--   <a href="#list-userLogs" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                                       default="Skip to content&hellip;"/></a>

        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                                      args="[entityName]"/></g:link></li>
            </ul>
        </div>--}%

        <div id="list-userLogs" class="content scaffold-list" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>
                    <g:sortableColumn property="user_id"
                                      title="${message(code: 'company.name.category', default: 'Username')}"/>

                    <g:sortableColumn property="message"
                                      title="${message(code: 'company.name.label', default: 'Message')}"/>
                    <g:sortableColumn property="created_at"
                                      title="${message(code: 'company.name.label', default: 'Time')}"/>

                </tr>
                </thead>
                <tbody>
                <g:each in="${userLogsList}" status="i" var="secLogListInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>${i + 1}</td>
                        <td>
                            <g:link class="create" controller="user" action="show"
                                    id="${secLogListInstance?.user_id?.id}">
                                ${fieldValue(bean: secLogListInstance, field: "user_id.full_name")}
                            </g:link>
                        </td>
                        <td>
                            <% String message = secLogListInstance.message
                            message = message.replace(",", " , ")
                            %>
                            <p style="max-width: 400px">${message}</p></td>
                        <td>${fieldValue(bean: secLogListInstance, field: "created_at")}</td>

                    </tr>
                </g:each>

                </tbody>
            </table>



            <div class="col-md-10 text-center" style="margin-top: 20px">
            <div class="pagination">
                <g:paginate total="${userLogsCount ?: 0}"/>
            </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>