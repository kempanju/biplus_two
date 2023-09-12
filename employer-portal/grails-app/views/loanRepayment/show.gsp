<%@ page import="com.softhama.loans.UserLoan" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'loanRepayment.label', default: 'LoanRepayment')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">

        <div class="center panel_div_list panel">

            <div class="page-header-content">
                <div class="page-title">
                    <h5>
                        <g:link action="index">
                            <i class="icon-arrow-left52 position-left"></i> <span
                                class="text-semibold">Payment</span>
                        </g:link>
                    </h5>
                </div>
            </div>

        <div id="show-loanRepayment" class="content scaffold-show" role="main">
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>

            <div class="card_user" style="width: 80%;margin-right: auto;margin-left: auto">

                <div class="panel table-responsive">

                    <table class="table text-nowrap">
                        <tr>
                            <td colspan="2"><h5>
                                <span class="text-bold">Payment information</span>
                            </h5></td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Name</span>
                            </td>
                            <td>
                                <g:link class="create" controller="employee" action="show" id="${loanRepayment?.user_id?.id}">
                                    ${fieldValue(bean: loanRepayment, field: "user_id.full_name")}
                                </g:link>
                            </td>

                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Amount paid</span>
                            </td>
                            <td>${fieldValue(bean: loanRepayment, field: "amount_paid")} TZS</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Created at</span>
                            </td>
                            <td>${fieldValue(bean: loanRepayment, field: "created_at")}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Remained loan amount</span>
                            </td>
                            <%
                                def totals = UserLoan.findByUser(loanRepayment.user_id)?.unpaidLoan
                            %>
                            <td>${formatAmountString(name:(int)totals)}  TZS</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Parent Loan</span>
                            </td>
                            <td><g:link controller="loanRequest" action="show" id="${loanRepayment.loan_id.id}">
                                Parent loan of ${fieldValue(bean: loanRepayment, field: "loan_id.loan_amount_total")} TZS
                            </g:link>
                                </td>
                        </tr>

                    </table>
                </div>
            </div>

                </div>
        </div>
    </div>
    </body>
</html>
