package admin

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class WardsServiceSpec extends Specification {

    WardsService wardsService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new Wards(...).save(flush: true, failOnError: true)
        //new Wards(...).save(flush: true, failOnError: true)
        //Wards wards = new Wards(...).save(flush: true, failOnError: true)
        //new Wards(...).save(flush: true, failOnError: true)
        //new Wards(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //wards.id
    }

    void "test get"() {
        setupData()

        expect:
        wardsService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<Wards> wardsList = wardsService.list(max: 2, offset: 2)

        then:
        wardsList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        wardsService.count() == 5
    }

    void "test delete"() {
        Long wardsId = setupData()

        expect:
        wardsService.count() == 5

        when:
        wardsService.delete(wardsId)
        sessionFactory.currentSession.flush()

        then:
        wardsService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        Wards wards = new Wards()
        wardsService.save(wards)

        then:
        wards.id != null
    }
}
