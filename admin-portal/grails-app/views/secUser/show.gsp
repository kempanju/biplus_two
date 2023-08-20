<%@ page import="loans.UserLoan; finance.SecRole; finance.SecUserSecRole; finance.SecUser; loans.LoanRequest" %>
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
<g:link controller="secUser" action="index" resource="${this.secUser}"><i
        class="icon-arrow-left52 position-left"></i> ${secUser.full_name} <span
        class="text-semibold">Details</span></g:link>
</h5>
</div>
<sec:ifLoggedIn>
    <g:if test="${secUser.id == Long.parseLong(sec.loggedInUserInfo(field: 'id').toString())}">

        <ul class="breadcrumb-elements">

            <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <i class="icon-gear position-left"></i>
                    Edit Product
                    <span class="caret"></span>
                </a>

                <ul class="dropdown-menu dropdown-menu-right">

                    <li><g:link class="edit" controller="secUser" action="edit"
                                resource="${this.secUser}"><i
                                class="icon-secUser-lock"></i> Edit Profile</g:link></li>
                    <li><a href="#" onclick="showUploadIconDialog()"><i
                            class="icon-statistics"></i>Profile Picture</a></li>
                    <li><a href="#" onclick="showUploadIconDialogSignature()"><i
                            class="icon-statistics"></i>Upload signature</a></li>
                    <li class="divider"></li>
                    <li><a href="#"><i class="icon-gear"></i> All settings</a></li>
                </ul>
            </li>
        </ul>
    </g:if>
    <g:else>
        <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_DATA">
            <ul class="breadcrumb-elements">

                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="icon-gear position-left"></i>
                        Edit User
                        <span class="caret"></span>
                    </a>

                    <ul class="dropdown-menu dropdown-menu-right">
                        %{--<g:if >
                            <li><g:link class="edit" controller="secUser" action="editAgent"
                                        resource="${this.secUser}"><i
                                        class="icon-secUser-lock"></i> Edit Profile</g:link></li>
                        </g:if>
                        <g:else>--}%
                        <li><g:link class="edit" controller="secUser" action="edit"
                                    resource="${this.secUser}"><i
                                    class="icon-secUser-lock"></i> Edit Profile</g:link></li>
                        <li><a href="#" onclick="showUploadIconDialog()"><i
                                class="icon-statistics"></i>Profile Picture</a></li>
                        <li><a href="#" onclick="showUploadIconDialogSignature()"><i
                                class="icon-statistics"></i>Upload signature</a></li>
                        <li class="divider"></li>
                        <li><a href="#" onclick="addRole()"><i class="icon-gear"></i> Add Role</a></li>

                    </ul>
                </li>
            </ul>
        </sec:ifAnyGranted>
        <sec:ifAnyGranted roles="ROLE_DATA">
            <ul class="breadcrumb-elements">
                <li>
                    <div class="col-md-4" style="margin: 10px">
                        <g:link class="create" controller="secUser" action="edit" id="${secUser.id}">
                            <button type="button" class="btn btn-default"><i
                                    class="icon-database-edit2 position-left"></i> Edit Account
                            </button></g:link>
                    </div></li>
            </ul>
        </sec:ifAnyGranted>

    </g:else>
</sec:ifLoggedIn>
</div>

</div>

<div class="content panel">
<div class="panel-secUser card_user" style="text-align: center">
    <div class="table_div">
        <div class="div_half" style="width: 65%">
<g:if test="${flash.message}">
    <div class="message alert alert-success alert-styled-left alert-arrow-left alert-bordered"
         role="status">${flash.message}</div>
