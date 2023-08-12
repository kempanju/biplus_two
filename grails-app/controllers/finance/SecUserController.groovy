package finance

import admin.Customers
import admin.DictionaryItem
import admin.District
import admin.Wards
import grails.converters.JSON
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.util.Environment
import grails.validation.ValidationException
import loans.LoanGroup
import loans.LoanRepayment
import loans.LoanRequest
import org.grails.web.json.JSONArray
import org.grails.web.json.JSONObject

import static org.springframework.http.HttpStatus.*

@Secured("isAuthenticated()")
class SecUserController {

    SecUserService secUserService
   // def passwordEncoder
    def springSecurityService
    def passwordEncoder


    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }
        session["activePage"] = "users"

        params.max = Math.min(max ?: 10, 100)
        respond SecUser.findAllByUser_deleted(false,params), model:[secUserCount: SecUser.countByUser_deleted(false,params)]


    }

    def usersAgentList(Integer max){
        if(!params.sort) {
            params.sort = 'agent_date'
            params.order = 'desc'
        }
        session["activePage"] = "agents"

        params.max = Math.min(max ?: 10, 100)
        render(view: 'usersAgentList',model: [secUserList:SecUser.findAllByAgent_active(true,params),secUserCount:SecUser.countByAgent_active(true)])
    }


    @Secured(['ROLE_ADMIN','ROLE_DATA'])
    @Transactional
    def uploadCVUsers(){
        String currentName = System.currentTimeMillis()+".csv"
        def file_path = "/Users/felixjoseph/Documents/Projects/TEST/biplus/docs/"+ currentName

        if (Environment.current != Environment.DEVELOPMENT) {
            file_path = "/var/www/web/biplus/"+currentName
        }

        def reqFile = request.getFile("uploadUsers")
        File fileDest = new File(file_path)
        reqFile.transferTo(fileDest)

        sleep(2000)

        def palines = 0;
        def orgInstance = Customers.read(params.user_group)
        println("Organization: "+orgInstance.toString())

        new File(file_path).splitEachLine(",") { fields ->
            if (palines > 0) {
                try {
                    def id = fields[0]
                    def name = fields[1]
                    def gender = fields[2]
                    def phoneNumber = fields[3]
                    def regNo = fields[4]
                    def salary = fields[5]
                    def loanAmount = fields[6]
                    if (loanAmount != null) {
                       // println("Amount: " + loanAmount + " Salary:" + salary + " name:" + name)
                        def userInstance = new SecUser()
                        userInstance.full_name = name
                        userInstance.gender = gender
                        userInstance.username = System.currentTimeMillis()+"I"
                        userInstance.user_group = orgInstance
                        userInstance.password = System.currentTimeMillis() + "ww"
                        userInstance.phone_number = phoneNumber;
                        userInstance.loan_limit = Integer.parseInt(loanAmount)
                        userInstance.salary = Integer.parseInt(salary)
                        userInstance.registration_no = regNo;
                        userInstance.save(flush: true)
                    }
                } catch (Exception e) {
                    e.printStackTrace()
                }
            }
            palines++

        }

        flash.message = "Users successfully updated"

        redirect( action: "index")
    }

    def agentList(Integer max){
        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }
        params.max = Math.min(max ?: 10, 100)
        session["activePage"] = "agents"

        def userAgents=Customers.findByCode("AGENT")
        render(view: 'agentList',model: [secUserList:SecUser.findAllByUser_group(userAgents,params),secUserCount:SecUser.countByUser_group(userAgents)])
    }


    def usersByCustomer(Integer max){
        if(!params.sort) {
            params.sort = 'id'
            params.order = 'desc'
        }
        def customerInstance=Customers.get(params.id)
        params.max = Math.min(max ?: 10, 100)
        respond SecUser.findAllByUser_deletedAndUser_group(false,customerInstance,params), model:[secUserCount: SecUser.countByUser_deletedAndUser_group(false,customerInstance,params)]

    }

    def show(Long id) {
        respond secUserService.get(id)
    }

    @Secured(['ROLE_ADMIN'])
    @Transactional
    def removeAgent(){
        def userInstance=SecUser.get(params.id)

        def agerntname=userInstance.agent_id.full_name

        userInstance.agent_id=null
        userInstance.agent_active=false
        if(userInstance.save()){
            def userLogsInstanceD = new UserLogs()
            userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("AGENTLOGS")
            userLogsInstanceD.user_id = userInstance
            userLogsInstanceD.message = agerntname+" removed."
            userLogsInstanceD.save()

        }
        redirect(action: 'show',params: [id:params.id])
    }

    def create() {
        session["activePage"] = "users"

        respond new SecUser(params)
    }

    def createAgent(){
        session["activePage"] = "agents"
        respond new SecUser(params)

    }


    @Secured(['ROLE_ADMIN'])
    @Transactional
    def addRole() {
        def userRoleInstance = new SecUserSecRole()
        userRoleInstance.secUser = SecUser.get(params.user_id)
        userRoleInstance.secRole = SecRole.get(params.role_id)
        userRoleInstance.save()
        redirect(action: 'show', params: [id: params.user_id])
    }

   // @Secured(['ROLE_ADMIN'])
    @Transactional
    def changePasswordUser(){
        println(params)
        def userInstance = SecUser.get(params.id)
        userInstance.password = params.newpassword
        //userInstance.username=params.username
        userInstance.accountLocked=0
        userInstance.save()
        flash.message="Password successfully changed"
        redirect(action: 'show',params: [id: params.id])
    }

    @Secured("isAuthenticated()")
    @Transactional
    def myUploadLogo() {
        def user_id = params.user_id

        if (params.photo) {
            //CommonsMultipartFile file = params.list("recent_photo")?.getAt(0)
            def reqFile = request.getFile("photo")

            def namephoto = System.currentTimeMillis() + ".jpg";

            def photo_path = "/var/www/html/uploads/KopafastaDocuments/" + namephoto

            //println("webrootDir:"+webrootDir)
            File fileDest = new File(photo_path)
            reqFile.transferTo(fileDest)

            /*  def namephotonew=System.currentTimeMillis()+".webp"

              def newfilewebp="/var/www/html/uploads/TacipDocuments/"+namephotonew

              String command="convert "+photo_path+" "+newfilewebp
              def proc = command.execute()
              def b = new StringBuffer()
              proc.consumeProcessErrorStream(b)*/

           // namephoto="http://www.tacip.co.tz/uploads/TacipDocuments/"+namephoto

            SecUser.executeUpdate("update SecUser set recent_photo=? where id=" + user_id, [namephoto])
            // fileDest.delete()

        }
        redirect action: 'show', params: [id: user_id]
    }

    @Transactional
    def changePasswordUserApi(){
        println(params)

        int source=Integer.parseInt(params.src)

        if(source==2) {
            def code = getRandomNumber(1000, 9999)
            if(params.registration_no) {
                def userInstance = SecUser.get(SecUser.findByRegistration_no(params.registration_no).id)
                userInstance.password = Integer.toString(code)
                userInstance.accountLocked = 0
                userInstance.save(failOnError: true)
                // String passwords=springSecurityService.encodePassword(Integer.toString(code), null)

                //SecUser.executeUpdate("update SecUser set password=?,accountLocked=0 where registration_no=? ", [Integer.toString(code), params.registration_no])

                //   if (userInstance.save(failOnError: true)) {


                String phonenumber = userInstance.phone_number
                // phonenumber="255766545878"

                def messagesent = "Kopafasta APP. Namba yako ya kumbu kumbu ni " + code + ". Phone No: " + phonenumber
                phonenumber = phonenumber.replace("+", "")
                JSONObject jsonObject = new JSONObject()
                jsonObject.put("token", "1d3b4b6104a072f1c221f6e9e5c9ad87")
                jsonObject.put("sender", "kopafasta")
                jsonObject.put("message", messagesent)
                jsonObject.put("push", "http://localhost:9090/company/create")

                JSONObject jsondata = new JSONObject()
                jsondata.put("message_id1", phonenumber)

                jsonObject.put("recipient", jsondata)

                // println(jsonObject)


                def post = new URL("http://login.smsmtandao.com/smsmtandaoapi/send").openConnection()
                def message = jsonObject.toString()
                post.setRequestMethod("POST")
                post.setDoOutput(true)
                post.setRequestProperty("Content-Type", "application/json")
                post.getOutputStream().write(message.getBytes("UTF-8"))
                def postRC = post.getResponseCode()
                println("out:" + postRC);
                if (postRC.equals(200)) {
                    //   println(post.getInputStream().getText())\
                    try {
                        def userLogsInstanceD = new UserLogs()
                        userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("ALL")
                        userLogsInstanceD.user_id = userInstance
                        userLogsInstanceD.message = messagesent
                        userLogsInstanceD.save()
                    } catch (Exception e) {
                        e.printStackTrace()
                    }
                }

            }
            //}
        }else if(source==1){
            String passwords=params.passwords
            def userInstance = SecUser.findByRegistration_no(params.registration_no)

           // String old_password= springSecurityService.encodePassword(passwords, null)

           // println(old_password+" "+userInstance)
            def exists = passwordEncoder.isPasswordValid(userInstance.password, passwords, null)

            JSONObject jsonObject=new JSONObject()

            if(exists){
                println("Equal")

                if(userInstance.user_group.loan_allowed){
                    jsonObject.put("status",1)
                    jsonObject.put("valid",true)
                    jsonObject.put("message","Successfully logged in")

                }else {
                    jsonObject.put("status",2)
                    jsonObject.put("valid",false)
                    jsonObject.put("message","Company not enabled")


                }
                render jsonObject as JSON
            }else {
                println("Not Equal")

                render status: 401

            }

        }
        render("Done")
    }


    @Transactional
    def saveAppData(){

        println(params)
        def company_idID=params.user_id
        println("TSIA COP ID:"+company_idID)

        def full_name=params.first_name+" "+params.middle_name+" "+params.last_name

        def userInstance = new SecUser()
        userInstance.full_name = full_name

        String mobileNo=params.phone_number_s
        userInstance.phone_number = mobileNo

        userInstance.village=params.ishi_ward
        userInstance.birth_village=params.kuzaliwa_ward

        def freelancerInstance=Customers.findByCode("FREELANCER")
        userInstance.user_group=freelancerInstance

        int countUsers=SecUser.countByUser_group(freelancerInstance)+2

        def regNo=String.format("%08d", countUsers)
        userInstance.registration_no=regNo
        userInstance.username=regNo

        userInstance.password=System.currentTimeMillis()

        userInstance.district_id=District.get(params.district_id_ishi)
        userInstance.birth_district_id=District.get(params.district_id_zaliwa)
        userInstance.agent_id=SecUser.findByRegistration_no(params.user_id)

        // println(params.company_id)



        if (Environment.current == Environment.PRODUCTION) {

            String bytesImagesProfile = params.bytesImagesProfile

            def namephoto = System.currentTimeMillis() + ".jpg"

            def photo_path = "/var/www/html/uploads/TsiaDocuments/" + namephoto


            bytesImagesProfile.replaceAll("\r", "")
            bytesImagesProfile.replaceAll("\n", "")
            byte[] decoded = bytesImagesProfile.decodeBase64()
            new File(photo_path).withOutputStream {
                it.write(decoded);
            }

            userInstance.recent_photo = namephoto




            String signatureString = params.signatureString

            def namesign = "1" + System.currentTimeMillis() + ".jpg"

            def sign_path = "/var/www/html/uploads/TsiaDocuments/" + namesign


            signatureString.replaceAll("\r", "")
            signatureString.replaceAll("\n", "")
            byte[] decodedsign = signatureString.decodeBase64()
            new File(sign_path).withOutputStream {
                it.write(decodedsign);
            }

            userInstance.user_signature = namesign

        }

        if(params.birth_date){
            userInstance.birth_date = Date.parse("yyyy-MM-dd", params.birth_date)

        }



        if(userInstance.save(failOnError: true)){


        }





        println("Saved")
        render("Done")
    }


    private int getRandomNumber(int min,int max) {
        return (new Random()).nextInt((max - min) + 1) + min;
    }

    @Transactional
    def getRegistrationDetails(){
       // def districts = District.findAllByD_deleted(false) as JSON
        println("called:"+params)

        JSONObject jsonObject=new JSONObject()

        def wardList = Wards.findAllByWard_visible(true)

        JSONArray wardsList = new JSONArray()
        wardList.each {
            JSONObject jsonObject1 = new JSONObject()
            jsonObject1.put("ward_name", it.name)
            jsonObject1.put("district_id", it.district_id.id)
            jsonObject1.put("district_name", it.district_id.name)
            jsonObject1.put("ward_id", it.id)
            wardsList.put(jsonObject1)

        }

        //    println(wardsList.toString())

        //jsonObject.put("wardlist",)

        def districtList=District.findAllByD_deleted(false) as JSON
        jsonObject.put("wardslist", wardsList.toString())
        jsonObject.put("districtlist",districtList.toString())
        render  jsonObject as JSON

    }

    @Transactional
    def saveTsiaData(){
        println(params)
        def source=Integer.parseInt(params.src)
        def registration_no=params.reg_no

        if(source==1){
            SecUser.executeUpdate("update SecUser set phone_number=? where registration_no=? ", [params.phone_number, registration_no])

        }else if(source==2) {
            int loan_limit=Integer.parseInt(params.loan_limit)
            SecUser.executeUpdate("update SecUser set loan_limit=? where registration_no=? ", [loan_limit, registration_no])
        }
        render("Ok")
    }

    @Transactional
    def userLoginApp(){

        println(params)

        JSONObject  jsonObject = new JSONObject()

        def userInstance=SecUser.findByUsernameAndAccountLocked(params.username,false)

        if(userInstance) {
            def exists = passwordEncoder.isPasswordValid(userInstance.password, params.password, null)

            //def userInstance=saveUsersDetails(jsonObject,"PSGP")
            if (exists) {
                println("Exists")
                jsonObject.put("loan_group", userInstance.loan_group.code)
                jsonObject.put("loan_max", userInstance.loan_group.end_range)
                jsonObject.put("instruments", userInstance.loan_group.instruments)
                jsonObject.put("loan_type",userInstance.user_group.loan_type.code)

                jsonObject.put("has_loan", userInstance.have_loan)
                jsonObject.put("loan_amount", userInstance.loan_amount)
                jsonObject.put("message", "User is valid")

                jsonObject.put("user_valid", true)
                // jsonObject.put("source","TSIA")
                jsonObject.put("user_id", userInstance.registration_no)
                jsonObject.put("reg_no",userInstance.registration_no)
                jsonObject.put("full_name", userInstance.full_name)

                jsonObject.put("username",userInstance.username)

                jsonObject.put("gender", userInstance.gender)
                jsonObject.put("ward", userInstance?.ward?.name)
                jsonObject.put("district_id", userInstance?.district_id?.name)

                jsonObject.put("phone_number", userInstance.phone_number)

                def previous_loan = LoanRequest.findAllByUser_id(userInstance, [sort: "id", order: "desc"]) as JSON
                jsonObject.put("previous_loan", previous_loan.toString())

                jsonObject.put("loan_limit", userInstance.loan_group.end_range)
                jsonObject.put("recent_photo", "http://tsia.datavision.co.tz/uploads/KopafastaDocuments/" + userInstance.recent_photo)


                if(userInstance.user_group.code=="AGENT"){
                    def amountData=SecUser.executeQuery("select sum (loan_amount) from SecUser where have_loan=true and agent_id=?",[userInstance])[0]


                    def totalPaidAmount=LoanRequest.executeQuery("select sum (amount) from LoanRequest where loan_status=2 and loan_repaid=1 and user_id.agent_id=? and repaid_date>=user_id.agent_date",[userInstance])[0];

                    def totalPaidAmountInterest=LoanRequest.executeQuery("select sum (loan_amount_total) from LoanRequest where loan_status=2 and loan_repaid=1 and user_id.agent_id=?  and repaid_date>=user_id.agent_date",[userInstance])[0];

                    //totalPaidAmount=30000
                    //totalPaidAmountInterest=35000

                    def profitAmount=0

                    if(totalPaidAmountInterest) {
                        if(userInstance.agent_type.code.equals("FREEA")){

                        }else {
                           int profitAmountInterest = (totalPaidAmountInterest - totalPaidAmount)-1050

                            float amountdata=profitAmountInterest*0.2

                            int tax=amountdata*0.1

                            profitAmount=amountdata-tax

                        println("Amount: "+profitAmountInterest+" "+profitAmount+" "+amountdata+" "+tax)


                        }
                    }



                    if(!amountData){
                        amountData=0
                    }

                    jsonObject.put("customer_loan_total",amountData)
                    jsonObject.put("profit_loan",profitAmount)

                    jsonObject.put("agent_type",userInstance.agent_type.code)

                    jsonObject.put("agent_float_amount",userInstance.agent_float_amount)

                    jsonObject.put("total_artists",SecUser.countByAgent_id(userInstance))
                }

                jsonObject.put("customer_code", userInstance.user_group.code)
                jsonObject.put("customer_name", userInstance.user_group.name)
                jsonObject.put("description", userInstance.description)
                jsonObject.put("valid", true)
                render jsonObject as JSON
            } else {
                println("Not Exists")

                render status: 401
            }

        }else{
            println("Not Exists")
            render status: 401
        }
    }

    @Secured("isAuthenticated()")
    def search_user(Integer max){
        def seatchText=params.search_string
        try{
            if(seatchText.indexOf("0")==0){
                seatchText = seatchText.substring(1)
            }
        }catch (Exception e){

        }
        //println(seatchText)
        def searchstring="%"+seatchText+"%"
        params.max=20
        // params.max = Math.min(max ?: 10, 10)
        // def user_id=springSecurityService.principal.id
        //def company_id=User.get(user_id)?.company_id
        //def userInstance=null

        def userInstance = SecUser.executeQuery("from SecUser where  full_name like :searchstring " +
                "  or username like :searchstring or registration_no like :searchstring or phone_number like :searchstring " +
                " ", [searchstring],params)


        // println(searchstring+"out:"+userInstance)

        render  template: 'searchUserlist', model:[secUserList:userInstance]
    }

    @Secured('ROLE_ADMIN')
    @Transactional
    def deleteUser(){
        flash.message="User deleted successfully !"
        def userid=Long.parseLong(params.id)
        SecUser.executeUpdate("update SecUser set user_deleted=? where id=? ", [true, userid])

        redirect(action: 'show',params:[id:params.id])

    }

    def sychTsiaData(){
        def outputTacip = callTsiaHttp(card_no: "dddd", returnUrl: grailsApplication.config.tsiadataSych.toString())
        outputTacip = outputTacip.replace("&quot;", '"')

        JSONArray jsonArray=new JSONArray(outputTacip)

        JSONObject jsonObject=null
        int j=0
        for(int i=0; i<jsonArray.size();i++){
            jsonObject=jsonArray.getJSONObject(i)
            def userInstance=saveUsersDetails(jsonObject,"PSGP", "")
            j++
        }

        flash.message=j+" successfully synchronize! "



       // println(outputTacip)
       redirect(action: 'index')

    }
    @Transactional
    def addUserAgent(){
      //  println(params)

        def agentInstance=SecUser.findByRegistration_no(params.agent_id)

        //println(agentInstance)
        def reg_no=params.reg_no

        def current_time = Calendar.instance
        def created_at = new java.sql.Timestamp(current_time.time.time)

        SecUser.executeUpdate("update SecUser set agent_id=?, agent_date=?, agent_active=1 where registration_no=? ", [agentInstance,created_at,reg_no])

        def userLogsInstanceD = new UserLogs()
        userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("AGENTLOGS")
        userLogsInstanceD.user_id = SecUser.findByRegistration_no(reg_no)
        userLogsInstanceD.message = agentInstance.full_name+" added."
        userLogsInstanceD.save()


        JSONObject jsonObject=fillJsonObject(SecUser.findByRegistration_no(reg_no),new JSONObject())
        jsonObject.put("user_valid",true)
        render jsonObject as JSON
    }

    def getArtistListByAgent(){
        def agentInstance=SecUser.findByRegistration_no(params.agent_id)
        JSONArray jsonArray=new JSONArray()

        def getUsersList=SecUser.findAllByAgent_id(agentInstance,[sort:'agent_date',order:'desc'])
        getUsersList.each {

            JSONObject jsonObject=fillJsonObject(SecUser.findByRegistration_no(it.registration_no),new JSONObject())
            jsonObject.put("user_valid",true)

            jsonArray.put(jsonObject)
        }
        render jsonArray as JSON
    }
     private  JSONObject fillJsonObject(SecUser userInstance,JSONObject jsonObjectww){
         JSONObject jsonObject=new JSONObject()
        jsonObject.put("user_valid", true)
        jsonObject.put("user_id", userInstance.registration_no)
         jsonObject.put("reg_no",userInstance.registration_no)
         jsonObject.put("full_name", userInstance.full_name)
        jsonObject.put("gender", userInstance.gender)
         jsonObject.put("username",userInstance.username)
         if(userInstance.ward){
             jsonObject.put("ward", userInstance.ward.name)

         }else {
             jsonObject.put("ward", "None")

         }
         if(userInstance.district_id){
             jsonObject.put("district_id", userInstance.district_id.name)

         }else {
             jsonObject.put("district_id", "None")

         }
        jsonObject.put("phone_number", userInstance.phone_number)
        jsonObject.put("recent_photo", userInstance.recent_photo)
        jsonObject.put("loan_type","IDLOAN")

         if(userInstance.agent_id) {
             jsonObject.put("have_agent", true)
             jsonObject.put("agent_name", userInstance.agent_id.full_name)


         }else {
             jsonObject.put("have_agent", false)

         }
        // saveUsersDetails(jsonObject,"OTHERS")

        jsonObject.put("loan_group",userInstance.loan_group.code)
        jsonObject.put("loan_max",userInstance.loan_group.end_range)
        jsonObject.put("instruments",userInstance.loan_group.instruments)
        jsonObject.put("has_loan",userInstance.have_loan)
        jsonObject.put("loan_amount",userInstance.loan_amount)

        def previous_loan=LoanRequest.findAllByUser_id(userInstance, [sort: "id", order: "desc"]) as JSON
        jsonObject.put("previous_loan",previous_loan.toString())
        jsonObject.put("valid",true)
        jsonObject.put("message","User is valid")

        return jsonObject;

    }



    def getArtistLoanRepaymentList(){
        def agentInstance=SecUser.findByRegistration_no(params.agent_id)
        JSONArray jsonArray=new JSONArray()

        //,[sort:'agent_date',order:'desc']
        def getUsersList=LoanRepayment.executeQuery("from LoanRepayment where user_id.agent_id=? order by id desc ",[agentInstance])
        getUsersList.each {

            JSONObject jsonObject=new JSONObject()
            jsonObject.put("full_name",it.user_id.full_name)
            jsonObject.put("reg_no",it.user_id.registration_no)
            jsonObject.put("loan_amount",it.amount_paid)
            jsonObject.put("loan_repaid",it.loan_id.loan_repaid)
            jsonObject.put("recent_photo",it.user_id.recent_photo)
            jsonObject.put("created_date",it.created_at.toString())
            jsonObject.put("user_valid",true)

            jsonArray.put(jsonObject)
        }
       // println(jsonArray.toString())
        render jsonArray as JSON
    }

    def getArtistLoanList(){
        def agentInstance=SecUser.findByRegistration_no(params.agent_id)
        JSONArray jsonArray=new JSONArray()
        def getUsersList=LoanRequest.executeQuery("from LoanRequest where user_id.agent_id=? and loan_status=2 order by id desc ",[agentInstance])
        getUsersList.each {

            JSONObject jsonObject=new JSONObject()
            jsonObject.put("full_name",it.user_id.full_name)
            jsonObject.put("reg_no",it.user_id.registration_no)
            jsonObject.put("loan_amount",it.amount)
            jsonObject.put("loan_amount_total",it.loan_amount_total)
            jsonObject.put("loan_repaid",it.loan_repaid)
            jsonObject.put("recent_photo",it.user_id.recent_photo)
            jsonObject.put("created_date",it.created_at.toString())
            jsonObject.put("user_valid",true)

            jsonArray.put(jsonObject)
        }
       // println(jsonArray.toString())
        render jsonArray as JSON

    }
    @Transactional
    def userDetails(){

        int src=Integer.parseInt(params.src)
       // int src=1
        String outputTacip = null
        JSONObject jsonObject = null
        if(src==1) {
            String card_no = params.card_no
            //card_no = "0C1547116818340"

            if (card_no.contains("0C")) {

                def userInstanceData=SecUser.findByCard_no(card_no)
                if(userInstanceData) {
                    jsonObject = fillJsonObject(userInstanceData,jsonObject)


                }else {
                    outputTacip = callTacipHttp(card_no: card_no, returnUrl: grailsApplication.config.tacipData.toString())
                    outputTacip = outputTacip.replace("&quot;", '"')
                    jsonObject = new JSONObject(outputTacip)

                    Boolean user_valid = jsonObject.get("user_valid")
                    if (!user_valid) {
                        outputTacip = callTsiaHttp(card_no: card_no, returnUrl: grailsApplication.config.tsiadata.toString())
                        outputTacip = outputTacip.replace("&quot;", '"')
                        jsonObject = new JSONObject(outputTacip)
                        def userInstance = saveUsersDetails(jsonObject, "PSGP", card_no)
                        jsonObject= fillJsonObject(userInstance,jsonObject)
                        jsonObject.put("loan_type", "ORLOAN")

                    } else {
                        def userInstance = saveUsersDetails(jsonObject, "TACIP", card_no)
                        jsonObject=fillJsonObject(userInstance,jsonObject)
                        jsonObject.put("loan_type", "IDLOAN")

                    }
                }

            } else if (card_no.contains("0P")) {
                outputTacip = callTsiaHttp(card_no: card_no, returnUrl: grailsApplication.config.tsiadata.toString())
                outputTacip = outputTacip.replace("&quot;", '"')
                jsonObject = new JSONObject(outputTacip)
                def userInstance=saveUsersDetails(jsonObject,"PSGP",card_no)
                jsonObject=fillJsonObject(userInstance,jsonObject)
                jsonObject.put("loan_type","ORLOAN")

            } else if (card_no.contains("0N")) {
                def userInstance = SecUser.findByRegistration_no(card_no,card_no)
                jsonObject = new JSONObject()
                if (userInstance) {
                    jsonObject=fillJsonObject(userInstance,jsonObject)


                } else {
                    jsonObject.put("user_valid", false)
                }

            }
        }else if(src==2){
            def username=params.username
            def password=params.password

            def verifycredentials = SecUser.countByUsername(username)
            if(verifycredentials>0) {
                def userInstance = SecUser.findByUsername(username)
                def exists = passwordEncoder.isPasswordValid(userInstance.password, password, null)
                //def userInstance = SecUser.findByRegistration_no(card_no)
                jsonObject = new JSONObject()
                if (exists) {
                    jsonObject=fillJsonObject(userInstance,jsonObject)


                } else {
                    jsonObject.put("user_valid", false)
                }
            }else {
                jsonObject.put("user_valid", false)

            }
        }
        if(!jsonObject){
            jsonObject=new JSONObject()
            jsonObject.put("user_valid", false)
             println("Error: "+ params)
        }
        render jsonObject as JSON
    }

    @Transactional
    def sychTacipData(){

        def findUsersAgent=SecUser.findAllByAgent_active(true)
        findUsersAgent.each {
            try {
                def card_no = it.registration_no
                String outputTacip = null
                JSONObject jsonObject = null
                outputTacip = callTacipHttp(card_no: card_no, returnUrl: grailsApplication.config.tacipData.toString())
                outputTacip = outputTacip.replace("&quot;", '"')
                jsonObject = new JSONObject(outputTacip)

                Boolean user_valid = jsonObject.get("user_valid")
                def userInstance = saveUsersDetails(jsonObject, "TACIP", card_no)
                jsonObject = fillJsonObject(userInstance, jsonObject)
                jsonObject.put("loan_type", "IDLOAN")
            }catch (Exception e){

            }

        }
        render("Done")
    }

    private static SecUser saveUsersDetails(JSONObject jsonObjectData,String loan_src,String card_no){
        String reg_no=jsonObjectData.get("user_id")
        def userID=SecUser.findByRegistration_no(reg_no)
        String customer_code=jsonObjectData.get("customer_code")
        String customer_name=jsonObjectData.get("customer_name")

       // println("Passed here men:"+userID)

        if(!userID) {
            def userInstance=new SecUser()
            userInstance.full_name=jsonObjectData.get("full_name")
            userInstance.recent_photo=jsonObjectData.get("recent_photo")
            userInstance.phone_number=jsonObjectData.get("phone_number")
            userInstance.username=reg_no
            if(card_no) {
                userInstance.card_no = card_no
            }
            userInstance.user_group=Customers.findByCode(loan_src)
            userInstance.description=jsonObjectData.get("description")

            //println("Limit:"+jsonObjectData.getInt("loan_limit"))
            userInstance.loan_limit=jsonObjectData.getInt("loan_limit")

            userInstance.user_group=Customers.findOrSaveWhere(code:customer_code,name: customer_name )

            userInstance.password=System.currentTimeMillis().toString()
            userInstance.gender=jsonObjectData.get("gender")
            if(loan_src=="TACIP") {
                if(jsonObjectData.has("identity_type")){
                    String code_type=jsonObjectData.has("identity_type")
                    userInstance.identity_type=DictionaryItem.findByCode(code_type)
                }

                if(jsonObjectData.has("national_id")){
                    userInstance.national_id=jsonObjectData.get("national_id")
                }
                if(jsonObjectData.has("national_id_name")){
                    userInstance.national_id_name=jsonObjectData.get("national_id_name")
                }
                if(jsonObjectData.has("national_id_copy_path")){
                    userInstance.national_id_copy_path=jsonObjectData.get("national_id_copy_path")
                }

                if(jsonObjectData.has("loan_points")){
                    try {
                        userInstance.loan_points = jsonObjectData.getInt("loan_points")
                    }catch (Exception e){

                    }
                }

                if(jsonObjectData.has("loan_group")){
                    try {
                        userInstance.loan_group = LoanGroup.findByCode(jsonObjectData.get("loan_group"))
                    }catch (Exception e){

                    }
                }

                if(jsonObjectData.has("birth_ward")){
                    userInstance.birth_ward=Wards.get(jsonObjectData.get("birth_ward"))
                }
                if(jsonObjectData.has("birth_district_id")){
                    userInstance.birth_district_id=District.get(jsonObjectData.getInt("birth_district_id"))
                }

                if(jsonObjectData.has("district_id")) {
                    userInstance.district_id = District.get(jsonObjectData.get("district_id"))
                }

                if(jsonObjectData.has("ward")) {
                    userInstance.ward = Wards.get(jsonObjectData.get("ward"))
                }
            }else if(loan_src=="PSGP"){
                try {
                    userInstance.district_id = District.findByName(jsonObjectData.get("district_id"))
                    if(jsonObjectData.has("ward")) {

                        userInstance.ward = Wards.findByName(jsonObjectData.get("ward"))
                    }
                }catch (Exception e){

                }
            }
            userInstance.registration_no=reg_no
            userInstance.save(failOnError:true)
            userID=userInstance
        }else {
            int loan_limit=jsonObjectData.getInt("loan_limit")
            String phone_no=jsonObjectData.get("phone_number")
            phone_no=phone_no.trim()

           // println(" "+loan_limit)
           // println(jsonObjectData.toString())

            if(loan_src=="TACIP") {
                if(jsonObjectData.has("identity_type")){
                    String code_type=jsonObjectData.has("identity_type")
                    userID.identity_type=DictionaryItem.findByCode(code_type)
                }

                if(jsonObjectData.has("national_id")){
                    userID.national_id=jsonObjectData.get("national_id")
                }
                if(jsonObjectData.has("national_id_name")){
                    userID.national_id_name=jsonObjectData.get("national_id_name")
                }
                if(jsonObjectData.has("national_id_copy_path")){
                    userID.national_id_copy_path=jsonObjectData.get("national_id_copy_path")
                }

                if(jsonObjectData.has("birth_ward")){
                    userID.birth_ward=Wards.get(jsonObjectData.get("birth_ward"))
                }
                if(jsonObjectData.has("birth_district_id")){
                    userID.birth_district_id=District.get(jsonObjectData.getInt("birth_district_id"))
                }

                if(jsonObjectData.has("loan_points")){
                    try {
                        userID.loan_points = jsonObjectData.getInt("loan_points")
                    }catch (Exception e){

                    }
                }

                if(jsonObjectData.has("loan_group")){
                    try {
                        userID.loan_group = LoanGroup.findByCode(jsonObjectData.get("loan_group"))
                    }catch (Exception e){

                    }
                }

                if(jsonObjectData.has("district_id")) {

                    userID.district_id = District.get(jsonObjectData.get("district_id"))
                }

                if(jsonObjectData.has("ward")) {
                    userID.ward = Wards.get(jsonObjectData.get("ward"))
                }
                userID.loan_limit=loan_limit
                userID.phone_number=phone_no
                userID.card_no=card_no
                userID.registration_no=reg_no
                userID.save(failOnError:true)
            }else {

                SecUser.executeUpdate("update SecUser set loan_limit=?,phone_number=?,card_no=? where registration_no=? ", [loan_limit, phone_no, card_no, reg_no])
            }
        }
        return  userID
    }


    @Secured(['ROLE_ADMIN','ROLE_CARD','ROLE_MANAGER'])
    def messagesSingleUser(){
        def phonenumber=params.phone_number
        phonenumber=phonenumber.replace("+", "")
        def message=params.message

        String returnUrl = grailsApplication.config.deliverySMS + "/deliveryRegistration"

        String sms_mtandao_json = smsMtandaoSendMessagesLoan(phonenumber: phonenumber, messagesent: message, returnUrl: returnUrl)

        def userLogsInstanceD = new UserLogs()
        userLogsInstanceD.dictionary_id = DictionaryItem.findByCode("SYL")
        userLogsInstanceD.user_id = SecUser.get(params.id)
        userLogsInstanceD.message = message
        userLogsInstanceD.save()
        flash.message="Message successfully sent."
        redirect(action: 'show' ,params: [id:params.id])
    }

    def save(SecUser secUser) {
        if (secUser == null) {
            notFound()
            return
        }

        try {
            def customerID= String.format("%03d",Integer.parseInt(params.user_group))

            Random r = new Random()
            int Low = 1000
            int High = 99999

            def exists=true
            def employeeformat=0;



                while (exists) {
                    int artistNo = r.nextInt(High - Low) + Low
                    employeeformat = String.format("%05d", artistNo)

                    def checkEmployee = SecUser.countByRegistration_no(employeeformat)
                    if (checkEmployee == 0) {
                        exists = false

                    }
                   // println("j:" + exists)
                }
            def reg_no=customerID+""+employeeformat
            secUser.registration_no=reg_no
            secUser.username=reg_no
            secUser.password=System.currentTimeMillis()
            secUser.recent_photo="http://www.tacip.co.tz/uploads/TacipDocuments/default_user.jpg"

            secUserService.save(secUser)
        } catch (ValidationException e) {
            respond secUser.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'secUser.label', default: 'SecUser'), secUser.id])
                redirect secUser
            }
            '*' { respond secUser, [status: CREATED] }
        }
    }

    @Secured("isAuthenticated()")
    def loanPointsByUser(Integer max){
        params.max = Math.min(max ?: 10, 10)
        //  params.sort = 'loan_points'
        params.order = 'desc'

        // println(params)

        // def userInstanceList=User.findAllByLoan_pointsGreaterThan(0)

        def c = SecUser.createCriteria()
        def userInstanceData = c.list (max:params.max,offset:params.offset) {
            gt("loan_points", 0)
            order("loan_points", "desc")
        }

        def userCount = SecUser.executeQuery("from SecUser where loan_points>0").size()

        render(view: 'loanPointsByUser',model: [userList:userInstanceData,userCount:userCount])

    }

    def edit(Long id) {
        respond secUserService.get(id)
    }

    def editAgent(Long id) {
        respond secUserService.get(id)
    }

    def update(SecUser secUser) {
        if (secUser == null) {
            notFound()
            return
        }

        try {
            if(params.agent_id){
                secUser.agent_active=1
            }else {
                secUser.agent_active=0

            }
            secUserService.save(secUser)
        } catch (ValidationException e) {
            respond secUser.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'secUser.label', default: 'SecUser'), secUser.id])
                redirect secUser
            }
            '*'{ respond secUser, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        secUserService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'secUser.label', default: 'SecUser'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'secUser.label', default: 'SecUser'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
