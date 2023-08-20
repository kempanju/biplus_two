<%@ page import="finance.SecUser" %>
<div class="form-group">

    <label class="control-label col-lg-2">Customer</label>

    <div class="col-lg-8">
        <g:select name="user_id" id="user_id" value="${loanRequest?.user_id?.id}" required="required"
                  data-show-subtext="true" data-live-search="true"
                  from="${SecUser.all}" optionKey="id" optionValue="full_name"
                  class="form-control selectpicker" noSelection="['': 'Select Customer']"/>

    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-2">Amount </label>
    <div class="col-lg-8">
        <input type="number" name="amount" class="form-control"   value="${loanRequest?.amount}">
    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-2">Interest(%) </label>
    <div class="col-lg-8">
        <input type="number" name="interest_percentage" class="form-control"  value="${loanRequest?.interest_percentage}">
    </div>
</div>


