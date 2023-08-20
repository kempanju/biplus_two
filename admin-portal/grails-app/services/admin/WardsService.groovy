package admin

import grails.gorm.services.Service

@Service(Wards)
interface WardsService {

    Wards get(Serializable id)

    List<Wards> list(Map args)

    Long count()

    void delete(Serializable id)

    Wards save(Wards wards)

}