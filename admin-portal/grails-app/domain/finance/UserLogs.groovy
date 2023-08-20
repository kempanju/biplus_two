package finance

import admin.DictionaryItem


class UserLogs {
    int id,version
    SecUser user_id
    DictionaryItem dictionary_id
    String message
    java.sql.Timestamp created_at


    static constraints = {
        created_at nullable: true
    }

    static mapping = {
        table 'gen_users_logs'
        user_id column: 'user_id'
        dictionary_id column: 'dictionary_id'
    }

    def beforeInsert = {
        def current_time = Calendar.instance
        created_at = new java.sql.Timestamp(current_time.time.time)

    }
}
