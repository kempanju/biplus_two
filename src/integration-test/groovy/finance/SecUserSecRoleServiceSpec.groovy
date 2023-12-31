package finance

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class SecUserSecRoleServiceSpec extends Specification {

    SecUserSecRoleService secUserSecRoleService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new SecUserSecRole(...).save(flush: true, failOnError: true)
        //new SecUserSecRole(...).save(flush: true, failOnError: true)
        //SecUserSecRole secUserSecRole = new SecUserSecRole(...).save(flush: true, failOnError: true)
        //new SecUserSecRole(...).save(flush: true, failOnError: true)
        //new SecUserSecRole(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //secUserSecRole.id
    }

    void "test get"() {
        setupData()

        expect:
        secUserSecRoleService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<SecUserSecRole> secUserSecRoleList = secUserSecRoleService.list(max: 2, offset: 2)

        then:
        secUserSecRoleList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        secUserSecRoleService.count() == 5
    }

    void "test delete"() {
        Long secUserSecRoleId = setupData()

        expect:
        secUserSecRoleService.count() == 5

        when:
        secUserSecRoleService.delete(secUserSecRoleId)
        sessionFactory.currentSession.flush()

        then:
        secUserSecRoleService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        SecUserSecRole secUserSecRole = new SecUserSecRole()
        secUserSecRoleService.save(secUserSecRole)

        then:
        secUserSecRole.id != null
    }
}
