package employee

import finance.SecUser
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.security.crypto.password.PasswordEncoder

import static org.springframework.http.HttpStatus.*
@Secured("isAuthenticated()")
class EmployeeUserController {

    EmployeeUserService employeeUserService
    def passwordEncoder

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        session["activePage"] = "employer"
        params.max = Math.min(max ?: 10, 100)
        respond employeeUserService.list(params), model:[employeeUserCount: employeeUserService.count()]
    }

    def show(Long id) {
        session["activePage"] = "employer"
        respond employeeUserService.get(id)
    }

    // @Secured(['ROLE_ADMIN'])
    @Transactional
    def changePasswordUser(){
        println(params)
        def userInstance = EmployeeUser.get(params.id)
        userInstance.password = passwordEncoder.encode(params.newpassword)
        //userInstance.username=params.username
        userInstance.accountLocked=0
        userInstance.save()
        flash.message="Password successfully changed"
        redirect(action: 'show',params: [id: params.id])
    }


    def create() {

        respond new EmployeeUser(params)
    }

    def save(EmployeeUser employeeUser) {
        employeeUser.password = passwordEncoder.encode(System.currentTimeMillis()+"")
        if (employeeUser == null) {
            notFound()
            return
        }

        try {
            employeeUserService.save(employeeUser)
        } catch (ValidationException e) {
            respond employeeUser.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'employeeUser.label', default: 'EmployeeUser'), employeeUser.id])
                redirect employeeUser
            }
            '*' { respond employeeUser, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond employeeUserService.get(id)
    }

    def update(EmployeeUser employeeUser) {
        if (employeeUser == null) {
            notFound()
            return
        }

        try {
            employeeUserService.save(employeeUser)
        } catch (ValidationException e) {
            respond employeeUser.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'employeeUser.label', default: 'EmployeeUser'), employeeUser.id])
                redirect employeeUser
            }
            '*'{ respond employeeUser, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        employeeUserService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'employeeUser.label', default: 'EmployeeUser'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'employeeUser.label', default: 'EmployeeUser'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
