package loans

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class CardPaymentsController {

    CardPaymentsService cardPaymentsService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }
        session["activePage"] = "payments"

        respond cardPaymentsService.list(params), model:[cardPaymentsCount: cardPaymentsService.count()]
    }

    def show(Long id) {
        respond cardPaymentsService.get(id)
    }

    def create() {
        respond new CardPayments(params)
    }
    @Secured(['ROLE_ADMIN','ROLE_CARD','ROLE_MANAGER'])
    def  cardByUser(Integer max){
        params.sort = 'id'
        params.order = 'desc'
        params.max = Math.min(max ?: 10, 100)
        def userInstance=SecUser.get(params.id)
        //println(params+":User:"+userInstance)
        def cardPaymentList=CardPayments.findAllByUser_id(userInstance)
        render(view: 'cardByUser', model:[userInstance:userInstance,cardPaymentList:cardPaymentList])
    }
    def save(CardPayments cardPayments) {
        if (cardPayments == null) {
            notFound()
            return
        }

        try {
            cardPaymentsService.save(cardPayments)
        } catch (ValidationException e) {
            respond cardPayments.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'cardPayments.label', default: 'CardPayments'), cardPayments.id])
                redirect cardPayments
            }
            '*' { respond cardPayments, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond cardPaymentsService.get(id)
    }

    def update(CardPayments cardPayments) {
        if (cardPayments == null) {
            notFound()
            return
        }

        try {
            cardPaymentsService.save(cardPayments)
        } catch (ValidationException e) {
            respond cardPayments.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'cardPayments.label', default: 'CardPayments'), cardPayments.id])
                redirect cardPayments
            }
            '*'{ respond cardPayments, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        cardPaymentsService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'cardPayments.label', default: 'CardPayments'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'cardPayments.label', default: 'CardPayments'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
