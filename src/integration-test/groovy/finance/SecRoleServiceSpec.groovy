package finance

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class SecRoleServiceSpec extends Specification {

    SecRoleService secRoleService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new SecRole(...).save(flush: true, failOnError: true)
        //new SecRole(...).save(flush: true, failOnError: true)
        //SecRole secRole = new SecRole(...).save(flush: true, failOnError: true)
        //new SecRole(...).save(flush: true, failOnError: true)
        //new SecRole(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //secRole.id
    }

    void "test get"() {
        setupData()

        expect:
        secRoleService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<SecRole> secRoleList = secRoleService.list(max: 2, offset: 2)

        then:
        secRoleList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        secRoleService.count() == 5
    }

    void "test delete"() {
        Long secRoleId = setupData()

        expect:
        secRoleService.count() == 5

        when:
        secRoleService.delete(secRoleId)
        sessionFactory.currentSession.flush()

        then:
        secRoleService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        SecRole secRole = new SecRole()
        secRoleService.save(secRole)

        then:
        secRole.id != null
    }
}
