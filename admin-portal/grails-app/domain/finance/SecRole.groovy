package finance

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@GrailsCompileStatic
@EqualsAndHashCode(includes='authority')
@ToString(includes='authority', includeNames=true, includePackage=false)
class SecRole implements Serializable {

	private static final long serialVersionUID = 1

	String authority,description

	static constraints = {
		authority nullable: false, blank: false, unique: true
		description nullable: true
	}

	static mapping = {
		table 'gen_role'
		cache true
	}
}
