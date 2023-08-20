<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'paymentConfig.label', default: 'PaymentConfig')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list">
        <div class="page-header-content">
            <div class="page-title">
                <h5>

                    <i class="icon-arrow-left52 position-left"></i> <span
                        class="text-semibold">Admin Configuration</span>
                </h5>
            </div>

            <div class="heading-elements">

            </div>

        </div>

        <div id="list-paymentConfig" class="content scaffold-list" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id" title="${message(code: 'employee.name.email', default: 'No')}"/>
                    <g:sortableColumn property="mlipa_code"
                                      title="${message(code: 'employee.name.label', default: 'MPESA Code')}"/>
                    <g:sortableColumn property="card_expired_years"
                                      title="${message(code: 'employee.name.label', default: 'Card Years Limit')}"/>
                    <g:sortableColumn property="card_cost"
                                      title="${message(code: 'employee.name.label', default: 'Insurance Cost')}"/>
                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${paymentConfigList}" status="i" var="paymentConfigListInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                        <td>${i + 1}</td>
                        <td>${fieldValue(bean: paymentConfigListInstance, field: "mlipa_code")}</td>
                        <td>${fieldValue(bean: paymentConfigListInstance, field: "card_expired_years")}</td>
                        <td>${fieldValue(bean: paymentConfigListInstance, field: "kopafasta_fee")}</td>

                        <td class="text-center">


                            <sec:ifAnyGranted roles="ROLE_ADMIN">
                                <g:link class="create" action="edit" id="${paymentConfigListInstance.id}"
                                        resource="${this.paymentConfigListInstance}"><button class="btn btn-primary">Update <i
                                        class="icon-arrow-right14 position-right"></i></button></g:link>
                            </sec:ifAnyGranted>

                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </table>


        </div>
    </div>
</div>
</body>
</html>