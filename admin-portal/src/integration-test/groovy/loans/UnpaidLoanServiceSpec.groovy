package loans

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class UnpaidLoanServiceSpec extends Specification {

    UnpaidLoanService unpaidLoanService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new UnpaidLoan(...).save(flush: true, failOnError: true)
        //new UnpaidLoan(...).save(flush: true, failOnError: true)
        //UnpaidLoan unpaidLoan = new UnpaidLoan(...).save(flush: true, failOnError: true)
        //new UnpaidLoan(...).save(flush: true, failOnError: true)
        //new UnpaidLoan(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //unpaidLoan.id
    }

    void "test get"() {
        setupData()

        expect:
        unpaidLoanService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<UnpaidLoan> unpaidLoanList = unpaidLoanService.list(max: 2, offset: 2)

        then:
        unpaidLoanList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        unpaidLoanService.count() == 5
    }

    void "test delete"() {
        Long unpaidLoanId = setupData()

        expect:
        unpaidLoanService.count() == 5

        when:
        unpaidLoanService.delete(unpaidLoanId)
        sessionFactory.currentSession.flush()

        then:
        unpaidLoanService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        UnpaidLoan unpaidLoan = new UnpaidLoan()
        unpaidLoanService.save(unpaidLoan)

        then:
        unpaidLoan.id != null
    }
}
