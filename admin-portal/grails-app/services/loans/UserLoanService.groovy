package loans

import grails.gorm.services.Service

@Service(UserLoan)
interface UserLoanService {

    UserLoan get(Serializable id)

    List<UserLoan> list(Map args)

    Long count()

    void delete(Serializable id)

    UserLoan save(UserLoan userLoan)

}