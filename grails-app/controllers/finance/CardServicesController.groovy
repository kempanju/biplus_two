package finance

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class CardServicesController {

    CardServicesService cardServicesService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond cardServicesService.list(params), model:[cardServicesCount: cardServicesService.count()]
    }

    def show(Long id) {
        respond cardServicesService.get(id)
    }

    def create() {
        respond new CardServices(params)
    }

    def save(CardServices cardServices) {
        if (cardServices == null) {
            notFound()
            return
        }

        try {
            cardServicesService.save(cardServices)
        } catch (ValidationException e) {
            respond cardServices.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'cardServices.label', default: 'CardServices'), cardServices.id])
                redirect cardServices
            }
            '*' { respond cardServices, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond cardServicesService.get(id)
    }

    def update(CardServices cardServices) {
        if (cardServices == null) {
            notFound()
            return
        }

        try {
            cardServicesService.save(cardServices)
        } catch (ValidationException e) {
            respond cardServices.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'cardServices.label', default: 'CardServices'), cardServices.id])
                redirect cardServices
            }
            '*'{ respond cardServices, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        cardServicesService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'cardServices.label', default: 'CardServices'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'cardServices.label', default: 'CardServices'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
