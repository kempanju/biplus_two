package loans

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class LoanGroupServiceSpec extends Specification {

    LoanGroupService loanGroupService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new LoanGroup(...).save(flush: true, failOnError: true)
        //new LoanGroup(...).save(flush: true, failOnError: true)
        //LoanGroup loanGroup = new LoanGroup(...).save(flush: true, failOnError: true)
        //new LoanGroup(...).save(flush: true, failOnError: true)
        //new LoanGroup(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //loanGroup.id
    }

    void "test get"() {
        setupData()

        expect:
        loanGroupService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<LoanGroup> loanGroupList = loanGroupService.list(max: 2, offset: 2)

        then:
        loanGroupList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        loanGroupService.count() == 5
    }

    void "test delete"() {
        Long loanGroupId = setupData()

        expect:
        loanGroupService.count() == 5

        when:
        loanGroupService.delete(loanGroupId)
        sessionFactory.currentSession.flush()

        then:
        loanGroupService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        LoanGroup loanGroup = new LoanGroup()
        loanGroupService.save(loanGroup)

        then:
        loanGroup.id != null
    }
}
