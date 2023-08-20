<%@ page import="finance.SecUser" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'customers.label', default: 'Customers')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">
    <div class="center panel_div_list_big">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link class="create" controller="loanRequest" action="reports">
                        <i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Customer list (${customersCount})</span>
                    </g:link>
                </h5>
            </div>

        </div>

        <a href="#list-customers" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                                        default="Skip to content&hellip;"/></a>


        <div id="list-customers" class="content scaffold-list" role="main">
        %{--
                    <h1><g:message code="default.list.label" args="[entityName]" /></h1>
        --}%
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
        %{--
                    <f:table collection="${customersList}" />
        --}%

            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

                    <g:sortableColumn property="code"
                                      title="${message(code: 'company.name.label', default: 'Code')}"/>


                    <g:sortableColumn property="name"
                                      title="${message(code: 'company.name.label', default: 'Name')}"/>
                    <th class="text-center">Members</th>

                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${customersList}" status="i" var="customerInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>
                            <% def offset = 0
                            if (params.offset) {
                                offset = Integer.parseInt(params.offset)
                            }
                            %>
                            ${i + 1 + offset}</td>
                        <td>${customerInstance.code}</td>

                        <td>
                            %{--<g:if test="${userInstance.district_id}">
                                <g:link controller="user" action="index"
                                        params="[district: userInstance?.district_id?.id]">${fieldValue(bean: userInstance, field: "district_id.name")}</g:link>

                            </g:if>
                            <g:else>--}%
                            ${fieldValue(bean: customerInstance, field: "name")}
                        </td>
                        <td class="text-center"><span class="text-center">
                            ${finance.SecUser.countByUser_group(customerInstance)}
                        </span>
                        </td>

                        <td class="text-center">

                            <g:link class="create" action="show" id="${customerInstance.id}"
                                    resource="${this.customerInstance}"><button class="btn btn-primary">Details <i
                                    class="icon-arrow-right14 position-right"></i></button></g:link>

                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
            <g:if test="${customersCount > 10}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${customersCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>
    </div>
</div>
</body>
</html>