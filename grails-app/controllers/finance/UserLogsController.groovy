package finance

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class UserLogsController {

    UserLogsService userLogsService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.sort = 'id'
        params.order = 'desc'
        session["activePage"] = "logs"

        params.max = Math.min(max ?: 5, 100)
        respond userLogsService.list(params), model:[userLogsCount: userLogsService.count()]
    }
    def logsByUser(Integer max){
        if(!params.order) {
            params.sort = 'id'
            params.order = 'desc'
        }
        params.max = Math.min(max ?: 5, 100)
        def userInstance=SecUser.get(params.id)
        respond UserLogs.findAllByUser_id(userInstance,params), model:[userLogsCount: UserLogs.countByUser_id(userInstance)]
    }
    def show(Long id) {
        respond userLogsService.get(id)
    }

    def create() {
        respond new UserLogs(params)
    }

    def save(UserLogs userLogs) {
        if (userLogs == null) {
            notFound()
            return
        }

        try {
            userLogsService.save(userLogs)
        } catch (ValidationException e) {
            respond userLogs.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'userLogs.label', default: 'UserLogs'), userLogs.id])
                redirect userLogs
            }
            '*' { respond userLogs, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond userLogsService.get(id)
    }

    def update(UserLogs userLogs) {
        if (userLogs == null) {
            notFound()
            return
        }

        try {
            userLogsService.save(userLogs)
        } catch (ValidationException e) {
            respond userLogs.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'userLogs.label', default: 'UserLogs'), userLogs.id])
                redirect userLogs
            }
            '*'{ respond userLogs, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        userLogsService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'userLogs.label', default: 'UserLogs'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'userLogs.label', default: 'UserLogs'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
