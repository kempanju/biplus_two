package employer.portal

import org.grails.web.json.JSONObject

import java.text.SimpleDateFormat

class GenericTagLib {
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

        def webrootDir = imagename

        if(imagename!=null&&!imagename.contains("http://www")){
            webrootDir = "https://web.habarisasa.com/photo/"+imagename
        }
        webrootDir ="https://web.habarisasa.com/photo/default_pic.webp"

        out << webrootDir
    }



}
