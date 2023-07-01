<%@ page import="loans.CardPayments" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cardPayments.label', default: 'CardPayments')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list">

        <!-- Main charts -->
        <div class="row">

        <div class="col-md-10">
            <g:form method="GET" action="reportByDatePayment" class="form-horizontal">
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="control-label col-lg-3 text-bold">From Date</label>


                        <div class="col-lg-7 input-append date form_datetime">
                            <input type="text" name="start_date" readonly required="required" class="form-control"/>
                            <span class="add-on"><i class="icon-th"></i></span>

                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="form-group">
                        <label class="control-label col-lg-3 text-bold">To Date</label>

                        <div class="col-lg-7 input-append date form_datetime">
                            <input type="text" name="end_date" readonly required="required" class="form-control"/>
                            <span class="add-on"><i class="icon-th"></i></span>

                        </div>
                    </div>
                </div>

                <div class="text-right col-md-4">
                    <button type="submit" class="btn btn-primary">SELECT REPORT <i
                            class="icon-arrow-right14 position-right"></i>
                    </button>

                </div>
            </g:form>
        </div>
            <div class="col-lg-10">

                <!-- Traffic sources -->
                <div class="panel panel-flat">
                    <div class="panel-heading">
                        <span class="label border-left-success label-striped">Idadi ya waliolipa</span>

                    </div>

                <%
                    def paidTotal=loans.CardPayments.executeQuery("from CardPayments where year(created_at)=YEAR(CURRENT_DATE)  ").size()



                    %>

                    <div class="container-fluid" style="margin-top: 30px">
                        <div class="row text-center">

                            <div class="col-lg-4">

                                <!-- Members online -->
                                <div class="panel bg-primary-400">
                                    <div class="panel-body">
                                        <h3 class="no-margin">
                                            <%
                                                def amountTotal=0
                                                try {
                                                    amountTotal = CardPayments.executeQuery("select sum (amount_paid) from CardPayments where date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) ")[0]
                                                    if(!amountTotal){
                                                        amountTotal=0;
                                                    }
                                                }catch (Exception e){

                                                }
                                            %>
                                            ${formatAmountString(name:(int)amountTotal)} TZS

                                        </h3>
                                        Zilizolipwa leo
                                        <div class="text-muted text-size-small">
                                        na ${CardPayments.executeQuery("from CardPayments where date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) ").size()}

                                            artists
                                        </div>
                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>


                            <div class="col-lg-4">

                                <!-- Members online -->
                                <div class="panel bg-teal-400">
                                    <div class="panel-body">
                                        <h3 class="no-margin">

                                            <%
                                                def totalAmountData = 0;
                                                try {
                                                    totalAmountData = CardPayments.executeQuery("select sum (amount_paid) from CardPayments where  month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) ")[0]
                                                    if(!totalAmountData){
                                                        totalAmountData=0
                                                    }
                                                } catch (Exception e) {

                                                }
                                            %>
                                            ${formatAmountString(name:(int)totalAmountData)} TZS

                                        </h3>
                                        Mwezi huu
                                        <div class="text-muted text-size-small">
                                        na ${CardPayments.executeQuery("from CardPayments where month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) ").size()
                                        }
                                            artists
                                        </div>
                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>



                            <div class="col-lg-4">

                                <!-- Members online -->
                                <div class="panel bg-success-400">
                                    <div class="panel-body">
                                        <h3 class="no-margin">
                                            ${formatAmountString(name:(int)CardPayments.executeQuery("select sum (amount_paid) from CardPayments where  year(created_at)=YEAR(CURRENT_DATE) ")[0])} TZS

                                        </h3>
                                        Mwaka huu
                                        <div class="text-muted text-size-small">
                                        na ${paidTotal}
                                            artists
                                        </div>
                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>



                        </div>
                    </div>

                    <div class="position-relative" id="traffic-sources"></div>
                </div>
                <!-- /traffic sources -->

            </div>



            <div class="col-lg-5">

                <!-- Sales stats -->
                <div class="panel panel-flat">
                    <div class="panel-heading">
                        <span class="label border-left-info label-striped">Waliolipa kwa category</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <table class="table datatable-basic">

                            <g:each in="${CardPayments.executeQuery("select count(user_id.art_category_id),user_id.art_category_id.name,user_id.art_category_id.id from CardPayments group by user_id.art_category_id")}" var="paymentInstance">
                            <tr><td>${paymentInstance[1]}</td><td>
                                <g:link controller="cardPayments" action="reportusers" id="${paymentInstance[2]}" params="[status:2]">
                                    <span class="badge badge-info">${paymentInstance[0]}</span>
                                </g:link>
                            </td></tr>
                        </g:each>

                            <tr><td><span class="label border-left-info label-striped">Total</span></td><td> <span class="badge badge-warning">${paidTotal}</span></td></tr>

                        </table>
                    </div>
                </div>
            </div>

        <div class="col-lg-5">

            <!-- Sales stats -->
            <div class="panel panel-flat">
                <div class="panel-heading">
                    <span class="label border-left-indigo label-striped">Waliolipa kwa maeneo</span>

                </div>

                <div class="container-fluid" style="margin-top: 30px">
                    <table class="table datatable-basic">

                        <g:each in="${CardPayments.executeQuery("select count(user_id.recruitment_district),user_id.recruitment_district.name,user_id.recruitment_district.id from CardPayments group by user_id.recruitment_district",[max:20])}" var="locationInstance">
                            <tr><td>${locationInstance[1]}</td>

                                <td>
                        <g:link controller="cardPayments" action="reportusers" id="${locationInstance[2]}" params="[status:1]">
                            <span class="badge badge-primary">${locationInstance[0]}</span>
                        </g:link>
                            </td>

                            </tr>
                        </g:each>
                        <tr><td><span class="label border-left-info label-striped">Total</span></td><td> <span class="badge badge-warning">${paidTotal}</span></td></tr>

                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-5">

            <!-- Sales stats -->
            <div class="panel panel-flat">
                <div class="panel-heading">
                    <span class="label border-left-success label-striped">Group ya kiasi kilicholipwa</span>

                </div>

                <div class="container-fluid" style="margin-top: 30px">
                    <table class="table datatable-basic">

                        <g:each in="${CardPayments.executeQuery("select count(amount_paid),amount_paid from CardPayments group by amount_paid",[max:20])}" var="amountInstance">
                            <tr><td>${formatAmountString(name:(int)amountInstance[1])}</td><td>
                                <g:link controller="cardPayments" action="reportusers" id="${amountInstance[1]}" params="[status:3]">
                                    <span class="badge badge-success"> ${amountInstance[0]}</span>
                                </g:link>
                            </td></tr>
                        </g:each>
                        <tr><td><span class="label border-left-info label-striped">Total</span></td><td> <span class="badge badge-warning">${paidTotal}</span></td></tr>

                    </table>
                </div>
            </div>
        </div>
        </div>


    </div>
        <!-- /main charts -->
    </div>
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:mm'});
</script>

</body>