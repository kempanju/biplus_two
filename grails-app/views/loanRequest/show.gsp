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
            <g:if test="${loanRequest.user_id.loan_amount == 0}">
                <g:if test="${loanRequest.loan_status == 0}">
                    <div class="page-header-content">
                        <div class="heading-elements">
                            <g:link class="create" controller="loanRequest" action="resendPayments"
                                    id="${loanRequest.id}"><button type="button"
                                                                   class="btn bg-teal-400 btn-labeled"><b><i
                                        class="icon-add"></i></b> Resend Payments</button></g:link>

                        </div>
                    </div>
                </g:if>
            </g:if>
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
                                <g:link class="create" controller="secUser" action="show"
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
                                <span class="text-semibold">Deadline Date</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "last_payment_date")}</td>
                        </tr>


                        <tr>
                            <td>
                                <span class="text-semibold">Loan Repaid</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "loan_repaid")}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Repaid Date</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "repaid_date")}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Feedback</span>
                            </td>
                            <td>${fieldValue(bean: loanRequest, field: "mlipa_feedback")}</td>
                        </tr>
                        <td>
                            <span class="text-semibold">Operator Feedback</span>
                        </td>
                        <td style="max-width: 300px"><p>${fieldValue(bean: loanRequest, field: "payment_feedback")}</p>
                        </td>
                        <tr>
                            <td>Full Name ${loanRequest.getFullName()}</td>

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
            <g:if test="${loanRequest.loan_status == 1}">
                <div class="page-header-content">
                    <div class="heading-elements">
                        <g:link class="create" controller="loanRequest" action="processLoan"
                                id="${loanRequest.id}"><button type="button" class="btn bg-teal-400 btn-labeled"><b><i
                                class="icon-add"></i></b> Resend Success</button></g:link>

                    </div>
                </div>
            </g:if>
            <sec:ifAnyGranted roles="ROLE_ADMIN">

                    <div class="col-lg-10">
                <g:if test="${loanRequest.loan_status == 2}">

                    <div class="col-lg-4">

                        <g:form method="POST" action="changeLoanStatus" class="form-horizontal">
                            <fieldset class="form">
                                <g:hiddenField name="id" value="${loanRequest.id}"/>
                                <g:hiddenField name="loan_status" value="5"/>
                                <div class="text-right col-lg-10">
                                    <button type="submit" class="btn btn-primary">Freeze loan <i
                                            class="icon-arrow-right14 position-right"></i>
                                    </button>

                                </div>
                            </fieldset>
                        </g:form>
                    </div>
                </g:if>
                <g:if test="${loanRequest.loan_status == 0 || loanRequest.loan_status == 1}">

                    <div class="text-left col-lg-8">
                        <g:form method="POST" action="processLoan" class="form-horizontal"  >
                            <fieldset class="form">
                                <g:hiddenField name="id" value="${loanRequest.id}"/>
                                <g:hiddenField name="loan_status" value="1"/>
                                <div class="col-lg-12">
                                <div class="col-lg-4">
                                <g:select name="channel" required="required" from="${['Tigo', 'Vodacom']}" noSelection="${['':'Select Channel...']}"/>
                                </div>
                                <div class="text-left col-lg-4">
                                    <button type="submit" class="btn btn-success">Process loan <i
                                            class="icon-check position-right"></i>
                                    </button>

                                </div>
                            </div>
                            </fieldset>
                        </g:form>
                    </div>
                </g:if>
                </div>
            </sec:ifAnyGranted>
        </div>
    </div>
</div>
</body>
</html>
