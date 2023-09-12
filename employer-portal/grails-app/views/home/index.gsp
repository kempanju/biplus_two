<%@ page import="com.softhama.loans.UserLoan; com.softhama.loans.LoanRequest" %>
!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cardPayments.label', default: 'CardPayments')}"/>
    <title>Dashboard</title>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load("current", {packages: ["corechart"]});

        google.charts.setOnLoadCallback(drawAgeRange);
        google.charts.setOnLoadCallback(drawChartArtistGender);


        function drawAgeRange() {
            var data = google.visualization.arrayToDataTable([
                ["Tarehe", "Idadi"],
                <g:each  in="${LoanRequest.executeQuery("select count(id), date(created_at) from LoanRequest where loan_status=2 and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and customer_id=:customer group by date(created_at) ",[customer:customer]) }" status="i" var="birthGroupInstance">
                ['${formatDaysMap(name:birthGroupInstance[1].toString())}', ${birthGroupInstance[0]}],
                </g:each>
            ]);


            var options = {
                title: 'Mwezi huu  idadi ya walioomba mkopo',
                legend: {position: 'none'}
            };

            var chart = new google.visualization.LineChart(document.getElementById('chart_div_comp'));

            chart.draw(data, options);

        }

        function drawChartArtistGender() {
            var data = google.visualization.arrayToDataTable([
                ['Task', 'Employee numbers'],
                ['Male', ${LoanRequest.executeQuery("from LoanRequest where loan_status=2 and user_id.gender=:gender and customer_id=:customer",[gender:'Male', customer: customer]).size()}],
                ['Female', ${LoanRequest.executeQuery("from LoanRequest where loan_status=2 and  user_id.gender=:gender and customer_id=:customer",[gender:'Female', customer: customer]).size()}],

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
            <div class="col-md-12">
                <g:form method="GET" action="reportByDate" class="form-horizontal">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="control-label col-lg-3 text-bold">From Date</label>


                            <div class="col-lg-7 input-append date form_datetime">
                                <input type="text" name="start_date" readonly required="required" class="form-control"/>
                                <span class="add-on"><i class="icon-th"></i></span>

                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-lg-3 text-bold">To Date</label>

                            <div class="col-lg-7 input-append date form_datetime">
                                <input type="text" name="end_date" readonly required="required" class="form-control"/>
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

            </div>


            <div class="col-lg-10">

                <!-- Traffic sources -->
                <div class="panel panel-flat">

                    <div class="panel-heading">
                        <span class="label border-left-info label-striped">Mikopo</span>

                    </div>

                    <div class="container-fluid" style="margin-top: 30px">
                        <div class="row text-center">
                            <div class="col-md-6">

                                <!-- Members online -->
                                <div class="panel bg-danger-400">
                                    <div class="panel-body">

                                        <h3 class="no-margin">

                                            <%
                                                def amountData= UserLoan.executeQuery("select sum (unpaidLoan) from UserLoan  where customer=:customer",[customer: customer])[0]


                                                if(!amountData){
                                                    amountData=0
                                                }
                                            %>
                                            ${formatAmountString(name: (int)amountData )}

                                        </h3>
                                        Inayodaiwa
                                        <div class="text-muted text-size-small">

                                            na ${formatAmountString(name: (int) UserLoan.executeQuery(" from UserLoan where unpaidLoan>0 and customer=:customer",[customer: customer]).size())} beneficiary

                                        </div>

                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>

                            <div class="col-md-6">

                                <!-- Members online -->
                                <div class="panel bg-teal-400">
                                    <div class="panel-body">
                                        <%
                                            def totalAmount = LoanRequest.executeQuery("select sum(loan_amount_total) from LoanRequest where loan_status=2 and loan_repaid=true and customer_id=:customer", [customer:customer])[0];


                                            if(!totalAmount){
                                                totalAmount=0
                                            }
                                            def totlReqLoan = LoanRequest.executeQuery("select sum(amount) from LoanRequest where loan_status=2 and loan_repaid=true and customer_id=:customer",[customer:customer])[0];
                                            if(!totlReqLoan){
                                                totlReqLoan=0
                                            }
                                            def profitAmount = totalAmount - totlReqLoan;
                                        %>


                                        <h3 class="no-margin">${formatAmountString(name: (int) totalAmount)} TZS</h3>
                                        Jumla ya kiasi
                                        <div class="text-muted text-size-small"> na ${LoanRequest.executeQuery(" from LoanRequest where loan_status=2 and loan_repaid=true and customer_id=:customer",[customer:customer]).size()} artists</div>

                                    </div>

                                </div>
                                <!-- /members online -->

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


                    <div class="panel-heading ">
                        <span class="label border-left-info label-striped">Idadi ya walioomba ( Unique users : <span
                                class="badge badge-info">
                            ${LoanRequest.executeQuery("from LoanRequest where  loan_status=2 and customer_id=:customer group by user_id ", [customer:customer]).size()}

                        </span>)</span>

                    </div>

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
                                                    totalAmountData = LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and customer_id=:customer ",[customer: customer])[0]
                                                    if(!totalAmountData){
                                                        totalAmountData=0
                                                    }
                                                } catch (Exception e) {

                                                }
                                            %>
                                            ${formatAmountString(name: (int)totalAmountData)} TZS
                                        </h3>
                                        Leo
                                        <div class="text-muted text-size-small">
                                            ${LoanRequest.executeQuery("from LoanRequest where  loan_status=2 and date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and customer_id=:customer",[customer: customer]).size()}
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
                                                def totalLoanMonth=0;
                                                try{
                                                    totalLoanMonth= LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and  month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and and customer_id=:customer",[customer:customer])[0]
                                                    if(!totalLoanMonth){
                                                        totalLoanMonth=0
                                                    }

                                                }catch (Exception e){

                                                }

                                            %>
                                            ${formatAmountString(name: (int)totalLoanMonth)} TZS

                                        </h3>
                                        Mwezi huu
                                        <div class="text-muted text-size-small">
                                            na ${LoanRequest.executeQuery("from LoanRequest where loan_status=2 and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and customer_id=:customer",[customer: customer]).size()}
                                            artists
                                        </div>
                                    </div>

                                </div>
                                <!-- /members online -->

                            </div>

                            <div class="col-lg-4">

                                <!-- Members online -->
                                <div class="panel bg-orange-400">
                                    <div class="panel-body">
                                        <h3 class="no-margin">

                                            <%
                                                def reqSumAMount=LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and  year(created_at)=YEAR(CURRENT_DATE) and customer_id=:customer ",[customer: customer])[0]
                                                if(!reqSumAMount){
                                                    reqSumAMount=0
                                                }

                                            %>
                                            ${formatAmountString(name: (int) reqSumAMount)} TZS

                                        </h3>
                                        Mwaka huu
                                        <div class="text-muted text-size-small">
                                            na  ${LoanRequest.executeQuery("from LoanRequest where loan_status=2 and year(created_at)=YEAR(CURRENT_DATE) and customer_id=:customer ",[customer: customer]).size()}
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

            <div class="col-lg-10">
                <div id="chart_div_comp" style="width: 100%;min-height: 300px"></div>

            </div>

            <div class="col-lg-10">
                <div id="piechart_3d_comp_gender" style="width: 100%;min-height: 300px;margin-top: 40px"></div>

            </div>

        </div>

    </div>
    <!-- /main charts -->
</div>
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:mm'});
</script>
</body>