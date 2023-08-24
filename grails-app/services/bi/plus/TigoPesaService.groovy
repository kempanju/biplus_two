package bi.plus

import grails.core.GrailsApplication
import grails.gorm.transactions.Transactional
import org.grails.web.json.JSONObject

import javax.net.ssl.HttpsURLConnection
import java.util.stream.Collectors

@Transactional
class TigoPesaService {
    GrailsApplication grailsApplication

    def serviceMethod() {

    }


    JSONObject processLoan(Integer inputAmount, String thirdPartyId, String reference, String phoneNUmber) {

        //System.setProperty("sun.net.http.allowRestrictedHeaders", "true");
        String paymentUrl = grailsApplication.config.paymentTigoUrl
        String senderName = grailsApplication.config.tigoSenderName
        String brandId = grailsApplication.config.brandId
        String sourceNumber = grailsApplication.config.tigoSenderNo

        String receiverNumber = phoneNUmber.startsWith("255") ? phoneNUmber.replace("255","0") : phoneNUmber.startsWith("+255") ? phoneNUmber.replace("+255","0") : phoneNUmber

        String msg = ""

        String message = "<COMMAND>" +
                "<TYPE>REQMFICIK</TYPE>" +
                "<REFERENCEID>"+reference+"</REFERENCEID>" +
                "<MSISDN>"+sourceNumber+"</MSISDN>" +
                "<PIN>0145</PIN>" +
                "<MSISDN1>"+receiverNumber+"</MSISDN1>" +
                "<AMOUNT>"+inputAmount+"</AMOUNT>" +
                "<SENDERNAME>"+senderName+"</SENDERNAME>" +
                "<BRAND_ID>"+brandId+"</BRAND_ID>" +
                "<LANGUAGE1>sw</LANGUAGE1>" +
                "</COMMAND>"

        System.out.println("Sent payload "+message)

        def url = new URL(paymentUrl)

        def connection = url.openConnection()
        connection.setRequestProperty("Origin", "*")
        connection.setRequestProperty("Content-Type", "application/xml")
        connection.setRequestMethod("POST")
        connection.setDoOutput(true);
        connection.getOutputStream().write(message.getBytes("UTF-8"))


        connection.connect()
        def statusCode = connection.getResponseCode()
        String output = null;

        if(statusCode >=400) {

            InputStream test = connection.getErrorStream();
            String result = new BufferedReader(new InputStreamReader(test)).lines().collect(Collectors.joining("\n"));

            if (result != null && result.length() != 0) {
                output = result
                msg = output

            }
        }

        String code = "6677"

        if (statusCode.equals(200)) {
            output = connection.getInputStream().getText()
            def completeXml= new XmlSlurper().parseText(output);
            msg = completeXml.MESSAGE
            code = completeXml.TXNSTATUS
        }

        if(code.equals("200")|| code.equals("0")) {
            statusCode = 201
        }

        println("output:" + output+" code:"+statusCode);

        JSONObject outputInf = new JSONObject();
        outputInf.put("message", msg)
        outputInf.put("code", statusCode)
        println("Final output: "+outputInf.toString())

        return  outputInf;

    }


}
