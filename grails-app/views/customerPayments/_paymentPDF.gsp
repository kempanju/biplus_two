<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html >
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
    <style type="text/css">
    p{
        margin: 5px auto;

    }

    hr {
        display: block;
        height: 1px;
        border: 0;
        border-top: 1px solid #000000;
        margin: 1em 0;
        padding: 0;
    }
</style>
</head>
<body>
<div class="row">
    <div class="col-lg-10">


        <!-- Marketing campaigns -->
        <div class="panel panel-flat">

            <div class="table-responsive">



                <table class="table border-blue" border="0" style="width: 100%">

                    <tr>
                        <td class="text-center">

                            <img src="http://tacip.co.tz:8080/kopafasta/assets/kopafasta-bcb62ca4f0239722ffe680f5c726bdd2.png" width="250" height="100"/>
%{--
                            <p>Request Note Number: ${report.unique_month_payments}</p>
--}%
                        </td>
                    <td style="vertical-align: top;text-align: right">
                        <p>DataVision Kopafasta LTD</p>
                        <p>373 Garden Road - Mikocheni</p>
                        <p>P.O.BOX 7744 Dar es salaam</p>
                        <p>TANZANIA</p>
                        <% Date date = new Date();
                        String modifiedDate= new java.text.SimpleDateFormat("dd/MM/yyyy").format(date); %>
                        Date: ${modifiedDate}

                    </td>

                    </tr>
                    <tr><td colspan="2" style="text-align: center"><h3>LOAN REPAYMENT NOTE</h3></td></tr>
                    <tr>
                        <td>
                            <p>To</p>
                            <p>${report?.customer_id?.name}</p>
                            <p>${report?.customer_id?.contacts}</p>
                            <p>Tanzania</p>
                        </td>
                        <td style="vertical-align: top;text-align: right">
                           <% String modifiedDates= new java.text.SimpleDateFormat("yyyy").format(date); %>
                            RPT No: ${modifiedDates+"-"+String.format("%04d",report.id)}
                        </td>
                    </tr>

                    <tr><td colspan="2"><hr/><br/></td></tr>

                    <tr><td  style="vertical-align: top;margin-top: 30px">
                        <p>Description</p>
                       %{-- <p>Invoice number.........................${report.unique_month_payments}</p>
                        <p>Invoice date...........................${report.payment_month}</p>
                        <p>Request No.............................${report.request_no}</p>
                        <p>Account ID.............................${report.customer_id.code}</p>--}%</td>

                        <td  style="vertical-align: top;margin-top: 30px">
                            <% def diffrerence=report.total_amount-report.requested_amount; %>

                            <table><tr><td><p>Basic Loan : TZS. </p></td><td><b>${fieldValue(bean: report, field: "requested_amount")}.00</b></td></tr>

                            <tr><td>Processing Fee : TZS. </td><td><b>${formatAmountString(name:diffrerence )}.00</b></td></tr>
                            <tr><td>Total (TZS) </td><td><b>${formatAmountString(name: report.total_amount)}.00</b></td></tr>

                        </table>


                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <br/>
                            <p>Being Payments for Advance Salary Loans for the staff of  ${report?.customer_id?.name} for month of

                                <%
                                    String dateFormat=report.payment_month+"-01"
                                    SimpleDateFormat month_date = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                                    Date dates = sdf.parse(dateFormat);

                                    String month_name = month_date.format(dates)

                                %>
                                <b>${month_name}</b>
                            </p>
                        </td>
                    </tr>
                    <tr><td colspan="2"><br/><hr/></td></tr>

                    <tr style="vertical-align: top;margin-top: 30px">
                        <td colspan="2">
                        <p style="margin-top: 30px">TERMS AND CONDITIONS:</p>
                        <ol>
                            <li>Loan should should be repaid within 10 days from the above date of this NOTE.</li>
                            <li>Payments should be made in favour of:</li>
                            <p>Account Name: <b style="color: #0a68b4">DataVision International LTD</b></p>
                            <p>Bank Name: <b style="color: #0a68b4">Bank of Africa Tanzania</b></p>
                            <p>A/C No: <b style="color: #0a68b4">02016790015</b></p>
                        </ol>
                        </td>
                    </tr>
                    <tr><td></td>
                        <td  style="text-align: end;margin-top: 30px"><p><i>Terms and Conditions of Payment to be adhered.</i></p></td>
                    </tr>
                    <tr><td colspan="2"><hr/><br/></td></tr>
                    <tr><td colspan="2" style="vertical-align: top;text-align: right">
                        <p>On behalf of <b style="color: #0a68b4"><i>: Kopafasta LTD</i></b></p>
                    </td></tr>

                </table>

            </div>
        </div>
        <!-- /marketing campaigns -->

    </div>
</div>
</body>
</html>