<%@ page import="loans.LoanRepayment" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'loanRepayment.label', default: 'LoanRepayment')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link class="create" controller="home" action="index"><i
                            class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Repayment list</span></g:link>
                </h5>
            </div>

            <div class="heading-elements">

                <div class="col-md-12">
                    <h2 class="label border-left-info label-striped">Amount:
                    <%
                        def totals = 0
                        try {

                            totals = loans.LoanRepayment.executeQuery("select sum (amount_paid) as total from LoanRepayment")[0]
                            if (!totals) {
                                totals = 0
                            }

                        } catch (Exception e) {

                        }
                    %>
                    ${formatAmountString(name: (int) totals)} TZS</h2>
                </div>
            </div>
        </div>

        <div id="list-loanRepayment" class="content scaffold-list" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>
                    <g:sortableColumn property="user_id"
                                      title="${message(code: 'company.name.label', default: 'Name')}"/>
                    <g:sortableColumn property="amount_paid"
                                      title="${message(code: 'company.name.label', default: 'Amount')}"/>
                    %{--
                                        <g:sortableColumn property="region_id"
                                                          title="${message(code: 'company.name.label', default: 'Remained')}"/>
                    --}%
                    <g:sortableColumn property="created_at"
                                      title="${message(code: 'company.name.label', default: 'Paid at')}"/>

                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${loanRepaymentList}" status="i" var="loanInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>
                            <% def offset = 0
                            if (params.offset) {
                                offset = Integer.parseInt(params.offset)
                            }
                            %>
                            ${i + 1 + offset}
                        </td>
                        <td>
                            <g:link controller="secUser" action="show" id="${loanInstance.user_id.id}">
                                ${fieldValue(bean: loanInstance, field: "user_id.full_name")}
                            </g:link>
                        </td>
                        <td>${fieldValue(bean: loanInstance, field: "amount_paid")}
                        </td>
                        %{-- <td >${fieldValue(bean: loanInstance, field: "user_id.loan_amount")}
                         </td>--}%
                        <td>${fieldValue(bean: loanInstance, field: "created_at")}
                        </td>


                        <td class="text-center">

                            <g:link class="create" action="show" id="${loanInstance.id}"
                                    resource="${this.loanInstance}"><button class="btn btn-primary">Details <i
                                    class="icon-arrow-right14 position-right"></i></button></g:link>

                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>

            <g:if test="${loanRepaymentCount > 10}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${loanRepaymentCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>




        <div class="panel" style="margin-top: 100px">

            <div class="col-md-5">
                <g:link class="create" controller="loanRepayment" action="printRepaymentExcel"><button type="button"
                                                                                                       class="btn bg-teal-400 btn-labeled"><b><i
                            class="icon-file-excel"></i></b> Print excel</button></g:link>

            </div>

        </div>

    </div>
</div>
</body>
</html>