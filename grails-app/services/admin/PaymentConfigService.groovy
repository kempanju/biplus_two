package admin

import grails.gorm.services.Service

@Service(PaymentConfig)
interface PaymentConfigService {

    PaymentConfig get(Serializable id)

    List<PaymentConfig> list(Map args)

    Long count()

    void delete(Serializable id)

    PaymentConfig save(PaymentConfig paymentConfig)

}