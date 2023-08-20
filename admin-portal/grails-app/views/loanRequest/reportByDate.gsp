<%@ page import="loans.LoanRepayment; loans.LoanRequest" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'loanRequest.label', default: 'CardPayments')}"/>
    <title>Loan reports</title>

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load("current", {packages: ["corechart"]});

        google.charts.setOnLoadCallback(drawAgeRange);

        google.charts.setOnLoadCallback(drawAmountRange);

        google.charts.setOnLoadCallback(drawChartArtistGender);


        function drawAgeRange(){
            var data = google.visualization.arrayToDataTable([
                ["Tarehe","Idadi"],
                <g:each  in="${loans.LoanRequest.executeQuery("select count(id), date(created_at) from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' group by date(created_at) ") }" status="i" var="birthGroupInstance">
                ['${formatDaysMap(name:birthGroupInstance[1].toString())}',${birthGroupInstance[0]}],
                </g:each>
            ]);


            var options = {
                title: 'Mwezi huu  idadi ya walioomba mkopo',
                legend: { position: 'none' }
            };

            var chart = new google.visualization.LineChart(document.getElementById('chart_div_comp'));

            chart.draw(data, options);

        }

        function drawChartArtistGender() {
            var data = google.visualization.arrayToDataTable([
                ['Task', 'Employee numbers'],
                ['Male', ${LoanRequest.executeQuery("from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' and user_id.gender=:gender ",[gender:'Male']).size()}],
                ['Female', ${LoanRequest.executeQuery("from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' and user_id.gender=:gender ",[gender:'Female']).size()}],

            ]);

            var options = {
                title: 'Gender Graph',
                is3D: true,
            };

            var chart = new google.visualization.PieChart(document.getElementById('piechart_3d_comp_gender'));
            chart.draw(data, options);
        }


        function drawAmountRange(){
            var data = google.visualization.arrayToDataTable([
                ["Tarehe","Kiasi"],
                <g:each  in="${LoanRequest.executeQuery("select sum(amount), date(created_at) from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' group by date(created_at) ") }" status="i" var="birthGroupInstance">
                ['${formatDaysMap(name:birthGroupInstance[1].toString())}',${birthGroupInstance[0]}],
                </g:each>
            ]);




            var options = {
                title: 'Kiasi kimekopwa',
                legend: { position: 'none' }
            };

            var chart = new google.visualization.BarChart(document.getElementById('chart_div_histogram'));

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
                <g:form method="GET" action="reportByDate"  class="form-horizontal">
                    <div class="col-md-4">
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
                        <button type="submit" class="btn btn-primary">SELECT REPORT <i class="icon-arrow-right14 position-right"></i>
                        </button>

                    </div>
                </g:form>
                <div class="text-right col-md-2">
                    <g:link controller="loanRequest" action="pdfReports" params="[start_date:params.start_date,end_date:params.end_date]">

                        <button type="submit" class="btn btn-warning">PRINT PDF <i
                                class="icon-file-pdf position-left"></i>
                        </button>
                    </g:link>

                </div>
            </div>
        <%
            def paidTotal= LoanRequest.executeQuery("from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' ").size()

%>

        <div class="col-lg-10">



                <!-- Traffic sources -->
                <div class="panel panel-flat">



                    <div class="panel-heading">
                        <span class="label border-left-success label-striped">Mikopo iliyoombwa ( Unique users :<span
                                class="badge badge-info"> ${LoanRequest.executeQuery("from LoanRequest where  loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' group by user_id ").size()}</span>)</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <div class="row text-center">
                            <div class="col-md-6">
                                <%
                                    def totalAount=LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"'")[0]

                                    if(!totalAount){
                                        totalAount=0
                                    }

                                    def totalInteretAmount=LoanRequest.executeQuery("select sum (loan_amount_total) from LoanRequest where loan_status=2 and  created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"'")[0]
                                    if(!totalInteretAmount){
                                        totalInteretAmount=0
                                    }

                                    def totalinterest=totalInteretAmount-totalAount

                                %>

                                <!-- Members online -->
                                <div class="panel bg-danger-400">
                                    <div class="panel-body">
                                        <h3 class="no-margin">
                                            ${formatAmountString(name:(int)totalAount )} TZS
                                        </h3>
                                        Iliyoombwa
                                        <div class="text-muted text-size-small">
                                        ${formatAmountString(name:(int)totalInteretAmount )} TZS with fees
                                        </div>

                                    </div>

                                </div>
                            </div>

                            <div class="col-md-6">

                                <!-- Members online -->
                                <div class="panel bg-primary-400">
                                    <div class="panel-body">
                                        <h3 class="no-margin">
                                            ${formatAmountString(name:(int)totalinterest )} TZS
                                        </h3>
                                        Total Fees
                                        <div class="text-muted text-size-small">
                                        from ${paidTotal} artists

                                    </div>

                                    </div>

                                </div>
                            </div>



                            %{--  <div class="col-md-4">
                                  <div class="content-group">
                                      <h5 class="text-semibold no-margin"><i
                                              class="icon-cash3 position-left text-slate"></i>
                                          ${formatAmountNumber(name:LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and  year(created_at)=YEAR(CURRENT_DATE) ")[0])} TZS

                                      </h5>
                                      <span class="text-muted text-size-small">Faida </span>
                                  </div>
                              </div>--}%
                        </div>
                    </div>
            <div class="panel-heading">
                <span class="label border-left-success label-striped">Mikopo iliyorudishwa</span>

            </div>

            <div class="container-fluid" style="margin-top: 30px">
                <div class="row text-center">
                    <div class="col-md-12">
                        %{--<div class="content-group">
                            <h5 class="text-semibold no-margin"><i
                                    class="icon-calendar5 position-left text-slate"></i>
                                ${formatAmountNumber(name: LoanRepayment.executeQuery("select sum (amount_paid) from LoanRepayment where created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"'")[0])}
                                (  ${LoanRepayment.executeQuery("from LoanRepayment where created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"'").size()}
                                )
                            </h5>
                            <span class="text-muted text-size-small">Iliyorudiswa</span>
                        </div>--}%

                        <!-- Members online -->
                        <div class="panel bg-blue-400">
                            <div class="panel-body">
                                <h3 class="no-margin">
                                    <%
                                        def mkopos=loans.LoanRepayment.executeQuery("select sum (amount_paid) from LoanRepayment where created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"'")[0]

                                        if(!mkopos){
                                            mkopos=0;
                                        }
                                    %>
                                    ${formatAmountString(name: (int)mkopos)} TZS

                                </h3>
                                Iliyorudishwa
                                <div class="text-muted text-size-small">

                                  ${LoanRepayment.executeQuery("from LoanRepayment where created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"'").size()} artists

                            </div>

                            </div>

                        </div>
                    </div>


                    %{--  <div class="col-md-4">
                          <div class="content-group">
                              <h5 class="text-semibold no-margin"><i
                                      class="icon-cash3 position-left text-slate"></i>
                                  ${formatAmountNumber(name:LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and  year(created_at)=YEAR(CURRENT_DATE) ")[0])} TZS

                              </h5>
                              <span class="text-muted text-size-small">Faida </span>
                          </div>
                      </div>--}%
                </div>
            </div>

            <div class="col-lg-10">

                <div id="piechart_3d_comp_gender" style="width: 100%;min-height: 300px;margin-top: 40px"></div>
            </div>




                <!-- By payment -->


          %{--  <div class="col-lg-5">

                <!-- Sales stats -->
                <div class="panel panel-flat">
                    <div class="panel-heading">
                        <span class="label border-left-success label-striped">Waliolipa kwa category</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <table class="table datatable-basic">

                            <g:each in="${LoanRequest.executeQuery("select count(user_id.art_category_id),user_id.art_category_id.name,user_id.art_category_id.id from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' group by user_id.art_category_id")}"
                                    var="paymentInstance">
                                <tr><td>${paymentInstance[1]}</td><td>
                                    <g:link controller="cardPayments" action="reportusers" id="${paymentInstance[2]}"
                                            params="[status: 2]">
                                        <span class="badge badge-info"> ${paymentInstance[0]}</span>
                                    </g:link>
                                </td></tr>
                            </g:each>
                            <tr><td><span class="label border-left-info label-striped">Total</span></td><td> <span class="badge badge-warning">${paidTotal}</span></td></tr>

                        </table>
                    </div>
                </div>
            </div>--}%

            <div class="col-lg-5">

                <!-- Sales stats -->
                <div class="panel panel-flat">
                    <div class="panel-heading">
                        <span class="label border-left-info label-striped">Waliolipa kwa maeneo</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <table class="table datatable-basic">

                            <g:each in="${LoanRequest.executeQuery("select count(user_id.district_id),user_id.district_id.name,user_id.district_id.id from LoanRequest where loan_status=2 and created_at>='"+params.start_date+"' and created_at<='"+params.end_date+"' group by user_id.district_id", [max: 20])}"
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

            <div class="col-lg-12">

                <div id="chart_div_comp" style="width: 100%;min-height: 300px"></div>
            </div>

            <div class="col-lg-12">

                <div id="chart_div_histogram" style="width: 100%;min-height: 300px;margin-top: 40px"></div>
            </div>



        </div>
    <!-- /main charts -->
</div>
    </div>
</div>
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:mm'});
</script>
</body>