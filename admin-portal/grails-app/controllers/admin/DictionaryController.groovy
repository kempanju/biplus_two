package admin

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class DictionaryController {

    DictionaryService dictionaryService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        session["activePage"] = "admin"
        params.max = Math.min(max ?: 10, 100)
        respond dictionaryService.list(params), model:[dictionaryCount: dictionaryService.count()]
    }

    def show(Long id) {
        respond dictionaryService.get(id)
    }

    def create() {
        respond new Dictionary(params)
    }

    def save(Dictionary dictionary) {
        if (dictionary == null) {
            notFound()
            return
        }

        try {
            dictionaryService.save(dictionary)
        } catch (ValidationException e) {
            respond dictionary.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'dictionary.label', default: 'Dictionary'), dictionary.id])
                redirect dictionary
            }
            '*' { respond dictionary, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond dictionaryService.get(id)
    }

    def update(Dictionary dictionary) {
        if (dictionary == null) {
            notFound()
            return
        }

        try {
            dictionaryService.save(dictionary)
        } catch (ValidationException e) {
            respond dictionary.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'dictionary.label', default: 'Dictionary'), dictionary.id])
                redirect dictionary
            }
            '*'{ respond dictionary, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        dictionaryService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'dictionary.label', default: 'Dictionary'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'dictionary.label', default: 'Dictionary'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
