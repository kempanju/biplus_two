package loans

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class UserLoanServiceSpec extends Specification {

    UserLoanService userLoanService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new UserLoan(...).save(flush: true, failOnError: true)
        //new UserLoan(...).save(flush: true, failOnError: true)
        //UserLoan userLoan = new UserLoan(...).save(flush: true, failOnError: true)
        //new UserLoan(...).save(flush: true, failOnError: true)
        //new UserLoan(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //userLoan.id
    }

    void "test get"() {
        setupData()

        expect:
        userLoanService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<UserLoan> userLoanList = userLoanService.list(max: 2, offset: 2)

        then:
        userLoanList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        userLoanService.count() == 5
    }

    void "test delete"() {
        Long userLoanId = setupData()

        expect:
        userLoanService.count() == 5

        when:
        userLoanService.delete(userLoanId)
        sessionFactory.currentSession.flush()

        then:
        userLoanService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        UserLoan userLoan = new UserLoan()
        userLoanService.save(userLoan)

        then:
        userLoan.id != null
    }
}
