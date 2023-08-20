package admin

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class DictionaryServiceSpec extends Specification {

    DictionaryService dictionaryService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new Dictionary(...).save(flush: true, failOnError: true)
        //new Dictionary(...).save(flush: true, failOnError: true)
        //Dictionary dictionary = new Dictionary(...).save(flush: true, failOnError: true)
        //new Dictionary(...).save(flush: true, failOnError: true)
        //new Dictionary(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //dictionary.id
    }

    void "test get"() {
        setupData()

        expect:
        dictionaryService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<Dictionary> dictionaryList = dictionaryService.list(max: 2, offset: 2)

        then:
        dictionaryList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        dictionaryService.count() == 5
    }

    void "test delete"() {
        Long dictionaryId = setupData()

        expect:
        dictionaryService.count() == 5

        when:
        dictionaryService.delete(dictionaryId)
        sessionFactory.currentSession.flush()

        then:
        dictionaryService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        Dictionary dictionary = new Dictionary()
        dictionaryService.save(dictionary)

        then:
        dictionary.id != null
    }
}
