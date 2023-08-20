package admin

class Customers {
    int id,version
    String name,contacts,code,mpesa_username,mpesa_password,mpesa_link,ceo_email,hr_email,accountant_email
    DictionaryItem loan_type
    Integer loan_interest
    Boolean loan_allowed
    java.sql.Timestamp created_at

    static constraints = {
        created_at nullable: true
        code unique: true
        contacts nullable: true
        loan_allowed nullable: true
        loan_type nullable: true
        mpesa_username nullable: true
        mpesa_password nullable: true
        mpesa_link nullable: true
        ceo_email nullable: true
        hr_email nullable: true
        accountant_email nullable: true
        loan_interest nullable: true
    }

    static mapping = {
        table name: 'gen_customers'
        loan_type column: 'loan_type'
    }

    def beforeInsert = {
        loan_allowed=0
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)
    }
}
