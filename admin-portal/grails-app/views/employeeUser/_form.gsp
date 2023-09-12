<%@ page import="admin.Customers" %>
<div class="form-group">

    <label class="control-label col-lg-3">Organization</label>


    <div class="col-lg-5">
        <g:select name="customer" id="customer" value="${employeeUser?.customer?.id}" required="required"
                  data-show-subtext="true" data-live-search="true"
                  from="${Customers.all}" optionKey="id" optionValue="name"
                  class="form-control selectpicker" noSelection="['': 'Select organization']"/>

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">Full Name</label>

    <div class="col-lg-5">

            <input type="text" name="full_name" placeholder="Full Name" class="form-control" value="${employeeUser?.full_name}"/>

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">Email Address</label>

    <div class="col-lg-5">
            <input type="text" name="username" placeholder="Email Address" class="form-control" value="${employeeUser?.username}">

    </div>
</div>

<div class="form-group">
    <label class="control-label col-lg-3">Namba ya Simu (Anza na +255)</label>

    <div class="col-lg-5">
        <input type="text" name="phone_number" placeholder="Phone Number" class="form-control"
               value="${employeeUser?.phone_number}">
    </div>
</div>