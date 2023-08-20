package finance

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import loans.LoanCalculatorService
import loans.LoanRepayment
import loans.LoanRequest
import loans.UserLoan
import org.grails.web.json.JSONArray
import org.grails.web.json.JSONObject

class GatewayController {

    LoanCalculatorService loanCalculatorService;

    def index() {}

    def request() {
        println(params)
        def action = params.action
        def phone_number = params.from
        def message_type = params.message_type
        JSONObject response = new JSONObject()
        JSONArray events = new JSONArray()

        JSONObject event = new JSONObject()
        if (action == "request" && message_type && message_type == "sms") {
            String message = params.message
            boolean success = saveLoanRequest(message.trim(), phone_number)
            if (success) {
                event.put("event", "log")
                event.put("message", "SMS Accepted")
            } else {
                event.put("event", "log")
                event.put("message", "No Outgoing SSM")
            }
        } else {
            event.put("event", "log")
            event.put("message", "No Outgoing SSM")
        }

        events.put(event)
        response.put("events", events)
        println(response)
        render response as JSON
    }

    def testData() {
        String sample = "id.56023083.kiasi.1000"
        def res = loanCalculatorService.testLoanRequest(null, 500)
        render res as JSON
    }

    @Transactional
    def saveLoanRequest(String msg, String mobileNo) {
        boolean success = true;
        String[] data = msg.split("\\.")
        if (data.length == 4) {
            def amount = data[3].replace(",", "")
            def regNo = data[1]

            def userInstance = SecUser.findByRegistration_no(regNo)

            if(userInstance) {

                String userMobileNumber = userInstance.phone_number
                if (userMobileNumber.length() == 10) {
                    userMobileNumber = "255" + userMobileNumber.substring(1)
                } else {
                    userMobileNumber = userMobileNumber.replace("+", "")
                }

                if (userInstance && userMobileNumber.replace("+", "") == mobileNo.replace("+", "") && Integer.parseInt(amount) <= userInstance.loan_limit) {
                    System.out.println("User loan request by " + userInstance.full_name + " no:" + userMobileNumber)

                    loanCalculatorService.genericSaveLoan(userInstance, Double.parseDouble(amount), userMobileNumber)

                } else {
                    println("Full Name: " + userInstance?.full_name)
                    System.out.println("User loan request by RegNo:" + regNo + " : Hana vigezo vya namba and loan limit")

                    success = false
                }
            } else {
                success = false;
            }
        } else {
            success = false;
        }

        return success;
    }

    def repayment() {
        def requestData = request.XML

        def remoteadd = request.getRemoteAddr()
        println("remote: "+remoteadd)

        def amount = requestData.AMOUNT.toString()
        def transId = requestData.TXNID
        def MSISDN = requestData.MSISDN

        def request_code = requestData.CUSTOMERREFERENCEID
        def loanInstance = LoanRequest.findByRequest_uniqueAndLoan_repaid(request_code, false)

        String errorCode = "error100"
        String errorMsg = ""
        String referenceId = "BP"+System.currentTimeMillis()
        String flag = "N"
        String content = "FAILED"
        String result = "TF"
        System.out.println("Amount:"+ amount)

        if(loanInstance) {
            def userBalance = UserLoan.findByUser(loanInstance.user_id)

            if (userBalance.unpaidLoan > 0 && userBalance.unpaidLoan >= Double.parseDouble(amount)) {
                if(LoanRepayment.countByTransId(transId) == 0) {
                    def userLoanRepayment = new LoanRepayment()
                    userLoanRepayment.loan_id = loanInstance
                    userLoanRepayment.amount_paid = Double.parseDouble(amount)
                    userLoanRepayment.user_id = loanInstance.user_id
                    userLoanRepayment.transId = transId
                    userLoanRepayment.requestId = referenceId

                    if (userLoanRepayment.save(failOnError: true)) {
                        def userLoanInstance = UserLoan.findByUser(loanInstance.user_id)
                        if (userLoanInstance.unpaidLoan <= 0) {
                            LoanRequest.executeUpdate("update LoanRequest set loan_repaid=1 where user_id=:userId", [userId: loanInstance.user_id])
                        }
                        flag = "Y"
                        errorCode = "error000"
                        content = "Malipo yamepokelewa."
                        result = "TS"
                    }
                } else {
                    errorCode = "error010"
                    errorMsg = "Reference number already received."
                }
            } else {
                if(userBalance.unpaidLoan <=0) {
                    errorCode = "error016"
                    errorMsg = "Invalid payment. User does not have any loan"
                } else {
                    errorCode = "error014"
                    errorMsg = "Amount too high. Try a smaller amount"
                }
            }
        } else {
            errorCode = "error010"
            errorMsg = "Invalid Customer Reference Number"
        }

        String phoneNumber = loanInstance == null ? MSISDN : loanInstance.user_id.phone_number
        if(phoneNumber.startsWith("255")) {
            phoneNumber = phoneNumber.substring(3)
            phoneNumber ="0"+phoneNumber
        }

        String xmlResult = "<COMMAND><TYPE>SYNC_BILLPAY_RESPONSE</TYPE><TXNID>"+transId+"</TXNID><REFID>"+referenceId+"</REFID><RESULT>"+result+"</RESULT><ERRORCODE>"+errorCode+"</ERRORCODE><ERRORDESC>"+errorMsg+"</ERRORDESC><MSISDN>"+phoneNumber+"</MSISDN> <FLAG>"+flag+"</FLAG> <CONTENT>"+content+"</CONTENT>" +
                "</COMMAND>"

        println("To Tigo response: "+xmlResult)

        def completeXml= new XmlSlurper().parseText(xmlResult)
        render(text: xmlResult, contentType: "text/xml", encoding: "UTF-8")
    }
}
