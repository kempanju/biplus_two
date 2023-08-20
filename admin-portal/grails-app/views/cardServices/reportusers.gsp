<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <g:set var="entityName" value="${message(code: 'cardServices.label', default: 'CardServices')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>

    <script>

        function cardsSearch(ids) {
            var ids = ids.value;

            $.ajax({
                url: '/cardServices/search_cardlist',
                data: {'search_string': ids}, // change this to send js object
                type: "post",
                success: function (data) {
                    //document.write(data); just do not use document.write
                    $("#list-cardServices").html(data);
                    //console.log(data);
                }
            });
        }
    </script>
</head>
<body>
<div class="register_dv expert">

    <div class="center panel_div_list">
        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <a href="/">
                        <i class="icon-arrow-left52 position-left"></i> <span
                            class="text-semibold">Issued Card list</span> (${cardServicesCount})</a>
                </h5>
            </div>

            <div class="heading-elements">

                <input type="text" value="" name="search_text" class="form-control" onkeyup="cardsSearch(this)" placeholder="Search  card number">

            </div>

        </div>
        <sec:ifAnyGranted roles="ROLE_ADMIN">

            <div class="page-header-content">
                <div class="heading-elements">
                    <g:link class="create" controller="cardServices" action="bulkSendCardAPI"><button type="button" class="btn bg-teal-400 btn-labeled"><b><i class="icon-add"></i></b> Issued cards</button></g:link>

                </div>
            </div>
        </sec:ifAnyGranted>
        <div id="list-cardServices" class="content scaffold-list" role="main">
            <g:if test="${flash.errormessage}">
                <div class="message" role="status">${flash.errormessage}</div>
            </g:if>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'employee.name.email', default: 'No')}"/>
                    <g:sortableColumn property="first_name"
                                      title="${message(code: 'employee.name.label', default: 'Name')}"/>
                    <g:sortableColumn property="card_number"
                                      title="${message(code: 'employee.name.label', default: 'Reference No')}"/>
                    <g:sortableColumn property="amount_paid"
                                      title="${message(code: 'employee.name.label', default: 'Amount')}"/>
                    <g:sortableColumn property="expired"
                                      title="${message(code: 'employee.name.category', default: 'Created Date')}"/>
                    <th>Card status</th>


                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${cardServicesList}" status="i" var="cardServicesInstance">
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
                                ${fieldValue(bean: cardServicesInstance, field: "user_id.first_name") + " " + fieldValue(bean: cardServicesInstance, field: "user_id.middle_name") + " " + fieldValue(bean: cardServicesInstance, field: "user_id.last_name")}
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

            <g:if test="${cardServicesCount > 10}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${cardServicesCount ?: 0}"/>
                    </div>
                </div>
            </g:if>

        </div>
    </div>
</div>
</body>
</html>