</g:if>
<table>
    <tr>
        <td>
            <img class="img-thumbnail img-responsive" width="140px"
                 src="${imagePathsProfile(name: secUser.recent_photo)}"/>

        </td>
        <td colspan="2">
            <table>
                <tr><td>${secUser.full_name}</td></tr>
                <tr><td><span class="date_color">@${secUser.username}</span></td></tr>
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
    %{--<g:if test="${secUser.user_group.code != "AGENT"}">
        <div class="row">

            <div class="col-lg-6">

                <g:link class="create" controller="cardPayments" action="cardByUser"
                        id="${secUser.id}">
                    <!-- Members online -->
                    <div class="panel bg-teal-400">
                        <div class="panel-body">
                            <div class="heading-elements">
                                <span class="heading-text badge bg-teal-800">Read more</span>
                            </div>

                            <h3 class="no-margin">
                                ${loans.LoanRequest.executeQuery("from LoanRequest where user_id=:userInstance ", [userInstance:secUser]).size()}

                            </h3>
                            Loan request

                            <div class="text-muted text-size-small">
                                ${loans.CardPayments.countByUser_id(secUser)}
                                Payments
                            </div>

                        </div>

                    </div>
                </g:link>
            <!-- /members online -->

            </div>

            <div class="col-lg-6">
                <g:link class="create" controller="userLogs" action="logsByUser"
                        id="${secUser.id}">
                    <!-- Members online -->
                    <div class="panel bg-success-400">
                        <div class="panel-body">
                            <div class="heading-elements">
                                <span class="heading-text badge bg-teal-800">Read more</span>
                            </div>

                            <h3 class="no-margin">
                                ${kopafasta.UserLogs.executeQuery("from UserLogs where user_id=:userInstance ", [userInstance:secUser]).size()}

                            </h3>
                            Logs SMS
                            <div class="text-muted text-size-small">
                                ${formatAmountString(name: (int) secUser.loan_points)}
                                Loan points
                            </div>

                        </div>

                    </div>
                </g:link>
            <!-- /members online -->

            </div>
        </div>
    </g:if>--}%
    <div class="row">

        <div class="col-lg-6">

            <%

                def userLoanInstance = UserLoan.findByUser(secUser)

            %>

            <g:link class="create" controller="loanRepayment" action="loanByUser"
                    id="${secUser.id}">
                <!-- Members online -->
                <div class="panel bg-teal-400">
                    <div class="panel-body">
                        <div class="heading-elements">
                            <span class="heading-text badge bg-teal-800">Read more</span>
                        </div>

                        <h3 class="no-margin">
                           <g:if test="${userLoanInstance&&userLoanInstance.loan_amount != null}"> ${formatAmountString(name: (int) userLoanInstance?.unpaidLoan)} </g:if> <g:else>0</g:else>

                        </h3>
                        Not returned Loan

                        <div class="text-muted text-size-small">

                        <g:if test="${userLoanInstance&&userLoanInstance.loan_amount != null}"> ${formatAmountString(name: (int) userLoanInstance?.loan_amount)} </g:if><g:else>0</g:else>
                            Loan Taken
                        </div>

                    </div>

                </div>
            </g:link>
        <!-- /members online -->

        </div>

        <div class="col-lg-6">
            <g:link class="create" controller="userLogs" action="logsByUser"
                    id="${secUser.id}">
                <!-- Members online -->
                <div class="panel bg-success-400">
                    <div class="panel-body">
                        <div class="heading-elements">
                            <span class="heading-text badge bg-teal-800">Read more</span>
                        </div>

                        <h3 class="no-margin">
                           0

                        </h3>
                        Profit

                    </div>

                </div>
            </g:link>
        <!-- /members online -->

        </div>
    </div>
</div>

<div class="col-lg-12">

    <div class="col-lg-6">

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
${secUser.full_name}
</td>
</tr>


<g:if test="${secUser.gender}">

    <tr>
        <td colspan="2">
            <span class="text-semibold">Gender</span>
        </td>
        <td colspan="2">${secUser?.gender}</td>
    </tr>
</g:if>
<tr>
    <td colspan="2">
        <span class="text-semibold">Employee Number</span>
    </td>
    <td colspan="2" class="numbers">${secUser?.registration_no}</td>
</tr>
<g:if test="${secUser.phone_number}">

    <tr>
        <td colspan="2">
            <span class="text-semibold">Phone Number</span>
        </td>
        <td colspan="2">${secUser?.phone_number}</td>
    </tr>
