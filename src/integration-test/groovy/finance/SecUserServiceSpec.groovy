package finance

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class SecUserServiceSpec extends Specification {

    SecUserService secUserService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new SecUser(...).save(flush: true, failOnError: true)
        //new SecUser(...).save(flush: true, failOnError: true)
        //SecUser secUser = new SecUser(...).save(flush: true, failOnError: true)
        //new SecUser(...).save(flush: true, failOnError: true)
        //new SecUser(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //secUser.id
    }

    void "test get"() {
        setupData()

        expect:
        secUserService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<SecUser> secUserList = secUserService.list(max: 2, offset: 2)

        then:
        secUserList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        secUserService.count() == 5
    }

    void "test delete"() {
        Long secUserId = setupData()

        expect:
        secUserService.count() == 5

        when:
        secUserService.delete(secUserId)
        sessionFactory.currentSession.flush()

        then:
        secUserService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        SecUser secUser = new SecUser()
        secUserService.save(secUser)

        then:
        secUser.id != null
    }
}
