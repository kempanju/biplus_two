package admin

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class DictionaryItemController {

    DictionaryItemService dictionaryItemService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        session["activePage"] = "admin"
        params.max = Math.min(max ?: 10, 100)
        respond dictionaryItemService.list(params), model:[dictionaryItemCount: dictionaryItemService.count()]
    }

    def show(Long id) {
        respond dictionaryItemService.get(id)
    }

    def create() {
        respond new DictionaryItem(params)
    }

    def save(DictionaryItem dictionaryItem) {
        if (dictionaryItem == null) {
            notFound()
            return
        }

        try {
            dictionaryItemService.save(dictionaryItem)
        } catch (ValidationException e) {
            respond dictionaryItem.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'dictionaryItem.label', default: 'DictionaryItem'), dictionaryItem.id])
                redirect dictionaryItem
            }
            '*' { respond dictionaryItem, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond dictionaryItemService.get(id)
    }

    def update(DictionaryItem dictionaryItem) {
        if (dictionaryItem == null) {
            notFound()
            return
        }

        try {
            dictionaryItemService.save(dictionaryItem)
        } catch (ValidationException e) {
            respond dictionaryItem.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'dictionaryItem.label', default: 'DictionaryItem'), dictionaryItem.id])
                redirect dictionaryItem
            }
            '*'{ respond dictionaryItem, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        dictionaryItemService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'dictionaryItem.label', default: 'DictionaryItem'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'dictionaryItem.label', default: 'DictionaryItem'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
