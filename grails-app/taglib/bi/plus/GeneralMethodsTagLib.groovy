package bi.plus

import org.grails.web.json.JSONObject

import java.text.SimpleDateFormat

class GeneralMethodsTagLib {
    static defaultEncodeAs = [taglib:'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    def formatAmountString = { attrs, body ->
        try {

            def amount = attrs.name
            // println(amount)
            if(amount) {
                def formatedstring = String.format("%,8d%n",amount)

                //  def finalNumber = formatedstring.substring(0, 5) + " " + formatedstring.substring(7, formatedstring.length())

                out << formatedstring
            }else {
                out << "0"
            }
        }catch (Exception e){
            //e.printStackTrace()
            out << "0"
        }


    }

    def formatDaysMap = { attrs, body ->

        def datetoday = attrs.name
        SimpleDateFormat sdf = new SimpleDateFormat(
                "yyyy-MM-dd", Locale.getDefault());
        def dateformatted=sdf.parse(datetoday)

        String  daysString = new SimpleDateFormat("MMM-dd,EEE").format(dateformatted)


        out << daysString

    }




    def imagePaths = { attrs, body ->

        String imagename = attrs.name

        //println(imagename+" "+session.haswebp)

        try {
            if (!session.haswebp) {
                String [] imagenamedata= imagename.split("\\.")
                imagename=imagenamedata[0]+".jpg"
            }
        }catch (Exception e){
            e.printStackTrace()

        }
        def webrootDir = "http://www.tacip.co.tz/uploads/TacipDocuments/"+imagename

        out << webrootDir
    }

    def imagePathsProfile = { attrs, body ->

        String imagename = attrs.name

        println(imagename+" ")




        def webrootDir = imagename

        if(imagename!=null&&!imagename.contains("http://www")){
            webrootDir = "https://web.habarisasa.com/photo/"+imagename
        }
        webrootDir ="https://web.habarisasa.com/photo/default_pic.webp"

        out << webrootDir
    }



    def callTsiaHttp={ attrs, body ->
        String output = null;

        try{

            JSONObject jsonObject = new JSONObject()
            jsonObject.put("username", "kempanju")
            jsonObject.put("password", "1234")

            def posts = new URL(grailsApplication.config.tsiaLogin.toString()).openConnection()
            posts.setRequestMethod("POST")
            def message = jsonObject.toString()

            posts.setDoOutput(true)
            posts.setRequestProperty("Content-Type", "application/json")

            //OutputStreamWriter wrs = new OutputStreamWriter(posts.getOutputStream())
            posts.getOutputStream().write(message.getBytes("UTF-8"))

            // wrs.flush()

            def postRCToken = posts.getResponseCode()
            // println("code TSIA:" + postRCToken)

            if (postRCToken.equals(200)) {
                String results=posts.getInputStream().getText()
                JSONObject jsonObjectData = new JSONObject(results)

                String accessToken = jsonObjectData.getString("access_token")

                //String accessToken=


                String card_no = attrs.card_no
                String returnUrl = attrs.returnUrl



                String parameters = "card_no=" + card_no
                String name = "1"
                def post = new URL(returnUrl).openConnection()
                post.setRequestMethod("POST")
                post.setDoOutput(true)
                post.setRequestProperty("Authorization", "Bearer " + accessToken)
                //post.setRequestProperty("Content-Type", "application/json")
                OutputStreamWriter wr = new OutputStreamWriter(post.getOutputStream())
                wr.write(parameters)
                wr.flush()



                def postRC = post.getResponseCode()
                //  println("code:" + postRC)

                if (postRC.equals(200)) {
                    output = post.getInputStream().getText()
                    output=output.replace("&quot;",'"')
                    //  println(output)
                    // println(post.getInputStream().getText())
                }
            }
        }catch (Exception e){
            e.printStackTrace()
        }
        out << output
    }


    def callTacipHttp={ attrs, body ->
        String output = null;

        try{

            JSONObject jsonObject = new JSONObject()
            jsonObject.put("username", "alex1")
            jsonObject.put("password", "123")

            def posts = new URL(grailsApplication.config.tacipLogin.toString()).openConnection()
            posts.setRequestMethod("POST")
            def message = jsonObject.toString()

            posts.setDoOutput(true)
            posts.setRequestProperty("Content-Type", "application/json")

            //OutputStreamWriter wrs = new OutputStreamWriter(posts.getOutputStream())
            posts.getOutputStream().write(message.getBytes("UTF-8"))

            // wrs.flush()

            def postRCToken = posts.getResponseCode()
            //    println("code:" + postRCToken)

            if (postRCToken.equals(200)) {
                String results=posts.getInputStream().getText()
                JSONObject jsonObjectData = new JSONObject(results)

                String accessToken = jsonObjectData.getString("access_token")

                //String accessToken=


                String card_no = attrs.card_no
                String returnUrl = attrs.returnUrl



                String parameters = "card_no=" + card_no
                String name = "1"
                def post = new URL(returnUrl).openConnection()
                post.setRequestMethod("POST")
                post.setDoOutput(true)
                post.setRequestProperty("Authorization", "Bearer " + accessToken)
                //post.setRequestProperty("Content-Type", "application/json")
                OutputStreamWriter wr = new OutputStreamWriter(post.getOutputStream())
                wr.write(parameters)
                wr.flush()



                def postRC = post.getResponseCode()
                // println("code:" + postRC)

                if (postRC.equals(200)) {
                    output = post.getInputStream().getText()
                    output=output.replace("&quot;",'"')
                    // println(output)
                    // println(post.getInputStream().getText())
                }
            }
        }catch (Exception e){
            e.printStackTrace()
        }
        out << output
    }



/**
 * SMS Mtandao service method.
 * Global method to send SMS
 */
    def smsMtandaoSendMessagesLoan={ attrs, body ->

        def output="none"
        try{
            String phonenumber=attrs.phonenumber
            String messagesent=attrs.messagesent
            String returnUrl=attrs.returnUrl

            phonenumber = phonenumber.replace("+", "")
            JSONObject jsonObject = new JSONObject()
            jsonObject.put("token", "1d3b4b6104a072f1c221f6e9e5c9ad87")
            jsonObject.put("sender", "kopafasta")
            jsonObject.put("message", messagesent)
            jsonObject.put("push", returnUrl)
            JSONObject jsondata = new JSONObject()
            jsondata.put("message_id1", phonenumber)
            jsonObject.put("recipient", jsondata)
            // println(jsonObject)
            def post = new URL(grailsApplication.config.smsMtandaoUrl.toString()).openConnection()
            def message = jsonObject.toString()
            post.setRequestMethod("POST")
            post.setDoOutput(true)
            post.setRequestProperty("Content-Type", "application/json")
            post.getOutputStream().write(message.getBytes("UTF-8"))
            def postRC = post.getResponseCode()
            //println("out:" + postRC);
            if (postRC.equals(200)) {
                output=post.getInputStream().getText()



                // println(post.getInputStream().getText())
            }
        }catch (Exception e){
            e.printStackTrace()
        }
        out << output
    }




}
