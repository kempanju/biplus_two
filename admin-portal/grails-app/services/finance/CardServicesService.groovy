package finance

import grails.gorm.services.Service

@Service(CardServices)
interface CardServicesService {

    CardServices get(Serializable id)

    List<CardServices> list(Map args)

    Long count()

    void delete(Serializable id)

    CardServices save(CardServices cardServices)

}