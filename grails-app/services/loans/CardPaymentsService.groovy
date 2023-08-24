package loans

import grails.gorm.services.Service

@Service(CardPayments)
interface CardPaymentsService {

    CardPayments get(Serializable id)

    List<CardPayments> list(Map args)

    Long count()

    void delete(Serializable id)

    CardPayments save(CardPayments cardPayments)

}