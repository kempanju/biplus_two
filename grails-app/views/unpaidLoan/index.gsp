<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'unpaidLoan.label', default: 'UnpaidLoan')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>

<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <a href="/"><i class="icon-arrow-left52 position-left"></i>
                        <span class="text-semibold">Unpaid Loan list</span></a>
                </h5>
            </div>
        </div>
        %{-- <a href="#list-unpaidLoan" class="skip" tabindex="-1"><g:message code="default.link.skip.label"
                                                                          default="Skip to content&hellip;"/></a>

         <div class="nav" role="navigation">
             <ul>
                 <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                 <li><g:link class="create" action="create"><g:message code="default.new.label"
                                                                       args="[entityName]"/></g:link></li>
             </ul>
         </div>--}%

        <div id="list-unpaidLoan" class="content scaffold-list" role="main">
        %{--
                        <h1><g:message code="default.list.label" args="[entityName]"/></h1>
        --}%
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
%{--
            <f:table collection="${unpaidLoanList}"/>
--}%

            <table class="table datatable-basic">
                <thead>
                <tr>
                    <g:sortableColumn property="id"
                                      title="${message(code: 'comapny.name.email', default: 'No')}"/>

                    <g:sortableColumn property="user_id"
                                      title="${message(code: 'company.name.label', default: 'Name')}"/>


                    <g:sortableColumn property="amount_to_pay"
                                      title="${message(code: 'company.name.label', default: 'Amount To Pay')}"/>

                    <g:sortableColumn property=" user_id.loan_amount"
                                      title="${message(code: 'company.name.label', default: 'Remained')}"/>



                    <g:sortableColumn property="days_passed"
                                      title="${message(code: 'company.name.label', default: 'Days passed')}"/>
                    <th class="text-center">Actions</th>

                </tr>
                </thead>
                <tbody>
                <g:each in="${unpaidLoanList}" status="i" var="unpaidInstance">
                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                        <td>
                            <% def offset = 0
                            if (params.offset) {
                                offset = Integer.parseInt(params.offset)
                            }
                            %>
                            ${i + 1 + offset}

                        </td>

                        <td>
                            <g:link class="create" controller="secUser" action="show" id="${unpaidInstance?.user_id?.id}"
                                    resource="${this.unpaidInstance?.user_id}">
                                ${fieldValue(bean: unpaidInstance, field: "user_id.full_name")}
                            </g:link>
                        </td>
                        <td>
                            ${fieldValue(bean: unpaidInstance, field: "amount_to_pay")}
                        </td>
                        <td>

                            ${fieldValue(bean: unpaidInstance, field: "user_id.loan_amount")}

                        </td>
                        <td>
                            ${fieldValue(bean: unpaidInstance, field: "days_passed")}
                        </td>

                        <td class="text-center">

                            <g:link class="create" controller="loanRequest" action="show" id="${unpaidInstance.parent_loan.id}"
                                    resource="${this.unpaidInstance}"><button class="btn btn-primary">Details <i
                                    class="icon-arrow-right14 position-right"></i></button></g:link>

                        </td>

                    </tr>
                </g:each>
                </tbody>
            </table>
            <g:if test="${unpaidLoanCount > 10}">
                <div class="col-md-10 text-center" style="margin-top: 20px">
                    <div class="pagination">
                        <g:paginate total="${unpaidLoanCount ?: 0}"/>
                    </div>
                </div>
            </g:if>
        </div>
    </div>

    <div class="col-lg-12 center panel panel-body">

        <g:form method="POST" action="messagesUnPaidUser" class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-lg-2">Message</label>

                <div class="col-lg-8">
                    <textarea type="text" required="required" name="message"
                              class="form-control"
                              value="${params?.message}">${params?.message}</textarea>
                </div>
            </div>


            <div class="form-group">
                <label class="control-label col-lg-2">Days</label>

                <div class="col-lg-5">
                    <input type="text" required="required" name="daysdata"
                              class="form-control"
                              value="100"/>
                </div>
            </div>



            <div class="text-right col-lg-10">
                <button type="submit" class="btn btn-primary">Send Message <i
                        class="icon-arrow-right14 position-right"></i>
                </button>

            </div>
        </g:form>

        <table>
            <tr><td class="text-bold">CODE</td><td class="text-bold">Description</td></tr>
            <tr><td>{fName}</td><td>Full Name</td></tr>
            <tr><td>{regNo}</td><td>Registration number</td></tr>
            <tr><td>{cDate}</td><td>Request date</td></tr>
            <tr><td>{EDate}</td><td>End return date</td></tr>
            <tr><td>{amount}</td><td>Amount requested</td></tr>
            <tr><td>{tAmount}</td><td>Total Amount to pay</td></tr>
            <tr><td>{instalment}</td><td>Instalment of payments</td></tr>

            <tr><td>{debtsAmount}</td><td>Kiasi anadaiwa kwa tarehe ya leo</td></tr>

        </table>
    </div>
</div>
</body>
</html>