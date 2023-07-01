package admin

import finance.UserLogs
import grails.converters.JSON
import grails.gorm.transactions.Transactional
import loans.CardPayments
import loans.LoanRequest
import org.grails.web.json.JSONObject

class HomeController {
    def mailService

    def index() { }


    def encodeStringsTest(){

       // String username="pkangombe1@datavision.co.tz"
        //String password="163988"
         String username="info@kopafasta.co.tz"
        String password="033614"
       String outputusername=username.bytes.encodeBase64().toString()
       println(outputusername)

       String passwordoutput=password.bytes.encodeBase64().toString()
       println(passwordoutput)


       render  outputusername+"  :  "+passwordoutput

   }



    @Transactional
    def cardPayments() {
        def response = request.JSON
        //JSONObject response = new JSONObject()
        println("response:" + response)


        if (response) {
            def action = response.ACTION
            def mkey = response.MKEY

            if (action == "VALIDATE") {

                String reference = response.REFERENCE
                def amount = response.AMOUNT

                //println("reference:"+reference)

                def responseStatus = "NOT_VALID"


                    String regno = reference.substring(3)
                    def employeeNo = SecUser.countByRegistration_no(regno)

                    if (employeeNo > 0) {
                        def userInstance = SecUser.findByRegistration_no(regno)

                            def amountD = Double.parseDouble(amount)

                            if (userInstance.have_loan) {

                                if (amountD >= 8700) {
                                    responseStatus = "SUCCESS"
                                } else {
                                    if (userInstance.loan_amount <= amountD) {
                                        responseStatus = "SUCCESS"
                                    } else {
                                        responseStatus = "NOT_VALID"
                                    }
                                }

                            } else {
                                if (amountD >= 1000) {
                                    responseStatus = "SUCCESS"
                                } else {
                                    responseStatus = "NOT_VALID"
                                }
                            }



                }

                JSONObject transaction = new JSONObject()
                transaction.put("MKEY", mkey)
                transaction.put("ACTION", action)
                transaction.put("REFERENCE", reference)
                transaction.put("STATUS", responseStatus)

                // println("response:"+transaction.toString())


                render transaction as JSON

            } else if (action == "TRANS") {

                def reference = response.reference
                def receipt = response.receipt



                    def countTransaction = CardPayments.countByMkey(mkey)
                    String regno = reference.substring(3)

                    def employeeInstance = SecUser.findByRegistration_no(regno)
                    def clientId = employeeInstance.id
                    def clientName = employeeInstance.full_name

                    if (countTransaction > 0) {
                        JSONObject transaction = new JSONObject()
                        transaction.put("status", "DUPLICATE")
                        transaction.put("receipt", receipt)
                        transaction.put("clientID", clientId)
                        transaction.put("clientName", clientName)

                        render transaction as JSON

                    } else {


                        def instanceConfig = PaymentConfig.get(1)





                        def timestamp = response.timestamp

                        def amount = response.amount
                        def charges = response.charges
                        def msisdn = response.msisdn

                        Double payments_amount = Double.parseDouble(amount)

                        Double user_credits = employeeInstance.payment_credit + payments_amount

                        def saveCardPayment = new CardPayments()
                        // saveCardServices.paid_at = timestamp
                        saveCardPayment.registration_no = reference
                        saveCardPayment.amount_paid = payments_amount

                        saveCardPayment.user_id = employeeInstance
                        saveCardPayment.mkey = mkey
                        saveCardPayment.mlipa_feedback = response.toString()
                        if (saveCardPayment.save(failOnError: true)) {
                            def userid = employeeInstance.id
                            SecUser.executeUpdate("update SecUser set payment_credit=? where id=? ", [user_credits, userid])
                            JSONObject transaction = new JSONObject()
                            transaction.put("status", "SUCCESS")
                            transaction.put("receipt", receipt)
                            transaction.put("clientID", clientId)
                            transaction.put("clientName", clientName)

                            def userLogsInstanceD = new UserLogs()
                            userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("PAL")
                            userLogsInstanceD.user_id = employeeInstance
                            userLogsInstanceD.message = "Paid amount from mlipa: " + response.toString()
                            userLogsInstanceD.save()

                            // println("response:"+transaction.toString())
                            try {
                                String phonenumber = employeeInstance.phone_number.replace("+", "")

                                String returnUrl = grailsApplication.config.deliverySMS + "/confirmPaymentSMS"



                                //def phonenumber = phonenumber.replace("+", "")


                            } catch (Exception e) {
                                e.printStackTrace()
                            }


                            render transaction as JSON
                        } else {
                            render status: 400, text: "Failed"
                        }


                }
            } else {
                //println("none:"+jsonObject.toString())

                render status: 405, text: "Failed"
            }

        } else {
            render status: 403, text: "Failed"
        }
    }


