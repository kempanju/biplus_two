package admin

import finance.SecUser

class Region {

    int id,version
    String code,name
   // Country country_id
    SecUser created_by
    java.sql.Timestamp created_at
    def user
    def springSecurityService

    static mapping = {
        table name: 'gen_region'
        //country_id column:'country_id'
        created_by column: 'created_by'
    }

    static constraints = {
        name unique: true
        code nullable: true, unique: true
        created_at nullable: true
        created_by nullable: true
    }

    def beforeUpdate = {
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)
        user = SecUser.findById(springSecurityService.principal.id)
        created_by = user

    }
}
