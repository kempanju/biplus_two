package loans

import finance.SecUser
import grails.rest.Resource

@Resource(uri='/city', formats=["json", "xml"])
class CardPayments {
    int id,version
    Double amount_paid
    SecUser user_id
    String mlipa_feedback,registration_no,mkey
    java.sql.Timestamp created_at

    static mapping = {
        table name: 'gen_card_payment'
        user_id column: 'user_id'
    }
    static constraints = {
        amount_paid nullable: true
        user_id nullable: true
        mlipa_feedback nullable: true
        registration_no nullable: true
        created_at nullable: true
        mkey nullable: true
    }
    def beforeInsert = {
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)
    }
}
