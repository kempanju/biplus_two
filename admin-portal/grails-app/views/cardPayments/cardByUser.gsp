<%@ page import="finance.CardServices; loans.LoanRequest; loans.CardPayments" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <g:set var="entityName" value="${message(code: 'cardServices.label', default: 'CardServices')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>

    <script>

        function cardsSearch(ids) {
            var ids = ids.value;

            $.ajax({
                url: '/cardServices/search_cardlist',
                data: {'search_string': ids}, // change this to send js object
                type: "post",
                success: function (data) {
                    //document.write(data); just do not use document.write
                    $("#list-cardServices").html(data);
                    //console.log(data);
                }
            });
        }
    </script>
</head>
<body>
<div class="register_dv expert">

    <div class="center panel_div_list">
        <div class="page-header-content">
            <div class="page-title">
                <h5>

                    <i class="icon-arrow-left52 position-left"></i> <span
                        class="text-semibold">Payment list</span>
                </h5>
            </div>

            <div class="heading-elements">

                <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD">

                    <div class="col-md-4">
                        <g:link class="create" controller="cardServices" action="issueNewCard" id="${userInstance.id}" ><button type="button" class="btn bg-teal-400 btn-labeled"><b><i class="icon-add"></i></b> NEW CARD</button></g:link>
                    </div>
                </sec:ifAnyGranted>
            </div>

        </div>
        <div class="page-header-content">
            <div class="page-title">
                <h4>

                    <i class="icon-credit-card position-left"></i> <span
                        class="text-semibold">Credits: <span class="numbers text-bold">${userInstance.payment_credit}</span></span>
                </h4>
            </div>
        </div>


            <div id="list-cardServices" class="content scaffold-list" role="main">
                <g:if test="${flash.errormessage}">
                    <div class="message errors" role="status">${flash.errormessage}</div>
                </g:if>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>


                <g:if test="${CardServices.countByUser_id(userInstance) > 0}">

                    <div class="page-header-content">
                        <div class="page-title">
                            <h4>
                                <i class="icon-list position-left"></i> <span
                                    class="text-semibold">Cards issued</span>
                            </h4>
                        </div>
                    </div>

                    <table class="table datatable-basic">
                        <thead>
                        <tr>
                            <g:sortableColumn property="id" title="${message(code: 'employee.name.email', default: 'No')}"/>
                            <g:sortableColumn property="first_name"
                                              title="${message(code: 'employee.name.label', default: 'Name')}"/>
                            <g:sortableColumn property="card_number"
                                              title="${message(code: 'employee.name.label', default: 'Card Number')}"/>
                            <g:sortableColumn property="first_name"
                                              title="${message(code: 'employee.name.label', default: 'Amount')}"/>
                            <g:sortableColumn property="registration_number"
                                              title="${message(code: 'employee.name.category', default: 'Created Date')}"/>


                            <th class="text-center">Actions</th>

                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${kopafasta.CardServices.findAllByUser_id(userInstance)}" status="i" var="cardServicesInstance">
                            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                                <td>${i + 1}</td>
                            <td>
                                <g:link class="create" controller="user" action="show"
                                        id="${cardServicesInstance?.user_id?.id}"
                                        resource="${this.cardServicesInstance}">
                                    ${fieldValue(bean: cardServicesInstance, field: "user_id.full_name")}</td>
                                </g:link>
                                <td>${fieldValue(bean: cardServicesInstance, field: "card_number")}</td>
                                <td>${fieldValue(bean: cardServicesInstance, field: "amount_paid")}</td>
                                <td>
                                    <g:formatDate format="dd-MMM-yyyy hh:mm a" date="${cardServicesInstance.created_at}"/>

                                </td>

                                <td class="text-center">

                                    <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD,ROLE_MANAGER">
                                        <g:link class="create" controller="cardServices" action="show" id="${cardServicesInstance.id}"
                                                resource="${this.cardServicesInstance}"><button
                                                class="btn btn-primary">Details <i
                                                    class="icon-arrow-right14 position-right"></i></button></g:link>
                                    </sec:ifAnyGranted>

                                </td>
                            </tr>
                        </g:each>

                        </tbody>
                    </table>
                </g:if>

            <g:if test="${loans.CardPayments.countByUser_id(userInstance)>0}">
                <div class="page-header-content">
                    <div class="page-title">
                        <h4>
                            <i class="icon-list position-left"></i> <span
                                class="text-semibold">Payment received</span>
                        </h4>
                    </div>
                </div>

            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'employee.name.email', default: 'No')}"/>
                    <g:sortableColumn property="first_name"
                                      title="${message(code: 'employee.name.label', default: 'Name')}"/>
                    <g:sortableColumn property="first_name"
                                      title="${message(code: 'employee.name.label', default: 'Amount')}"/>
                    <g:sortableColumn property="registration_number"
                                      title="${message(code: 'employee.name.category', default: 'Created Date')}"/>


                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${cardPaymentList}" status="i" var="cardPaymentInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                        <td>${i+1}</td>
                    <td>
                        <g:link class="create" controller="user" action="show" id="${cardPaymentInstance?.user_id?.id}"
                                resource="${this.cardPaymentInstance}">
                            ${fieldValue(bean: cardPaymentInstance, field: "user_id.full_name")}</td>
                        </g:link>
                        <td>${fieldValue(bean: cardPaymentInstance, field: "amount_paid")}</td>
                        <td>
                            <g:formatDate format="dd-MMM-yyyy hh:mm a" date="${cardPaymentInstance.created_at}"/>

                        </td>

                        <td class="text-center">


                            <sec:ifAnyGranted roles="ROLE_ADMIN">
                                <g:link class="create" controller="cardPayments" action="show" id="${cardPaymentInstance.id}"
                                        resource="${this.cardPaymentInstance}"><button class="btn btn-primary">Details <i
                                        class="icon-arrow-right14 position-right"></i></button></g:link>
                            </sec:ifAnyGranted>

                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
            </g:if>

