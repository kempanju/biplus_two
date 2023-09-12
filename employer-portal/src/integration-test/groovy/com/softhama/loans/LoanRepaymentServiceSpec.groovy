package com.softhama.loans

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class LoanRepaymentServiceSpec extends Specification {

    LoanRepaymentService loanRepaymentService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new LoanRepayment(...).save(flush: true, failOnError: true)
        //new LoanRepayment(...).save(flush: true, failOnError: true)
        //LoanRepayment loanRepayment = new LoanRepayment(...).save(flush: true, failOnError: true)
        //new LoanRepayment(...).save(flush: true, failOnError: true)
        //new LoanRepayment(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //loanRepayment.id
    }

    void "test get"() {
        setupData()

        expect:
        loanRepaymentService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<LoanRepayment> loanRepaymentList = loanRepaymentService.list(max: 2, offset: 2)

        then:
        loanRepaymentList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        loanRepaymentService.count() == 5
    }

    void "test delete"() {
        Long loanRepaymentId = setupData()

        expect:
        loanRepaymentService.count() == 5

        when:
        loanRepaymentService.delete(loanRepaymentId)
        sessionFactory.currentSession.flush()

        then:
        loanRepaymentService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        LoanRepayment loanRepayment = new LoanRepayment()
        loanRepaymentService.save(loanRepayment)

        then:
        loanRepayment.id != null
    }
}