</g:if>

    <g:if test="${secUser.phone_number}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">Phone Number</span>
            </td>
            <td colspan="2">${secUser?.phone_number}</td>
        </tr>
    </g:if>

    <g:if test="${secUser.user_group}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">Organization</span>
            </td>
            <td colspan="2">${secUser?.user_group.name}</td>
        </tr>
    </g:if>
    <g:if test="${secUser.description}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">Description</span>
            </td>
            <td colspan="2" class="numbers">${secUser?.description}</td>
        </tr>
    </g:if>
    <g:if test="${secUser.national_id}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">National ID</span>
            </td>
            <td colspan="2">${secUser?.national_id}</td>
        </tr>
    </g:if>

    <g:if test="${secUser.salary}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">Salary</span>
            </td>
            <td colspan="2" class="numbers">${secUser?.salary}</td>
        </tr>
    </g:if>
    <g:if test="${secUser.loan_limit}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">Loan Limit</span>
            </td>
            <td colspan="2" class="numbers">${secUser?.loan_limit}</td>
        </tr>
    </g:if>
    <g:if test="${secUser.birth_district_id}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">Birth District</span>
            </td>
            <td colspan="2">
                <g:link class="edit" controller="district" action="show"
                        resource="${secUser.birth_district_id}">
                    ${secUser?.birth_district_id?.name}</g:link></td>
        </tr>
    </g:if>
    <g:if test="${secUser.birth_ward}">
        <tr>
            <td colspan="2">
                <span class="text-semibold">Birth Ward</span>
            </td>
            <td colspan="2">${secUser?.birth_ward?.name}</td>
        </tr>
    </g:if>


    <g:if test="${secUser.ward}">
        <tr>
            <td colspan="2">
                <span class="text-semibold">Ward</span>
            </td>
            <td colspan="2">${secUser?.ward?.name}</td>
        </tr>
    </g:if>


    <g:if test="${secUser.district_id}">

        <tr>
            <td colspan="2">
                <span class="text-semibold">District</span>
            </td>
            <td colspan="2">
                <g:link class="edit" controller="district" action="show"
                        resource="${secUser.district_id}">
                    ${secUser?.district_id?.name}</g:link></td>
        </tr>
    </g:if>

    <g:if test="${secUser.ward}">
        <tr>
            <td colspan="2">
                <span class="text-semibold">Ward</span>
            </td>
            <td colspan="2">${secUser?.ward?.name}</td>
        </tr>
    </g:if>
    <g:if test="${secUser.village}">
        <tr>
            <td colspan="2">
                <span class="text-semibold">Kijiji</span>
            </td>
            <td colspan="2">${secUser?.village}</td>
        </tr>
    </g:if>

%{-- <g:if test="${secUser?.user_group.code == "AGENT"}">

     <tr>
         <td colspan="2">
             <span class="text-semibold">Agent Type</span>
         </td>
         <td colspan="2">
             ${fieldValue(bean: secUser, field: "agent_type.name")}
         </td>
     </tr>


     <tr>
         <td colspan="2">
             <span class="text-semibold">Float Amount</span>
         </td>
         <td colspan="2">
             ${fieldValue(bean: secUser, field: "agent_float_amount")} TZS
         </td>
     </tr>
 </g:if>
--}%


    <g:if test="${secUser.created_at}">
        <tr>
            <td colspan="2">
                <span class="text-semibold">Added At</span>
            </td>
            <td colspan="2">
                <g:formatDate format="dd-MMM-yyyy hh:mm a" date="${secUser.created_at}"/>

            </td>
        </tr>
    </g:if>

    </table>
