<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cardPayments.label', default: 'CardPayments')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">
    <div class="center panel_div_list">
        <div class="page-title">
            <h5>
                <g:link class="create" controller="cardPayments" action="index" id="${cardPayments.id}">
                    <i class="icon-arrow-left52 position-left"></i> <span
                        class="text-semibold">Issued Card details</span></g:link>
            </h5>
        </div>

        <div id="show-cardPayments" class="content scaffold-show" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:display bean="cardPayments"/>

        </div>
    </div>
</div>
</body>
</html>
