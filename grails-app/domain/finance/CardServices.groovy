package finance

class CardServices {
    int id,version
    Integer amount_paid,card_status
    Date expired_date
    SecUser created_by
    Boolean issued,enabled,active,expired,paid,sms_card,sms_instruction,deleted=false,loan_eligible,card_printed
    SecUser user_id
    java.sql.Timestamp created_at,paid_at
    String card_number
    String user_number,receipt,charges,msisdn,mkey
    String reponse_mlipa

    def user
    def springSecurityService
    static mapping = {
        table name: 'gen_card_services'
        user_id column: 'user_id'
        created_by column: 'created_by'
    }

    static constraints = {
        created_by nullable: true
        created_at nullable: true
        expired_date nullable: true
        issued nullable: true
        expired_date nullable: true
        expired nullable: true
        enabled nullable: true
        active nullable: true
        card_number nullable: true
        paid_at nullable: true
        user_id nullable: true
        receipt nullable: true
        charges nullable: true
        msisdn nullable: true
        paid  nullable: true
        mkey nullable: true,unique: true
        reponse_mlipa nullable: true
        sms_card nullable: true
        sms_instruction nullable: true
        deleted nullable: true
        card_status nullable: true
        loan_eligible nullable: true
        card_printed nullable: true
    }
    /*def renderQR(){
        def qrCodeService
        qrCodeService.renderPng("test", 30, outputStream)

    }*/

    def beforeInsert = {
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)
        user = SecUser.findById(springSecurityService?.principal?.id)
        created_by = user
        /*Calendar cal = Calendar.getInstance();
        Date today = cal.getTime();
        cal.add(Calendar.YEAR, 3)
        Date nextYear = cal.getTime()
        expired_date=nextYear*/
        deleted=0
        card_printed=0
        card_number="0K"+System.currentTimeMillis()

    }
}