    def pdfRenderingSample(){
        def reportObject = CustomerPayments.get(3)

        def bytes = pdfRenderingService.render(template: '/customerPayments/paymentPDF', model: [report: reportObject])
        render bytes.toString()

    }

    def monthlyReport() {
       // def email_address = "pkangombe@datavision.co.tz"

        println("called:"+params)

        def from_address = "kopafasta.service@gmail.com"



        try {
            def reportObject = CustomerPayments.findAllByPaidAndNotified(false,false)
            reportObject.each {
                def paymentInstance=it
                def email_address = it.customer_id.accountant_email

                mailService.sendMail {
                    try {
                        async true
                        multipart true
                        //  def name = clientName
                        to email_address,paymentInstance.customer_id.hr_email,paymentInstance.customer_id.ceo_email
                        from from_address
                       // bcc "fjoseph@datavision.co.tz"
                        cc "pkangombe@datavision.co.tz"
                        //bcc "gmwaijonga@datavision.co.tz", "fjoseph@datavision.co.tz", "skiwanga@datavision.co.tz", "nyonazi@datavision.co.tz", "amyovella@datavision.co.tz"
                        bcc "gmwaijonga@datavision.co.tz", "fjoseph@datavision.co.tz", "skiwanga@datavision.co.tz", "nyonazi@datavision.co.tz", "william.kihula@datavision.co.tz", "tq@datavision.co.tz","amyovella@datavision.co.tz","macleangm@datavision.co.tz"
                        // bcc "gmwaijonga@datavision.co.tz", "fjoseph@datavision.co.tz", "skiwanga@datavision.co.tz", "nyonazi@datavision.co.tz"
                        subject " Kopafasta request note."
                        text "Your Kopafasta  monthly invoice is available for PSGP. Please find the PDF documents attached at the bottom of this email. "

                        ByteArrayOutputStream bytes = pdfRenderingService.render(template: '/customerPayments/paymentPDF', model: [report: paymentInstance])
                        String fileName = paymentInstance.customer_id.name + System.currentTimeMillis() + ".pdf"
                        attach fileName, "text/plain", bytes.toByteArray()
                        //html view: "/home/dailyReport"
                    } catch (Exception e) {
                        e.printStackTrace()
                    }
                }


                CustomerPayments.executeUpdate("update CustomerPayments set notified=1 where id=?", [paymentInstance.id])

            }

        } catch (Exception e) {
            e.printStackTrace()
        }
        render("ok")
    }

    def renderReport(){
        render(view: '/home/dailyReport')
    }

    @Transactional
    def saveTacipPayment(){
        def response = request.JSON

        println("Kopafasta:Card payment information-> "+response)

       // println(params)

        def instanceConfig = PaymentConfig.get(1)

        def configValue = instanceConfig.card_expired_years



        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.YEAR, configValue)
        Date nextYear = cal.getTime()
        def expired_date = nextYear


        String reference = response.reference

        def timestamp = response.timestamp

        def amount = response.amount
        def charges = response.charges
        def msisdn = response.msisdn
        def mkey = response.MKEY



        Double payments_amount = Double.parseDouble(amount)

        String regno=reference.substring(3)
        def employeeNo = SecUser.findByRegistration_no(regno)

