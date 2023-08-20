<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'region.label', default: 'Region')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script>

        function regionSearch(ids) {
            var ids = ids.value;

            $.ajax({
                url: '${grailsApplication.config.systemLink.toString()}/region/search_region',
                data: {'search_string': ids}, // change this to send js object
                type: "post",
                success: function (data) {
                    //document.write(data); just do not use document.write
                    $("#list-region").html(data);
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
                    <g:link class="create" controller="home" action="index"><i
                            class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Region list</span></g:link>
                </h5>
            </div>

            <div class="heading-elements">
                <div class="col-md-7">
                    <div class="form-group">
                        <div class="has-feedback">
                            <input type="search" value="" name="search_text" class="form-control"
                                   onkeyup="regionSearch(this)" placeholder="Search region">

                        </div>
                    </div>
                </div>
<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_DATA">

    <div class="col-md-4">
                    <g:link class="create" action="create" id="${params.id}"><button type="button"
                                                                                     class="btn bg-teal-400 btn-labeled"><b><i
                                class="icon-add"></i></b> <g:message code="default.new.label"
                                                                     args="[entityName]"/>
                    </button></g:link>
                </div>
</sec:ifAnyGranted>

            </div>
        </div>

        <div id="list-region" class="content scaffold-list" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>


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
            <g:if test="${regionCount > 5}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${regionCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>

    </div>
</div>
</body>
</html>