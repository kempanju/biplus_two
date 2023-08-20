<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'customers.label', default: 'Customers')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <i class="icon-arrow-left52 position-left"></i> <span class="text-semibold">Add Customer</span>
                </h5>
            </div>
        </div>
        <a href="#create-customers" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                                          default="Skip to content&hellip;"/></a>

      %{--  <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="default.list.label"
                                                                   args="[entityName]"/></g:link></li>
            </ul>
        </div>--}%

        <div id="create-customers" class="content scaffold-create" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.customers}">
                <ul class="errors" role="alert">
                    <g:eachError bean="${this.customers}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                error="${error}"/></li>
                    </g:eachError>
                </ul>
            </g:hasErrors>
            <g:form resource="${this.customers}" method="POST" class="form-horizontal">
            %{--  <fieldset class="form">
                  <f:all bean="customers"/>
              </fieldset>
              <fieldset class="buttons">
                  <g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" />
              </fieldset>--}%

                    <g:render template="form" bean="customers"/>
                    <div class="text-right col-lg-10">
                        <button type="submit" class="btn btn-primary">Save <i
                                class="icon-arrow-right14 position-right"></i>
                        </button>

                    </div>
            </g:form>
        </div>
    </div>
</div>
</body>
</html>
