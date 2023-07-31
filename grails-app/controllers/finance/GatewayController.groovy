package finance

import grails.converters.JSON
import grails.gorm.transactions.Transactional
import loans.LoanCalculatorService
import org.grails.web.json.JSONArray
import org.grails.web.json.JSONObject

class GatewayController {

    LoanCalculatorService loanCalculatorService;

    def index() { }

    def request() {
        println(params)
        def  action = params.action
        def phone_number = params.from
        def message_type = params.message_type
        JSONObject response = new JSONObject()
        JSONArray events = new JSONArray()

        JSONObject event = new JSONObject()
        if(action=="request" && message_type && message_type=="sms") {
            String  message = params.message
            boolean  success = saveLoanRequest(message.trim(), phone_number)
            if(success) {
                event.put("event", "log")
                event.put("message", "SMS Accepted")
            } else {
                event.put("event","log")
                event.put("message","No Outgoing SSM")
            }
        } else {
            event.put("event","log")
            event.put("message","No Outgoing SSM")
        }

        events.put(event)
        response.put("events",events)
        println(response)
        render response as JSON
    }

    def testData() {
        String sample = "id.56023083.kiasi.1000"
        saveLoanRequest(sample,"+255766545878")
        render "Ok"
    }

    @Transactional
    def saveLoanRequest(String msg, String mobileNo) {
        boolean  success=  true;
        String [] data =  msg.split("\\.")
        if(data.length == 4) {
            def amount = data[3].replace(",","")
            def regNo = data[1]

            def userInstance = SecUser.findByRegistration_no(regNo)

            if (userInstance && userInstance.phone_number.replace("+","") == mobileNo.replace("+", "") && Integer.parseInt(amount) <= userInstance.loan_limit) {
                System.out.println("User loan request by "+userInstance.full_name+" no:"+userInstance.phone_number)

                loanCalculatorService.genericSaveLoan(userInstance, Double.parseDouble(amount))

            } else {
                System.out.println("User loan request by RegNo:"+regNo+" : Hana vigezo vya namba and loan limit")

                success = false
            }
        } else {
            success = false;
        }

        return success;
    }
}
