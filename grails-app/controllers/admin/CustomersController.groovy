package admin

import finance.SecUser
import finance.UserLogs
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import loans.LoanRequest
import loans.UserLoan
import pl.touk.excel.export.WebXlsxExporter

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class CustomersController {

    CustomersService customersService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        session["activePage"] = "customers"

        respond customersService.list(params), model:[customersCount: customersService.count()]
    }

    def show(Long id) {
        respond customersService.get(id)
    }

    def create() {
        session["activePage"] = "customers"

        respond new Customers(params)
    }

    def save(Customers customers) {
        if (customers == null) {
            notFound()
            return
        }

        try {
            customersService.save(customers)
        } catch (ValidationException e) {
            respond customers.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'customers.label', default: 'Customers'), customers.id])
                redirect customers
            }
            '*' { respond customers, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond customersService.get(id)
    }

    @Transactional
    def sendBulkMessages(){
        def userList= SecUser.findAllByUser_groupAndUser_deleted(Customers.get(params.company_id),false)
        int i = 1;
        userList.each {
            String mesagedata = params.message

            if (mesagedata.contains("{fName}")) {

                def firstname = it.full_name
                def regNo = it.registration_no
                def company = it.user_group.name
                def mobileNumber = it.phone_number

                mesagedata = mesagedata.replace("{fName}", firstname)
                mesagedata = mesagedata.replace("{regNo}", regNo)
                mesagedata = mesagedata.replace("{company}", company)
                mesagedata = mesagedata.replace("{mobile}", mobileNumber)

                String returnUrl = grailsApplication.config.deliverySMS + "/deliveryRegistration"


                String phonenumber = it.phone_number.replace("+", "")


                if(phonenumber.startsWith("0")){
                    phonenumber="255"+phonenumber.substring(1)

                    SecUser.executeUpdate("update SecUser set phone_number=? where id=? ", [phonenumber, it.id])

                }

                // println(i+":"+mesagedata)
                if(UserLogs.countByUser_idAndMessage(it,mesagedata)==0) {
                    String sms_mtandao_json = smsMtandaoSendMessagesLoan(phonenumber: phonenumber, messagesent: mesagedata, returnUrl: returnUrl)

                    println(sms_mtandao_json+" "+phonenumber)
                    def userLogsInstanceD = new UserLogs()
                    userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("SYL")
                    userLogsInstanceD.user_id = it
                    userLogsInstanceD.message = mesagedata
                    userLogsInstanceD.save()
                }
                i++
            }else {
                flash.message="Message failed to send"
            }

        }
        flash.message = "Message successfully sent to " + i + " artists"
        redirect(action: 'show',params:[id:params.company_id])

    }

    def printLoanCsv(){
        println(params)

       // def nameData=System.currentTimeMillis()+".xlsx"
       // def zailspath = servletContext.getRealPath("/") + "csvfiles/"+nameData

        //  def headers = ['M-LIPA No', 'Full name', 'Registration no', 'District', 'Location','Phone number']



        //def userData=User.findAllByBatch_no(params.batchno)
        def userData=LoanRequest.executeQuery("from LoanRequest where loan_repaid=0 and loan_status=2 and customer_id=:customerInstance group by user_id",[customerInstance:Customers.get(params.id)])
        def headers = ['Full name', 'Registration No','Customer Name','Amount','Phone Number','Unique ID']
        try {
            new WebXlsxExporter().with {
                // def responseD = response.outputStream
                setResponseHeaders(response,System.currentTimeMillis()+".xlsx")
                fillHeader(headers)
                int i=1
                userData.each {

                    def full_name=it.user_id.full_name
                    def registrationNo=it.user_id.registration_no
                    def customer_name=it.customer_id.name
                    def phone_number=it.user_id.phone_number

                    def unpaidLoan = UserLoan.findByUser(it.user_id)
                    def amount= unpaidLoan.unpaidLoan
                    def uniqueID=it.request_unique
                    // String reg_no="1141010023124"

                    //def finalNumber = mlipa_no.substring(0, 3)+" "+mlipa_no.substring(3, 6) + " " +mlipa_no.substring(6, 9)+" "+ mlipa_no.substring(9, mlipa_no.length())


                    //String mlipaNo=formatRegNumber(reg_no)

                    fillRow([full_name,registrationNo,customer_name,amount,phone_number,uniqueID],i)
                    i++

                }
               // add(userData, withProperties)
                save(response.outputStream)
            }
        }catch (Exception e){
            e.printStackTrace()
        }

        flash.message= "Successfully printed"

    }

    def update(Customers customers) {
        if (customers == null) {
            notFound()
            return
        }

        try {
            customersService.save(customers)
        } catch (ValidationException e) {
            respond customers.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'customers.label', default: 'Customers'), customers.id])
                redirect customers
            }
            '*'{ respond customers, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        customersService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'customers.label', default: 'Customers'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'customers.label', default: 'Customers'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
