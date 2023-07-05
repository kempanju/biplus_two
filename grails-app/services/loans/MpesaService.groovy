package loans

import grails.core.GrailsApplication
import grails.gorm.transactions.Transactional

import org.grails.web.json.JSONObject

import javax.crypto.Cipher
import javax.net.ssl.HttpsURLConnection
import java.nio.charset.StandardCharsets
import java.security.KeyFactory
import java.security.PublicKey
import java.security.spec.X509EncodedKeySpec
import java.util.stream.Collectors

@Transactional
class MpesaService {

    GrailsApplication grailsApplication

    def serviceMethod() {

    }

    def encryptAuthToken(String publicKey, String apiKey) {
        // Public key on the API listener used to encrypt keys

        // Generate BearerToken
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        Cipher cipher = Cipher.getInstance("RSA");
        byte[] encodedPublicKey = Base64.getDecoder().decode(publicKey);
        X509EncodedKeySpec publicKeySpec = new X509EncodedKeySpec(encodedPublicKey);
        PublicKey pk = keyFactory.generatePublic(publicKeySpec);
        cipher.init(1, pk);
        byte[] encryptedApiKey = Base64.getEncoder().encode(cipher.doFinal(apiKey.getBytes(StandardCharsets.UTF_8)));
        return new String(encryptedApiKey, StandardCharsets.UTF_8);

    }


    def getSessionKey () {
        System.setProperty("sun.net.http.allowRestrictedHeaders", "true");

        String publicKey = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAietPTdEyyoV/wvxRjS5pSn3ZBQH9hnVtQC9SFLgM9IkomEX9Vu9fBg2MzWSSqkQlaYIGFGH3d69Q5NOWkRo+Y8p5a61sc9hZ+ItAiEL9KIbZzhnMwi12jUYCTff0bVTsTGSNUePQ2V42sToOIKCeBpUtwWKhhW3CSpK7S1iJhS9H22/BT/pk21Jd8btwMLUHfVD95iXbHNM8u6vFaYuHczx966T7gpa9RGGXRtiOr3ScJq1515tzOSOsHTPHLTun59nxxJiEjKoI4Lb9h6IlauvcGAQHp5q6/2XmxuqZdGzh39uLac8tMSmY3vC3fiHYC3iMyTb7eXqATIhDUOf9mOSbgZMS19iiVZvz8igDl950IMcelJwcj0qCLoufLE5y8ud5WIw47OCVkD7tcAEPmVWlCQ744SIM5afw+Jg50T1SEtu3q3GiL0UQ6KTLDyDEt5BL9HWXAIXsjFdPDpX1jtxZavVQV+Jd7FXhuPQuDbh12liTROREdzatYWRnrhzeOJ5Se9xeXLvYSj8DmAI4iFf2cVtWCzj/02uK4+iIGXlX7lHP1W+tycLS7Pe2RdtC2+oz5RSSqb5jI4+3iEY/vZjSMBVk69pCDzZy4ZE8LBgyEvSabJ/cddwWmShcRS+21XvGQ1uXYLv0FCTEHHobCfmn2y8bJBb/Hct53BaojWUCAwEAAQ=="
        // APIKey
       // String apiKey = "4lINiHdBJbuFK3RIxGmyJQX4sSZ4xvJE"
        String apiKey = "xBnRm3VsFw9ajEhGnfokdVpbmOT6IXBG"

        def accessToken = "Bearer "+encryptAuthToken(publicKey, apiKey)
        println("Auth Token:"+ accessToken)

        String urlS = "https://openapi.m-pesa.com/openapi/ipg/v2/vodacomTZN/getSession/"

        URL url = new URL(urlS)
        HttpsURLConnection con = (HttpsURLConnection) url.openConnection()
        con.setRequestProperty("Authorization",accessToken)
        con.setRequestProperty("Accept", "application/json")
        con.setRequestProperty("Origin", "*")
       // con.setRequestProperty("user-agent", "Application")
        con.setRequestMethod("GET");
        con.connect()
        def postRCToken = con.getResponseCode()

        String output = null;

        if (postRCToken.equals(200)) {
            output = con.getInputStream().getText()
        }

        println("Session key:"+ output+" "+postRCToken)
        JSONObject object = new JSONObject(output)
        String sessionId =  object.get("output_SessionID");

        String finalBearer = encryptAuthToken(publicKey, sessionId)

        return  finalBearer;
    }

    JSONObject processLoan(Double inputAmount, String thirdPartyId, String reference, String phoneNUmber) {

        System.setProperty("sun.net.http.allowRestrictedHeaders", "true");
        def accessToken = getSessionKey()

        String providerCode = grailsApplication.config.businessCode
        String paymentUrl = grailsApplication.config.paymentUrl



        JSONObject request = new JSONObject()
        request.put("input_Amount",inputAmount)
        request.put("input_Country","TZN")
        request.put("input_Currency","TZS")
        request.put("input_ServiceProviderCode",providerCode)
        request.put("input_ThirdPartyConversationID",thirdPartyId)
        request.put("input_TransactionReference",reference)
        request.put("input_PaymentItemsDesc",reference)
        request.put("input_CustomerMSISDN", phoneNUmber);


        def message = request.toString()

        def url = new URL(paymentUrl)

        HttpsURLConnection  connection = (HttpsURLConnection) url.openConnection()
        connection.setRequestProperty("Authorization", "Bearer " + accessToken)
        connection.setRequestProperty("Origin", "*")
        connection.setRequestProperty("Content-Type", "application/json")
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
                JSONObject object = new JSONObject(result)
                output = object .has("output_ResponseDesc") ? object.get("output_ResponseDesc") : "Failed to send money"

            }
        }

        if(statusCode == 201) {
            output = "Request processed successfully"
        }

        JSONObject outputInf = new JSONObject();
        outputInf.put("message", output)
        outputInf.put("code", statusCode)

        return  outputInf;

    }


}
