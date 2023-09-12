package employee

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class EmployeeUserServiceSpec extends Specification {

    EmployeeUserService employeeUserService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new EmployeeUser(...).save(flush: true, failOnError: true)
        //new EmployeeUser(...).save(flush: true, failOnError: true)
        //EmployeeUser employeeUser = new EmployeeUser(...).save(flush: true, failOnError: true)
        //new EmployeeUser(...).save(flush: true, failOnError: true)
        //new EmployeeUser(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //employeeUser.id
    }

    void "test get"() {
        setupData()

        expect:
        employeeUserService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<EmployeeUser> employeeUserList = employeeUserService.list(max: 2, offset: 2)

        then:
        employeeUserList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        employeeUserService.count() == 5
    }

    void "test delete"() {
        Long employeeUserId = setupData()

        expect:
        employeeUserService.count() == 5

        when:
        employeeUserService.delete(employeeUserId)
        sessionFactory.currentSession.flush()

        then:
        employeeUserService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        EmployeeUser employeeUser = new EmployeeUser()
        employeeUserService.save(employeeUser)

        then:
        employeeUser.id != null
    }
}
