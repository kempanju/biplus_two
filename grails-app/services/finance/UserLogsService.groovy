package finance

import grails.gorm.services.Service

@Service(UserLogs)
interface UserLogsService {

    UserLogs get(Serializable id)

    List<UserLogs> list(Map args)

    Long count()

    void delete(Serializable id)

    UserLogs save(UserLogs userLogs)

}