package admin

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class DictionaryItemServiceSpec extends Specification {

    DictionaryItemService dictionaryItemService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new DictionaryItem(...).save(flush: true, failOnError: true)
        //new DictionaryItem(...).save(flush: true, failOnError: true)
        //DictionaryItem dictionaryItem = new DictionaryItem(...).save(flush: true, failOnError: true)
        //new DictionaryItem(...).save(flush: true, failOnError: true)
        //new DictionaryItem(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //dictionaryItem.id
    }

    void "test get"() {
        setupData()

        expect:
        dictionaryItemService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<DictionaryItem> dictionaryItemList = dictionaryItemService.list(max: 2, offset: 2)

        then:
        dictionaryItemList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        dictionaryItemService.count() == 5
    }

    void "test delete"() {
        Long dictionaryItemId = setupData()

        expect:
        dictionaryItemService.count() == 5

        when:
        dictionaryItemService.delete(dictionaryItemId)
        sessionFactory.currentSession.flush()

        then:
        dictionaryItemService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        DictionaryItem dictionaryItem = new DictionaryItem()
        dictionaryItemService.save(dictionaryItem)

        then:
        dictionaryItem.id != null
    }
}
