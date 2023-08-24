package finance

import admin.Customers
import admin.DictionaryItem
import admin.District
import admin.Wards
import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import loans.LoanGroup
import loans.LoanRequest

@GrailsCompileStatic
@EqualsAndHashCode(includes='username')
//@ToString(includes='username', includeNames=true, includePackage=false)
class SecUser implements Serializable {

    private static final long serialVersionUID = 1

    String username
    String phone_number,full_name,description,card_no

    String password,gender,recent_photo,registration_no,national_id_copy_path,national_id_name,national_id,village,user_signature,birth_village
    boolean enabled = true
    boolean accountExpired
    boolean accountLocked
    boolean passwordExpired
    Double loan_amount,agent_float_amount
    LoanRequest last_loan
    LoanGroup loan_group
    java.sql.Timestamp created_at,agent_date
    Integer loan_points,agent_loan_interest
    Double payment_credit
    Boolean have_loan,user_deleted,agent_active,loan_enabled,agent_blocked
    District district_id,birth_district_id
    Wards ward,birth_ward
    Customers user_group
    int loan_limit=0
    Integer salary;
    DictionaryItem identity_type,agent_type

    Date birth_date

    SecUser agent_id


    Set<SecRole> getAuthorities() {
        (SecUserSecRole.findAllBySecUser(this) as List<SecUserSecRole>)*.secRole as Set<SecRole>
    }

    static constraints = {
        password nullable: false, blank: false, password: true
        username nullable: false, blank: false, unique: true
        created_at nullable: true
        loan_group nullable: true
        payment_credit nullable: true
        loan_points nullable: true
        have_loan nullable: true
        loan_amount nullable: true
        user_group nullable: true
        last_loan nullable: true
        gender nullable: true
        salary nullable:true
        recent_photo nullable: true
        full_name nullable: true
        district_id nullable: true
        ward nullable: true
        registration_no nullable: true,unique: true
        description nullable: true
        loan_limit nullable:true
        user_deleted nullable: true
        agent_id nullable: true
        card_no nullable: true
        agent_date nullable: true
        agent_active nullable: true
        birth_district_id nullable: true
        birth_ward nullable: true
        national_id_copy_path nullable: true
        national_id_name nullable: true
        national_id nullable: true
        identity_type nullable: true
        village nullable: true
        agent_float_amount nullable: true
        loan_enabled nullable: true
        agent_type nullable: true
        agent_loan_interest nullable: true
        user_signature nullable: true
        birth_date nullable: true
        birth_village nullable: true
        agent_blocked nullable: true
    }

    static mapping = {
        autowire true
        table 'gen_users'

        password column: '`password`'
        loan_group column: 'loan_group'
        last_loan column: 'last_loan'
        district_id column: 'district_id'
        ward column: 'ward'
        user_group column: 'user_group'
        agent_id column: 'agent_id'
        birth_district_id column: 'birth_district_id'
        birth_ward column: 'birth_ward'
        identity_type column: 'identity_type'
        agent_type column: 'agent_type'

    }

    def beforeInsert = {
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)
        //loan_group =LoanGroup.findByCode("A")
        payment_credit=0
        loan_points=0
        // recent_photo="default_user.jpg"
        have_loan=0
        loan_amount=0
        user_deleted=0
        agent_active=0
        agent_float_amount=0
        loan_enabled=1
        agent_blocked=0
    }
}
