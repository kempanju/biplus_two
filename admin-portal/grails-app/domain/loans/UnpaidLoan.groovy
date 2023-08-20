package loans

import finance.SecUser


class UnpaidLoan {
    int id,version
    Integer days_passed,amount_to_pay
    LoanRequest parent_loan
    SecUser user_id
    long status
    static constraints = {
    }

    static mapping = {
        table name: 'gen_unpaid_loan'
        user_id column: 'user_id'
        parent_loan column: 'parent_loan'
    }
}
