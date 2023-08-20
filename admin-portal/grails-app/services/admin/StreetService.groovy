package admin

import grails.gorm.services.Service

@Service(Street)
interface StreetService {

    Street get(Serializable id)

    List<Street> list(Map args)

    Long count()

    void delete(Serializable id)

    Street save(Street street)

}