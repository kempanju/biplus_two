package admin

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class RegionController {

    RegionService regionService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond regionService.list(params), model:[regionCount: regionService.count()]
    }

    def show(Long id) {
        respond regionService.get(id)
    }

    def create() {
        respond new Region(params)
    }

    def save(Region region) {
        if (region == null) {
            notFound()
            return
        }

        try {
            regionService.save(region)
        } catch (ValidationException e) {
            respond region.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'region.label', default: 'Region'), region.id])
                redirect region
            }
            '*' { respond region, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond regionService.get(id)
    }

    def update(Region region) {
        if (region == null) {
            notFound()
            return
        }

        try {
            regionService.save(region)
        } catch (ValidationException e) {
            respond region.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'region.label', default: 'Region'), region.id])
                redirect region
            }
            '*'{ respond region, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        regionService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'region.label', default: 'Region'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'region.label', default: 'Region'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
