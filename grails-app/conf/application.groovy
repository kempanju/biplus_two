grails.plugin.springsecurity.rest.token.storage.jwt.secret="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ"

// Added by the Spring Security Core plugin:
grails.plugin.springsecurity.userLookup.userDomainClassName = 'finance.SecUser'
grails.plugin.springsecurity.userLookup.authorityJoinClassName = 'finance.SecUserSecRole'
grails.plugin.springsecurity.authority.className = 'finance.SecRole'
grails.plugin.springsecurity.controllerAnnotations.staticRules = [
		[pattern: '/',               access: ['permitAll']],
		[pattern: '/error',          access: ['permitAll']],
		[pattern: '/index',          access: ['permitAll']],
		[pattern: '/index.gsp',      access: ['permitAll']],
		[pattern: '/shutdown',       access: ['permitAll']],
		[pattern: '/assets/**',      access: ['permitAll']],
		[pattern: '/**/js/**',       access: ['permitAll']],
		[pattern: '/**/css/**',      access: ['permitAll']],
		[pattern: '/**/images/**',   access: ['permitAll']],
		[pattern: '/**/favicon.ico', access: ['permitAll']],
		[pattern: '/home/**',    access: ['permitAll']],
		[pattern: '/register/**',    access: ['permitAll']],
		[pattern: '/user/**',    access: ['permitAll']],
		[pattern: '/gateway/request',    access: ['permitAll']],
		[pattern: '/gateway/repayment',    access: ['permitAll']],
		[pattern: '/gateway/testData',    access: ['permitAll']],
		[pattern: '/secUser/changePasswordUser',    access: ['permitAll']],
		[pattern: '/qrcode/**',      access: ['permitAll']]
]

grails.plugin.springsecurity.filterChain.chainMap = [
		[pattern: '/assets/**',      filters: 'none'],
		[pattern: '/**/js/**',       filters: 'none'],
		[pattern: '/**/css/**',      filters: 'none'],
		[pattern: '/**/images/**',   filters: 'none'],
		[pattern: '/**/favicon.ico', filters: 'none'],
		[pattern: '/**',             filters: 'JOINED_FILTERS']
]
