package admin

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class StreetServiceSpec extends Specification {

    StreetService streetService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new Street(...).save(flush: true, failOnError: true)
        //new Street(...).save(flush: true, failOnError: true)
        //Street street = new Street(...).save(flush: true, failOnError: true)
        //new Street(...).save(flush: true, failOnError: true)
        //new Street(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //street.id
    }

    void "test get"() {
        setupData()

        expect:
        streetService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<Street> streetList = streetService.list(max: 2, offset: 2)

        then:
        streetList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        streetService.count() == 5
    }

    void "test delete"() {
        Long streetId = setupData()

        expect:
        streetService.count() == 5

        when:
        streetService.delete(streetId)
        sessionFactory.currentSession.flush()

        then:
        streetService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        Street street = new Street()
        streetService.save(street)

        then:
        street.id != null
    }
}
