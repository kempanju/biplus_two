package com.softhama.loans

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*
@Secured("isAuthenticated()")
class LoanRequestController {

    LoanRequestService loanRequestService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        def userInstance = springSecurityService.currentUser

        session["activePage"] = "loans"
        params.max = Math.min(max ?: 10, 100)
        render view: 'index', model:[loanRequestList:LoanRequest.findAllByCustomer_idAndLoan_status(userInstance.customer,2,params),loanRequestCount: LoanRequest.countByCustomer_idAndLoan_status(userInstance.customer,2), customer:userInstance.customer]
    }

    def show(Long id) {
        session["activePage"] = "loans"
        def userInstance = springSecurityService.currentUser
        respond LoanRequest.findByIdAndCustomer_id(id,userInstance.customer)
    }

    def create() {
        respond new LoanRequest(params)
    }



    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'loanRequest.label', default: 'LoanRequest'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
