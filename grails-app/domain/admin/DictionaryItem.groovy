package admin

class DictionaryItem {

    int version,id
    String name,name_en,code
    Dictionary dictionary_id
    static mapping = {
        table name: 'gen_dictionary_item'
        dictionary_id column: 'dictionary_id'
    }
    static constraints = {
        name_en nullable: true
    }
}
