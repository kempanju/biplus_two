
<div class="form-group">
    <label  class="control-label col-lg-2">Code <span class="text-danger">*</span></label>
    <div class="col-lg-8">
        <input type="text" name="code" class="form-control" required="required" value="${region?.code}">
    </div>
</div>
<div class="form-group">
    <label class="control-label col-lg-2">Name </label>
    <div class="col-lg-8">
        <input type="text" name="name" class="form-control"  value="${region?.name}">
    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-2">Country </label>


    <div class="col-lg-8">
        <g:select name="country_id" id="country_id" value="${associationOffice?.country_id?.id}"
                  from="${com.tacip.admin.Country.all}" optionKey="id" optionValue="name"
                  class="form-control select-search" noSelection="['': 'Select country']"/>

    </div>
</div>