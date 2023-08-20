package bi.plus

import grails.testing.web.taglib.TagLibUnitTest
import spock.lang.Specification

class GeneralMethodsTagLibSpec extends Specification implements TagLibUnitTest<GeneralMethodsTagLib> {

    def setup() {
    }

    def cleanup() {
    }

    void "test something"() {
        expect:"fix me"
            true == false
    }
}
