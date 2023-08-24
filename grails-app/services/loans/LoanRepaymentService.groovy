package loans

import grails.gorm.services.Service

@Service(LoanRepayment)
interface LoanRepaymentService {

    LoanRepayment get(Serializable id)

    List<LoanRepayment> list(Map args)

    Long count()

    void delete(Serializable id)

    LoanRepayment save(LoanRepayment loanRepayment)

}