<%@ page import="finance.CardServices; loans.LoanRequest" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cardPayments.label', default: 'CardPayments')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load("current", {packages: ["corechart"]});

        google.charts.setOnLoadCallback(drawAgeRange);
        google.charts.setOnLoadCallback(drawChartArtistGender);


        function drawAgeRange() {
            var data = google.visualization.arrayToDataTable([
                ["Tarehe", "Idadi"],
                <g:each  in="${CardServices.executeQuery("select count(id), date(paid_at) from CardServices where paid=1 and  paid_at>='"+params.start_date+"' and paid_at<='"+params.end_date+"' group by date(paid_at) ") }" status="i" var="cardGroupInstance">
                ['${formatDaysMap(name:cardGroupInstance[1].toString())}', ${cardGroupInstance[0]}],
                </g:each>
            ]);


            var options = {
                title: 'Waliolipia kadi mwezi huu',
                legend: {position: 'none'}
            };

            var chart = new google.visualization.LineChart(document.getElementById('chart_div_comp'));

            chart.draw(data, options);

        }

        function drawChartArtistGender() {
            var data = google.visualization.arrayToDataTable([
                ['Task', 'Employee numbers'],
                ['Male', ${loans.LoanRequest.executeQuery("from CardServices where paid=1 and user_id.gender=? and  paid_at>='"+params.start_date+"' and paid_at<='"+params.end_date+"' ",['Male']).size()}],
                ['Female', ${LoanRequest.executeQuery("from CardServices where paid=1 and  user_id.gender=? and  paid_at>='"+params.start_date+"' and paid_at<='"+params.end_date+"' ",['Female']).size()}],

            ]);

            var options = {
                title: 'Gender Graph',
                is3D: true,
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart_3d_comp_gender'));
            chart.draw(data, options);
        }


    </script>

</head>

<body>
<div class="register_dv expert">

    <div class="center panel_div_list">

        <!-- Main charts -->
        <div class="row">
            <div class="col-md-10">
                <g:form method="GET" action="reportByDateCard" class="form-horizontal">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-lg-3 text-bold">From Date</label>


                            <div class="col-lg-7 input-append date form_datetime">
                                <input type="text" name="start_date" value="${params.start_date}" readonly required="required" class="form-control"/>
                                <span class="add-on"><i class="icon-th"></i></span>

                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-lg-3 text-bold">To Date</label>

                            <div class="col-lg-7 input-append date form_datetime">
                                <input type="text" name="end_date" value="${params.end_date}" readonly required="required" class="form-control"/>
                                <span class="add-on"><i class="icon-th"></i></span>

                            </div>
                        </div>
                    </div>

                    <div class="text-right col-md-3">
                        <button type="submit" class="btn btn-primary">SELECT REPORT <i
                                class="icon-arrow-right14 position-right"></i>
                        </button>

                    </div>


                </g:form>
                <div class="text-right col-md-3">
                    <g:link controller="cardServices" action="printReportCardPayment" params="[start_date:params.start_date,end_date:params.end_date]">
                    <button type="button" class="btn btn-success">PRINT REPORT <i
                            class="icon-file-pdf position-right"></i>
                    </button>
                    </g:link>
                </div>
            </div>


        <%
        def paidTotal=CardServices.executeQuery("from CardServices where  paid=1 and  paid_at>='" + params.start_date + "' and paid_at<='" + params.end_date + "' ").size()

    %>


            <div class="col-lg-10">

                <!-- Traffic sources -->
                <div class="panel panel-flat">

                    <div class="panel-heading">
                        <span class="label border-left-info label-striped">Cards</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <div class="row text-center">

                            <div class="col-md-6">

                                <!-- Members online -->
                                <div class="panel bg-danger-400">
                                    <div class="panel-body">

                                        <h3 class="no-margin">
                                            ${CardServices.executeQuery(" from CardServices where issued=true and  paid_at>='" + params.start_date + "' and paid_at<='" + params.end_date + "' ").size()}

                                        </h3>
                                        Zilizotumwa IDCARDS
                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>

                            <div class="col-md-6">

                                <!-- Members online -->
                                <div class="panel bg-teal-400">
                                    <div class="panel-body">

                                        <h3 class="no-margin">
                                            ${CardServices.executeQuery(" from CardServices where issued=false and  paid_at>='" + params.start_date + "' and paid_at<='" + params.end_date + "'").size()}

                                        </h3>
                                        Ambazo hazijatumwa
                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>

                            %{--  <div class="col-md-4">
                                  <div class="content-group">
                                      <h5 class="text-semibold no-margin"><i
                                              class="icon-cash3 position-left text-slate"></i>
                                          ${formatAmountNumber(name:LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and  year(paid_at)=YEAR(CURRENT_DATE) ")[0])} TZS

                                      </h5>
                                      <span class="text-muted text-size-small">Faida </span>
                                  </div>
                              </div>--}%
                        </div>
                    </div>


                    <div class="panel-heading ">
                        <span class="label border-left-info label-striped">Idadi ya waliolipa ( Unique users :
                            <span class="badge badge-info">
                        ${CardServices.executeQuery("from CardServices where  paid=1 and  paid_at>='" + params.start_date + "' and paid_at<='" + params.end_date + "' group by user_id ").size()}
                        </span>)
                        </span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <div class="row text-center">
                            <div class="col-lg-12">

                                <!-- Members online -->
                                <div class="panel bg-success-400">
                                    <div class="panel-body">
                                        <h3 class="no-margin">
                                            ${formatAmountString(name: CardServices.executeQuery("select sum (amount_paid) from CardServices where paid=1 and  paid_at>='" + params.start_date + "' and paid_at<='" + params.end_date + "'  ")[0])}
                                        </h3> Kiasi
                                        <div class="text-muted text-size-small">
                                       na ${paidTotal}
                                        artists
                                        </div>
                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>
                        </div>

                            %{--
                             <div class="col-lg-4">
                                 <ul class="list-inline text-center">
                                     <li>
                                         <a href="#"
                                            class="btn border-indigo-400 text-indigo-400 btn-flat btn-rounded btn-icon btn-xs valign-text-bottom"><i
                                                 class="icon-people"></i></a>
                                     </li>
                                     <li class="text-left">
                                         <div class="text-semibold">Mwaka huu</div>

                                         <div class="text-muted"><span
                                                 class="status-mark border-success position-left"></span> ${CardServices.executeQuery("from CardServices where paid=1 and  paid_at>='"+params.start_date+"' and paid_at<='"+params.end_date+"'   ").size()}
                                         </div>
                                     </li>
                                 </ul>

                                 <div class="col-lg-10 col-lg-offset-1">
                                     <div class="content-group" id="total-online"></div>
                                 </div>
                             </div>--}%
                    </div>

                    <div class="position-relative" id="traffic-sources"></div>
                </div>
                <!-- /traffic sources -->

            </div>

        <div class="col-lg-10">
            <div id="chart_div_comp" style="width: 100%;min-height: 300px"></div>

        </div>

        <div class="col-lg-10">
            <div id="piechart_3d_comp_gender" style="width: 100%;min-height: 300px;margin-top: 40px"></div>

        </div>

            %{-- <div class="col-lg-10">

                 <!-- By payment -->
                 <div class="panel panel-flat">
                     <div class="panel-heading">
                         <h6 class="panel-title text-bold">Kiasi kilicholipwa</h6>

                     </div>

                     <div class="container-fluid" style="margin-top: 30px">
                         <div class="row text-center">
                             <div class="col-md-4">
                                 <div class="content-group">
                                     <h5 class="text-semibold no-margin"><i
                                             class="icon-calendar5 position-left text-slate"></i>
                                         ${formatAmountNumber(name: CardServices.executeQuery("select sum (amount_paid) from CardServices where paid=1 and  paid_at>='"+params.start_date+"' and paid_at<='"+params.end_date+"'  ")[0])}

                                     </h5>
                                     <span class="text-muted text-size-small">Zilizolipwa </span>
                                 </div>
                             </div>

                           --}%%{--  <div class="col-md-4">
                                 <div class="content-group">
                                     <h5 class="text-semibold no-margin"><i
                                             class="icon-calendar52 position-left text-slate"></i>
                                         ${formatAmountNumber(name: CardServices.executeQuery("select sum (amount_paid) from CardServices where paid=1 and  paid_at>='"+params.start_date+"' and paid_at<='"+params.end_date+"'  ")[0])} TZS

                                     </h5>
                                     <span class="text-muted text-size-small">Mwezi huu</span>
                                 </div>
                             </div>

                             <div class="col-md-4">
                                 <div class="content-group">
                                     <h5 class="text-semibold no-margin"><i
                                             class="icon-cash3 position-left text-slate"></i>
                                         ${formatAmountNumber(name: CardServices.executeQuery("select sum (amount_paid) from CardServices where paid=1 and  paid_at>='"+params.start_date+"' and paid_at<='"+params.end_date+"'  ")[0])} TZS

                                     </h5>
                                     <span class="text-muted text-size-small">Mwaka huu</span>
                                 </div>
                             </div>--}%%{--
                         </div>
                     </div>

                     <div class="content-group-sm" id="app_sales"></div>

                     <div id="monthly-sales-stats"></div>
                 </div>
                 <!-- By payment -->

             </div>--}%



            <div class="col-lg-5">

                <!-- Sales stats -->
                <div class="panel panel-flat">
                    <div class="panel-heading">
                        <span class="label border-left-info label-striped">Waliolipa kwa category</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <table class="table datatable-basic">

                            <g:each in="${CardServices.executeQuery("select count(user_id.art_category_id),user_id.art_category_id.name,user_id.art_category_id.id from CardServices where paid=1 and  paid_at>='" + params.start_date + "' and paid_at<='" + params.end_date + "'  group by user_id.art_category_id")}"
                                    var="paymentInstance">
                                <tr><td>${paymentInstance[1]}</td><td>
                                    <g:link controller="cardPayments" action="reportusers" id="${paymentInstance[2]}"
                                            params="[status: 2]">
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
                        <span class="label border-left-success label-striped">Waliolipa kwa maeneo</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <table class="table datatable-basic">

                            <g:each in="${CardServices.executeQuery("select count(user_id.recruitment_district),user_id.recruitment_district.name,user_id.recruitment_district.id from CardServices where paid=1 and  paid_at>='" + params.start_date + "' and paid_at<='" + params.end_date + "'  group by user_id.recruitment_district", [max: 20])}"
                                    var="locationInstance">
                                <tr><td>${locationInstance[1]}</td>

                                    <td>
                                        <g:link controller="cardPayments" action="reportusers"
                                                id="${locationInstance[2]}" params="[status: 1]">
                                            <span class="badge badge-success">${locationInstance[0]}</span>
                                        </g:link>
                                    </td>

                                </tr>
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