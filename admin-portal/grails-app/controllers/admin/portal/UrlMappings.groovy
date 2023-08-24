package admin.portal

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/api/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: 'loanRequest',action: 'reports')
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
