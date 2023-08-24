package loans

import finance.SecUser

class LoanRepayment {
    int id,version
    Double amount_paid
    String mlipa_json
    LoanRequest loan_id
    SecUser user_id
    java.sql.Timestamp created_at
    String transId
    String requestId

    static constraints = {
        mlipa_json nullable: true
        created_at nullable: true
        transId nullable:  true, unique: true
        requestId  nullable: true
    }
    static mapping = {
        table name: 'gen_loan_repayment'
        user_id column: 'user_id'
        loan_id column: 'loan_id'
    }
    def beforeInsert = {
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)
    }
}
