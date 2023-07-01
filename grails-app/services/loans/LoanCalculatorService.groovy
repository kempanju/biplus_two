package loans

import admin.PaymentConfig
import finance.SecUser
import grails.gorm.transactions.Transactional

@Transactional
class LoanCalculatorService {

    def serviceMethod() {

    }

    def genericSaveLoan(SecUser userInstance, def amount){

        def paymentConfig = PaymentConfig.findByDeleted(0)

        String request_code = "KP"+System.currentTimeMillis().toString()
        def loanInstance = new LoanRequest();
        loanInstance.amount = amount

        loanInstance.loan_status = 2
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

        }
    }
}
