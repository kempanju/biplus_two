package loans

import admin.PaymentConfig
import bi.plus.TigoPesaService
import finance.SecUser
import grails.gorm.transactions.Transactional
import org.grails.web.json.JSONObject

@Transactional
class LoanCalculatorService {

    MpesaService mpesaService;
    TigoPesaService tigoPesaService;

    def serviceMethod() {

    }

    def testLoanRequest(SecUser userInstance, def amount) {
        def unique = System.currentTimeMillis().toString()
        String output = tigoPesaService.processLoan(1000, unique, unique, "0713123892")
    }

    def genericSaveLoan(SecUser userInstance, def amount){

        def paymentConfig = PaymentConfig.findByDeleted(0)

        String request_code = "KP"+System.currentTimeMillis().toString()
        def loanInstance = new LoanRequest();
        loanInstance.amount = amount

        loanInstance.loan_status = 1
        loanInstance.loan_repaid = false
        loanInstance.payment_sent = false

        loanInstance.user_id = userInstance
        loanInstance.request_code = request_code
        loanInstance.interest_percentage = userInstance.user_group.loan_interest

        loanInstance.instruments = 0
        loanInstance.mobile_number = userInstance.phone_number
        loanInstance.customer_id = userInstance?.user_group
        loanInstance.insurance_fee = paymentConfig.kopafasta_fee

        def current_time = Calendar.instance
        def created_atd = new java.sql.Timestamp(current_time.time.time)
        loanInstance.created_at = created_atd
        if(loanInstance.save(failOnError:true,flush:true)) {
            if(paymentConfig.sendAutoLoan && !userInstance.accountLocked) {
                def loanBalanceInstance = UserLoan.findByUser(userInstance)
                boolean valid = loanBalanceInstance != null && loanBalanceInstance.unpaidLoan < 0 ? true : !(loanBalanceInstance != null && loanBalanceInstance.unpaidLoan > 0);

                if(valid) {
                    JSONObject output = mpesaService.processLoan(loanInstance.amount, loanInstance.request_unique, loanInstance.request_unique, loanInstance.user_id.phone_number)
                    loanInstance.payment_feedback = output.get("message")
                    if(output.get("code")==201) {
                        loanInstance.payment_sent = true
                        loanInstance.loan_status = 2
                    } else {
                        loanInstance.payment_sent = false
                        loanInstance.loan_status = 0
                    }
                    System.out.println("User loan request by "+userInstance.full_name+" : Loan processed!")
                } else {
                    loanInstance.loan_status = 0
                    loanInstance.payment_feedback = "Existing loan failed"
                    System.out.println("User loan request by "+userInstance.full_name+" : He have existing loan")
                }

            } else {
                System.out.println("User loan request by "+userInstance.full_name+" : Account locked or closed")

            }
            loanInstance.save()
        }
    }
}
