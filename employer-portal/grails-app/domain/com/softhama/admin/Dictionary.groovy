package com.softhama.admin

class Dictionary {
    int version,id
    String name,name_en,code
    static mapping = {
        table name: 'gen_dictionary'
    }
    static constraints = {
        name_en nullable: true
        code unique: true
    }
}