</div>
</div>

    <div class="col-lg-6">
        <table class="table text-nowrap">

        <tr>
            <g:if test="${secUser.national_id}">

                <td colspan="2"><h5>
                    <span class="text-bold">Nationa ID information</span>
                </h5></td>
            </g:if>
            <g:if test="${secUser.national_id}">

                <tr>
                    <td colspan="2">
                        <span class="text-semibold">National ID</span>
                    </td>
                    <td colspan="2">${secUser?.national_id}</td>
                </tr>
            </g:if>
            <g:if test="${secUser.national_id_name}">

                <tr>
                    <td colspan="2">
                        <span class="text-semibold">National ID Name</span>
                    </td>
                    <td colspan="2">${secUser?.national_id_name}</td>
                </tr>
            </g:if>
            <g:if test="${secUser.national_id}">

                <tr>
                    <td colspan="2">
                        <span class="text-semibold">National ID Photo</span>
                    </td>
                    <td colspan="2">

                        <img class="img-thumbnail img-responsive" width="140px"
                             src="${imagePathsProfile(name: secUser.national_id_copy_path)}"/>

                    </td>
                </tr>
            </g:if>


            <tr>
                <td colspan="2"><h5>
                    <span class="text-bold">User logs</span>
                </h5></td>

                <td colspan="2">
                    <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD">

                        <div class="col-md-4">
                            <g:link class="create" controller="userLogs" action="logsByUser"
                                    id="${secUser.id}">
                                <button type="button" class="btn btn-info"><i
                                        class="icon-list position-left"></i> Logs list</button></g:link>
                        </div>
                    </sec:ifAnyGranted>

                </td>
            </tr>
            <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD,ROLE_MANAGER">

                <tr>
                    <td colspan="4">
                        <g:form method="POST" action="messagesSingleUser" class="form-horizontal">
                            <g:hiddenField name="id" value="${secUser.id}"/>
                            <g:hiddenField name="phone_number" value="${secUser.phone_number}"/>
                            <div class="form-group">
                                <label class="control-label col-lg-2">Message</label>

                                <div class="col-lg-8">
                                    <textarea type="text" required="required" name="message"
                                              class="form-control"
                                              value="${params?.message}">${params?.message}</textarea>
                                </div>
                            </div>


                            <div class="text-right col-lg-10">
                                <button type="submit" class="btn btn-primary">Send Message <i
                                        class="icon-arrow-right14 position-right"></i>
                                </button>

                            </div>
                        </g:form>

                    </td>

                </tr>

                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    <tr>
                        <td colspan="4">
                            <g:form method="POST" action="changePasswordUser" class="form-horizontal">
                                <g:hiddenField name="id" value="${secUser.id}"/>

                                <div class="form-group">
                                    <label class="control-label col-lg-2">Username</label>

                                    <div class="col-lg-8">

                                        <input class="input" type="text" name="username"
                                               required="required" placeholder="Username"
                                               value="${secUser?.username}">

                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="control-label col-lg-2">Password</label>

                                    <div class="col-lg-8">

                                        <input class="input" type="password" name="newpassword"
                                               required="required" placeholder="Password" value="">

                                    </div>
                                </div>


                                <div class="text-right col-lg-10">
                                    <button type="submit" class="btn btn-danger">Change Password <i
                                            class="icon-arrow-right14 position-right"></i>
                                    </button>

                                </div>
                            </g:form>

                        </td>

                    </tr>
                </sec:ifAnyGranted>

                <g:if test="${SecUserSecRole.countBySecUser(secUser)}">

                    <tr>
                        <td colspan="4"><h5>
                            <span class="text-bold">User roles</span>
                        </h5></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table>
                                <g:each in="${SecUserSecRole.findAllBySecUser(secUser)}"
                                        status="i"
                                        var="roleInstance">
                                    <tr class="${(i % 2) == 0 ? 'even' : 'odd'} ">
                                        <td>${i + 1}</td>
                                        <td>${fieldValue(bean: roleInstance, field: "secRole.authority")}</td>
                                        <td>${fieldValue(bean: roleInstance, field: "secRole.description")}</td>
                                    </tr>
                                </g:each>
                            </table>

                        </td>
                    </tr>
                </g:if>
            </sec:ifAnyGranted>
        </table>
    </div>
    </div>
</div>

</div>

    <div id="dialog" style="display: none" title="Upload Profile Picture">
        <div class="panel-body">

            <g:uploadForm name="myUploadLogo" controller="secUser" action="myUploadLogo">
                <div class="col-lg-8">
                    <input type="file" name="photo"/>
                </div>
                <g:hiddenField name="user_id" value="${secUser.id}"/>
                <div class="text-right col-lg-10" style="margin-top: 20px">
                    <button type="submit" style="margin-left:4px"
                            class="btn btn-primary">Upload Picture <i
                            class="icon-arrow-right14 position-right"></i>
                    </button>
                </div>
            </g:uploadForm>
        </div>
    </div>


    <div id="dialogSignature" style="display: none" title="Upload Signature">
        <div class="panel-body">

            <g:uploadForm name="myUploadLogo" controller="secUser" action="myUploadSignature">
                <div class="col-lg-8">
                    <input type="file" name="signaturephoto"/>
                </div>
                <g:hiddenField name="user_id" value="${secUser.id}"/>
                <div class="text-right col-lg-10" style="margin-top: 20px">
                    <button type="submit" style="margin-left:4px"
                            class="btn btn-primary">Upload Signature <i
                            class="icon-arrow-right14 position-right"></i>
                    </button>
                </div>
            </g:uploadForm>
        </div>
    </div>
    <sec:ifAnyGranted roles="ROLE_ADMIN">

        <div id="dialogrole" style="display: none" title="Add Role To Users">
            <div class="panel-body">

                <g:form controller="secUser" action="addRole" method="POST" class="form-horizontal">
                    <div class="form-group">
                        <label class="control-label col-lg-2">Role</label>


                        <div class="col-lg-8">
                            <g:select name="role_id" id="role_id"
                                      from="${SecRole.all}" optionKey="id" optionValue="authority"
                                      class="form-control select-search" noSelection="['': 'Select Role']"/>

                        </div>
                    </div>
                    <g:hiddenField name="user_id" value="${secUser.id}"/>
                    <div class="text-right col-lg-10" style="margin-top: 20px">
                        <button type="submit" style="margin-left:4px"
                                class="btn btn-primary">Add role <i
                                class="icon-arrow-right14 position-right"></i>
                        </button>
                    </div>
                </g:form>
            </div>
        </div>
    </sec:ifAnyGranted>
    </div>
</div>
</body>
</html>
