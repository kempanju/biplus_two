package admin

class District {
    int id,version
    String code,name
    Region region_id
    Boolean d_deleted

    static mapping = {
        table name: 'gen_district'
        region_id column:'region_id'
    }
    static constraints = {
        code nullable: true
        name unique: true
        d_deleted nullable: true
    }

    def beforeInsert = {
        d_deleted=0
    }
}
