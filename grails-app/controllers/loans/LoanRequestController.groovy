package loans

import admin.*
import finance.SecUser
import finance.UserLogs
import grails.converters.JSON
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.util.Environment
import grails.validation.ValidationException
import org.grails.web.json.JSONObject
import pl.touk.excel.export.WebXlsxExporter

import java.sql.Timestamp
import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN','ROLE_LOAN','ROLE_MANAGER'])
class LoanRequestController {
    def springSecurityService

    LoanRequestService loanRequestService
    MpesaService mpesaService;

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        if(!params.sort) {
            params.sort = 'created_at'
            params.order = 'desc'
        }
        session["activePage"] = "loans"

        params.max = Math.min(max ?: 10, 100)
        respond loanRequestService.list(params), model:[loanRequestCount: loanRequestService.count()]
    }


    def printLoanExcel(){
        def nameData=System.currentTimeMillis()+".xlsx"
        // def zailspath = servletContext.getRealPath("/") + "csvfiles/"+nameData

        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }


        def userData=LoanRequest.findAllByLoan_status(2,params)
        // def userData=CardServices.executeQuery("from CardServices where card_status=203 and user_id.region_id.id=3").user_id
        def headers = ['Name', 'Registration  no', 'Phone no', 'Amount', 'Date','District','Ward','Location','Category']

        def withProperties = ['user_id.full_name', 'user_id.registration_no','user_id.phone_number', 'amount','created_at','user_id.recruitment_district.name','user_id.recruitment_ward','user_id.location_name','user_id.art_category_id.name']
        /* new XlsxExporter(zailspath).
         //setResponseHeaders(response).
         // fillHeader(headers).
                 add(userData, withProperties).
                 save()*/
        try {
            new WebXlsxExporter().with {
                def responseD = response.outputStream
                setResponseHeaders(response)
                fillHeader(headers)
                add(userData, withProperties)
                save(responseD)
            }
        }catch (Exception e){

        }

        flash.message= "Successfully printed"
        //redirect(action: 'index')
    }

    def show(Long id) {
        respond loanRequestService.get(id)
    }

    def reports(){
        session["activePage"] = "dashboard"
        render(view: 'reports')
    }
    @Transactional
    def saveTacipLoanRequest(){
        println("Kopafasta Request: "+params)
        def card_no=params.card_no
        def registration_no=params.registration_no
        def totalloan=Double.parseDouble(params.totalloan)

        def dataInstance=SecUser.findByRegistration_no(registration_no)
        def loadRequestInstance = null;
        String request_code=params.request_code

        if(!dataInstance) {
            String outputTacip = callTacipHttp(card_no: card_no, returnUrl: grailsApplication.config.tacipData.toString())

            def loaninstance=LoanRequest.findByRequest_code(request_code)
            if(!loaninstance){
                println(request_code+" "+dataInstance+" "+outputTacip)
            }

            outputTacip = outputTacip.replace("&quot;", '"')
            JSONObject jsonObject = new JSONObject(outputTacip)


            Boolean user_valid = jsonObject.get("user_valid")
            if (user_valid) {
              //  outputTacip = callTsiaHttp(card_no: card_no, returnUrl: grailsApplication.config.tsiadata.toString())
               // outputTacip = outputTacip.replace("&quot;", '"')
               // jsonObject = new JSONObject(outputTacip)
                jsonObject.put("loan_type", "ORLOAN")
                dataInstance = saveUsersDetails(jsonObject, "TACIP")

                Boolean loan_repaid=Boolean.parseBoolean(params.loan_repaid)
                def have_loan=Boolean.parseBoolean(params.have_loan)

                def user_loan_amount=Double.parseDouble(params.user_loan_amount)

              //  println(userInstance+" data")
                if(LoanRequest.countByRequest_code(request_code)==0) {


                    // println(date_paid)

                        def current_time = Calendar.instance
                    def created_atd = new java.sql.Timestamp(current_time.time.time)


                    def date_paid=params.date_paid


                    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                    def date =  new java.sql.Timestamp(date_paid)


                    loadRequestInstance = new LoanRequest()
                    loadRequestInstance.amount = Double.parseDouble(params.amount)
                    loadRequestInstance.user_id = dataInstance
                    loadRequestInstance.request_code = params.request_code
                    loadRequestInstance.interest_percentage = Float.parseFloat(params.interest_percentage)
                    loadRequestInstance.instruments = Integer.parseInt(params.instruments)
                    loadRequestInstance.mobile_number = params.mobile_number
                    loadRequestInstance.customer_id=Customers.findByCode("TACIP")
                    loadRequestInstance.loan_amount_total = Double.parseDouble(params.loan_amount_total)
                    loadRequestInstance.mlipa_feedback = params.mlipa_feedback
                    loadRequestInstance.payment_feedback = params.payment_feedback
                    loadRequestInstance.loan_status = Integer.parseInt(params.loan_status)
                    loadRequestInstance.loan_repaid=loan_repaid
                    loadRequestInstance.created_at=date
                    loadRequestInstance.save(failOnError: true)

                    if(!loan_repaid) {
                       // SecUser.executeUpdate("update SecUser set loan_amount=?,have_loan=? where id=? ", [user_loan_amount, have_loan, dataInstance.id])
                    }else {
                     //   SecUser.executeUpdate("update SecUser set loan_amount=?,have_loan=?,last_loan=? where id=? ", [user_loan_amount, have_loan,loadRequestInstance, dataInstance.id])

                    }
                }else {
                    def date_paid=params.date_paid
                    def created_atd=null
                    // println(date_paid)

                    if(date_paid){
                        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                        Date date = (Date) formatter.parse(date_paid)


                        created_atd=new Timestamp(date.getTime());
                    }else {
                        def current_time = Calendar.instance
                        created_atd = new java.sql.Timestamp(current_time.time.time)

                    }


                   // LoanRequest.executeUpdate("update LoanRequest set created_at=?,loan_repaid=? where request_code=? ",[created_atd,loan_repaid,request_code])


                //    SecUser.executeUpdate("update SecUser set loan_amount=?,have_loan=? where id=? ",[user_loan_amount,have_loan,dataInstance.id])

                }
             //   println(params)


            }
        }else {
            Boolean loan_repaid=Boolean.parseBoolean(params.loan_repaid)

            def user_loan_amount=Double.parseDouble(params.user_loan_amount)
            def have_loan=Boolean.parseBoolean(params.have_loan)


           // def date =  new java.sql.Timestamp(date_paid)

            //  println(userInstance+" data")
            if(LoanRequest.countByRequest_code(request_code)==0) {
                def current_time = Calendar.instance
                def date_paid=params.date_paid
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                Date date = (Date) formatter.parse(date_paid)


                def created_atd=new Timestamp(date.getTime());
                loadRequestInstance = new LoanRequest()
                loadRequestInstance.amount = Double.parseDouble(params.amount)
                loadRequestInstance.user_id = dataInstance
                loadRequestInstance.request_code = params.request_code
                loadRequestInstance.interest_percentage = Float.parseFloat(params.interest_percentage)
                loadRequestInstance.instruments = Integer.parseInt(params.instruments)
                loadRequestInstance.mobile_number = params.mobile_number
                loadRequestInstance.customer_id=Customers.findByCode("TACIP")
                loadRequestInstance.loan_amount_total = Double.parseDouble(params.loan_amount_total)
                loadRequestInstance.mlipa_feedback = params.mlipa_feedback
                loadRequestInstance.payment_feedback = params.payment_feedback
              //  loadRequestInstance.loan_status = 2
                loadRequestInstance.loan_repaid=loan_repaid
                loadRequestInstance.created_at=created_atd
                loadRequestInstance.loan_status = Integer.parseInt(params.loan_status)

                loadRequestInstance.save(failOnError: true)
                SecUser.executeUpdate("update SecUser set loan_amount=?,have_loan=? where id=? ",[user_loan_amount,have_loan,dataInstance.id])

            }else{
                println("done")
                def date_paid=params.date_paid
                def created_atd=null
                // println(date_paid)

                if(date_paid){
                    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                    Date date = (Date) formatter.parse(date_paid)


                    created_atd=new Timestamp(date.getTime());
                }else {
                    def current_time = Calendar.instance
                    created_atd = new java.sql.Timestamp(current_time.time.time)

                }
                LoanRequest.executeUpdate("update LoanRequest set created_at=?,loan_repaid=? where request_code=? ",[created_atd,loan_repaid,request_code])

                //println(user_loan_amount+" : "+have_loan+" : "+dataInstance.id+" "+dataInstance.full_name)

               // SecUser.executeUpdate("update SecUser set loan_amount=?,have_loan=? where id=? ",[user_loan_amount,have_loan,dataInstance.id])

            }

        }

       // SecUser.executeUpdate("update SecUser set last_loan=?, loan_amount=?, have_loan=? where id=? ",[loadRequestInstance,totalloan,true,dataInstance.id])

        render("Done")
    }


    private SecUser saveUsersDetails(JSONObject jsonObjectData, String loan_src){
        String reg_no=jsonObjectData.get("user_id")
        def userID=SecUser.findByRegistration_no(reg_no)
        String customer_code=jsonObjectData.get("customer_code")
        String customer_name=jsonObjectData.get("customer_name")

        if(!userID) {
            def userInstance=new SecUser()
            userInstance.full_name=jsonObjectData.get("full_name")
            userInstance.recent_photo=jsonObjectData.get("recent_photo")
            userInstance.phone_number=jsonObjectData.get("phone_number")
            userInstance.username=reg_no
            userInstance.description=jsonObjectData.get("description")
            userInstance.user_group=Customers.findOrSaveWhere(code:customer_code,name: customer_name )
            userInstance.password=System.currentTimeMillis().toString()
            userInstance.gender=jsonObjectData.get("gender")
            if(loan_src=="TACIP") {
                if(jsonObjectData.has("ward")) {
                    userInstance.district_id = District.get(jsonObjectData.get("district_id"))
                }
                if(jsonObjectData.has("ward"))
                userInstance.ward = Wards.get(jsonObjectData.get("ward"))
            }else if(loan_src=="PSGP"){
                try {
                    userInstance.district_id = District.findByName(jsonObjectData.get("district_id"))
                    userInstance.ward = Wards.findByName(jsonObjectData.get("ward"))
                }catch (Exception e){

                }
            }
            userInstance.registration_no=reg_no
            userInstance.save(failOnError:true)
            userID=userInstance
        }
        return  userID;
    }


    def create() {
        respond new LoanRequest(params)
    }

    @Secured(['ROLE_ADMIN'])
    @Transactional
    def changeLoanStatus(){
        def loanInstance=LoanRequest.get(params.id)
        loanInstance.loan_status=5
        loanInstance.save()
        redirect(action: 'show',params:[id:params.id])
    }

    @Secured(['ROLE_ADMIN'])
    @Transactional
    def processLoan() {
        println(params)
        def loanInstance=LoanRequest.get(params.id)
        loanInstance.loan_status=6
        loanInstance.loan_repaid=false
        loanInstance.payment_sent=true
        JSONObject output = null;
        if(loanInstance.save(failOnError:true,flush:true)){
            output =  mpesaService.processLoan(loanInstance.amount,loanInstance.request_unique,loanInstance.request_unique, loanInstance.user_id.phone_number)
        }
        String msg = output.get("message")
        flash.message ="Msg : "+msg
        if(output.get("code")==201) {
            LoanRequest.executeUpdate("update LoanRequest set loan_status=2, mlipa_feedback=:msg where id=:id", [msg:msg, id:loanInstance.id])
        } else {
            LoanRequest.executeUpdate("update LoanRequest set loan_status=0, mlipa_feedback=:msg where id=:id", [msg:msg, id:loanInstance.id])
        }
        redirect(action: 'show',params:[id:params.id])
    }

    @Transactional
    def resendPaymentsSuccess(){

        def loanInstance=LoanRequest.get(params.id)
        loanInstance.payment_sent=true
        loanInstance.payment_feedback="Successfully sent"
        loanInstance.loan_repaid=false
        loanInstance.loan_status=2
        loanInstance.save()

        int loan=0
        try {
            if (loanInstance.user_id.loan_amount > 0) {
                loan=loanInstance.user_id.loan_amount
            }
        }catch (Exception e){
            e.printStackTrace()
        }


        def totalloan=loan+loanInstance.loan_amount_total
        def user_id=loanInstance.user_id.id
        def name=loanInstance.user_id.full_name
        println("total:"+totalloan)

        //  LoanRequest.executeUpdate("update Payments set approved=1, payment_feedback=?  where request_code=? ", [feebback, txnID])

        String returnUrl = grailsApplication.config.deliverySMS + "/deliveryRegistration"
        def phonenumber=loanInstance.user_id.phone_number

        //User.executeUpdate("update User set last_loan=?, loan_amount=?, have_loan=? where id=? ",[loanInstance,totalloan,true,user_id])
        SecUser.executeUpdate("update SecUser set last_loan=:loanInstance, loan_amount=:totalloan, have_loan=:hasLoan where id=:userInstance ", [loanInstance:loanInstance, totalloan:totalloan, hasLoan:true, userInstance:user_id])


        def messagesent = "Ndugu " + name + " umafanikiwa kupokea mkopo wa Tsh " + loanInstance.amount +
                " Unaruhusiwa kukopa mpaka kiwango chako cha mwisho kwa mwezi.  Vigezo na mashariti " +
                " kuzingatiwa. Kwa mawasiliano piga simu kwenda  namba  0742024747."
        String sms_mtandao_json = smsMtandaoSendMessagesLoan(phonenumber: phonenumber, messagesent: messagesent, returnUrl: returnUrl)


        try {
            updateTsiaLoanData(loanInstance.id)
        }catch (Exception e){
            e.printStackTrace()
        }



        def userLogsInstanceD=new UserLogs()
        userLogsInstanceD.dictionary_id=DictionaryItem.findByCode("ALL")
        userLogsInstanceD.user_id=loanInstance.user_id
        userLogsInstanceD.message=messagesent
        userLogsInstanceD.save()
        flash.message="Texts sent"
        redirect(action: 'show',params:[id:params.id])



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


    def encodeStringsTest() {

        def username = "pkangombe1@datavision.co.tz"
        def password = "150568"
        String outputusername = username.bytes.encodeBase64().toString()
        println(outputusername)

        String passwordoutput = password.bytes.encodeBase64().toString()
        println(passwordoutput)

        render(outputusername + " : " + passwordoutput)

    }

    def pdfReports(){
        def nameRequest=System.currentTimeMillis()
        ///params.start_date="2018-11-28 00:11"
        //params.end_date="2018-12-05 23:11"
        renderPdf(template: "/loanRequest/printPDF",model: [start_date:params.start_date,end_date:params.end_date], filename: nameRequest+".pdf")
    }

    def todayDue(Integer max){
        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }
        params.max = Math.min(max ?: 5, 100)
        render(view: 'todayDue',params:params)
    }

    @Transactional
    def resendPayments(){
        // println("d:"+params)
        // if (request.method == 'POST') {
        def loadRepayments=LoanRequest.get(params.id)

        def user=loadRepayments.user_id
        if(user.loan_amount==0&&loadRepayments.loan_status==0) {

            def name=user.full_name
            def created_at =  new Date().toString()


            def request_code = "KOPAR" + created_at+user.id


            //def request_code = "KOPAR" + created_at+user.id


            String phonenumber = user.phone_number.replace("+", "")
            JSONObject authentication = new JSONObject()
            //authentication.put("username", "c2tpd2FuZ2ExQGRhdGF2aXNpb24uY28udHo=")
            //authentication.put("password", "MzcwMDU5")


            def usernames=user.user_group.mpesa_link.trim()
            def pwords=user.user_group.mpesa_username.trim()
            String returnUrl = grailsApplication.config.systemLink + "/home/paymentFeedBack"


            authentication.put("username",usernames)
            authentication.put("password", pwords)

            JSONObject transaction = new JSONObject()
            transaction.put("txnID", request_code)
            transaction.put("amount", Double.toString(loadRepayments.amount))
            transaction.put("mobile", phonenumber)
            transaction.put("name", name)
            transaction.put("callback", returnUrl)

            JSONObject paymentData = new JSONObject()
            paymentData.put("authentication", authentication)
            paymentData.put("transaction", transaction)
            String outputtexts = "empty"

            try {
                def post = new URL(user.user_group.mlipa_link).openConnection()
                def message = paymentData.toString()
                post.setRequestMethod("POST")
                post.setDoOutput(true)
                post.setRequestProperty("Content-Type", "application/json")
                post.getOutputStream().write(message.getBytes("UTF-8"))
                def postRC = post.getResponseCode()
                println("out:" + postRC)
                if (postRC.equals(200)) {
                    outputtexts = post.getInputStream().getText()
                    println("out:" + outputtexts)

                    JSONObject jsonObject = new JSONObject(outputtexts)
                    String status = jsonObject.getString("status")


                    //	println(status+":"+description)
                    if (status.equals("SUCCESS")) {
                        // loadRequestInstance.loan_status = 1

                        LoanRequest.executeUpdate("update LoanRequest set loan_status=1,request_code=?,mlipa_feedback=? where id=? ", [request_code,outputtexts,Integer.parseInt(params.id)])


                        def userLogsInstanceD=new UserLogs()
                        userLogsInstanceD.dictionary_id=DictionaryItem.findByCode("ALL")
                        userLogsInstanceD.user_id=user
                        userLogsInstanceD.message="Requested loan resend."
                        userLogsInstanceD.save()

                    } else {
                        LoanRequest.executeUpdate("update LoanRequest set loan_status=0,request_code=? where id=? ", [request_code,Integer.parseInt(params.id)])

                    }
                    flash.message= "Asante kwa kuomba mkopo. Utatumiwa muda si mrefu."

                } else {
                    flash.message= "Loan request failed"

                }
                //println(""+post.getInputStream().getText())

            } catch (IOException e) {
                //println("outtwo"+outputtexts)
                e.printStackTrace()
            }
        }else {
            flash.message= "Lipa mkopo wako wa nyuma kuweza kupata mkopo mwingine."

        }

        redirect(action: 'show',params:[id:params.id])

    }

    def requestLoanDetails(){
        println(params)
        def reg_no=params.reg_no
        def userInstance=SecUser.findByRegistration_no(reg_no)
        JSONObject jsonObject=new JSONObject()
        if(userInstance){
            jsonObject.put("valid",true)

            int loanAmount=userInstance.loan_limit-userInstance.loan_amount
            jsonObject.put("loan_limit",loanAmount)
            jsonObject.put("full_name",userInstance.full_name)
            jsonObject.put("phone_number",userInstance.phone_number)
            jsonObject.put("have_loan",userInstance.have_loan)
            jsonObject.put("loan_group",userInstance?.loan_group?.code)
            jsonObject.put("instrument",userInstance?.loan_group?.instruments)
            jsonObject.put("loan_max_amount",userInstance?.loan_group?.end_range)
            jsonObject.put("loan_interest",userInstance?.loan_group?.interest)
            jsonObject.put("kopafasta_fee",2000)
            jsonObject.put("message","Successfully")

        }else {
            jsonObject.put("valid",false)
        }

        println(jsonObject.toString())
        render jsonObject as JSON

    }

    @Transactional
    def requestLoan(){

        println(params)

        def employeeId=params.reg_no
       //def employeeId="5323417"
        //card_no="0C1547534327114"
        String outputTacip=null
      //  requestLoanMethods()

        // def amount = Double.parseDouble(params.requested_amount)
        //def installment=Integer.parseInt(params.installment)
        def amount=Integer.parseInt(params. requested_amount)
        //int amount=3000
        def installment=Integer.parseInt(params.installment)
        //int installment=1
        def userInstance=SecUser.findByRegistration_no(employeeId)

        def loanType=userInstance.user_group.loan_type.code

        JSONObject jsonObject=new JSONObject()

      //  if(!userInstance.have_loan&&loanType.equals("IDLOAN")&&userInstance.agent_active&&userInstance.agent_id.agent_float_amount>=amount&&userInstance.user_group.loan_allowed){
        if(!userInstance.have_loan&&loanType.equals("IDLOAN")&&userInstance.agent_active&&userInstance.user_group.loan_allowed&&userInstance.loan_enabled&&!userInstance.agent_id.agent_blocked){

            if(userInstance.agent_id.agent_type.code.equals("FREEA")){
                if(userInstance.agent_id.agent_float_amount>=amount){
                    jsonObject.put("status", 1)
                    jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yamwefanikiwa. Utapokea ujumbe wa uthibitisho hivi punde")
                    requestLoan0Methods(userInstance, amount, installment)
                }else{
                    jsonObject.put("status",0)
                    jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yameshindikana. Wasiliana na wakala wako kwa maelezo zaidi.")
                }
            }else {
                jsonObject.put("status", 1)
                jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yamwefanikiwa. Utapokea ujumbe wa uthibitisho hivi punde")
                requestLoan0Methods(userInstance, amount, installment)

            }


        }else{
            jsonObject.put("status",0)

            if(userInstance.have_loan) {
                jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yameshindikana. Rudisha mkopo kabla ya kuomba mwingine.")
            }else if(!userInstance.agent_active){
                jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yameshindikana. Jiunge na wakala aliyekaribu na wewe ili uweze kuomba mkopo..")
            }/*else if(userInstance.agent_id.agent_float_amount<amount){
                jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yameshindikana. Wasiliana na wakala wako kwa maelezo zaidi.")

            }*/else if(!userInstance.user_group.loan_allowed){
                jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yameshindikana. Wasiliana na wakala wako kwa maelezo zaidi.")
            }
            else if(!userInstance.loan_enabled){
                jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yameshindikana. Wasiliana na wakala wako kwa maelezo zaidi.")
            }else if(userInstance.agent_id.agent_blocked){
                jsonObject.put("message", "Maombi yako ya mkopo wa " + amount + " TZS yameshindikana. Endelea kusubili tukiwa tunashughulikia tatizo lako. Au piga simu 0742024747")
            }
        }
        if(loanType.equals("ORLOAN")&&userInstance.loan_enabled){

            def sumpayments = LoanRequest.executeQuery("select sum (amount) as total from LoanRequest where user_id=? and month(created_at)=MONTH(CURRENT_DATE())  " +
                    " and year(created_at)=YEAR(CURRENT_DATE) and loan_status=2", [userInstance])
            int totalloan=0

            if(sumpayments[0]){
                try {
                    totalloan = (int) sumpayments[0]
                }catch (Exception e){
                    totalloan=0;
                }
            }
            int loaneligible=userInstance.loan_limit-totalloan

            //println(loaneligible+" "+amount)

            if(userInstance.user_group.loan_allowed) {
                if (loaneligible >= amount&&amount<=1500000) {
                    if (Environment.current == Environment.PRODUCTION) {
                        requestLoan0MethodsOR(userInstance, amount, installment)
                    }
                    jsonObject.put("status",1)
                    jsonObject.put("message","Maombi yako ya mkopo wa "+amount+" TZS yamwefanikiwa. Utapokea ujumbe wa uthibitisho hivi punde")
                    requestLoan0Methods(userInstance,amount,installment)

                }
            }
        }

        render jsonObject as JSON
    }


    @Secured("isAuthenticated()")
    def search_user(Integer max){
        def seatchText=params.search_string
        try{
            if(seatchText.indexOf("0")==0){
                seatchText = seatchText.substring(1)
            }
        }catch (Exception e){

        }
        //println(seatchText)
        def searchstring="%"+seatchText+"%"
        params.max=10
        params.sort = 'id'
        params.order = 'desc'
        // params.max = Math.min(max ?: 10, 10)
        // def user_id=springSecurityService.principal.id
        //def company_id=User.get(user_id)?.company_id
        //def userInstance=null

        def userInstance = LoanRequest.executeQuery("from LoanRequest where user_id.full_name like :searchstring " +
                " or user_id.user_group.name like :searchstring or user_id.username like :searchstring or user_id.registration_no like :searchstring or user_id.phone_number like :searchstring " +
                "or user_id.district_id.name like :searchstring or user_id.district_id.region_id.name like :searchstring or user_id.ward.name like :searchstring or user_id.agent_id.full_name like :searchstring", [searchstring:searchstring],params)


        // println(searchstring+"out:"+employeeInstance)

        render  template: 'searchUserlist', model:[loanRequestList:userInstance]
    }


    private void requestLoan0MethodsOR(SecUser user,def  amount,def installment){

        Boolean successful_sent=false
        def name = user.full_name

        def created_at =  new Date().format( 'yyyyMMddHH' ).toString()


        def request_code = "KOPA" + created_at+user.id

        if(LoanRequest.countByRequest_code(request_code)==0&&LoanRequest.countByUser_idAndLoan_status(user,1)==0) {

            SecUser.executeUpdate("update SecUser set have_loan=? where id=? ", [true, user.id])


            String phonenumber = user.phone_number.replace("+", "")
            //phonenumber="255658043864"
            //JSONObject authentication = new JSONObject()

            //def instanceConfig = PaymentConfig.get(1)

            /*      def usernames=instanceConfig.mlipa_username.trim()
              def pwords=instanceConfig.mlipa_password.trim()

              authentication.put("username", usernames)
              authentication.put("password", pwords)
  */
            //authentication.put("username", "aW5mb0Brb3BhZmFzdGEuY28udHo=")
            // authentication.put("password", "MTIxNzcy")

            //def instanceConfig = PaymentConfig.get(1)

            def usernames=user.user_group.mlipa_username.trim()
              def pwords=user.user_group.mlipa_password.trim()
            String returnUrl = grailsApplication.config.systemLink + "/home/paymentFeedBack"


            JSONObject authentication = new JSONObject()
           // authentication.put("username", "cGthbmdvbWJlMUBkYXRhdmlzaW9uLmNvLnR6")
          //  authentication.put("password", "MTYzOTg4")

            authentication.put("username", usernames)
            authentication.put("password", pwords)

            JSONObject transaction = new JSONObject()
            transaction.put("txnID", request_code)
            transaction.put("amount", amount)
            transaction.put("mobile", phonenumber)
            transaction.put("name", name)
            transaction.put("callback", returnUrl)

            JSONObject paymentData = new JSONObject()
            paymentData.put("authentication", authentication)
            paymentData.put("transaction", transaction)
            String outputtexts = "empty"

            try {

                def post = new URL(user.user_group.mlipa_link).openConnection()
                def message = paymentData.toString()
                post.setRequestMethod("POST")
                post.setDoOutput(true)
                post.setRequestProperty("Content-Type", "application/json")
                post.getOutputStream().write(message.getBytes("UTF-8"))
                def postRC = post.getResponseCode()
                // println("out:" + postRC)
                if (postRC.equals(200)) {
                    outputtexts = post.getInputStream().getText()
                    println("out:" + outputtexts)

                    JSONObject jsonObject = new JSONObject(outputtexts)
                    String status = jsonObject.getString("status")
                    def interest = user.loan_group.interest
                   // def interest = 10

                    //def configurationData = PaymentConfig.get(1)
                    // int  kopafasta_fee=1000


                    def loanTotal = amount + ((interest / 100) * amount)
                    // String description = jsonObject.getString("description")
                    def loadRequestInstance = new LoanRequest()
                    loadRequestInstance.amount = amount
                    loadRequestInstance.user_id = user
                    loadRequestInstance.request_code = request_code
                    loadRequestInstance.interest_percentage = interest
                    loadRequestInstance.instruments = installment
                    loadRequestInstance.mobile_number = user.phone_number
                    loadRequestInstance.loan_amount_total = loanTotal
                    loadRequestInstance.mlipa_feedback = outputtexts
                    loadRequestInstance.customer_id = user.user_group

                    def current_time = Calendar.instance
                    def created_atd = new java.sql.Timestamp(current_time.time.time)
                    loadRequestInstance.created_at = created_atd



                    println("Data:" + status)
                    if (status.equals("SUCCESS")) {
                        successful_sent = true
                        loadRequestInstance.loan_status = 1

                        def userLogsInstanceD = new UserLogs()
                        userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("ALL")
                        userLogsInstanceD.user_id = user
                        userLogsInstanceD.message = "Requested loan."
                        userLogsInstanceD.save()
                    } else {
                        loadRequestInstance.loan_status = 0
                        //  User.executeUpdate("update User set have_loan=? where id=? ", [false, user.id])


                    }
                    loadRequestInstance.save()
                    render "Asante kwa kuomba mkopo. Utatumiwa muda si mrefu.", status: 200

                } else {
                    render "Loan request failed", status: 200

                }

            } catch (IOException e) {
                e.printStackTrace()
            }
        }else {
            render "Loan request failed. Wait for 1 hour.", status: 200

        }
    }


    private void requestLoan0Methods(SecUser user,def  amount,def installment){

            Boolean successful_sent=false
            def name = user.full_name
           // amount=1000

            def created_at =  new Date().format( 'yyyyMMdd' ).toString()


            def request_code = "KOPAF" + created_at+user.id

            SecUser.executeUpdate("update SecUser set have_loan=? where id=? ", [true, user.id])


            String phonenumber = user.phone_number.replace("+", "")

        String returnUrl = grailsApplication.config.systemLink + "/home/paymentFeedBack"
        JSONObject authentication=new JSONObject()
        authentication.put("username",user.user_group.mlipa_username)
        authentication.put("password",user.user_group.mlipa_password)

        JSONObject transaction=new JSONObject()
        transaction.put("txnID",request_code)
        transaction.put("amount",amount)
        transaction.put("mobile",phonenumber)
        transaction.put("name",name)
        transaction.put("callback",returnUrl)

        JSONObject paymentData=new JSONObject()
        paymentData.put("authentication",authentication)
        paymentData.put("transaction",transaction)
        String outputtexts="empty"

        try{

            def post = new URL(user.user_group.mlipa_link).openConnection()
            def message = paymentData.toString()
            post.setRequestMethod("POST")
            post.setDoOutput(true)
            post.setRequestProperty("Content-Type", "application/json")
                post.getOutputStream().write(message.getBytes("UTF-8"))
                def postRC = post.getResponseCode()
                // println("out:" + postRC)
                if (postRC.equals(200)) {
                    outputtexts = post.getInputStream().getText()
                   // println("out:" + outputtexts)

                    JSONObject jsonObject = new JSONObject(outputtexts)
                    String status = jsonObject.getString("status")
                    //def interest = user.loan_group.interest
                    def interest=10

                    if(user.agent_id.agent_type.code.equals("FREEA")) {
                        interest=user.agent_id.agent_loan_interest
                    }else {
                        interest=user.user_group.loan_interest

                    }

                    def configurationData = PaymentConfig.get(1)
                   // int  kopafasta_fee=1000


                    def loanTotal = amount + ((interest / 100) * amount)+configurationData.kopafasta_fee
                    // String description = jsonObject.getString("description")
                    def loadRequestInstance = new LoanRequest()
                    loadRequestInstance.amount = amount
                    loadRequestInstance.user_id = user
                    loadRequestInstance.request_code = request_code
                    loadRequestInstance.interest_percentage = interest
                    loadRequestInstance.instruments = installment
                    loadRequestInstance.mobile_number = user.phone_number
                    loadRequestInstance.loan_amount_total = loanTotal
                    loadRequestInstance.mlipa_feedback = outputtexts
                    loadRequestInstance.customer_id=user.user_group

                    def current_time = Calendar.instance
                    def created_atd = new java.sql.Timestamp(current_time.time.time)
                    loadRequestInstance.created_at=created_atd



                    //	println(status+":"+description)
                    if (status.equals("SUCCESS")) {
                        successful_sent=true
                        loadRequestInstance.loan_status = 1

                        def userLogsInstanceD = new UserLogs()
                        userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("ALL")
                        userLogsInstanceD.user_id = user
                        userLogsInstanceD.message = "Requested loan."
                        userLogsInstanceD.save()
                        try {
                            if(user.agent_id.agent_type.code.equals("FREEA")) {
                                SecUser.executeUpdate("update SecUser set agent_float_amount=agent_float_amount-" + amount + " where id=? ", [user.agent_id.id])
                            }
                        }catch (Exception e){
                            e.printStackTrace()
                        }

                    } else {
                        loadRequestInstance.loan_status = 0
                        //  User.executeUpdate("update User set have_loan=? where id=? ", [false, user.id])


                    }
                    loadRequestInstance.save()
                  //  render "Asante kwa kuomba mkopo. Utatumiwa muda si mrefu.", status: 200

                } else {
                 //   render "Loan request failed", status: 200

                }
                //println(""+post.getInputStream().getText())

            } catch (IOException e) {
                //println("outtwo"+outputtexts)
                e.printStackTrace()
            }
    }

    def save(LoanRequest loanRequest) {
        if (loanRequest == null) {
            notFound()
            return
        }

        try {
            loanRequestService.save(loanRequest)
        } catch (ValidationException e) {
            respond loanRequest.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'loanRequest.label', default: 'LoanRequest'), loanRequest.id])
                redirect loanRequest
            }
            '*' { respond loanRequest, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond loanRequestService.get(id)
    }

    def reportByDate(){
        def start_date=params.start_date
        def end_date=params.end_date
        render(view: 'reportByDate')

    }

    def update(LoanRequest loanRequest) {
        if (loanRequest == null) {
            notFound()
            return
        }

        try {
            loanRequestService.save(loanRequest)
        } catch (ValidationException e) {
            respond loanRequest.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'loanRequest.label', default: 'LoanRequest'), loanRequest.id])
                redirect loanRequest
            }
            '*'{ respond loanRequest, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        loanRequestService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'loanRequest.label', default: 'LoanRequest'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'loanRequest.label', default: 'LoanRequest'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}