package loans

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class CardPaymentsServiceSpec extends Specification {

    CardPaymentsService cardPaymentsService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new CardPayments(...).save(flush: true, failOnError: true)
        //new CardPayments(...).save(flush: true, failOnError: true)
        //CardPayments cardPayments = new CardPayments(...).save(flush: true, failOnError: true)
        //new CardPayments(...).save(flush: true, failOnError: true)
        //new CardPayments(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //cardPayments.id
    }

    void "test get"() {
        setupData()

        expect:
        cardPaymentsService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<CardPayments> cardPaymentsList = cardPaymentsService.list(max: 2, offset: 2)

        then:
        cardPaymentsList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        cardPaymentsService.count() == 5
    }

    void "test delete"() {
        Long cardPaymentsId = setupData()

        expect:
        cardPaymentsService.count() == 5

        when:
        cardPaymentsService.delete(cardPaymentsId)
        sessionFactory.currentSession.flush()

        then:
        cardPaymentsService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        CardPayments cardPayments = new CardPayments()
        cardPaymentsService.save(cardPayments)

        then:
        cardPayments.id != null
    }
}
