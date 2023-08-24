<%@ page import="loans.LoanRepayment" %>
<!DOCTYPE html>
<html>

<head>
    <title>Daily reports</title>
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

<body style="margin: 30px; width: 100%">
<h3>KOPAFASTA Automatic Daily reports:  <b><g:formatDate format="dd-MMM-yyyy hh:mm a" date="${new Date()}"/>
</b></h3>


<div class="col-lg-12">

    <h5>TODAY LOAN STATUS</h5>

    <table border="1" class="table_class">
        <tr>
            <td>SUCCESS</td>
            <td>PENDING</td>
            <td>FAILED</td>
            <td>TOTAL PENDING</td>
        </tr>

        <tr>
    <td>${loans.LoanRequest.executeQuery("from LoanRequest where  loan_status=2 and date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) ").size()}
            </td>
            <td>${loans.LoanRequest.executeQuery("from LoanRequest where  loan_status=1 and date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) ").size()}
            </td>
            <td>${loans.LoanRequest.executeQuery("from LoanRequest where  loan_status=0 and date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) ").size()}
            </td>
            <td>
                ${loans.LoanRequest.countByLoan_status(1)}
            </td>
        </tr>
    </table>

    <g:each in="${admin.Customers.findAllByLoan_allowed(true)}" var="customerInstance" status="l">
        <% l=l+1; %>
        <h5>${l}. ${customerInstance.name}</h5>

        <table border="1" class="table_class">
            <tr>
                <td>TODAY REQUEST</td>
                <td>TODAY REPAYMENT</td>
                <td>GENERAL TOTAL REQUEST</td>
                <td>GENERAL TOTAL REPAYMENT</td>
                <td>PAID FEE</td>
            </tr>

            <tr>
                <td>
                    <%
                        def totalAmountData = 0;
                        try {
                            totalAmountData = loans.LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and user_id.user_group=?", [customerInstance])[0]
                            if (!totalAmountData) {
                                totalAmountData = 0
                            }
                        } catch (Exception e) {

                        }

                        def totalRepaymentData = 0;
                        try {
                            totalRepaymentData = loans.LoanRepayment.executeQuery("select sum (amount_paid) from LoanRepayment where  date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and user_id.user_group=?", [customerInstance])[0]
                            if (!totalRepaymentData) {
                                totalRepaymentData = 0
                            }
                        } catch (Exception e) {

                        }


                    %>
                    ${formatAmountString(name: (int) totalAmountData)} TZS

                </td>
                <td>${formatAmountString(name: (int) totalRepaymentData)} TZS
                </td>
                <td>

                    <%
                    def amontL=loans.LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and user_id.user_group=?", [customerInstance])[0]
                        if(!amontL){
                            amontL=0
                        }
                        %>
                    <%
                        def amountLi=loans.LoanRepayment.executeQuery("select sum (amount_paid) from LoanRepayment  where user_id.user_group=?", [customerInstance])[0]
                        if(!amountLi){
                            amountLi=0
                        }

                    %>
                    ${formatAmountString(name: (int)amontL )} TZS
                </td>
                <td>${formatAmountString(name: (int)amountLi )} TZS
                </td>

                <td>
                    <%
                        def totalPaidAmount = loans.LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and loan_repaid=1 and user_id.user_group=?", [customerInstance])[0];

                        def totalPaidAmountInterest = loans.LoanRequest.executeQuery("select sum (loan_amount_total) from LoanRequest where loan_status=2 and loan_repaid=1 and user_id.user_group=?", [customerInstance])[0];




                        def feesAmount = totalPaidAmountInterest - totalPaidAmount

                    %>

                    ${formatAmountString(name: (int) feesAmount)} TZS

                </td>

            </tr>

            <tr>
                <td>
                    ${loans.LoanRequest.executeQuery("from LoanRequest where  loan_status=2 and date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and user_id.user_group=?", [customerInstance]).size()}

                </td>
                <td>
                    ${LoanRepayment.executeQuery("from LoanRepayment where  date(created_at)=DATE(CURRENT_DATE()) and month(created_at)=MONTH(CURRENT_DATE()) and year(created_at)=YEAR(CURRENT_DATE) and user_id.user_group=?", [customerInstance]).size()}

                </td>
                <td>
                    ${loans.LoanRequest.executeQuery("from LoanRequest where user_id.user_group=? and loan_status=2", [customerInstance]).size()}
                </td>
                <td>
                    ${loans.LoanRepayment.executeQuery("from LoanRepayment where user_id.user_group=? ", [customerInstance]).size()}

                </td>
                <td>-</td>

            </tr>
        </table>
    </g:each>
</div>
</body>
</html>