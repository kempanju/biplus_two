package loans

import grails.gorm.services.Service

@Service(LoanRequest)
interface LoanRequestService {

    LoanRequest get(Serializable id)

    List<LoanRequest> list(Map args)

    Long count()

    void delete(Serializable id)

    LoanRequest save(LoanRequest loanRequest)

}