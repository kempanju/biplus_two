<div class="form-group">
    <label class="control-label col-lg-2">Issued  </label>
    <div class="col-lg-8">
        <g:checkBox name="issued" value="${cardServices.issued}" />

    </div>
</div>
<div class="form-group">
    <label class="control-label col-lg-2">Enabled  </label>
    <div class="col-lg-8">
        <g:checkBox name="enabled" value="${cardServices.enabled}" />

    </div>
</div>
<div class="form-group">
    <label class="control-label col-lg-2">Active  </label>
    <div class="col-lg-8">
        <g:checkBox name="active" value="${cardServices.active}" />

    </div>
</div>
<div class="form-group">
    <label class="control-label col-lg-2">Paid  </label>
    <div class="col-lg-8">
        <g:checkBox style="display:block" name="paid" value="${cardServices.paid}" />

    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-2">Loan Eligible?  </label>
    <div class="col-lg-8">
        <g:checkBox style="display:block" name="loan_eligible" value="${cardServices.loan_eligible}" />

    </div>
</div>
