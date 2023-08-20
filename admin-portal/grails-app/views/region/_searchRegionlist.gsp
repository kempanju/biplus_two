<table class="table datatable-basic">
    <thead>
    <tr>
        <g:sortableColumn property="id"
                          title="${message(code: 'comapny.name.email', default: 'No')}"/>

        <g:sortableColumn property="name"
                          title="${message(code: 'company.name.label', default: 'Name')}"/>
        <th class="text-center">Actions</th>

    </tr>
    </thead>
    <tbody>
    <g:each in="${regionList}" status="i" var="regionInstance">
        <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
            <td>
                <% def offset = 0
                if (params.offset) {
                    offset = Integer.parseInt(params.offset)
                }
                %>
                ${i + 1 + offset}

            </td>
            <td>${fieldValue(bean: regionInstance, field: "name")}</td>
            <td class="text-center">

                <g:link class="create" action="show" id="${regionInstance.id}"
                        resource="${this.regionInstance}"><button class="btn btn-primary">Details <i
                        class="icon-arrow-right14 position-right"></i></button></g:link>

            </td>
        </tr>
    </g:each>

    </tbody>
</table>