<g:if test="${loans.LoanRequest.countByUser_id(userInstance)>0}">

    <div class="page-header-content">
        <div class="page-title">
            <h4>
                <i class="icon-list position-left"></i> <span
                    class="text-semibold">Loan received (${LoanRequest.countByUser_id(userInstance)})</span>
            </h4>
        </div>
    </div>

    <table class="table datatable-basic">
        <thead>
        <tr>
            <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

            <g:sortableColumn property="user_id" title="${message(code: 'company.name.label', default: 'Name')}"/>

            <g:sortableColumn property="amount" title="${message(code: 'company.name.label', default: 'Amount')}"/>
            <g:sortableColumn property="created_at"
                              title="${message(code: 'company.name.category', default: 'Date')}"/>
            <g:sortableColumn property="loan_repaid"
                              title="${message(code: 'company.name.category', default: 'Paid')}"/>
            <g:sortableColumn property="loan_status"
                              title="${message(code: 'company.name.category', default: 'Status')}"/>



            <th class="text-center">Actions</th>

        </tr>
        </thead>
        <tbody>
        <g:each in="${LoanRequest.findAllByUser_id(userInstance)}" status="i" var="loanInstance">
            <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                <td>
                    <% def offset = 0
                    if (params.offset) {
                        offset = Integer.parseInt(params.offset)
                    }
                    %>
                    ${i + 1 + offset}</td>
                <td>
                    <g:link class="create" controller="secUser" action="show" id="${loanInstance?.user_id?.id}"
                            resource="${this.loanInstance}">
                        ${fieldValue(bean: loanInstance, field: "user_id.full_name")}
                    </g:link>
                </td>

                <td>${fieldValue(bean: loanInstance, field: "amount")}</td>
                <td>${fieldValue(bean: loanInstance, field: "created_at")}</td>


                                        <td>
                                            ${fieldValue(bean: loanInstance, field: "loan_repaid")}

                                        </td>


                <td>

                    <g:if test="${loanInstance.loan_status==1}">
                        <span class="text-info">Pending</span>
                    </g:if>
                    <g:elseif test="${loanInstance.loan_status==2}">
                        <span class="text-success">Success</span>

                    </g:elseif>

                    <g:elseif test="${loanInstance.loan_status==0}">
                        <span class="text-warning">Failed</span>

                    </g:elseif>
                </td>
                <td class="text-center">

                    <g:link class="create" controller="loanRequest" action="show" id="${loanInstance.id}"
                            resource="${this.loanInstance}"><button class="btn btn-primary">Details <i
                            class="icon-arrow-right14 position-right"></i></button></g:link>

                </td>
            </tr>
        </g:each>

        </tbody>
    </table>


</g:if>
        </div>
    </div>
</div>
</body>
</html>