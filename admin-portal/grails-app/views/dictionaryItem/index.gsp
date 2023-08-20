<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dictionaryItem.label', default: 'DictionaryItem')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">

        <div class="center panel_div_list">
        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <a href="/"> <i class="icon-arrow-left52 position-left"></i> <span class="text-semibold">Dictionary Item Lists</span></a>
                </h5>
            </div>

            <div class="heading-elements">

                <div class="col-md-4">
                    <g:link class="create" action="create"><button type="button" class="btn bg-teal-400 btn-labeled"><b><i class="icon-add"></i></b> <g:message code="default.new.label" args="[entityName]" /></button></g:link>
                </div>
            </div>

        </div>

        <div id="list-dictionaryItem" class="content scaffold-list" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>


            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}" />
                    <g:sortableColumn property="code" title="${message(code: 'company.name.category', default: 'Code')}" />

                    <g:sortableColumn property="name" title="${message(code: 'company.name.label', default: 'Name')}" />
                    <g:sortableColumn property="dictionary_id" title="${message(code: 'company.name.label', default: 'Dictionary')}" />

                    <th class="text-center">Actions</th>


                </tr>
                </thead>
                <tbody>
                <g:each in="${dictionaryItemList}" status="i" var="dictionaryListInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>${i+1}</td>
                        <td > ${fieldValue(bean: dictionaryListInstance, field: "code")}</td>
                        <td>${fieldValue(bean: dictionaryListInstance, field: "name")}</td>
                        <td>${fieldValue(bean: dictionaryListInstance, field: "dictionary_id.name")}</td>

                        <td class="text-center">

                            <g:link class="create" action="show" id="${dictionaryListInstance.id}" resource="${this.dictionaryListInstance}"><button  class="btn btn-primary">Details <i class="icon-arrow-right14 position-right"></i></button></g:link>


                        </td>
                    </tr>
                </g:each>

                </tbody>
            </table>


        </div>

        <g:if test="${dictionaryItemCount > 10}">
            <div class="col-md-10 text-center" style="margin-top: 20px">
                <div class="pagination">
                    <g:paginate total="${dictionaryItemCount ?: 0}"/>
                </div>
            </div>
        </g:if>
    </div>
    </div>
    </body>
</html>