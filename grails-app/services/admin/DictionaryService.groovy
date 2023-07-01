package admin

import grails.gorm.services.Service

@Service(Dictionary)
interface DictionaryService {

    Dictionary get(Serializable id)

    List<Dictionary> list(Map args)

    Long count()

    void delete(Serializable id)

    Dictionary save(Dictionary dictionary)

}