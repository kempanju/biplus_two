<%@ page import="admin.Dictionary" %>
<fieldset class="content-group">

    <div style="width: 50%;float: left">

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Code <span class="text-danger">*</span></label>

            <div class="col-lg-5">
                <input type="text" name="code" class="form-control" autocomplete="code" required="required"
                       value="${customers?.code}">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Name <span class="text-danger">*</span></label>

            <div class="col-lg-5">
                <input type="text" name="name" class="form-control" autocomplete="name" required="required"
                       value="${customers?.name}">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Contacts</label>

            <div class="col-lg-5">
                <input type="text" name="contacts" class="form-control" autocomplete="contacts" required="required"
                       value="${customers?.contacts}">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Loan Type <span class="text-danger">*</span></label>

            <div class="col-lg-5">
                <g:select name="loan_type" id="loan_type" value="${customers?.loan_type?.id}"
                          from="${admin.DictionaryItem.findAllByDictionary_id(admin.Dictionary.findByCode("LONTY"))}"
                          optionKey="id" optionValue="name"
                          class="form-control select-search" noSelection="['': 'Select loan Type']"/>

            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">Loan Allowed?</label>

            <div class="col-lg-5">
                <g:checkBox style="display:block" name="loan_allowed" value="${customers?.loan_allowed}"/>

            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">CEO Email</label>

            <div class="col-lg-5">
                <input type="text" name="ceo_email" class="form-control" value="${customers?.ceo_email}">
            </div>
        </div>

    </div>


    <div style="width: 50%;float: left">

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">ACCOUNTANT Email</label>

            <div class="col-lg-5">
                <input type="text" name="accountant_email" class="form-control" value="${customers?.accountant_email}">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-lg-3 text-bold">HR Email</label>

            <div class="col-lg-5">
                <input type="text" name="hr_email" class="form-control" value="${customers?.hr_email}">
            </div>
        </div>
        <sec:ifAnyGranted roles="ROLE_ADMIN">

            <g:if test="${customers}">
                <div class="form-group">
                    <label class="control-label col-lg-3 text-bold">MPESA Username</label>

                    <div class="col-lg-5">
                        <input type="text" name="mpesa_username" class="form-control" autocomplete="name"
                               value="${customers?.mpesa_username}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-lg-3 text-bold">MPESA Password</label>

                    <div class="col-lg-5">
                        <input type="password" name="mpesa_password" class="form-control"
                               value="${customers?.mpesa_password}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-lg-3 text-bold">MPESA Link</label>

                    <div class="col-lg-5">
                        <input type="text" name="mpesa_link" class="form-control" value="${customers?.mpesa_link}">
                    </div>
                </div>

                <div class="form-group">
                    <label class="control-label col-lg-3 text-bold">Loan Interest</label>

                    <div class="col-lg-5">
                        <input type="number" name="loan_interest" class="form-control"
                               value="${customers?.loan_interest}">
                    </div>
                </div>

            </g:if>
        </sec:ifAnyGranted>
    </div>
</fieldset>