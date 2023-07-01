<%@ page import="loans.CardPayments" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'cardPayments.label', default: 'CardPayments')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">

        <div class="center panel_div_list">


            <div class="page-header-content">
                <div class="page-title">
                    <h5>
<g:link class="create" controller="home" action="index">
                            <i class="icon-arrow-left52 position-left"></i> <span
        class="text-semibold">Issued Payment list</span> (${cardPaymentsCount})</g:link>
                    </h5>
                </div>
                    <div class="heading-elements">

                        <%
                        def instanceTtl=loans.CardPayments.executeQuery("select sum (amount_paid) as total from CardPayments")[0]
                            if(!instanceTtl){
                                instanceTtl=0
                            }

                        %>

                        <div class="col-md-8">
                           <h3 class="label border-left-info label-striped">Amount: ${formatAmountString(name:(int)instanceTtl)} TZS</h3>
                        </div>
                    </div>
            </div>


            <div id="list-cardPayments" class="content scaffold-list" role="main">

            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

                    <g:sortableColumn property="user_id.first_name" title="${message(code: 'company.name.label', default: 'Name')}"/>

                    <g:sortableColumn property="amount_paid" title="${message(code: 'company.name.label', default: 'Amount')}"/>
                    <g:sortableColumn property="user_id.registration_no"
                                      title="${message(code: 'company.name.category', default: 'Registration No')}"/>

                    <g:sortableColumn property="created_at"
                                      title="${message(code: 'employee.name.category', default: 'Created Date')}"/>


                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${cardPaymentsList}" status="i" var="cardInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>
                            <% def offset = 0
                            if (params.offset) {
                                offset = Integer.parseInt(params.offset)
                            }
                            %>
                            ${i + 1 + offset}</td>
                        <td>
                            <g:link class="create" controller="secUser" action="show" id="${cardInstance?.user_id?.id}"
                                    resource="${this.cardInstance}">
                                ${fieldValue(bean: cardInstance, field: "user_id.full_name")}
                            </g:link>
                        </td>

                        <td>${fieldValue(bean: cardInstance, field: "amount_paid")}</td>
                        <td>${fieldValue(bean: cardInstance, field: "registration_no")}</td>
                        <td>
                            <g:formatDate format="dd-MMM-yyyy hh:mm a" date="${cardInstance.created_at}"/>

                        </td>
                        <td class="text-center">

                            <g:link class="create" action="show" id="${cardInstance.id}"
                                    resource="${this.cardInstance}"><button class="btn btn-primary">Details <i
                                    class="icon-arrow-right14 position-right"></i></button></g:link>

                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>

            <g:if test="${cardPaymentsCount > 5}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${cardPaymentsCount ?: 0}"/>
                    </div>
                </div>
            </g:if>

        </div>
        </div>
    </div>
    </body>
</html>