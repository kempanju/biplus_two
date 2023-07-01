<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'loanGroup.label', default: 'LoanGroup')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <a href="/"><i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Loan group list</span></a>
                </h5>
            </div>

            <div class="heading-elements">

                <div class="col-md-4">
                    <g:link class="create" action="create" id="${params.id}"><button type="button"
                                                                                     class="btn bg-teal-400 btn-labeled"><b><i
                                class="icon-add"></i></b> <g:message code="default.new.label"
                                                                     args="[entityName]"/>
                    </button></g:link>
                </div>
            </div>
        </div>
        <a href="#list-loanGroup" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                                        default="Skip to content&hellip;"/></a>

        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                                      args="[entityName]"/></g:link></li>
            </ul>
        </div>

        <div id="list-loanGroup" class="content scaffold-list" role="main">
%{--
            <h1><g:message code="default.list.label" args="[entityName]"/></h1>
--}%
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:table collection="${loanGroupList}"/>

            <div class="pagination">
                <g:paginate total="${loanGroupCount ?: 0}"/>
            </div>
        </div>
    </div>
</div>
</body>
</html>