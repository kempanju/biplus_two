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
        <g:each in="${loans.LoanRequest.findAllByUser_idAndLoan_status(userInstance,2)}" status="i" var="loanInstance">
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

</div>