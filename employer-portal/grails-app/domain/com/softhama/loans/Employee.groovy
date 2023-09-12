package com.softhama.loans

import com.softhama.admin.Customers
import com.softhama.admin.DictionaryItem
import com.softhama.admin.District
import com.softhama.admin.Wards

class Employee {
    int id,version
    String phone_number,full_name,description

    String username
    String password,gender,recent_photo,registration_no,national_id_copy_path,national_id_name,national_id,village,user_signature,birth_village
    boolean enabled = true
    boolean accountExpired
    boolean accountLocked
    boolean passwordExpired
    Double loan_amount,agent_float_amount
    LoanRequest last_loan
    java.sql.Timestamp created_at,agent_date
    Integer loan_points,agent_loan_interest
    Double payment_credit
    Boolean have_loan,user_deleted,agent_active,loan_enabled,agent_blocked
    District district_id, birth_district_id
    Wards ward, birth_ward
    Customers user_group
    int loan_limit=0
    Integer salary;
    DictionaryItem identity_type, agent_type

    Date birth_date


    static constraints = {
    }

    static mapping = {
        autowire true
        table 'gen_users'

        password column: '`password`'
        last_loan column: 'last_loan'
        district_id column: 'district_id'
        ward column: 'ward'
        user_group column: 'user_group'
        birth_district_id column: 'birth_district_id'
        birth_ward column: 'birth_ward'
        identity_type column: 'identity_type'
        agent_type column: 'agent_type'
    }
}
