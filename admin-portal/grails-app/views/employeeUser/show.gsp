<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'employeeUser.label', default: 'EmployeeUser')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">

        <div class="center panel_div_list panel">
        <a href="#show-employeeUser" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        <div id="show-employeeUser" class="content scaffold-show" role="main">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>

            <div class="panel table-responsive">

                <table class="table text-nowrap">
                    <tr>
                        <td colspan="2"><h5>
                            <span class="text-bold">Customer information</span>
                        </h5></td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Name</span>
                        </td>
                        <td>${fieldValue(bean: employeeUser, field: "full_name")}</td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Email</span>
                        </td>
                        <td>${fieldValue(bean: employeeUser, field: "username")}</td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Phone Number</span>
                        </td>
                        <td>${fieldValue(bean: employeeUser, field: "phone_number")}</td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Employer</span>
                        </td>
                        <td>${fieldValue(bean: employeeUser, field: "customer.name")}</td>
                    </tr>


                    <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <tr>
                            <td colspan="4">
                                <g:form method="POST" action="changePasswordUser" class="form-horizontal">
                                    <g:hiddenField name="id" value="${employeeUser.id}"/>

                                            <g:hiddenField  name="username"
                                                   required="required" placeholder="Username"
                                                            value="${employeeUser?.username}"/>

                                    <div class="form-group">
                                        <label class="control-label col-lg-2">Password</label>

                                        <div class="col-lg-8">

                                            <input class="input" type="password" name="newpassword"
                                                   required="required" placeholder="Password" value="">

                                        </div>
                                    </div>


                                    <div class="text-right col-lg-10">
                                        <button type="submit" class="btn btn-danger">Change Password <i
                                                class="icon-arrow-right14 position-right"></i>
                                        </button>

                                    </div>
                                </g:form>

                            </td>

                        </tr>
                    </sec:ifAnyGranted>

                </table>
            </div>


            <g:form resource="${this.employeeUser}" method="DELETE">
                <fieldset class="buttons">
                    <g:link class="edit" action="edit" resource="${this.employeeUser}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                    <input class="delete" type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                </fieldset>
            </g:form>
        </div>
        </div>
    </div>
    </body>
</html>
