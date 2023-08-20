

<div class="form-group">
    <label class="control-label col-lg-2">Name </label>
    <div class="col-lg-8">
        <input type="text" name="name" class="form-control"  value="${district?.name}">
    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-2">District </label>


    <div class="col-lg-8">
        <g:select name="region_id" id="region_id" value="${district?.region_id?.id}"
                  from="${admin.Region.all}" optionKey="id" optionValue="name"
                  class="form-control select-search" noSelection="['': 'Select region']"/>

    </div>
</div>