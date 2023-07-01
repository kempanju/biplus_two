<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'district.label', default: 'District')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>

        <script>

            function districtSearch(ids) {
                var ids = ids.value;

                $.ajax({
                    url: '${grailsApplication.config.systemLink.toString()}/district/search_district',
                    data: {'search_string': ids}, // change this to send js object
                    type: "post",
                    success: function (data) {
                        //document.write(data); just do not use document.write
                        $("#list-district").html(data);
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
                        <g:link class="create" controller="home" action="index">  <i class="icon-arrow-left52 position-left"></i> <span class="text-semibold">District list</span></g:link>
                    </h5>
                </div>
                <div class="heading-elements">

                    <div class="col-md-7">
                        <div class="form-group">
                            <div class="has-feedback">
                                <input type="search" value="" name="search_text" class="form-control"
                                       onkeyup="districtSearch(this)" placeholder="Search district">

                            </div>
                        </div>
                    </div>
<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_DATA">

                    <div class="col-md-4">
                        <g:link class="create" action="create"><button type="button" class="btn bg-teal-400 btn-labeled"><b><i class="icon-add"></i></b> <g:message code="default.new.label" args="[entityName]" /></button></g:link>
                    </div>
</sec:ifAnyGranted>
                </div>
            </div>

        <div id="list-district" class="content scaffold-list" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

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
                  %{--  <sec:ifAnyGranted roles="ROLE_ADMIN">
                        <g:link class="create" controller="district" params="[offset:params.offset,max:params.max]" action="deleteDistrict" id="${districtInstance.id}" resource="${this.districtInstance}"><button  class="btn btn-danger">Delete <i class="icon-arrow-right14 position-right"></i></button></g:link>
                    </sec:ifAnyGranted>--}%
                            <g:link class="create" action="show" id="${districtInstance.id}" resource="${this.districtInstance}"><button  class="btn btn-primary">Details <i class="icon-arrow-right14 position-right"></i></button></g:link>


                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>
            <g:if test="${districtCount > 5}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${districtCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>

        </div>
    </div>
    </body>
</html>