<%@ page import="loans.LoanRequest" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'region.label', default: 'Region')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>


</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-title"><g:link class="list" action="index">
            <h4 class="panel-title"><i class="position-left"></i> <span
                    class="text-semibold">${region.name}</span> Profile</h4></g:link>
        </div>

        <div id="show-region" class="content scaffold-show" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <div class=" container-fluid text-center">
                <div class="row">

                    <div class="col-md-6">

                        <!-- Members online -->
                        <div class="panel bg-success-400">
                            <div class="panel-body">

                                <h3 class="no-margin">
                                    ${admin.District.countByRegion_idAndD_deleted(region,false)}
                                </h3>
                                Total Districts
                            </div>

                        </div>
                        <!-- /members online -->

                    </div>
                    <g:link controller="user" action="index" params="[region:region.id]">
                    <div class="col-md-6">

                        <!-- Members online -->
                        <div class="panel bg-danger-400">
                            <div class="panel-body">

                                <div class="heading-elements">
                                    <span class="heading-text badge bg-teal-800">Read more..</span>
                                </div>

                                <h3 class="no-margin">
                                    ${kopafasta.SecUser.executeQuery("from SecUser where district_id.region_id=?",[region]).size()}
                                </h3>
                                Total Artists
                            </div>

                        </div>
                        <!-- /members online -->

                    </div>
                    </g:link>


                </div>
            </div>


            <div class="col-lg-12">

                <div class="panel table-responsive">
                    <table class="table text-nowrap">

                        <tr>
                            <td colspan="2"><h5>
                                <span class="label border-left-info label-striped">General information</span>
                            </h5></td>
                        </tr>


                        <tr>
                            <td>
                                <span class="text-semibold">Region Name</span>
                            </td>
                            <td>${region.name}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Code</span>
                            </td>
                            <td>${region.code}</td>
                        </tr>

                        <tr>
                            <td>
                        <span class="text-semibold"><g:link class="create" action="printPDF" id="${region.id}" target="_blank"><button type="button" class="btn bg-info-300 btn-labeled"><b><i class="icon-file-pdf"></i></b> Print PDF</button></g:link>
                                </span>
                            </td>
                            <td>

                                <g:link class="create" action="printEXCEL" id="${region.id}" target="_blank"><button type="button" class="btn bg-success-300 btn-warning"><b><i class="icon-file-excel"></i></b> Print EXCEL</button></g:link>


                            </td>
                        </tr>

                    </table>
                </div>
            </div>

            <div class=" container-fluid text-center">
                <div class="row">



                    <div class="col-md-6">

                        <!-- Members online -->
                        <div class="panel bg-brown-400">
                            <div class="panel-body">

                                <h3 class="no-margin">
                                    ${formatAmountString(name:loans.LoanRequest.executeQuery("from LoanRequest where loan_status=2 and user_id.district_id.region_id=?",[region]).size())}

                                    <%
                                        def amountReq=loans.LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and user_id.district_id.region_id=?",[region])[0]
                                        if(!amountReq){
                                            amountReq=0
                                        }
                                        %>

                                    (${formatAmountString(name:(int)amountReq)} TZS)

                                </h3>
                                Loan request
                                <div class="text-muted text-size-small">
                                <%
                                    def amountRepayed=loans.LoanRepayment.executeQuery("from LoanRequest where user_id.district_id.region_id=?",[region]).size()
                                    %>
                                ${formatAmountString(name:amountRepayed)} repayment

                            </div>
                                </div>

                        </div>
                        <!-- /members online -->

                    </div>


                </div>
            </div>


            <div class="col-lg-5">

                <!-- Sales stats -->
                <div class="panel panel-flat">
                    <div class="panel-heading">
                        <span class="label border-left-info label-striped">Loan by category</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <table class="table datatable-basic">

                            <g:each in="${loans.LoanRequest.executeQuery("select count(amount),amount from LoanRequest where loan_status=2 and user_id.district_id.region_id=? group by amount",[region])}" var="paymentInstance">
                                <tr><td>${formatAmountString(name:(int)paymentInstance[1])} TZS</td><td>
                                    <span class="badge badge-info">${paymentInstance[0]}</span>
                                </td></tr>
                            </g:each>


                        </table>
                    </div>
                </div>
            </div>



        </div>
    </div>
</div>
</body>
</html>
