package finance

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class CardServicesServiceSpec extends Specification {

    CardServicesService cardServicesService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new CardServices(...).save(flush: true, failOnError: true)
        //new CardServices(...).save(flush: true, failOnError: true)
        //CardServices cardServices = new CardServices(...).save(flush: true, failOnError: true)
        //new CardServices(...).save(flush: true, failOnError: true)
        //new CardServices(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //cardServices.id
    }

    void "test get"() {
        setupData()

        expect:
        cardServicesService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<CardServices> cardServicesList = cardServicesService.list(max: 2, offset: 2)

        then:
        cardServicesList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        cardServicesService.count() == 5
    }

    void "test delete"() {
        Long cardServicesId = setupData()

        expect:
        cardServicesService.count() == 5

        when:
        cardServicesService.delete(cardServicesId)
        sessionFactory.currentSession.flush()

        then:
        cardServicesService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        CardServices cardServices = new CardServices()
        cardServicesService.save(cardServices)

        then:
        cardServices.id != null
    }
}
