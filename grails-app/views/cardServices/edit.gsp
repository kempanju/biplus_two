<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'cardServices.label', default: 'CardServices')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">

        <div class="center panel_div_list panel">

            <div class="page-header-content">
                <div class="page-title">
                    <h5>
                        <g:link controller="cardServices" action="show" id="${cardServices.id}"><i class="icon-arrow-left52 position-left"></i> <span
                                class="text-semibold">Edit card Information</span></g:link>
                    </h5>
                </div>
            </div>

            <a href="#edit-cardServices" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>

        <div id="edit-cardServices" class="content scaffold-edit" role="main">
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.cardServices}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.cardServices}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>
            <g:form resource="${this.cardServices}" method="PUT" class="form-horizontal">
                <g:hiddenField name="version" value="${this.cardServices?.version}" />
                <fieldset class="form">
                    <g:render template="form" bean="cardServices"/>
                    <div class="text-right col-lg-10">
                        <button type="submit" class="btn btn-primary">Update <i
                                class="icon-arrow-right14 position-right"></i>
                        </button>

                    </div>
                </fieldset>
            </g:form>
        </div>
        </div>
    </div>
    </body>
</html>
