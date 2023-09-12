package employer.portal

import grails.plugin.springsecurity.annotation.Secured

@Secured("isAuthenticated()")
class HomeController {
    def springSecurityService

    def index() {
        session["activePage"] = "dashboard"
        def userInstance = springSecurityService.currentUser
        render(view: 'index', model: [customer:userInstance.customer])
    }
}
