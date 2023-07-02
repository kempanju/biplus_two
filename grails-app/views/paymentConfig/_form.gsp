<div class="form-group">
    <label  class="control-label col-lg-3">Card Expires Years <span class="text-danger">*</span></label>
    <div class="col-lg-7">
        <input type="number" name="card_expired_years" class="form-control"  required="required" value="${paymentConfig?.card_expired_years}">
    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-3">Loan Fee </label>
    <div class="col-lg-7">
        <input type="number" name="kopafasta_fee" autocomplete="kopafasta_fee"  class="form-control"  value="${paymentConfig?.kopafasta_fee}">
    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">Loan Opened  </label>
    <div class="col-lg-7">
        <g:checkBox name="loan_opened" value="${paymentConfig.loan_opened}" />

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">Product upload?  </label>
    <div class="col-lg-7">

        <g:checkBox name="product_opened" value="${paymentConfig.product_opened}" />

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">M-PESA Username  </label>
    <div class="col-lg-7">
        <input type="text" name="mlipa_username" autocomplete="mlipa_username"  class="form-control"  value="${paymentConfig?.mlipa_username}">

    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-3">M-PESA Password  </label>
    <div class="col-lg-7">
        <input type="text" name="mlipa_password" autocomplete="mlipa_password"  class="form-control"  value="${paymentConfig?.mlipa_password}">

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">M-PESA Private Key  </label>
    <div class="col-lg-7">
        <input type="text" name="privateKey"   class="form-control"  value="${paymentConfig?.privateKey}">

    </div>
</div>


<div class="form-group">
    <label class="control-label col-lg-3">M-PESA Public Key  </label>
    <div class="col-lg-7">
        <input type="text" name="publicPublic"   class="form-control"  value="${paymentConfig?.publicPublic}">

    </div>
</div>
