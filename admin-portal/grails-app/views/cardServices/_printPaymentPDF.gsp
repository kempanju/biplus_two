<%@ page import="finance.CardServices" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <title>
        Statement
    </title>
    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="bootstrap.css"/>

    <asset:stylesheet src="core.css"/>
    <asset:stylesheet src="components.css"/>
    <asset:stylesheet src="colors.css"/>
    <asset:stylesheet src="general.css"/>

    <style>

    table {
        border-collapse: collapse;
        width: 100%;

    }

    th, td {
        text-align: left;
        padding: 8px;
    }

    .table_class tr:nth-child(even) {
        background-color: #f2f2f2
    }

    .table_class th {
        background-color: #4CAF50;
        color: white;
    }
    </style>

</head>

<body>
<div class="row">
    <div class="col-lg-10">

        <!-- Marketing campaigns -->
        <div class="panel panel-flat">
        <h3>
                <span class="text-bold numbers text-center">Card Payment Reports - Total: ${CardServices.countByPaid(true)-1}</span>
            </h3>

            <div class="table-responsive">

                <table class="table border-blue"
                       style="width: 100%;background-color: #2E7D32;color: white;margin: 30px;padding: 20px">



                    <g:each in="${CardServices.executeQuery("select count(user_id.source_district) ,user_id.source_district.region_id.name,sum(amount_paid),user_id.source_district.region_id from CardServices where paid=1 group by user_id.source_district.region_id ")}"
                            var="cardInstance"  status="k">
                        <tr>
                            <td>${k+1}</td>
                            <td>${cardInstance[1]}</td>
                            <td>${cardInstance[0]}</td>
                            <td>${formatAmountString(name:(int)cardInstance[2])}</td>

                        </tr>

                        <tr>
                            <td colspan="3">

                                <table style="width: 100%;background-color: #3b3b3b;color: white;margin: 30px;padding: 20px">
                                    <g:each in="${CardServices.executeQuery("select count(user_id.source_district) ,user_id.source_district.name,sum(amount_paid),user_id.source_district from CardServices where paid=1 and user_id.source_district.region_id=? group by user_id.source_district ", [cardInstance[3]])}"
                                            status="i" var="cardInstanceDistrict">
                                        <tr>
                                            <td>${i+1}</td>

                                            <td>${cardInstanceDistrict[1]}</td>
                                            <td>${cardInstanceDistrict[0]}</td>
                                            <td>${formatAmountString(name:(int)cardInstanceDistrict[2])}</td>

                                        </tr>

                                       %{-- <tr>
                                            <td colspan="3">
                                                <table style="width: 100%;background-color: #8c8c8c;margin: 30px;padding: 20px"
                                                       border="1">

                                                    <g:each in="${com.tacip.cardServices.CardServices.executeQuery("select count(user_id.location_ward_id) ,user_id.location_ward_id.name,sum(amount_paid) from CardServices where paid=1 and user_id.source_district=? group by user_id.location_ward_id ", [cardInstanceDistrict[3]])}"
                                                            status="j" var="cardInstanceWard">
                                                        <tr>
                                                            <td>${cardInstanceWard[1]}</td>
                                                            <td>${cardInstanceWard[0]}</td>
                                                            <td>${cardInstanceWard[2]}</td>

                                                        </tr>
                                                    </g:each>
                                                </table>

                                            </td></tr>--}%
                                    </g:each>
                                </table>

                            </td>
                        </tr>

                    </g:each>

                </table>

            </div>
        </div>
        <!-- /marketing campaigns -->

    </div>
</div>
</body>
</html>