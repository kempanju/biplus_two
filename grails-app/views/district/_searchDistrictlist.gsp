<table class="table datatable-basic">
    <thead>
    <tr>
        <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}" />

        <g:sortableColumn property="name" title="${message(code: 'company.name.label', default: 'Name')}" />
        <g:sortableColumn property="region_id" title="${message(code: 'company.name.label', default: 'Region')}" />
        <th class="text-center">Wards No</th>

        <th class="text-center">Actions</th>


    </tr>
    </thead>
    <tbody>
    <g:each in="${districtList}" status="i" var="districtInstance">
        <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
            <td>
                <% def offset = 0
                if (params.offset) {
                    offset = Integer.parseInt(params.offset)
                }
                %>
                ${i + 1 + offset}
            </td>
            <td > ${fieldValue(bean: districtInstance, field: "name")}</td>
            <td > <g:link class="edit" controller="region" action="show"
                          resource="${districtInstance.region_id}">${fieldValue(bean: districtInstance, field: "region_id.name")}
            </g:link>
            </td>
            <td>${admin.Wards.countByDistrict_idAndWard_visible(districtInstance,true)}</td>

            <td class="text-center">
%{--
                <g:link class="create" controller="district" params="[offset:params.offset,max:params.max]" action="deleteDistrict" id="${districtInstance.id}" resource="${this.districtInstance}"><button  class="btn btn-danger">Delete <i class="icon-arrow-right14 position-right"></i></button></g:link>
--}%

                <g:link class="create" action="show" id="${districtInstance.id}" resource="${this.districtInstance}"><button  class="btn btn-primary">Details <i class="icon-arrow-right14 position-right"></i></button></g:link>


            </td>
        </tr>
    </g:each>

    </tbody>
</table>
