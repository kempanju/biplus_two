package com.softhama.loans

import com.softhama.admin.Customers
import com.softhama.admin.DictionaryItem

import java.sql.Timestamp

class LoanRequest {
    int id,version
    Employee user_id
    DictionaryItem category
    Double amount,loan_amount_total
    Integer instruments,loan_status,next_instruments, insurance_fee, interestAmount
    String mlipa_feedback,mobile_number
    Boolean payment_sent,loan_repaid
    Float interest_percentage
    Timestamp created_at, repaid_date
    String request_code,payment_feedback
    Date last_payment_date

    Customers customer_id
    String  request_unique


    static constraints = {
        mlipa_feedback nullable: true
        payment_sent nullable: true
        instruments nullable: true
        created_at nullable: true
        mobile_number nullable: true
        request_code nullable: true
        category nullable: true
        loan_status nullable: true
        payment_feedback nullable: true
        last_payment_date nullable: true
        insurance_fee nullable: true
        loan_amount_total formula:"(amount+insurance_fee+ ((interest_percentage/100)*amount))"
        interestAmount formula : "(interest_percentage/100)*amount"
        loan_repaid nullable: true
        next_instruments nullable: true
        repaid_date nullable: true
        customer_id nullable: true
        request_unique nullable: true,unique: true

    }
    static mapping = {
        table name: 'gen_loans_request'
        user_id column: 'user_id'
        customer_id column: 'customer_id'
    }
    def beforeInsert = {
        Calendar cal = Calendar.getInstance();
        Date today = cal.getTime();
        cal.add(Calendar.DATE, 30)
        Date nextPayment = cal.getTime()
        next_instruments=1
        loan_repaid=0
        loan_status = 1;
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)
        last_payment_date =nextPayment
        request_unique="BP"+System.currentTimeMillis()
    }

    String getFullName () {
        return user_id == null ? " " : user_id.full_name.substring(0,1);
    }
}
