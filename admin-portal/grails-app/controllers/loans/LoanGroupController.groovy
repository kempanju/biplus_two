package loans

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class LoanGroupController {

    LoanGroupService loanGroupService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        session["activePage"] = "loans"
        params.max = Math.min(max ?: 10, 100)
        respond loanGroupService.list(params), model:[loanGroupCount: loanGroupService.count()]
    }

    def show(Long id) {
        respond loanGroupService.get(id)
    }

    def create() {
        respond new LoanGroup(params)
    }

    def save(LoanGroup loanGroup) {
        if (loanGroup == null) {
            notFound()
            return
        }

        try {
            loanGroupService.save(loanGroup)
        } catch (ValidationException e) {
            respond loanGroup.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'loanGroup.label', default: 'LoanGroup'), loanGroup.id])
                redirect loanGroup
            }
            '*' { respond loanGroup, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond loanGroupService.get(id)
    }

    def update(LoanGroup loanGroup) {
        if (loanGroup == null) {
            notFound()
            return
        }

        try {
            loanGroupService.save(loanGroup)
        } catch (ValidationException e) {
            respond loanGroup.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'loanGroup.label', default: 'LoanGroup'), loanGroup.id])
                redirect loanGroup
            }
            '*'{ respond loanGroup, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        loanGroupService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'loanGroup.label', default: 'LoanGroup'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'loanGroup.label', default: 'LoanGroup'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
