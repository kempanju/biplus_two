package loans

import admin.DictionaryItem
import finance.UserLogs
import grails.plugin.springsecurity.annotation.Secured
import grails.util.Environment
import grails.validation.ValidationException
import pl.touk.excel.export.WebXlsxExporter

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN','ROLE_LOAN','ROLE_MANAGER'])
class UnpaidLoanController {

    UnpaidLoanService unpaidLoanService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        session["activePage"] = "loans"

        params.max = Math.min(max ?: 10, 100)
        respond unpaidLoanService.list(params), model:[unpaidLoanCount: unpaidLoanService.count()]
    }

    def show(Long id) {
        respond unpaidLoanService.get(id)
    }

    def create() {
        respond new UnpaidLoan(params)
    }

    def save(UnpaidLoan unpaidLoan) {
        if (unpaidLoan == null) {
            notFound()
            return
        }

        try {
            unpaidLoanService.save(unpaidLoan)
        } catch (ValidationException e) {
            respond unpaidLoan.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'unpaidLoan.label', default: 'UnpaidLoan'), unpaidLoan.id])
                redirect unpaidLoan
            }
            '*' { respond unpaidLoan, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond unpaidLoanService.get(id)
    }

    def update(UnpaidLoan unpaidLoan) {
        if (unpaidLoan == null) {
            notFound()
            return
        }

        try {
            unpaidLoanService.save(unpaidLoan)
        } catch (ValidationException e) {
            respond unpaidLoan.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'unpaidLoan.label', default: 'UnpaidLoan'), unpaidLoan.id])
                redirect unpaidLoan
            }
            '*'{ respond unpaidLoan, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        unpaidLoanService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'unpaidLoan.label', default: 'UnpaidLoan'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'unpaidLoan.label', default: 'UnpaidLoan'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }


    def messagesUnPaidUser(){
        int daysdata=Integer.parseInt(params.daysdata)
        def findAllUnpaid=UnpaidLoan.executeQuery("from UnpaidLoan where days_passed<=?",[daysdata])

        //   println(findAllUnpaid)

        int i = 1;
        findAllUnpaid.each {
            String mesagedata = params.message

            if (mesagedata.contains("{fName}")) {
                def firstname = it.user_id.full_name
                def regNo = it.user_id.registration_no

                def totalAmount = it.user_id.last_loan.loan_amount_total
                def amount = it.user_id.last_loan.amount
                def createdDate = it.user_id.last_loan.created_at.toString()
                def pDate = it.user_id.last_loan.last_payment_date.toString()
                def interest = it.user_id.last_loan.instruments




                mesagedata = mesagedata.replace("{fName}", firstname)
                mesagedata = mesagedata.replace("{regNo}", regNo)
                mesagedata = mesagedata.replace("{cDate}", createdDate)
                mesagedata = mesagedata.replace("{EDate}", pDate)
                mesagedata = mesagedata.replace("{amount}", amount.toString())
                mesagedata = mesagedata.replace("{tAmount}", totalAmount.toString())
                mesagedata = mesagedata.replace("{instalment}", interest.toString())

                //   println("msg:"+mesagedata)

                String returnUrl = grailsApplication.config.deliverySMS + "/deliveryRegistration"


                def phonenumber = it.user_id.phone_number.replace("+", "")

                // println(i+":"+mesagedata)
                if (Environment.current == Environment.PRODUCTION) {

                    String sms_mtandao_json = smsMtandaoSendMessagesLoan(phonenumber: phonenumber, messagesent: mesagedata, returnUrl: returnUrl)
                }


                def userLogsInstanceD = new UserLogs()
                userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("SYL")
                userLogsInstanceD.user_id = it.user_id
                userLogsInstanceD.message = mesagedata
                //userLogsInstanceD.save()
                i++
            }  else {
                flash.message="Message failed to send"

            }

        }

        if(i>1){
            flash.message = "Message successfully sent to " + i + " artists"

        }
        redirect(action: 'index')
    }


    def printLoanExcel(){
        def nameData=System.currentTimeMillis()+".xlsx"
        // def zailspath = servletContext.getRealPath("/") + "csvfiles/"+nameData

        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }


        def userData=UnpaidLoan.list(params)
        // def userData=CardServices.executeQuery("from CardServices where card_status=203 and user_id.region_id.id=3").user_id
        def headers = ['Name', 'Registration  no', 'Phone no', 'Due Amount','Loan Amount', 'Date','District','Ward','Location','Category','Days Passed']

        def withProperties = ['user_id.full_name', 'user_id.registration_no','user_id.phone_number', 'amount_to_pay','parent_loan.amount','parent_loan.created_at','user_id.district_id.name','user_id.ward.name','user_id.village','user_id.description','days_passed']
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
        // params.max = Math.min(max ?: 10, 10)
        // def user_id=springSecurityService.principal.id
        //def company_id=User.get(user_id)?.company_id
        //def userInstance=null

        def userInstance = UnpaidLoan.executeQuery("from UnpaidLoan where user_id.first_name like ? or user_id.full_name like ? " +
                " or user_id.mlipa_no like ? or user_id.username like ? or user_id.registration_no like ? or user_id.phone_number like ? " +
                "or user_id.source_district.name like ? or user_id.region_id.name like ? or CONCAT(user_id.first_name,' ',user_id.last_name) like ? or CONCAT(user_id.first_name,' ',user_id.middle_name,' ',user_id.last_name) like ?", [searchstring, searchstring, searchstring, searchstring, searchstring, searchstring,searchstring,searchstring,searchstring,searchstring],params)


        // println(searchstring+"out:"+employeeInstance)

        render  template: 'searchUserlist', model:[unpaidLoanList:userInstance]
    }

}
