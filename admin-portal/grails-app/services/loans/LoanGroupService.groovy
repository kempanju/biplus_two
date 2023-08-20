package loans

import grails.gorm.services.Service

@Service(LoanGroup)
interface LoanGroupService {

    LoanGroup get(Serializable id)

    List<LoanGroup> list(Map args)

    Long count()

    void delete(Serializable id)

    LoanGroup save(LoanGroup loanGroup)

}