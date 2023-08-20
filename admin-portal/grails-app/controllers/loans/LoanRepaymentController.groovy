package loans

import admin.Customers
import admin.District
import admin.Wards
import finance.SecUser
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.grails.web.json.JSONObject
import pl.touk.excel.export.WebXlsxExporter

import java.sql.Timestamp
import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class LoanRepaymentController {

    LoanRepaymentService loanRepaymentService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        if(!params.sort) {
            params.sort = 'created_at'
            params.order = 'desc'
        }
        session["activePage"] = "loans"

        params.max = Math.min(max ?: 10, 100)
        respond loanRepaymentService.list(params), model:[loanRepaymentCount: loanRepaymentService.count()]
    }

    def loanByUser(Long id){

        session["activePage"] = "loans"
        def userInstance = SecUser.read(id)
        def loanList = LoanRepayment.findAllByUser_id(userInstance)
        render view: 'loanByUser', model: [loanRepaymentList: loanList, userInstance:userInstance]
    }


    def printRepaymentExcel(){
        def nameData=System.currentTimeMillis()+".xlsx"
        // def zailspath = servletContext.getRealPath("/") + "csvfiles/"+nameData

        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }

        def userData=LoanRepayment.findAll(params)
        // def userData=CardServices.executeQuery("from CardServices where card_status=203 and user_id.region_id.id=3").user_id
        def headers = ['Name', 'Registration  no', 'Phone no', 'Amount','Date']

        def withProperties = ['user_id.full_name', 'user_id.registration_no','user_id.phone_number', 'amount_paid','created_at']
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
    }

    @Transactional
    def saveTacipLoanPayment(){
      //  println(params)
        def card_no=params.card_no
        def registration_no=params.registration_no
        def totalloan=Double.parseDouble(params.totalloan)

        def date_paid=params.date_paid
        def created_at=null
   // println(date_paid)

        if(date_paid){
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            Date date = (Date) formatter.parse(date_paid)


            created_at=new Timestamp(date.getTime());
        }else {
            def current_time = Calendar.instance
            created_at = new java.sql.Timestamp(current_time.time.time)

        }
        def dataInstance = SecUser.findByRegistration_no(registration_no)


        if(LoanRepayment.countByCreated_atAndUser_id(created_at,dataInstance)==0) {

            def loadRequestInstance = null;

            if (!dataInstance) {
                String outputTacip = callTacipHttp(card_no: card_no, returnUrl: grailsApplication.config.tacipData.toString())

                outputTacip = outputTacip.replace("&quot;", '"')
                JSONObject jsonObject = new JSONObject(outputTacip)


                Boolean user_valid = jsonObject.get("user_valid")
                if (user_valid) {
                    //  outputTacip = callTsiaHttp(card_no: card_no, returnUrl: grailsApplication.config.tsiadata.toString())
                    // outputTacip = outputTacip.replace("&quot;", '"')
                    // jsonObject = new JSONObject(outputTacip)
                    jsonObject.put("loan_type", "ORLOAN")
                    dataInstance = saveUsersDetails(jsonObject, "TACIP")

                    String request_code = params.request_code

                    //  println(userInstance+" data")
                    if (LoanRequest.countByRequest_code(request_code) == 0) {
                        loadRequestInstance = new LoanRequest()
                        loadRequestInstance.amount = Double.parseDouble(params.amount)
                        loadRequestInstance.user_id = dataInstance
                        loadRequestInstance.request_code = params.request_code
                        loadRequestInstance.interest_percentage = Float.parseFloat(params.interest_percentage)
                        loadRequestInstance.instruments = Integer.parseInt(params.instruments)
                        loadRequestInstance.mobile_number = params.mobile_number
                        loadRequestInstance.loan_amount_total = Double.parseDouble(params.loan_amount_total)
                        loadRequestInstance.mlipa_feedback = params.mlipa_feedback
                        loadRequestInstance.payment_feedback = params.payment_feedback
                        loadRequestInstance.loan_status = 2
                        if (loadRequestInstance.save(failOnError: true)) {
                            def userLoanRepayment = new LoanRepayment()
                            userLoanRepayment.loan_id = loadRequestInstance
                            userLoanRepayment.amount_paid = Double.parseDouble(params.amountpaid)
                            userLoanRepayment.user_id = dataInstance
                            userLoanRepayment.created_at = created_at
                            userLoanRepayment.save(failOnError: true)
                        }
                    } else {
                        def userLoanRepayment = new LoanRepayment()
                        userLoanRepayment.loan_id = LoanRequest.findByRequest_code(request_code)
                        userLoanRepayment.amount_paid = Double.parseDouble(params.amountpaid)
                        userLoanRepayment.user_id = dataInstance
                        userLoanRepayment.created_at = created_at

                        userLoanRepayment.save(failOnError: true)
                    }


                }
            } else {
                String request_code = params.request_code

                //  println(userInstance+" data")
                if (LoanRequest.countByRequest_code(request_code) == 0) {
                    loadRequestInstance = new LoanRequest()
                    loadRequestInstance.amount = Double.parseDouble(params.amount)
                    loadRequestInstance.user_id = dataInstance
                    loadRequestInstance.request_code = params.request_code
                    loadRequestInstance.interest_percentage = Float.parseFloat(params.interest_percentage)
                    loadRequestInstance.instruments = Integer.parseInt(params.instruments)
                    loadRequestInstance.mobile_number = params.mobile_number
                    loadRequestInstance.loan_amount_total = Double.parseDouble(params.loan_amount_total)
                    loadRequestInstance.mlipa_feedback = params.mlipa_feedback
                    loadRequestInstance.payment_feedback = params.payment_feedback
                    loadRequestInstance.loan_status = 2
                    if (loadRequestInstance.save(failOnError: true)) {
                        def userLoanRepayment = new LoanRepayment()
                        userLoanRepayment.loan_id = loadRequestInstance
                        userLoanRepayment.amount_paid = Double.parseDouble(params.amountpaid)
                        userLoanRepayment.user_id = dataInstance
                        userLoanRepayment.created_at = created_at
                        userLoanRepayment.save(failOnError: true)
                    }
                } else {
                    def userLoanRepayment = new LoanRepayment()
                    userLoanRepayment.loan_id = LoanRequest.findByRequest_code(request_code)
                    userLoanRepayment.amount_paid = Double.parseDouble(params.amountpaid)
                    userLoanRepayment.user_id = dataInstance
                    userLoanRepayment.created_at = created_at
                    userLoanRepayment.save(failOnError: true)
                }

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
            userInstance.description=jsonObjectData.get("description")
            userInstance.username=reg_no
            userInstance.user_group=Customers.findOrSaveWhere(code:customer_code,name: customer_name)
            userInstance.password=System.currentTimeMillis().toString()
            userInstance.gender=jsonObjectData.get("gender")
            if(loan_src=="TACIP") {
                if(jsonObjectData.containsKey("district_id")) {
                    userInstance.district_id = District.get(jsonObjectData.get("district_id"))
                }
                if(jsonObjectData.containsKey("ward")) {
                    userInstance.ward = Wards.get(jsonObjectData.get("ward"))
                }
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

    def show(Long id) {
        respond loanRepaymentService.get(id)
    }

    def create() {
        respond new LoanRepayment(params)
    }

    def addRepayment(Long id) {
        session["activePage"] = "loans"
        def userInstance = SecUser.read(id)

        render view: 'addRepayment', model: [userInstance: userInstance]
    }

    @Transactional
    def save(LoanRepayment loanRepayment) {
        if (loanRepayment == null) {
            notFound()
            return
        }

        try {
            if(loanRepaymentService.save(loanRepayment)) {
               def userInstance = loanRepayment.user_id
               def loanInstance = UserLoan.findByUser(userInstance)
                if(loanInstance.unpaidLoan <=0 ) {
                    LoanRequest.executeUpdate("update LoanRequest set loan_repaid=1 where user_id=:userId",[userId:userInstance])
                }
            }
        } catch (ValidationException e) {
            respond loanRepayment.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), loanRepayment.id])
                redirect loanRepayment
            }
            '*' { respond loanRepayment, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond loanRepaymentService.get(id)
    }

    def update(LoanRepayment loanRepayment) {
        if (loanRepayment == null) {
            notFound()
            return
        }

        try {
            loanRepaymentService.save(loanRepayment)
        } catch (ValidationException e) {
            respond loanRepayment.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), loanRepayment.id])
                redirect loanRepayment
            }
            '*'{ respond loanRepayment, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        loanRepaymentService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
