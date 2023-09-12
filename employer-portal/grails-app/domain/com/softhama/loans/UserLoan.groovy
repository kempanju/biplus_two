package com.softhama.loans

import com.softhama.admin.Customers


class UserLoan {
    int id
    Customers customer
    LoanRequest last_loan
    Integer loan_amount
    Employee user
    Integer total_repaid,unpaidLoan

    static constraints = {
        unpaidLoan  formula:"loan_amount - total_repaid"
        total_repaid nullable:true
        customer nullable: true
        last_loan nullable: true
    }

    static mapping = {
        table name: 'view_user_loan'
        version false
    }
}
