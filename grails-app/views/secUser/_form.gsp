<%@ page import="admin.Customers; admin.Wards; admin.District" %>

<div class="form-group">

    <label class="control-label col-lg-3">Organization</label>


    <div class="col-lg-5">
        <g:select name="user_group" id="user_group" value="${secUser?.user_group?.id}" required="required"
                  data-show-subtext="true" data-live-search="true"
                  from="${admin.Customers.all}" optionKey="id" optionValue="name"
                  class="form-control selectpicker" noSelection="['': 'Select organization']"/>

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">Full Name</label>

    <div class="col-lg-5">

        <input type="text" name="full_name" placeholder="Full Name" class="form-control" value="${secUser?.full_name}">

    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-3">Description</label>

    <div class="col-lg-5">
        <textarea rows="2" cols="5" name="description" class="form-control"
                  placeholder="Write short description">${secUser?.description}</textarea>
    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-3">Namba ya Simu (Anza na +255)</label>

    <div class="col-lg-5">
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
    <label class="display-block control-label col-lg-3">Gender:</label>

    <div class="col-lg-5">

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
<g:if test="${!secUser.recent_photo}">
    <g:hiddenField name="recent_photo" value="default_user.jpg"/>

</g:if>

<div class="form-group">
    <label class="control-label col-lg-3">Employee No</label>

    <div class="col-lg-5">
        <input type="text" name="registration_no" placeholder="Employee No" class="form-control"
               value="${secUser?.registration_no}">
    </div>
</div>

<fieldset class="content-group">
    <legend class="text-bold">MAHALI ANAISHI</legend>

    <div class="form-group">
        <label class="control-label col-lg-3">Wilaya</label>

        <div class="col-lg-5">
            <g:select name="district_id" id="district_id" value="${secUser?.district_id?.id}"
                      data-show-subtext="true" data-live-search="true"
                      from="${admin.District.findAllByD_deleted(false)}" optionKey="id" optionValue="name"
                      class="form-control selectpicker" noSelection="['': 'Wilaya anaishi']"/>

        </div>
    </div>

</fieldset>

<div class="form-group">
    <label class="control-label col-lg-3">Salary</label>

    <div class="col-lg-5">
        <input type="number" name="salary" placeholder="Salary" class="form-control"
               value="${secUser?.salary}">
    </div>
</div>

        <div class="form-group">
            <label class="control-label col-lg-3">Loan Limit</label>

            <div class="col-lg-5">
                <input type="number" name="loan_limit" placeholder="Loan Limit" class="form-control"
                       value="${secUser?.loan_limit}">
            </div>
        </div>


<sec:ifAnyGranted roles="ROLE_ADMIN">

    <div class="form-group">
        <label class="control-label col-lg-3">Have loan?</label>

        <div class="col-lg-5">
            <g:checkBox name="have_loan" value="${secUser?.have_loan}"/>

        </div>
    </div>

</sec:ifAnyGranted>


<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_LOAN">

    <div class="form-group">
        <label class="control-label col-lg-3">Have enabled?</label>

        <div class="col-lg-5">
            <g:checkBox name="loan_enabled" value="${secUser?.loan_enabled}"/>

        </div>
    </div>

</sec:ifAnyGranted>