        if(employeeNo) {
            if(CardPayments.countByMkey(mkey)==0) {
                def saveCardPayment = new CardPayments()
                // saveCardServices.paid_at = timestamp
                saveCardPayment.registration_no = reference
                saveCardPayment.amount_paid = payments_amount
                saveCardPayment.user_id = employeeNo
                saveCardPayment.mkey = mkey
                saveCardPayment.mlipa_feedback = response.toString()
                if (saveCardPayment.save(failOnError: true)) {

                    def amountcredits = employeeNo.payment_credit + payments_amount
                    SecUser.executeUpdate("update SecUser set payment_credit=? where id=? ", [amountcredits, employeeNo.id])

                }
            }
        }
        render status: 200
        }
    @Transactional
    def paymentFeedBack() {
        def jsonObject = request.JSON
        //String json='{"name":"","receipt":"6CK625AEAI2","comment":"Process service request successfully.- 0","txnID":"TACIP20190215091696"}'
        //JSONObject jsonObject = new JSONObject(json)

        JSONObject response = new JSONObject()


        println("output:"+jsonObject.toString())

        if (jsonObject) {
            def txnID = jsonObject.txnID
            def feebback=jsonObject.toString()
            //def receipt = jsonObject.receipt
            //def name = jsonObject.name
            // def comment = jsonObject.comment

            /*def loanInstance=LoanRequest.findByRequest_code(txnID)
            loanInstance.payment_sent=true
            loanInstance.payment_feedback=feebback
            loanInstance.loan_repaid=false
            loanInstance.loan_status=2
            loanInstance.save()*/

            def loanInstance=LoanRequest.findByRequest_code(txnID)

            if(loanInstance.loan_status!=2) {
                LoanRequest.executeUpdate("update LoanRequest set payment_sent=1, payment_feedback=?, loan_repaid=0,loan_status=2 where request_code=? ", [feebback, txnID])


                int loan = 0
                try {
                    if (loanInstance.user_id.loan_amount > 0) {
                        if(loanInstance.user_id.user_group.loan_type.code.equals("IDLOAN")){
                            loan=0;
                        }else {
                            loan = loanInstance.user_id.loan_amount

                        }
                    }
                } catch (Exception e) {
                    // e.printStackTrace()
                }

                def totalloan = loan + loanInstance.loan_amount_total
                def user_id = loanInstance.user_id.id
                def name = loanInstance.user_id.full_name
              //  println("total:" + totalloan)

                //  LoanRequest.executeUpdate("update Payments set approved=1, payment_feedback=?  where request_code=? ", [feebback, txnID])

                String returnUrl = grailsApplication.config.deliverySMS + "/deliveryRegistration"
                def phonenumber = loanInstance.user_id.phone_number

                SecUser.executeUpdate("update SecUser set last_loan=?, loan_amount=?, have_loan=? where id=? ", [loanInstance, totalloan, true, user_id])


                def messagesent = "Ndugu " + name + " umafanikiwa kupokea mkopo wa Tsh " + loanInstance.amount +
                        " Unaruhusiwa kukopa mpaka kiwango chako cha mwisho kwa mwezi.  Vigezo na mashariti " +
                        " kuzingatiwa. Kwa mawasiliano piga simu kwenda  namba  0742024747."

                if(loanInstance.user_id.user_group.loan_type.code.equals("IDLOAN")){
                     messagesent = "Ndugu " + name + " umafanikiwa kupokea mkopo wa Tsh " + loanInstance.amount +
                            " Utatakiwa kurudisha ndani ya siku 30.  Vigezo na mashariti " +
                            " kuzingatiwa. Kwa mawasiliano piga simu kwenda  namba  0742024747."
                }else {
                    try {
                        updateTsiaLoanData(loanInstance.id)
                    }catch (Exception e){
                        e.printStackTrace()
                    }
                }


                String sms_mtandao_json = smsMtandaoSendMessagesLoan(phonenumber: phonenumber, messagesent: messagesent, returnUrl: returnUrl)



                try {
                    def userLogsInstanceD = new UserLogs()
                    userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("ALL")
                    userLogsInstanceD.user_id = loanInstance.user_id
                    userLogsInstanceD.message = messagesent
                    userLogsInstanceD.save()
                } catch (Exception e) {

                }
            }

            response.put("msg", "SUCCESS")
            render response,status: 200



        } else {
            response.put("msg", "SUCCESS")
            render response, status: 500
        }

    }

    def testLoanRequest(){
        updateTsiaLoanData(597)
        render("Done")
    }


    def dailyReport() {
        def email_address = "pkangombe@datavision.co.tz"
        def from_address = "kopafasta.service@gmail.com"



        try {

            if (params.t == "1") {

                mailService.sendMail {
                    try {
                        //  def name = clientName
                        async true
                        multipart true
                        to email_address
                        from from_address
                        cc "fjoseph@datavision.co.tz"

                        // cc "gmwaijonga@datavision.co.tz", "fjoseph@datavision.co.tz", "skiwanga@datavision.co.tz", "pkangombe@datavision.co.tz", "nyonazi@datavision.co.tz", "william.kihula@datavision.co.tz"
                        subject " Kopafasta Report."
                        //text "You have received payments for Tacip of "+amount+ " TZS from "+phonenumber+ " mobile number. "
                       html view: "/home/dailyReport"


                      /*  ByteArrayOutputStream bytes = pdfRenderingService.render(template: '/customerPayments/paymentPDF', model: [report: paymentInstance])
                        String fileName = System.currentTimeMillis() + ".pdf"
                        attach fileName, "text/plain", bytes.toByteArray()*/
                    } catch (Exception e) {
                        e.printStackTrace()
                    }
                }
            } else {
                mailService.sendMail {
                    try {
                        //  def name = clientName
                        to email_address
                        from from_address
                        //cc "fjoseph@datavision.co.tz"

                        cc "gmwaijonga@datavision.co.tz", "fjoseph@datavision.co.tz", "skiwanga@datavision.co.tz", "smpock@datavision.co.tz", "nyonazi@datavision.co.tz", "william.kihula@datavision.co.tz", "tq@datavision.co.tz","macleangm@datavision.co.tz","hmgoba@datavision.co.tz"
                        subject " Kopafasta Report."
                        //text "You have received payments for Tacip of "+amount+ " TZS from "+phonenumber+ " mobile number. "
                        html view: "/home/dailyReport"
                    } catch (Exception e) {
                        e.printStackTrace()
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace()
        }
        render("ok")
        // html view: "/home/emailPayment", model: [name: name, orderID: reference,amount:amount]
    }


    private void updateTsiaLoanData(def loanID) {
        try {

            println("called:"+loanID)
            def loanRequest = LoanRequest.get(loanID)

            String urls = grailsApplication.config.saveTsiaLoanDetails.toString()

           // urls="http://www.tacip.co.tz/tacip/home/saveLoanDetails"

            if (loanRequest.customer_id.code == "TACIP") {

                urls = grailsApplication.config.saveTacipLoanDetails.toString()


            }

            String parameters = "requested_amount=" + loanRequest.amount + "&company_id=" + loanRequest.customer_id.code + "&total_amount=" + loanRequest.loan_amount_total +
                    "&employee_id=" + loanRequest.user_id.registration_no + "&request_code=" + loanRequest.request_code + "&mlipa_feedback=" + loanRequest.mlipa_feedback + "&operator_comment=" + loanRequest.payment_feedback


            println(parameters)

            def output = null;
            String name = "1"
            def post = new URL(urls).openConnection()
            post.setRequestMethod("POST")
            post.setDoOutput(true)
            OutputStreamWriter wr = new OutputStreamWriter(post.getOutputStream())
            wr.write(parameters)
            wr.flush()

            def postRC = post.getResponseCode()


            if (postRC.equals(200)) {
                output = post.getInputStream().getText()

               // println(output)

            }

        }catch (Exception e){
e.printStackTrace()
        }

    }

}
