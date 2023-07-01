package admin

import grails.gorm.services.Service

@Service(DictionaryItem)
interface DictionaryItemService {

    DictionaryItem get(Serializable id)

    List<DictionaryItem> list(Map args)

    Long count()

    void delete(Serializable id)

    DictionaryItem save(DictionaryItem dictionaryItem)

}