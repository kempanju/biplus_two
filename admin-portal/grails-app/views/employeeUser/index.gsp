<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'employeeUser.label', default: 'EmployeeUser')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">
        <div class="center panel_div_list_big">
        <a href="#list-employeeUser" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        <div id="list-employeeUser" class="content scaffold-list" role="main">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>


            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

                    <g:sortableColumn property="first_name"
                                      title="${message(code: 'company.name.label', default: 'Name')}"/>




                    <g:sortableColumn property="registration_no"
                                      title="${message(code: 'company.name.label', default: 'Reg No')}"/>
                    <g:sortableColumn property="phone_number"
                                      title="${message(code: 'company.name.label', default: 'Phone No')}"/>
                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${employeeUserList}" status="i" var="userInstance">
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
                            ${fieldValue(bean: userInstance, field: "username")}
                        </td>
                        <td>${fieldValue(bean: userInstance, field: "phone_number")}</td>


                        <td class="text-center">

                            <g:link class="create" action="show" id="${userInstance.id}"
                                    resource="${this.userInstance}"><button class="btn btn-primary">Details <i
                                    class="icon-arrow-right14 position-right"></i></button></g:link>

                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
            <g:if test="${employeeUserCount > 10}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${employeeUserCount ?: 0}"/>
                    </div>
                </div>
            </g:if>



        </div>
        </div>
    </div>
    </body>
</html>