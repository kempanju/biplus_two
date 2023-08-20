package finance

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class UserLogsServiceSpec extends Specification {

    UserLogsService userLogsService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new UserLogs(...).save(flush: true, failOnError: true)
        //new UserLogs(...).save(flush: true, failOnError: true)
        //UserLogs userLogs = new UserLogs(...).save(flush: true, failOnError: true)
        //new UserLogs(...).save(flush: true, failOnError: true)
        //new UserLogs(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //userLogs.id
    }

    void "test get"() {
        setupData()

        expect:
        userLogsService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<UserLogs> userLogsList = userLogsService.list(max: 2, offset: 2)

        then:
        userLogsList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        userLogsService.count() == 5
    }

    void "test delete"() {
        Long userLogsId = setupData()

        expect:
        userLogsService.count() == 5

        when:
        userLogsService.delete(userLogsId)
        sessionFactory.currentSession.flush()

        then:
        userLogsService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        UserLogs userLogs = new UserLogs()
        userLogsService.save(userLogs)

        then:
        userLogs.id != null
    }
}
