package admin

import finance.SecUser

class PaymentConfig {
    int id,version
    Integer fees=0, days_before_refund=15,deleted=0,card_expired_years,kopafasta_fee
    Boolean loan_opened,product_opened
    SecUser created_by, deleted_by
    java.sql.Timestamp created_at
    String mlipa_code,mlipa_username,mlipa_password
    Integer card_cost=0;

    static mapping = {
        table name: 'gen_payment_config'
        created_by column:'created_by'
        deleted_by column:'deleted_by'
    }

    static constraints = {
        fees(nullable: true)
        days_before_refund(nullable: true)
        loan_opened(nullable: true)
        created_at(nullable: true)
        created_by(nullable: true)
        deleted_by(nullable: true)
        deleted(nullable: true)
        mlipa_code(nullable: true)
        card_expired_years(nullable: true)
        card_cost nullable: true
        product_opened nullable: true
        mlipa_username nullable: true
        mlipa_password nullable: true
        kopafasta_fee nullable: true
    }
}
