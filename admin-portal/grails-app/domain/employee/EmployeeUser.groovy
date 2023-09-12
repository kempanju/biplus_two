package employee

import admin.Customers

class EmployeeUser {

    private static final long serialVersionUID = 1

    String username
    String password
    String full_name
    String phone_number
    boolean enabled = true
    boolean accountExpired
    boolean accountLocked
    boolean passwordExpired
    Customers customer

    static constraints = {
        password nullable: false, blank: false, password: true
        username nullable: false, blank: false, unique: true
        phone_number nullable: true
    }

    static mapping = {
        table 'employer_users'
        password column: '`password`'
    }

}
