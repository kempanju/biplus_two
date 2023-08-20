<%@ page import="finance.SecUser; loans.LoanRepayment; loans.LoanRequest;" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'district.label', default: 'District')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">
        <div class="page-title"><g:link class="list" action="index">
            <h4 class="panel-title"><i class="position-left"></i> <span
                    class="text-semibold">${district.name}</span> Profile</h4></g:link>
        </div>


        <div id="show-district" class="content scaffold-show" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <div class=" container-fluid">
                <div class="row">



                    <g:link controller="user" action="index" params="[district:district.id]">
                        <div class="col-md-4">

                            <!-- Members online -->
                            <div class="panel bg-success-400">
                                <div class="panel-body">

                                    <div class="heading-elements">
                                        <span class="heading-text badge bg-teal-800">Read more..</span>
                                    </div>

                                    <h3 class="no-margin">
                                        ${SecUser.countByDistrict_id(district)}
                                    </h3>
                                    Total Artists
                                </div>

                            </div>
                            <!-- /members online -->

                        </div>
                    </g:link>


                    <div class="col-lg-4">
                        <ul class="list-inline text-center">
                            <g:link class="create" action="printPDF" id="${district.id}" target="_blank"><button
                                    type="button" class="btn bg-info-300 btn-labeled"><b><i class="icon-file-pdf"></i>
                                </b> Print PDF</button></g:link>

                        </ul>

                        <div class="col-lg-10 col-lg-offset-1">
                            <div class="content-group" id="total-onsline"></div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <ul class="list-inline text-center">
                            <g:link class="create" action="printEXCEL" id="${district.id}" target="_blank"><button
                                    type="button" class="btn bg-success-300 btn-warning"><b><i
                                        class="icon-file-excel"></i></b> Print EXCEL</button></g:link>

                        </ul>

                        <div class="col-lg-10 col-lg-offset-1">
                            <div class="content-group" id="total-onslinse"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-12">

                <div class="panel table-responsive">
                    <table class="table text-nowrap">

                        <tr>
                            <td colspan="2"><h5>
                                <span class="text-bold">General information</span>
                            </h5></td>
                        </tr>


                        <tr>
                            <td>
                                <span class="text-semibold">Region Name</span>
                            </td>
                            <td>${district.name}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Code</span>
                            </td>
                            <td>${district.code}</td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Region Name</span>
                            </td>
                            <td>
                                <g:link class="edit" controller="region" action="show"
                                        resource="${district.region_id}">
                                    ${district.region_id.name}</g:link></td>
                        </tr>
                       %{-- <tr>
                            <td>
                                <span class="text-semibold">Country</span>
                            </td>
                            <td class="numbers">${district.region_id.country_id.name}</td>
                        </tr>--}%
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
                                    ${formatAmountString(name:loans.LoanRequest.executeQuery("from LoanRequest where loan_status=2 and user_id.district_id=?",[district]).size())}

                                </h3>
                                Loan request
                                <div class="text-muted text-size-small">
                                    ${formatAmountString(name:loans.LoanRepayment.executeQuery("from LoanRequest where user_id.district_id=?",[district]).size())} repayment

                                </div>
                            </div>

                        </div>
                        <!-- /members online -->

                    </div>


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

                        <g:each in="${LoanRequest.executeQuery("select count(amount),amount from LoanRequest where loan_status=2 and user_id.district_id=? group by amount",[district])}" var="paymentInstance">
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
</body>
</html>
