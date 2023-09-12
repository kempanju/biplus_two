package com.softhama.loans

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*
@Secured("isAuthenticated()")
class LoanRepaymentController {

    LoanRepaymentService loanRepaymentService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        session["activePage"] = "loans"
        params.max = Math.min(max ?: 10, 100)
        def userInstance = springSecurityService.currentUser

        def repaymentList =  LoanRepayment.executeQuery("from LoanRepayment where loan_id.customer_id=:customer",[customer:userInstance.customer],params)
        def repaymentListCount =  LoanRepayment.executeQuery("from LoanRepayment where loan_id.customer_id=:customer",[customer:userInstance.customer]).size()

        render view: 'index', model:[loanRepaymentList:repaymentList, loanRepaymentCount: repaymentListCount]
    }

    def show(Long id) {
        session["activePage"] = "loans"
        respond loanRepaymentService.get(id)
    }

    def create() {
        respond new LoanRepayment(params)
    }

    def save(LoanRepayment loanRepayment) {
        if (loanRepayment == null) {
            notFound()
            return
        }

        try {
            loanRepaymentService.save(loanRepayment)
        } catch (ValidationException e) {
            respond loanRepayment.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), loanRepayment.id])
                redirect loanRepayment
            }
            '*' { respond loanRepayment, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond loanRepaymentService.get(id)
    }

    def update(LoanRepayment loanRepayment) {
        if (loanRepayment == null) {
            notFound()
            return
        }

        try {
            loanRepaymentService.save(loanRepayment)
        } catch (ValidationException e) {
            respond loanRepayment.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), loanRepayment.id])
                redirect loanRepayment
            }
            '*'{ respond loanRepayment, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        loanRepaymentService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'loanRepayment.label', default: 'LoanRepayment'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
