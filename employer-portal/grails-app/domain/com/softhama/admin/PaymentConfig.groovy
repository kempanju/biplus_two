package com.softhama.admin

import java.sql.Timestamp

class PaymentConfig {
    int id,version
    Integer fees=0, days_before_refund=15,deleted=0,card_expired_years,kopafasta_fee
    Boolean loan_opened,product_opened, sendAutoLoan
    Timestamp created_at
    String mlipa_code,mlipa_username,mlipa_password
    String privateKey, publicPublic
    String disbursementSrc
    Integer card_cost=0;

    static mapping = {
        table name: 'gen_payment_config'
        publicPublic type: "text"
    }

    static constraints = {
        fees(nullable: true)
        days_before_refund(nullable: true)
        loan_opened(nullable: true)
        privateKey nullable: true
        sendAutoLoan nullable: true
        publicPublic nullable: true
        created_at(nullable: true)
        deleted(nullable: true)
        mlipa_code(nullable: true)
        card_expired_years(nullable: true)
        card_cost nullable: true
        product_opened nullable: true
        mlipa_username nullable: true
        mlipa_password nullable: true
        kopafasta_fee nullable: true
        disbursementSrc nullable: true
    }
}
