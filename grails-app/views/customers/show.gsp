<%@ page import="finance.SecUser; loans.LoanRequest" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'customers.label', default: 'Customers')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">
        <a href="#show-customers" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                                        default="Skip to content&hellip;"/></a>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="list" action="index"><g:message code="default.list.label"
                                                                   args="[entityName]"/></g:link></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                                      args="[entityName]"/></g:link></li>
            </ul>
        </div>

        <div id="show-customers" class="content scaffold-show" role="main">
        %{--
                    <h1><g:message code="default.show.label" args="[entityName]" /></h1>
        --}%
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
        %{--
                    <f:display bean="customers" />
        --}%

            <div class="card_user" style="width: 80%;margin-right: auto;margin-left: auto">

                <div class="container-fluid" style="margin-top: 30px">
                    <div class="row">

                        <div class="col-lg-4">

                            <!-- Members online -->
                            <div class="panel bg-success-400">
                                <div class="panel-body">
                                    <h3 class="no-margin">
                                        <%
                                            def totalAmountData = 0;
                                            try {
                                                if(customers.loan_type.code=="IDLOAN") {
                                                    totalAmountData = loans.LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and customer_id=:customer ", [customer:customers])[0]

                                                }else {
                                                    totalAmountData = loans.LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and customer_id=:customer and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE)", [customer:customers])[0]

                                                }
                                                if (!totalAmountData) {
                                                    totalAmountData = 0
                                                }
                                            } catch (Exception e) {
                                                e.printStackTrace();

                                            }
                                        %>
                                        ${formatAmountString(name: (int) totalAmountData)} TZS
                                    </h3>
                                    Jumla
                                    <div class="text-muted text-size-small">
                                        <g:if test="${customers.loan_type.code=="IDLOAN"}">
                                            ${LoanRequest.executeQuery("from LoanRequest where  loan_status=2 and customer_id=:customer  ", [customer:customers]).size()}

                                        </g:if>
                                        <g:else>
                                            ${LoanRequest.executeQuery("from LoanRequest where  loan_status=2 and customer_id=:customer and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE)  ", [customer:customers]).size()}

                                        </g:else>
                                    </div>
                                </div>

                            </div>
                            <!-- /members online -->

                        </div>


                        <div class="col-lg-4">

                            <!-- Members online -->
                            <div class="panel bg-danger-400">
                                <div class="panel-body">

                                    <%
                                        def totalAmount = SecUser.executeQuery("select sum (loan_amount) from SecUser where have_loan=true and user_group=:customer", [customer:customers])[0]

                                        if (!totalAmount) {
                                            totalAmount = 0
                                        }

                                    %>

                                    <h3 class="no-margin">
                                        ${formatAmountString(name: (int) totalAmount)}

                                    </h3>
                                    Inayodaiwa
                                    <div class="text-muted text-size-small">
                                        na ${formatAmountString(name: (int) SecUser.executeQuery(" from SecUser where have_loan=true and user_group=:customer", [customer:customers]).size())} artists

                                    </div>

                                </div>

                            </div>
                            <!-- /members online -->

                        </div>
                    </div>
                </div>

                <div class="panel table-responsive">

                    <table class="table text-nowrap">
                        <tr>
                            <td colspan="2"><h5>
                                <span class="text-bold">Customer informations</span>
                            </h5></td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Customer Name</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "name")}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Code</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "code")}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Contacts</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "contacts")}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">CEO Email</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "ceo_email")}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Accountant Email</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "accountant_email")}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">HR Email</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "hr_email")}</td>
                        </tr>


                        <tr>
                            <td>
                                <span class="text-semibold">Loan type</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "loan_type.name")}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Loan allowed</span>
                            </td>
                            <td>${fieldValue(bean: customers, field: "loan_allowed")}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Beneficiary No</span>
                            </td>
                            <td>${SecUser.countByUser_group(customers)}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Loan requested</span>
                            </td>
                            <td>${LoanRequest.countByCustomer_id(customers)}</td>
                        </tr>


                        <tr>
                            <td>
                                <span class="text-semibold">Loan allowed</span>
                            </td>
                            <td>${customers.loan_allowed}</td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Members</span>
                            </td>
                            <td>
                                <g:link class="create" controller="secUser" action="usersByCustomer" id="${customers.id}"><button type="button"
                                                                                                          class="btn bg-indigo-400 btn-labeled"><b><i
                                            class="icon-file-excel"></i></b> MEMBERS LIST</button></g:link>

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Print wanaodaiwa</span>
                            </td>
                            <td><g:link class="create" action="printLoanCsv" id="${customers.id}"><button type="button"
                                                                                                          class="btn bg-success-400 btn-labeled"><b><i
                                        class="icon-file-excel"></i></b> PRINT CSV</button></g:link></td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Upload waliolipa</span>
                            </td>
                            <td>${LoanRequest.countByCustomer_id(customers)}</td>
                        </tr>
                    </table>
                </div>
            </div>

        </div>




        <div id="create-loanRequest" class="content scaffold-create" role="main">
            <g:if test="${flash.message}">
                <div class="message alert-success alert-styled-left alert-arrow-left alert-bordered" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.customers}">
                <ul class="errors" role="alert">
                    <g:eachError bean="${this.customers}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
                </ul>
            </g:hasErrors>

            <div class="col-lg-12">
            <g:form  method="POST" controller="customers" action="sendBulkMessages" class="form-horizontal">
                <fieldset class="form">


                    <div class="col-lg-12">


                        <div class="form-group">
                            <label class="control-label col-lg-2">Message </label>
                            <div class="col-lg-8">
                                <textarea type="text" required="required" name="message"  class="form-control"  value="${params?.message}">${params?.message}</textarea>
                            </div>
                        </div>
                        <g:hiddenField name="company_id" value="${customers.id}"/>


                        <div class="text-right col-lg-10">
                            <button type="submit" class="btn btn-primary">Send Messages <i class="icon-arrow-right14 position-right"></i>
                            </button>

                        </div>
                    </div>
                </fieldset>
            </g:form>
            <table>
                <tr><td class="text-bold">CODE</td><td class="text-bold">Description</td></tr>
                <tr><td>{fName}</td><td>Full Name</td></tr>
                <tr><td>{regNo}</td><td>Registration number</td></tr>
                <tr><td>{company}</td><td>Company Name</td></tr>
                <tr><td>{mobile}</td><td>Phone number</td></tr>

            </table>


</div>

            <g:form resource="${this.customers}" method="DELETE">
                <fieldset class="buttons">
                    <g:link class="edit" action="edit" resource="${this.customers}"><g:message
                            code="default.button.edit.label" default="Edit"/></g:link>
                    %{--
                                                     <input class="delete" type="submit"
                                                            value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                                                            onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
                    --}%
                </fieldset>
            </g:form>


        </div>
</div>
</body>
</html>
