<%@ page import="com.softhama.loans.UserLoan" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'secUser.label', default: 'User')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
    <script>
        function showUploadIconDialog() {
            $(function () {
                $("#dialog").dialog({
                    width: "30%",
                    maxWidth: "500px"
                });
            });
        }

        function showUploadIconDialogSignature() {
            $(function () {
                $("#dialogSignature").dialog({
                    width: "30%",
                    maxWidth: "500px"
                });
            });
        }


        function addRole() {
            $(function () {
                $("#dialogrole").dialog({
                    width: "30%",
                    maxWidth: "500px"
                });
            });
        }

    </script>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header">
            <div class="breadcrumb-line">

                <div class="page-title">
                    <h5>
                        <g:link controller="secUser" action="index" resource="${this.employee}"><i
                                class="icon-arrow-left52 position-left"></i> ${employee.full_name} <span
                                class="text-semibold">Details</span></g:link>
                    </h5>
                </div>

            </div>

        </div>

        <div class="content panel">
            <div class="panel-secUser card_user" style="text-align: center">
                <div class="table_div">
                    <div class="div_halfz" style="width: 100%">
                        <g:if test="${flash.message}">
                            <div class="message alert alert-success alert-styled-left alert-arrow-left alert-bordered"
                                 role="status">${flash.message}</div>
                        </g:if>
                        <table>
                            <tr>
                                <td>
                                    <img class="img-thumbnail img-responsive" width="140px"
                                         src="${imagePathsProfile(name: "default_pic.jpg")}"/>

                                </td>
                                <td colspan="2">
                                    <table>
                                        <tr><td>${employee.full_name}</td></tr>
                                        <tr><td><span class="date_color">@${employee.username}</span></td></tr>
                                    </table>

                                </td>
                                %{-- <g:if test="${secUser.user_signature}">
                                     <td>
                                         <img class="img-thumbnail img-responsive" style="width: 200px;height: 120px"
                                              src="${imagePathsProfile(name: secUser.user_signature)}"/>
                                     </td>
                                 </g:if>--}%
                            </tr>

                        </table>
                    </div>

                </div>

                <div class="col-lg-12">

                    <div class="row">

                        <div class="col-lg-8">

                            <%

                                def userLoanInstance = UserLoan.findByUser(employee)

                            %>

                            <g:link class="create" controller="loanRepayment" action="loanByUser"
                                    id="${employee.id}">
                                <!-- Members online -->
                                <div class="panel bg-teal-400">
                                    <div class="panel-body">
                                        <div class="heading-elements">
                                            <span class="heading-text badge bg-teal-800">Read more</span>
                                        </div>

                                        <h3 class="no-margin">
                                            <g:if test="${userLoanInstance && userLoanInstance.loan_amount != null}">${formatAmountString(name: (int) userLoanInstance?.unpaidLoan)}</g:if> <g:else>0</g:else>

                                        </h3>
                                        Not returned Loan

                                        <div class="text-muted text-size-small">

                                            <g:if test="${userLoanInstance && userLoanInstance.loan_amount != null}">${formatAmountString(name: (int) userLoanInstance?.loan_amount)}</g:if><g:else>0</g:else>
                                            Loan Taken
                                        </div>

                                    </div>

                                </div>
                            </g:link>
                        <!-- /members online -->

                        </div>

                    </div>
                </div>

                <div class="col-lg-12">

                    <div class="col-lg-8">

                        <div class="panel table-responsive">
                            <table class="table text-nowrap">

                                <tr>
                                    <td colspan="4"><h5>
                                        <span class="text-bold">General information</span>
                                    </h5></td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <span class="text-semibold">Full Name</span>
                                    </td>
                                    <td colspan="2">
                                        ${employee.full_name}
                                    </td>
                                </tr>


                                <g:if test="${employee.gender}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Gender</span>
                                        </td>
                                        <td colspan="2">${employee?.gender}</td>
                                    </tr>
                                </g:if>
                                <tr>
                                    <td colspan="2">
                                        <span class="text-semibold">Employee Number</span>
                                    </td>
                                    <td colspan="2" class="numbers">${employee?.registration_no}</td>
                                </tr>
                                <g:if test="${employee.phone_number}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Phone Number</span>
                                        </td>
                                        <td colspan="2">${employee?.phone_number}</td>
                                    </tr>
                                </g:if>

                                <g:if test="${employee.phone_number}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Phone Number</span>
                                        </td>
                                        <td colspan="2">${employee?.phone_number}</td>
                                    </tr>
                                </g:if>


                                <g:if test="${employee.description}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Description</span>
                                        </td>
                                        <td colspan="2" class="numbers">${employee?.description}</td>
                                    </tr>
                                </g:if>

                                <g:if test="${employee.salary}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Salary</span>
                                        </td>
                                        <td colspan="2" class="numbers">${employee?.salary}</td>
                                    </tr>
                                </g:if>
                                <g:if test="${employee.loan_limit}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Loan Limit</span>
                                        </td>
                                        <td colspan="2" class="numbers">${employee?.loan_limit}</td>
                                    </tr>
                                </g:if>
                                <g:if test="${employee.birth_district_id}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Birth District</span>
                                        </td>
                                        <td colspan="2">
                                            <g:link class="edit" controller="district" action="show"
                                                    resource="${employee.birth_district_id}">
                                                ${employee?.birth_district_id?.name}</g:link></td>
                                    </tr>
                                </g:if>
                                <g:if test="${employee.birth_ward}">
                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Birth Ward</span>
                                        </td>
                                        <td colspan="2">${employee?.birth_ward?.name}</td>
                                    </tr>
                                </g:if>


                                <g:if test="${employee.ward}">
                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Ward</span>
                                        </td>
                                        <td colspan="2">${secUser?.ward?.name}</td>
                                    </tr>
                                </g:if>


                                <g:if test="${employee.district_id}">

                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">District</span>
                                        </td>
                                        <td colspan="2">
                                            <g:link class="edit" controller="district" action="show"
                                                    resource="${employee.district_id}">
                                                ${employee?.district_id?.name}</g:link></td>
                                    </tr>
                                </g:if>

                                <g:if test="${employee.ward}">
                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Ward</span>
                                        </td>
                                        <td colspan="2">${employee?.ward?.name}</td>
                                    </tr>
                                </g:if>
                                <g:if test="${employee.village}">
                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Kijiji</span>
                                        </td>
                                        <td colspan="2">${employee?.village}</td>
                                    </tr>
                                </g:if>


                                <g:if test="${employee.created_at}">
                                    <tr>
                                        <td colspan="2">
                                            <span class="text-semibold">Added At</span>
                                        </td>
                                        <td colspan="2">
                                            <g:formatDate format="dd-MMM-yyyy hh:mm a" date="${employee.created_at}"/>

                                        </td>
                                    </tr>
                                </g:if>

                            </table>
                        </div>
                    </div>

                </div>
            </div>

        </div>

    </div>
</div>
</body>
</html>
