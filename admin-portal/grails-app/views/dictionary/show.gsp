<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'dictionary.label', default: 'Dictionary')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">

        <div class="center panel_div_list panel">
            <div class="page-title"><g:link class="list" action="index">
                <h4 class="panel-title"><i class="position-left"></i> <span
                        class="text-semibold">${dictionary.code}</span> Dictionary</h4></g:link>
            </div>
        <a href="#show-dictionary" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
            </ul>
        </div>
        <div id="show-dictionary" class="content scaffold-show" role="main">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:display bean="dictionary" />
           %{-- <g:form resource="${this.dictionary}" method="DELETE">
                <fieldset class="buttons">
                    <g:link class="edit" action="edit" resource="${this.dictionary}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                </fieldset>
            </g:form>--}%
        </div>
        </div>
    </div>
    </body>
</html>
