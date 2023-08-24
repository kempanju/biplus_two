package loans

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN','ROLE_LOAN','ROLE_MANAGER'])
class UserLoanController {

    UserLoanService userLoanService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond userLoanService.list(params), model:[userLoanCount: userLoanService.count()]
    }

    def show(Long id) {
        respond userLoanService.get(id)
    }

    def create() {
        respond new UserLoan(params)
    }

    def save(UserLoan userLoan) {
        if (userLoan == null) {
            notFound()
            return
        }

        try {
            userLoanService.save(userLoan)
        } catch (ValidationException e) {
            respond userLoan.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'userLoan.label', default: 'UserLoan'), userLoan.id])
                redirect userLoan
            }
            '*' { respond userLoan, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond userLoanService.get(id)
    }

    def update(UserLoan userLoan) {
        if (userLoan == null) {
            notFound()
            return
        }

        try {
            userLoanService.save(userLoan)
        } catch (ValidationException e) {
            respond userLoan.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'userLoan.label', default: 'UserLoan'), userLoan.id])
                redirect userLoan
            }
            '*'{ respond userLoan, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        userLoanService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'userLoan.label', default: 'UserLoan'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'userLoan.label', default: 'UserLoan'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
