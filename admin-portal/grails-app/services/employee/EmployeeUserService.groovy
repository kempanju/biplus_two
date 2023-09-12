package employee

import grails.gorm.services.Service

@Service(EmployeeUser)
interface EmployeeUserService {

    EmployeeUser get(Serializable id)

    List<EmployeeUser> list(Map args)

    Long count()

    void delete(Serializable id)

    EmployeeUser save(EmployeeUser employeeUser)

}