<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'paymentConfig.label', default: 'PaymentConfig')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>
    <div class="register_dv expert">

        <div class="center panel_div_list">
        <a href="#edit-paymentConfig" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
            </ul>
        </div>
        <div id="edit-paymentConfig" class="content scaffold-edit" role="main">
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.paymentConfig}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.paymentConfig}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>
            <g:form resource="${this.paymentConfig}" method="PUT" class="form-horizontal">
                <g:hiddenField name="version" value="${this.paymentConfig?.version}" />
                <fieldset class="form">
                    <g:render template="form" bean="associations"/>
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
