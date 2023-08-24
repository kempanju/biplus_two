package admin

class Street {
    int id,version
    String name
    District district_id
    Wards ward_id
    Boolean deleted

    static constraints = {
        deleted nullable: true

        name (unique:['district_id','ward_id'])

    }

    static mapping = {
        table name: 'gen_street'
        district_id column:'district_id'
        ward_id column: 'ward_id'
    }
}
