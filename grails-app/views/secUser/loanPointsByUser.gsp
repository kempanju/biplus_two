<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>

    <script>

        function userSearch(ids) {
            var ids = ids.value;

            $.ajax({
                url: '${grailsApplication.config.systemLink.toString()}/user/search_user',
                data: {'search_string': ids}, // change this to send js object
                type: "post",
                success: function (data) {
                    //document.write(data); just do not use document.write
                    $("#list-user").html(data);
                    //console.log(data);
                }
            });
        }
    </script>
</head>

<body>
<div class="register_dv expert">
    <div class="center panel_div_list_big">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link controller="home" action="index">
                        <i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">User points list (${userCount})</span>
                    </g:link>
                </h5>
            </div>

            <div class="page-title">
                <g:link class="create" controller="user" action="messagesUsers"><button type="button" class="btn bg-teal-400 btn-labeled"><b><i class="icon-envelop2"></i></b> Send Messages</button></g:link>

            </div>

        </div>

        <div id="list-user" class="content scaffold-list" role="main">

            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'comapny.name.email', default: 'No')}"/>

                    <g:sortableColumn property="first_name"
                                      title="${message(code: 'company.name.label', default: 'Name')}"/>



                    <g:sortableColumn property="recruitment_district"
                                      title="${message(code: 'company.name.label', default: 'District')}"/>
                    <g:sortableColumn property="loan_group"
                                      title="${message(code: 'company.name.label', default: 'Loan Group')}"/>

                    <th>Frequencies</th>
                    <th>Loan Points</th>
                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${userList}" status="i" var="userInstance">
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
                            <g:if test="${userInstance.district_id}">
                                <g:link controller="user" action="index"
                                        params="[district: userInstance?.district_id?.id]">${fieldValue(bean: userInstance, field: "district_id.name")}</g:link>

                            </g:if>
                            <g:else>
                                ${fieldValue(bean: userInstance, field: "recruitment_district.name")}
                            </g:else></td>

                        <td>
                                ${fieldValue(bean: userInstance, field: "loan_group.code")} - Max (${fieldValue(bean: userInstance, field: "loan_group.end_range")})

                        </td>

                        <td>${loans.LoanRequest.countByUser_idAndLoan_status(userInstance,2)}</td>


                        <td>${fieldValue(bean: userInstance, field: "loan_points")}</td>

                        <td class="text-center">

                            <g:link class="create" action="show" id="${userInstance.id}"
                                    resource="${this.userInstance}"><button class="btn btn-primary">Details <i
                                    class="icon-arrow-right14 position-right"></i></button></g:link>

                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
            <g:if test="${userCount > 10}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${userCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>

    </div>
</div>
</body>
</html>