<%@ page import="org.grails.web.json.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cardServices.label', default: 'CardServices')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list panel">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link action="index">
                        <i class="icon-arrow-left52 position-left"></i> <span
                            class="text-semibold">Card</span>
                    </g:link>
                </h5>
            </div>

        </div>

        <div class="page-header-content">

            <div class="heading-elements">
                <div class="col-md-4" style="margin-right: 40px">
                    <g:link class="create" controller="cardServices" action="show"
                            id="${cardServices.id - 1}"><button type="button"
                                                                class="btn bg-warning-400 btn-labeled"><b><i
                                class="icon-previous"></i></b> Previous</button></g:link>
                </div>

                <div class="col-md-4">
                    <g:link class="create" controller="cardServices" action="show"
                            id="${cardServices.id + 1}"><button type="button"
                                                                class="btn bg-warning-400 btn-labeled"><b><i
                                class="icon-next"></i></b> Next</button></g:link>
                </div>
            </div>
        </div>

        <g:if test="${flash.errormessage}">
            <div class="message errors" role="status">${flash.errormessage}</div>
        </g:if>
        <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
        </g:if>
        <div class="card_user" style="width: 80%;margin-right: auto;margin-left: auto">

            <div class="panel table-responsive">

                <table class="table text-nowrap">
                    <tr>
                        <td colspan="2"><h5>
                            <span class="text-bold">Card information</span>
                        </h5></td>
                    </tr>

                    <tr>
                        <td>

                            <img class="img-thumbnail img-responsive"
                                 style="width: 130px;height: 130px;object-fit: cover;"
                                 src="${imagePaths(name: cardServices?.user_id.recent_photo)}"/>

                        </td>
                        <td>
                            %{-- <% org.grails.web.json.JSONObject jsonObject = new JSONObject()
                             jsonObject.put("reg_no", cardServices?.user_id?.registration_no)
                             jsonObject.put("card_no", cardServices.card_number)
                             String output = jsonObject.toString()

                             %>
 --}%
                            <qrcode:image height="100" width="100" text="${cardServices.card_number}"/>

                        </td>
                    </tr>




                    <tr>
                        <td>
                            <span class="text-semibold">Name</span>
                        </td>
                        <td>
                            <g:link class="create" controller="user" action="show" id="${cardServices?.user_id?.id}">
                                ${fieldValue(bean: cardServices, field: "user_id.full_name")}
                            </g:link>
                        </td>

                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Artist Number</span>
                        </td>
                        <td>${fieldValue(bean: cardServices, field: "user_id.registration_no")}</td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Description</span>
                        </td>
                        <td>${fieldValue(bean: cardServices, field: "user_id.description")}</td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Card Number</span>
                        </td>
                        <td>${fieldValue(bean: cardServices, field: "card_number")}</td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Phone Number</span>
                        </td>
                        <td>${fieldValue(bean: cardServices, field: "user_id.phone_number")}</td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Loan eligible?</span>
                        </td>
                        <td>${cardServices?.loan_eligible}</td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Expired Date</span>
                        </td>
                        <td><g:formatDate format="dd-MMM-yyyy" date="${cardServices.expired_date}"/></td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Created Date</span>
                        </td>
                        <td><g:formatDate format="dd-MMM-yyyy hh:mm a" date="${cardServices.created_at}"/></td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Amount Paid</span>
                        </td>
                        <td class="numbers">${fieldValue(bean: cardServices, field: "amount_paid")}</td>
                    </tr>


                    <tr>
                        <td>
                            <span class="text-semibold">Issued</span>
                        </td>
                        <td class="numbers">${fieldValue(bean: cardServices, field: "issued")}</td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Expired</span>
                        </td>
                        <td class="numbers">${fieldValue(bean: cardServices, field: "expired")}</td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Enabled</span>
                        </td>
                        <td class="numbers">${fieldValue(bean: cardServices, field: "enabled")}</td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Active</span>
                        </td>
                        <td class="numbers">${fieldValue(bean: cardServices, field: "active")}</td>
                    </tr>

                    <tr>
                        <td>
                            <span class="text-semibold">Printed</span>
                        </td>
                        <td class="numbers">${fieldValue(bean: cardServices, field: "card_printed")}</td>
                    </tr>


                    <tr>
                        <td colspan="2"><h5>
                            <span class="text-bold">Payment information</span>
                        </h5></td>
                    </tr>
                    <tr>
                        <td>
                            <span class="text-semibold">Reference No</span>
                        </td>
                        <td class="numbers">${fieldValue(bean: cardServices, field: "user_number")}</td>
                    </tr>
                    <g:if test="${cardServices.receipt}">

                        <tr>
                            <td>
                                <span class="text-semibold">Receipt</span>
                            </td>
                            <td class="numbers">${fieldValue(bean: cardServices, field: "receipt")}</td>
                        </tr>
                    </g:if>
                    <g:if test="${cardServices.charges}">

                        <tr>
                            <td>
                                <span class="text-semibold">Charges</span>
                            </td>
                            <td class="numbers">${fieldValue(bean: cardServices, field: "charges")}</td>
                        </tr>
                    </g:if>
                    <g:if test="${cardServices.msisdn}">

                        <tr>
                            <td>
                                <span class="text-semibold">Mobile No</span>
                            </td>
                            <td class="numbers">${fieldValue(bean: cardServices, field: "msisdn")}</td>
                        </tr>
                    </g:if>
                    <g:if test="${cardServices.mkey}">
                        <tr>
                            <td>
                                <span class="text-semibold">M-key</span>
                            </td>
                            <td class="numbers">${fieldValue(bean: cardServices, field: "mkey")}</td>
                        </tr>
                    </g:if>

                    <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_CARD">

                      %{--  <tr>
                            <td>
                                <span class="text-semibold">Send confirm message</span>
                            </td>
                            <td class="numbers">
                                <g:link class="create" controller="cardServices" action="resendMessageSuccess"
                                        id="${cardServices.id}"><button type="button"
                                                                        class="btn bg-teal-400 btn-labeled"><b><i
                                            class="icon-add"></i></b> Resend Success</button></g:link>

                            </td>
                        </tr>
--}%
                        <tr>
                            <td>
                                <span class="text-semibold">Edit card</span>
                            </td>
                            <td>
                                <g:link class="edit" controller="cardServices" action="edit"
                                        id="${cardServices.id}"><button
                                        type="button" class="btn bg-info btn-labeled"><b><i class="icon-pencil"></i>
                                    </b> EDIT CARD</button></g:link>

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Issue card</span>
                            </td>
                            <td>
                                <g:link class="create" controller="cardServices" action="issueCard"
                                        id="${cardServices.id}"><button type="button"
                                                                        class="btn bg-teal-400 btn-labeled"><b><i
                                            class="icon-add"></i></b> ISSUE CARD</button></g:link>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-semibold">Update card</span>
                            </td>
                            <td>
                                <g:link class="create" controller="cardServices" action="updateCard"
                                        id="${cardServices.id}"><button type="button"
                                                                        class="btn bg-brown-400 btn-labeled"><b><i
                                            class="icon-add"></i></b> UPDATE CARD</button></g:link>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span class="text-semibold">Card excel</span>
                            </td>
                            <td>
                                <g:link class="create" controller="cardServices" action="cardExcel"
                                        id="${cardServices.id}"><button type="button"
                                                                        class="btn bg-white-400 btn-labeled"><b><i
                                            class="icon-file-text2"></i></b> PRINT EXCEL</button></g:link>
                            </td>
                        </tr>
                    </sec:ifAnyGranted>
                </table>
            </div>

        </div>
    </div>
</div>
</body>
</html>
