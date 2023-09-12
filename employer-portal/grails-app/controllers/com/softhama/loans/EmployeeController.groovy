package com.softhama.loans

import com.softhama.SecUser
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*
@Secured("isAuthenticated()")
class EmployeeController {

    EmployeeService employeeService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        def userInstance = springSecurityService.currentUser

        session["activePage"] = "users"
        params.max = Math.min(max ?: 10, 100)
        render view: 'index',  model:[employeeList: Employee.findAllByUser_group(userInstance.customer,params),employeeCount: Employee.countByUser_group(userInstance.customer)]
    }

    def show(Long id) {
        def userInstance = springSecurityService.currentUser
        respond Employee.findByIdAndUser_group(id, userInstance.customer)
    }

    def create() {
        respond new Employee(params)
    }





    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'employee.label', default: 'Employee'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
