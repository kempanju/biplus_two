package com.softhama.loans

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class LoanRequestServiceSpec extends Specification {

    LoanRequestService loanRequestService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new LoanRequest(...).save(flush: true, failOnError: true)
        //new LoanRequest(...).save(flush: true, failOnError: true)
        //LoanRequest loanRequest = new LoanRequest(...).save(flush: true, failOnError: true)
        //new LoanRequest(...).save(flush: true, failOnError: true)
        //new LoanRequest(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //loanRequest.id
    }

    void "test get"() {
        setupData()

        expect:
        loanRequestService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<LoanRequest> loanRequestList = loanRequestService.list(max: 2, offset: 2)

        then:
        loanRequestList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        loanRequestService.count() == 5
    }

    void "test delete"() {
        Long loanRequestId = setupData()

        expect:
        loanRequestService.count() == 5

        when:
        loanRequestService.delete(loanRequestId)
        sessionFactory.currentSession.flush()

        then:
        loanRequestService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        LoanRequest loanRequest = new LoanRequest()
        loanRequestService.save(loanRequest)

        then:
        loanRequest.id != null
    }
}
