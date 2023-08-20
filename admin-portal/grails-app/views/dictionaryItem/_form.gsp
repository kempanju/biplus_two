<fieldset class="content-group">

    <div class="form-group">
        <label  class="control-label col-lg-3">Code <span class="text-danger">*</span></label>
        <div class="col-lg-7">
            <input type="text" name="code" class="form-control" autocomplete="code" required="required" value="${dictionaryItem?.code}">
        </div>
    </div>
    <div class="form-group">
        <label  class="control-label col-lg-3">Name <span class="text-danger">*</span></label>
        <div class="col-lg-7">
            <input type="text" name="name" class="form-control" autocomplete="name" required="required" value="${dictionaryItem?.name}">
        </div>
    </div>

    <div class="form-group">
        <label class="control-label col-lg-3">Dictionary Item <span class="text-danger">*</span></label>

        <div class="col-lg-7">
            <g:select name="dictionary_id" id="dictionary_id" value="${dictionaryItem?.dictionary_id?.id}"
                      from="${admin.Dictionary.list()}" optionKey="id" optionValue="name"
                      class="form-control select-search" noSelection="['': 'Select dictionary']"/>

        </div>
    </div>


</fieldset>