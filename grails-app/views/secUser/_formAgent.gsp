<%@ page import="admin.Dictionary; admin.Customers; admin.Wards; admin.District" %>

<script>
    function districtChanged(ids) {
        $.ajax({
            url: '${grailsApplication.config.systemLink.toString()}/wards/searchByDistrict',
            data: {'district_id': ids}, // change this to send js object
            type: "post",
            success: function (data) {
                // document.write(data); just do not use document.write
                $("#list-ward").html(data);
                console.log(data);
            }
        });
    }
</script>

<div style="width: 50%;float: left">

    <div class="form-group">
        <label class="control-label col-lg-3 text-bold">Agent Type <span class="text-danger">*</span></label>

        <div class="col-lg-7">
            <g:select name="agent_type" id="agent_type" value="${secUser?.agent_type?.id}" required="required"
                      from="${admin.DictionaryItem.findAllByDictionary_id(admin.Dictionary.findByCode("AGENT"))}"
                      optionKey="id" optionValue="name"
                      class="form-control select-search" noSelection="['': 'Select agent type']"/>

        </div>
    </div>



    <g:hiddenField name="user_group" value="${admin.Customers.findByCode("AGENT").id}"/>
    <div class="form-group">
        <label class="control-label col-lg-3 text-bold">Full Name</label>

        <div class="col-lg-7">

            <input type="text" name="full_name" placeholder="Full Name" class="form-control"
                   value="${secUser?.full_name}">

        </div>
    </div>


    <div class="form-group">
        <label class="control-label col-lg-3 text-bold">Description</label>

        <div class="col-lg-7">
            <textarea rows="2" cols="5" name="description" class="form-control"
                      placeholder="Write short description">${secUser?.description}</textarea>
        </div>
    </div>


    <div class="form-group">
        <label class="control-label col-lg-3 text-bold">Namba ya Simu (Anza na +255)</label>

        <div class="col-lg-7">
            <input type="text" name="phone_number" placeholder="Phone Number" class="form-control"
                   value="${secUser?.phone_number}">
        </div>
    </div>



    %{--<div class="form-group">
        <label class="control-label col-lg-3">Birth Date </label>
        <div class="col-lg-7">
            <input type="date"  name="birth_date" class="form-control"   value="${formatDate(format:'MM/dd/yyyy',date:secUser?.birth_date)}">
        </div>
    </div>--}%



    <div class="form-group">
        <label class="display-block control-label col-lg-3 text-bold">Gender:</label>

        <div class="col-lg-7">

        <label class="radio-inline">
            <g:if test="${secUser.gender == 'Male'}">
                <input type="radio" value="Male" name="gender" checked="checked">Male</label>
            </g:if>
            <g:else>
                <input type="radio" value="Male" name="gender">Male
            </g:else>
        </label>
        <label class="radio-inline">
            <g:if test="${secUser.gender == 'Female'}">
                <input type="radio" class="styled" value="Female" name="gender" checked="checked">Female</label>

            </g:if>
            <g:else>
                <input type="radio" class="styled" value="Female" name="gender">Female</label>

            </g:else>
        </div>
    </div>

    <g:if test="${secUser}">
        <div class="form-group">
            <label class="control-label text-bold col-lg-3">Float Amount</label>

            <div class="col-lg-7">
                <input type="number" name="agent_float_amount" placeholder="SALIO" class="form-control"
                       value="${secUser?.agent_float_amount}">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label text-bold col-lg-3">Loan Interest</label>

            <div class="col-lg-7">
                <input type="number" name="agent_loan_interest" placeholder="INTEREST" class="form-control"
                       value="${secUser?.agent_loan_interest}">
            </div>
        </div>
    </g:if>
</div>

<div style="width: 50%;float: left">

    <g:if test="${!secUser.recent_photo}">
        <g:hiddenField name="recent_photo" value="default_user.jpg"/>

    </g:if>



    <fieldset class="content-group">
        <legend class="text-bold">MAHALI ANAISHI</legend>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Wilaya</label>

            <div class="col-lg-7">
                <g:select name="district_id" id="district_id" value="${secUser?.district_id?.id}"
                          data-show-subtext="true" data-live-search="true"
                          from="${admin.District.findAllByD_deleted(false)}" optionKey="id" optionValue="name"
                          onchange="districtChanged(this.value);"
                          class="form-control selectpicker" noSelection="['': 'Wilaya anaishi']"/>

            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Kata</label>

            <div class="col-lg-7" id="list-ward">
                <g:select name="ward" id="ward" value="${secUser?.ward?.id}"
                          data-show-subtext="true" data-live-search="true"
                          from="${admin.Wards.findAllByDistrict_id(secUser?.district_id)}" optionKey="id"
                          optionValue="name"
                          class="form-control selectpicker" noSelection="['': 'Kata anayoishi']"/>

            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Mtaa/Kijiji</label>

            <div class="col-lg-7">
                <input type="text" name="village" placeholder="Kijiji / Mtaa" class="form-control"
                       value="${secUser?.village}">
            </div>
        </div>

    <div class="form-group">
        <label class="control-label col-lg-2">Agent Blocked  </label>
        <div class="col-lg-8">
            <g:checkBox style="display:block" name="agent_blocked" value="${secUser.agent_blocked}" />

        </div>
    </div>


    </fieldset>

</div>
