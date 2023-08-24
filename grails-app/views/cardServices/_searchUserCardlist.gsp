<table class="table datatable-basic">
    <thead>
    <tr>
        <g:sortableColumn property="id" title="${message(code: 'employee.name.email', default: 'No')}"/>
        <g:sortableColumn property="user_id.first_name"
                          title="${message(code: 'employee.name.label', default: 'Name')}"/>
        <g:sortableColumn property="card_number"
                          title="${message(code: 'employee.name.label', default: 'Reference No')}"/>
        <g:sortableColumn property="amount_paid"
                          title="${message(code: 'employee.name.label', default: 'Amount')}"/>
        <g:sortableColumn property="created_at"
                          title="${message(code: 'employee.name.category', default: 'Created Date')}"/>
        <th>Card status</th>


        <th class="text-center">Actions</th>

    </tr>
    </thead>
    <tbody>
    <g:each in="${cardList}" status="i" var="cardServicesInstance">
        <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
            <td>
                <% def offset = 0
                if (params.offset) {
                    offset = Integer.parseInt(params.offset)
                }
                %>
                ${i + 1 + offset}
            </td>
            <td>
                <g:link class="create" controller="user" action="show" id="${cardServicesInstance?.user_id?.id}"
                        resource="${this.cardServicesInstance}">
                    ${fieldValue(bean: cardServicesInstance, field: "user_id.full_name") }
                </g:link></td>
            <td>${fieldValue(bean: cardServicesInstance, field: "card_number")}</td>
            <td>${fieldValue(bean: cardServicesInstance, field: "amount_paid")}</td>
            <td>
                <g:formatDate format="dd-MMM-yyyy hh:mm a" date="${cardServicesInstance.created_at}"/>

            </td>

            <td>
                <g:if test="${!cardServicesInstance.issued}">
                    <span class="text-info">Not issued</span>
                </g:if>

                <g:elseif test="${!cardServicesInstance.active}">
                    <span class="text-info">Not Active</span>
                </g:elseif>
                <g:elseif test="${!cardServicesInstance.enabled}">
                    <span class="text-info">Disabled</span>
                </g:elseif>
                <g:elseif test="${!cardServicesInstance.paid}">
                    <span class="text-info">Not Paid</span>
                </g:elseif>

                <g:elseif test="${cardServicesInstance.expired}">
                    <span class="text-info">Expired</span>
                </g:elseif>
                <g:else>
                    <span class="text-info">Active</span>
                </g:else>

            </td>

            <td class="text-center">


                <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD">
                    <g:link class="create" action="show" id="${cardServicesInstance.id}"
                            resource="${this.cardServicesInstance}"><button class="btn btn-primary">Details <i
                            class="icon-arrow-right14 position-right"></i></button></g:link>
                </sec:ifAnyGranted>

            </td>
        </tr>
    </g:each>

    </tbody>
</table>
