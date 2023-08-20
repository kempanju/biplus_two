<%@ page import="finance.SecUser; loans.LoanRequest" %>
<div class="form-group">

    <label class="control-label col-lg-2">Parent Loan</label>

    <div class="col-lg-6">
        <g:select name="loan_id" id="loan_id" value="${loanRequest?.loan_id?.id}" required="required"
                  data-show-subtext="true" data-live-search="true"
                  from="${LoanRequest.findAllByLoan_statusAndLoan_repaidAndUser_id(2, false, SecUser.read(params.user_id))}" optionKey="id" optionValue="loan_amount_total"
                  class="form-control " noSelection="['': 'Select Loan']"/>

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-2">Amount </label>
    <div class="col-lg-6">
        <input type="number" name="amount_paid" class="form-control"   value="${loanRequest?.amount_paid}">
    </div>
</div>

