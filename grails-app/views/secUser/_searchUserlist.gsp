<table class="table datatable-basic">
    <thead>
    <tr>
        <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

        <g:sortableColumn property="first_name"
                          title="${message(code: 'company.name.label', default: 'Name')}"/>

        <g:sortableColumn property="registration_no"
                          title="${message(code: 'company.name.label', default: 'Reg No')}"/>
        <g:sortableColumn property="phone_number"
                          title="${message(code: 'company.name.label', default: 'Phone No')}"/>
        <th class="text-center">Actions</th>

    </tr>
    </thead>
    <tbody>
    <g:each in="${secUserList}" status="i" var="userInstance">
        <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
            <td>
                <% def offset = 0
                if (params.offset) {
                    offset = Integer.parseInt(params.offset)
                }
                %>
                ${i + 1 + offset}</td>
            <td>${userInstance.full_name}</td>

            <td>
                %{--<g:if test="${userInstance.district_id}">
                    <g:link controller="user" action="index"
                            params="[district: userInstance?.district_id?.id]">${fieldValue(bean: userInstance, field: "district_id.name")}</g:link>

                </g:if>
                <g:else>--}%
                ${fieldValue(bean: userInstance, field: "registration_no")}
            </td>
            <td>${fieldValue(bean: userInstance, field: "phone_number")}</td>


            <td class="text-center">

                <g:link class="create" action="show" id="${userInstance.id}"
                        resource="${this.userInstance}"><button class="btn btn-primary">Details <i
                        class="icon-arrow-right14 position-right"></i></button></g:link>

            </td>
        </tr>
    </g:each>
    </tbody>
</table>