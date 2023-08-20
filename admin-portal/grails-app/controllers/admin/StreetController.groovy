package admin

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class StreetController {

    StreetService streetService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond streetService.list(params), model:[streetCount: streetService.count()]
    }

    def show(Long id) {
        respond streetService.get(id)
    }

    def create() {
        respond new Street(params)
    }

    def save(Street street) {
        if (street == null) {
            notFound()
            return
        }

        try {
            streetService.save(street)
        } catch (ValidationException e) {
            respond street.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'street.label', default: 'Street'), street.id])
                redirect street
            }
            '*' { respond street, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond streetService.get(id)
    }

    def update(Street street) {
        if (street == null) {
            notFound()
            return
        }

        try {
            streetService.save(street)
        } catch (ValidationException e) {
            respond street.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'street.label', default: 'Street'), street.id])
                redirect street
            }
            '*'{ respond street, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        streetService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'street.label', default: 'Street'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'street.label', default: 'Street'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
