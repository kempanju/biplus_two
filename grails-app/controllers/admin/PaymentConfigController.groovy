package admin

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class PaymentConfigController {

    PaymentConfigService paymentConfigService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        session["activePage"] = "admin"
        params.max = Math.min(max ?: 10, 100)
        respond paymentConfigService.list(params), model:[paymentConfigCount: paymentConfigService.count()]
    }

    def show(Long id) {
        respond paymentConfigService.get(id)
    }

    def create() {
        respond new PaymentConfig(params)
    }

    @Secured('ROLE_ADMIN')
    def save(PaymentConfig paymentConfig) {
        if (paymentConfig == null) {
            notFound()
            return
        }

        try {
            paymentConfigService.save(paymentConfig)
        } catch (ValidationException e) {
            respond paymentConfig.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'paymentConfig.label', default: 'PaymentConfig'), paymentConfig.id])
                redirect paymentConfig
            }
            '*' { respond paymentConfig, [status: CREATED] }
        }
    }

    @Secured('ROLE_ADMIN')
    def edit(Long id) {
        respond paymentConfigService.get(id)
    }

    def update(PaymentConfig paymentConfig) {
        if (paymentConfig == null) {
            notFound()
            return
        }

        try {
            paymentConfigService.save(paymentConfig)
        } catch (ValidationException e) {
            respond paymentConfig.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'paymentConfig.label', default: 'PaymentConfig'), paymentConfig.id])
                redirect paymentConfig
            }
            '*'{ respond paymentConfig, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        paymentConfigService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'paymentConfig.label', default: 'PaymentConfig'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'paymentConfig.label', default: 'PaymentConfig'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
