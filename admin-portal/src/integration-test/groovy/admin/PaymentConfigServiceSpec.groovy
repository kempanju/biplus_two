package admin

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class PaymentConfigServiceSpec extends Specification {

    PaymentConfigService paymentConfigService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new PaymentConfig(...).save(flush: true, failOnError: true)
        //new PaymentConfig(...).save(flush: true, failOnError: true)
        //PaymentConfig paymentConfig = new PaymentConfig(...).save(flush: true, failOnError: true)
        //new PaymentConfig(...).save(flush: true, failOnError: true)
        //new PaymentConfig(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //paymentConfig.id
    }

    void "test get"() {
        setupData()

        expect:
        paymentConfigService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<PaymentConfig> paymentConfigList = paymentConfigService.list(max: 2, offset: 2)

        then:
        paymentConfigList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        paymentConfigService.count() == 5
    }

    void "test delete"() {
        Long paymentConfigId = setupData()

        expect:
        paymentConfigService.count() == 5

        when:
        paymentConfigService.delete(paymentConfigId)
        sessionFactory.currentSession.flush()

        then:
        paymentConfigService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        PaymentConfig paymentConfig = new PaymentConfig()
        paymentConfigService.save(paymentConfig)

        then:
        paymentConfig.id != null
    }
}
