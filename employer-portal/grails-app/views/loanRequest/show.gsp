<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'loanRequest.label', default: 'LoanRequest')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link action="index">
                        <i class="icon-arrow-left52 position-left"></i> <span
                            class="text-semibold">Loan request</span>
                    </g:link>
                </h5>
            </div>


        </div>


        <div id="show-loanRequest" class="content scaffold-show" role="main">
            <g:if test="${flash.message}">
                <div class="message alert alert-success alert-styled-left alert-arrow-left alert-bordered"
                     role="status">${flash.message}</div>
            </g:if>

            <div class="card_user" style="width: 80%;margin-right: auto;margin-left: auto">

                <div class="panel table-responsive">

                    <table class="table text-nowrap">
                        <tr>
                            <td colspan="2"><h5>
                                <span class="text-bold">Loan request information</span>
                            </h5></td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Name</span>
                            </td>
                            <td>
                                <g:link class="create" controller="employee" action="show"
                                        id="${loanRequest?.user_id?.id}">
                                    ${fieldValue(bean: loanRequest, field: "user_id.full_name")}
                                </g:link>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Instalment</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "instruments")}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Reference code</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "request_unique")}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Loan status</span>
                            </td>
                            <td>
                                <g:if test="${loanRequest.loan_status == 1}">
                                    <span class="text-info">Pending</span>
                                </g:if>
                                <g:elseif test="${loanRequest.loan_status == 2}">
                                    <span class="text-success">Success</span>

                                </g:elseif>

                                <g:elseif test="${loanRequest.loan_status == 0}">
                                    <span class="text-warning">Failed</span>

                                </g:elseif>
                                <g:elseif test="${loanRequest.loan_status == 5}">
                                    <span class="text-info">Freezed</span>

                                </g:elseif>
                                <g:elseif test="${loanRequest.loan_status == 6}">
                                    <span class="text-info">Waiting</span>

                                </g:elseif>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Loan amount</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "amount")} TZS</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Interest amount</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "interestAmount")} TZS</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Loan fee</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "interest_percentage")}%</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Insurance fee </span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "insurance_fee")}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Loan total amount</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "loan_amount_total")} TZS</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Mobile No</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "user_id.phone_number")}</td>
                        </tr>



                        <tr>
                            <td>
                                <span class="text-semibold">Loan Repaid</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "loan_repaid")}</td>
                        </tr>


                        <tr>
                            <td>
                                <span class="text-semibold">Feedback</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "mlipa_feedback")}</td>
                        </tr>


                        <tr>
                            <td>
                                <span class="text-semibold">Created at</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "created_at")}</td>
                        </tr>
                    </table>
                </div>
            </div>


        </div>
    </div>
</div>
</body>
</html>
