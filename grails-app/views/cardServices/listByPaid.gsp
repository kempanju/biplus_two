<%@ page import="finance.CardServices" %>
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
                url: '${grailsApplication.config.systemLink.toString()}/cardServices/search_cardlist',
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
                            class="text-semibold">Card Payment list</span> (${cardServicesCount})</a>
                </h5>
            </div>

            <div class="heading-elements">

                <input type="text" value="" name="search_text" class="form-control" onkeyup="cardsSearch(this)" placeholder="Search  card number">

            </div>

        </div>
        <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD,ROLE_MANAGER">
            <div class="col-md-12 text-right">

                    <h3 class="label border-left-info label-striped">Amount:
                    <%
                        Double totalss=0
                        try {
                            totalss = CardServices.executeQuery("select sum (amount_paid) as total from CardServices")[0]

                        }catch (Exception e){
                            //e.printStackTrace()

                        }
                    %>
                    ${formatAmountString(name:(int)totalss)} TZS</h3>

            </div>
        </sec:ifAnyGranted>
        <div id="list-cardServices" class="content scaffold-list" role="main">

            <div class="col-md-12">
                <g:form method="GET" controller="cardServices" action="printReportCard" class="form-horizontal">

                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-lg-3 text-bold">Options</label>


                            <div class="col-lg-7 ">
                                <select name="optionData">
                                    <option value="3">All Paid</option>

                                    <option value="2">Paid not printed</option>
                                    <option value="1">Paid printed</option>
%{--
                                    <option value="3">Paid not Issued</option>
--}%

                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-lg-3 text-bold">From Date</label>


                            <div class="col-lg-7 input-append date form_datetime">
                                <input type="text" name="start_date" readonly required="required" class="form-control"/>
                                <span class="add-on"><i class="icon-th"></i></span>

                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-lg-3 text-bold">To Date</label>

                            <div class="col-lg-7 input-append date form_datetime">
                                <input type="text" name="end_date" readonly required="required" class="form-control"/>
                                <span class="add-on"><i class="icon-th"></i></span>

                            </div>
                        </div>
                    </div>

                    <div class="text-right col-md-3">
                        <button type="submit" class="btn btn-primary">PRINT REPORT <i
                                class="icon-arrow-right14 position-right"></i>
                        </button>

                    </div>
                </g:form>
            </div>
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
                    <g:sortableColumn property="user_id.first_name"
                                      title="${message(code: 'employee.name.label', default: 'Name')}"/>
                    <g:sortableColumn property="card_number"
                                      title="${message(code: 'employee.name.label', default: 'Reference No')}"/>
                    <g:sortableColumn property="amount_paid"
                                      title="${message(code: 'employee.name.label', default: 'Amount')}"/>
                    <g:sortableColumn property="paid_at"
                                      title="${message(code: 'employee.name.category', default: 'Paid Date')}"/>
                    <g:sortableColumn property="issued"
                                      title="${message(code: 'employee.name.category', default: 'Card status')}"/>

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
                                ${fieldValue(bean: cardServicesInstance, field: "user_id.full_name")}
                            </g:link></td>
                        <td>${fieldValue(bean: cardServicesInstance, field: "card_number")}</td>
                        <td>${fieldValue(bean: cardServicesInstance, field: "amount_paid")}</td>
                        <td>
                            <g:formatDate format="dd-MMM-yyyy hh:mm a" date="${cardServicesInstance.paid_at}"/>

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


                            <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD,ROLE_MANAGER">
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
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:mm'});
</script>
</body>
</html>