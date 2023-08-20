package loans

import grails.gorm.services.Service

@Service(UnpaidLoan)
interface UnpaidLoanService {

    UnpaidLoan get(Serializable id)

    List<UnpaidLoan> list(Map args)

    Long count()

    void delete(Serializable id)

    UnpaidLoan save(UnpaidLoan unpaidLoan)

}