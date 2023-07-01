<%@ page import="loans.UnpaidLoan; loans.LoanRepayment; loans.LoanRequest" %>
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
    table, td, th {
        border: 1px solid black;
    }

    table {
        border-collapse: collapse;
        width: 100%;
        padding: 10px;
        margin: 10px;
    }

    th {
        height: 50px;
    }

    @page {
        size: 210mm 297mm;
    }
    </style>
</head>

<body>
<div class="row">
    <div class="col-lg-12">

        <h4>Kopafasta SUMMARY LOANS REPORT FROM ${start_date} TO ${end_date}</h4>




        <h3>Kopafasta</h3>

        <%
           // def totalLoans = com.tacip.loans.LoanRequest.countByLoan_status(2)
            def totalLoanedNo = SecUser.executeQuery("from SecUser where created_at<='" + end_date + "' ").size()


            def loanedMembers = loans.LoanRequest.executeQuery("from LoanRequest where  loan_status=2 group by user_id ").size()

           // def elIGibleMembers = CardServices.countByPaid(true)

            def notTakenLoan = totalLoanedNo - loanedMembers


            def totalLoaned = LoanRequest.executeQuery("from LoanRequest where  created_at>='" + start_date + "' and created_at<='" + end_date + "' and loan_status=2").size()



        %>

        <table>
            <tr>
                <td>S/No.</td><td>OPENING BALANCE</td>
                <td>LOANED MEMBERS</td>
                <td>NOT LOANED</td>
            </tr>

            <tr>
                <td>1</td>
                <td>${totalLoanedNo}</td>
                <td>${loanedMembers}</td>
                <td>${notTakenLoan}</td>

            </tr>
        </table>

        <h4>2. LOANS REPORT</h4>

        <h5>(A) ISSUED LOANS</h5>

        <%
            //def totalLoans=com.tacip.loans.LoanRequest.count()

            //def prevLoan=com.tacip.loans.LoanRequest.executeQuery("from LoanRequest where created_at<'"+start_date+"'  ").size()

            def prevLoanEndL = LoanRequest.executeQuery("from LoanRequest where created_at<'" + start_date + "' and loan_status=2  ").size()

            //  def totalLoaned=com.tacip.loans.LoanRequest.executeQuery("from LoanRequest where  created_at>='"+start_date+"' and created_at<='"+end_date+"'").size()

            def loadAmT = LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and created_at<'" + start_date + "' ")[0]
            if(!loadAmT){
                loadAmT=0
            }
            def loanBtnT = LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and created_at>='" + start_date + "' and created_at<='" + end_date + "' ")[0]

            if(!loanBtnT){
                loanBtnT=0
            }

            def dataLoanAmount = formatAmountString(name: (int)loadAmT)

            def dataLoanAmountBtn = formatAmountString(name: (int)loanBtnT)

            def newLoanTtl = totalLoaned + prevLoanEndL

            int dataLoanAmountTl = loadAmT + loanBtnT

        %>

        <table>
            <tr>
                <td>S/No.</td>
                <td>OPENING BALANCE</td>
                <td>TZS</td>
                <td>ISSUED LOAN</td>
                <td>TZS</td><td>TOTAL</td><td>TZS</td>
            </tr>

            <tr>
                <td>1</td>
                <td>${prevLoanEndL}</td>
                <td>${dataLoanAmount}</td>
                <td>${totalLoaned}</td>
                <td>${dataLoanAmountBtn} TZS</td>
                <td>${newLoanTtl}</td>
                <td>${formatAmountString(name: dataLoanAmountTl)}</td>
            </tr>
        </table>
        <%

            def loanReq = LoanRequest.executeQuery("from LoanRequest where created_at<'" + end_date + "' and loan_repaid=1 and loan_status=2 ").size()

            def loanReqSum = LoanRequest.executeQuery("select sum (amount) from LoanRequest where created_at<'" + end_date + "' and loan_repaid=1 and loan_status=2")[0]
            if(!loanReqSum){
                loanReqSum=0
            }


            def loanReqSumInt = LoanRequest.executeQuery("select sum (loan_amount_total) from LoanRequest where created_at<'" + end_date + "' and loan_repaid=1 and loan_status=2 ")[0]

            if(!loanReqSumInt){
                loanReqSumInt=0
            }


            int inrestDT = loanReqSumInt - loanReqSum

            int loanReqPatials = LoanRequest.executeQuery("from LoanRequest where created_at<'" + end_date + "' and loan_repaid=0 and loan_status=2").size()


            def paymenTotals=loans.LoanRepayment.executeQuery("select sum (amount_paid) from LoanRepayment where created_at<'" + end_date + "' ")[0]
            if(!paymenTotals){
                paymenTotals=0
            }

            int loanAmountReqPatials=paymenTotals-loanReqSumInt

            //int loanAmountReqPatials = com.tacip.loans.LoanRequest.executeQuery("select sum (loan_amount_total) from LoanRequest where created_at<'" + end_date + "' and loan_repaid=0 and loan_status=2")[0]



            int loanFee = loanAmountReqPatials/11
            int loanAmountReqPatialsP =loanAmountReqPatials-loanFee

            int totalPre = loanReqPatials + loanReq


            int moneysNointes = loanAmountReqPatials + loanReqSumInt

            int interestTotal = inrestDT + loanFee


            int totalPrinciples = loanAmountReqPatialsP + loanReqSum
        %>


        <h5>(B) REPAID LOANS STATUS</h5>
        <table>
            <tr>
                <td>S/No.</td>
                <td>LOAN STATUS</td>
                <td>FULLY REPAID</td><td>TZS</td><td>PARTIAL REPAID</td><td>TZS</td><td>CLOSING BAL</td><td>TZS</td>
            </tr>
            <tr><td>1</td><td>PRINCIPAL</td><td>${loanReq}</td><td>${formatAmountString(name: (int)loanReqSum)}</td><td>${loanReqPatials}</td><td>${formatAmountString(name: loanAmountReqPatialsP)}</td><td>${totalPre}</td><td>${formatAmountString(name: totalPrinciples)}</td>
            </tr>
            <tr><td>2</td><td>LOAN FEE</td><td></td><td>${formatAmountString(name: inrestDT)}</td><td></td><td>${formatAmountString(name: loanFee)}</td><td></td><td>${formatAmountString(name: interestTotal)}</td>
            </tr>
            <tr><td>3</td><td>TOTAL</td><td>${loanReq}</td><td>${formatAmountString(name: (int)loanReqSumInt)}</td><td>${loanReqPatials}</td><td>${formatAmountString(name: loanAmountReqPatials)}</td><td>${totalPre}</td><td>${formatAmountString(name: moneysNointes)}</td>
            </tr>
        </table>
        <%
            def prevRepaymentEndL = LoanRepayment.executeQuery("from LoanRepayment where created_at>='" + start_date + "' and created_at<='" + end_date + "'  group by loan_id  ").size()

            def receivedBefore = LoanRepayment.executeQuery("from LoanRepayment where  created_at<'" + start_date + "'  group by loan_id ").size()

            def totalPaid = prevRepaymentEndL + receivedBefore



            def repaymemntLoanAmT = LoanRepayment.executeQuery("select sum (amount_paid) from LoanRepayment where created_at>='" + start_date + "' and  created_at<='" + end_date + "' ")[0]

            if(!repaymemntLoanAmT){
                repaymemntLoanAmT=0
            }

            def repaymemntLoanAmTBtn = LoanRepayment.executeQuery("select sum (amount_paid) from LoanRepayment where  created_at>='" + start_date + "' and created_at<='" + end_date + "'")[0]

            if(!repaymemntLoanAmTBtn){
                repaymemntLoanAmTBtn=0
            }





            int totalAmountData = (int)moneysNointes - (int)repaymemntLoanAmT

            int interestDataBfr=totalAmountData/11

            int totalPrinciplesBfr=totalAmountData-interestDataBfr



            int interestData = repaymemntLoanAmT / 11

            int principleData = repaymemntLoanAmT - interestData


            int startData=totalPre-prevRepaymentEndL



        %>

        <h5>(C) TOTAL REPAID LOANS</h5>
        <table>
            <tr>
                <td>S/No.</td>
                <td></td>
                <td>OPENING BAL</td><td>TZS</td><td>LOANS</td><td>TZS</td><td>CLOSING BAL</td><td>TZS</td>
            </tr>
            <tr><td>1</td><td>PRINCIPAL</td><td>${receivedBefore}</td><td>${formatAmountString(name: totalPrinciplesBfr)}</td><td>${prevRepaymentEndL}</td><td>${formatAmountString(name: principleData)}</td><td>${totalPaid}</td><td>${formatAmountString(name: totalPrinciples)}</td>
            </tr>
            <tr><td>2</td><td>LOAN FEE</td><td></td><td>${formatAmountString(name: interestDataBfr)}</td><td></td><td>${formatAmountString(name: interestData)}</td><td></td><td>${formatAmountString(name: interestTotal)}</td>
            </tr>
            <tr><td>3</td><td>TOTAL</td><td>${receivedBefore}</td><td>${formatAmountString(name: totalAmountData)}</td><td>${prevRepaymentEndL}</td><td>${formatAmountString(name: (int)repaymemntLoanAmT)}</td><td>${totalPaid}</td><td>${formatAmountString(name: moneysNointes)}</td>
            </tr>
        </table>
        <%
           def prevNotPaid = LoanRequest.executeQuery("from LoanRequest where created_at<'" + start_date + "' and loan_repaid=false and loan_status=2 ").size()





            int interestsNot = (int)dataLoanAmountTl / 11
            def principleNot = (int)dataLoanAmountTl - interestsNot

            def prevNotPaidBtn =LoanRequest.executeQuery("from LoanRequest where created_at<='" + end_date + "' and loan_repaid=false and loan_status=2 ").size()

            def loanAmountNotPaid = (int)dataLoanAmountTl-moneysNointes

            int interestDataNot = loanAmountNotPaid / 11
            int principleNotPaid = loanAmountNotPaid - interestDataNot

            int remzinedPayment=newLoanTtl-totalPaid


            def usersWithLoan=SecUser.countByHave_loan(true);

        %>
        <h5>(D) OUTSTANDING  LOANS</h5>

        <table>
            <tr>
                <td>S/No.</td>
                <td></td>
                <td>OPENING BAL</td><td>TZS</td><td>LOANS</td><td>TZS</td><td>CLOSING BAL</td><td>TZS</td>
            </tr>
            <tr><td>1</td><td>PRINCIPAL</td><td>${newLoanTtl}</td><td>${formatAmountString(name: principleNot)}</td><td>${totalPaid}</td><td>${formatAmountString(name: totalPrinciples)}</td><td>${usersWithLoan}</td><td>${formatAmountString(name:principleNotPaid)}</td>
            </tr>
            <tr><td>2</td><td>LOAN FEE</td><td></td><td>${formatAmountString(name: interestsNot)}</td><td></td><td>${formatAmountString(name: interestTotal)}</td><td></td><td>${formatAmountString(name: interestDataNot)}</td>
            </tr>
            <tr><td>3</td><td>TOTAL</td><td>${newLoanTtl}</td><td>${formatAmountString(name: (int)dataLoanAmountTl)}</td><td>${totalPaid}</td><td>${formatAmountString(name: moneysNointes)}</td><td>${usersWithLoan}</td><td>${formatAmountString(name: loanAmountNotPaid)}</td>
            </tr>
        </table>


    </div>
</div>
</body>
</html>