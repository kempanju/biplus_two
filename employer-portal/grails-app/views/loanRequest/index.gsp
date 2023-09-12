<%@ page import="com.softhama.loans.LoanRequest" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'loanRequest.label', default: 'LoanRequest')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>

    <script>

        function userSearch(ids) {
            var ids = ids.value;

            $.ajax({
                url: '${grailsApplication.config.systemLink.toString()}/loanRequest/search_user',
                data: {'search_string': ids}, // change this to send js object
                type: "post",
                success: function (data) {
                    //document.write(data); just do not use document.write
                    $("#list-loanRequest").html(data);
                    //console.log(data);
                }
            });
        }
    </script>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link class="create" controller="loanRequest" action="reports"><i
                            class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Loan request list(${loanRequestCount})</span></g:link>
                </h5>
            </div>


            <div class="heading-elements">

                <div class="col-md-12">

                    <%
                        def totalRequest = LoanRequest.executeQuery("select sum (amount) as total from LoanRequest where loan_status=2 and customer_id=:customer",[customer:customer])[0]
                        if (!totalRequest) {
                            totalRequest = 0
                        }

                    %>

                    <h2 class="label border-left-info label-striped fa-th-large">Amount: ${formatAmountString(name: (int) totalRequest)} TZS</h2>

                </div>
            </div>

            <div class="page-title col-md-4 text-right">
                <div class="form-group">
                    <div class="has-feedback">
                        <input type="search" value="" name="search_text" class="form-control"
                               onkeyup="userSearch(this)" placeholder="Search">

                    </div>
                </div>
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

                    <g:sortableColumn property="user_group"
                                      title="${message(code: 'company.name.label', default: 'Registration No')}"/>


                    <g:sortableColumn property="amount"
                                      title="${message(code: 'company.name.label', default: 'Amount')}"/>
                    <g:sortableColumn property="created_at"
                                      title="${message(code: 'company.name.category', default: 'Date')}"/>
                    %{--<g:sortableColumn property="loan_repaid"
                                      title="${message(code: 'company.name.category', default: 'Paid')}"/>--}%
                    <g:sortableColumn property="loan_status"
                                      title="${message(code: 'company.name.category', default: 'Status')}"/>



                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${loanRequestList}" status="i" var="loanInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>
                            <% def offset = 0
                            if (params.offset) {
                                offset = Integer.parseInt(params.offset)
                            }
                            %>
                            ${i + 1 + offset}</td>
                        <td>
                            <g:link class="create" controller="employee" action="show" id="${loanInstance?.user_id?.id}"
                                    resource="${this.loanInstance}">
                                ${fieldValue(bean: loanInstance, field: "user_id.full_name")}
                            </g:link>
                        </td>
                        <td>
                            ${fieldValue(bean: loanInstance, field: "user_id.registration_no")}
                        </td>

                        <td>${fieldValue(bean: loanInstance, field: "amount")}</td>
                        <td>${fieldValue(bean: loanInstance, field: "created_at")}</td>

                        %{--
                                                <td>${fieldValue(bean: loanInstance, field: "loan_repaid")}</td>
                        --}%

                        <td>

                            <g:if test="${loanInstance.loan_status == 1}">
                                <span class="text-info">Pending</span>
                            </g:if>
                            <g:elseif test="${loanInstance.loan_status == 2}">
                                <span class="text-success">Success</span>

                            </g:elseif>

                            <g:elseif test="${loanInstance.loan_status == 0}">
                                <span class="text-warning">Failed</span>

                            </g:elseif>
                            <g:elseif test="${loanInstance.loan_status == 5}">
                                <span class="text-info">Freezed</span>

                            </g:elseif>
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


            <g:if test="${loanRequestCount > 5}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${loanRequestCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>

    </div>
</div>
</body>
</html>