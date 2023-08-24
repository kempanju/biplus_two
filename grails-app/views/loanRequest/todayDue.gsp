%{--
<%@ page import="com.tacip.security.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'loanRequest.label', default: 'LoanRequest')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <a href="/"><i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Today due users</span></a>
                </h5>
            </div>

            <div class="page-title">
                <g:link class="create" controller="home" action="messagesLoans"><button type="button"
                                                                                        class="btn bg-teal-400 btn-labeled"><b><i
                            class="icon-envelop2"></i></b> Send Messages</button></g:link>

            </div>

        </div>

        <a href="#list-loanRequest" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                                          default="Skip to content&hellip;"/></a>

        <div id="list-loanRequest" class="content scaffold-list panel" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

                    <g:sortableColumn property="user_id"
                                      title="${message(code: 'company.name.label', default: 'Name')}"/>

                    <g:sortableColumn property="id"
                                      title="${message(code: 'company.name.label', default: 'Supposed Amount')}"/>
                    <g:sortableColumn property="id"
                                      title="${message(code: 'company.name.category', default: 'Remained')}"/>
                    <g:sortableColumn property="id"
                                      title="${message(code: 'company.name.category', default: 'Passed days')}"/>




                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <% def j = 0; %>

                <g:each in="${com.tacip.security.User.findAllByHave_loan(true)}" status="i" var="loanInstance">

                    <%

                        def full_name = loanInstance.full_name
                        def lastLoan = loanInstance.last_loan.loan_amount_total
                        int lastLoanAmount = loanInstance.last_loan.amount

                        def instruments = loanInstance.last_loan.instruments
                        def inserteddate = loanInstance.last_loan.created_at

                        int reminedLoan = loanInstance.loan_amount

                        int eachinstruments = lastLoan / instruments

                        int paidAmount = lastLoan - reminedLoan

                        int instrumentsPAid = (paidAmount / eachinstruments) + 1

                        int supposseddate = (30 / instruments) * instrumentsPAid


                        int nextAmount = (eachinstruments * instrumentsPAid) - paidAmount



                        def dayspassed = dateDiffreneces(name: inserteddate.toString())

                        def inst_days = 30 / instruments

                        def passeddate = Integer.parseInt(dayspassed.toString()) - supposseddate;

                        def suppposedInstraments = Math.floor(Integer.parseInt(dayspassed.toString()) / inst_days)

                        if (suppposedInstraments > instruments) {
                            suppposedInstraments = instruments
                        }



                        def nextamount = (int) (eachinstruments * suppposedInstraments) - paidAmount


                        def amount = loanInstance.last_loan.amount
                        def firstname = loanInstance.first_name + " " + loanInstance.last_name

                    %>
                    <g:if test="${Integer.parseInt(dayspassed.toString()) >= supposseddate}">

                        <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">

                            <td>

                                ${j + 1}</td>
                            <td>
                                <g:link class="create" controller="user" action="show" id="${loanInstance?.id}"
                                        resource="${this.loanInstance}">
                                    ${fieldValue(bean: loanInstance, field: "first_name") + " " + fieldValue(bean: loanInstance, field: "middle_name") + " " + fieldValue(bean: loanInstance, field: "last_name")}
                                </g:link>
                            </td>

                            <td>${nextamount}</td>
                            <td>${fieldValue(bean: loanInstance, field: "loan_amount")}</td>

                            <td>

                                ${passeddate}

                            </td>


                            <td class="text-center">

                                <g:link class="create" action="show" id="${loanInstance.last_loan.id}"
                                        resource="${this.loanInstance}"><button class="btn btn-primary">Details <i
                                        class="icon-arrow-right14 position-right"></i></button></g:link>

                            </td>
                            <% j++ %>
                        </tr>
                    </g:if>
                </g:each>

                </tbody>
            </table>

        </div>
    </div>
</div>
</body>
</html>--}%
