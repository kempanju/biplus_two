<%@ page import="java.sql.Timestamp; java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <title>Message</title>

    <script>

        function onChangeData(ids) {
            var ids = ids.value;

            $.ajax({
                url: '${grailsApplication.config.systemLink.toString()}user/messageOptions',
                data: {'search_string': ids}, // change this to send js object
                type: "post",
                success: function (data) {
                    //document.write(data); just do not use document.write
                    $("#dataOptions").html(data);
                    console.log(data);
                }
            });
        }
    </script>
</head>
<body>
<div class="content">

    <div class="panel panel-flat">

        <div class="page-header-content">
            <div class="page-title">
                <h5>
                    <g:link controller="loanRequest" action="index">
                        <i class="icon-arrow-left52 position-left"></i> <span class="text-semibold">Send Messages</span>
                    </g:link>
                </h5>
            </div>
        </div>

        <div id="create-loanRequest" class="content scaffold-create" role="main">
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.loanRequest}">
                <ul class="errors" role="alert">
                    <g:eachError bean="${this.loanRequest}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                    </g:eachError>
                </ul>
            </g:hasErrors>


            <g:form  method="POST" action="sendBulkMessages" class="form-horizontal">
                <fieldset class="form">

                    <div class="col-lg-12">

                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="control-label col-lg-3 text-bold">From Date</label>


                                <div class="col-lg-7 input-append date form_datetime">
                                    <input type="text" name="start_date" value="2018-07-01 01:07"  required="required" class="form-control"/>
                                    <span class="add-on"><i class="icon-th"></i></span>

                                </div>
                            </div>
                        </div>

                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="control-label col-lg-3 text-bold">To Date</label>
                                <%
                                    def current_time = Calendar.instance
                                    def created_at = new java.sql.Timestamp(current_time.time.time).toString()

                                    java.text.SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm")
                                    Date now = new Date();
                                    String strDate = formatter.format(now);


                                    %>

                                <div class="col-lg-7 input-append date form_datetime">
                                    <input type="text" name="end_date" value="${strDate}" readonly required="required" class="form-control"/>
                                    <span class="add-on"><i class="icon-th"></i></span>

                                </div>
                            </div>
                        </div>

                    </div>


                    <div class="col-lg-12">

                    <div class="form-group">
                        <label class="control-label col-lg-2">Group </label>


                        <div class="col-lg-3">
                            <select name="category" onchange="onChangeData(this)">
                                <option value="0">All</option>
                                <option value="1">By District</option>
                                <option value="2">By Region</option>
                                <option value="3">By Category</option>
                                <option value="4">By Status</option>
                            </select>

                        </div>


                        <div class="col-lg-3" id="dataOptions">
                            %{-- <select name="category">
                                 <option value="0">All</option>
                                 <option value="1">By Location</option>
                                 <option value="2">By Category</option>
                                 <option value="3">By Status</option>
                             </select>--}%

                        </div>
                        <div class="col-lg-3" id="dataOptionsND">
                            <select name="paidCategory">
                                <option value="0">All</option>
                                <option value="1">Paid</option>
                                <option value="3">Not Paid</option>
                                <option value="2">Paid partially</option>

                            </select>

                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-lg-2">Message </label>
                        <div class="col-lg-8">
                            <textarea type="text" required="required" name="message"  class="form-control"  value="${params?.message}">${params?.message}</textarea>
                        </div>
                    </div>


                    <div class="text-right col-lg-10">
                        <button type="submit" class="btn btn-primary">Send Messages <i class="icon-arrow-right14 position-right"></i>
                        </button>

                    </div>
                    </div>
                </fieldset>
            </g:form>
            <table>
                <tr><td class="text-bold">CODE</td><td class="text-bold">Description</td></tr>
                <tr><td>{fName}</td><td>Full Name</td></tr>
                <tr><td>{regNo}</td><td>Registration number</td></tr>
                <tr><td>{MregNo}</td><td>MLIPA registration number</td></tr>
                <tr><td>{mobile}</td><td>Phone number</td></tr>

            </table>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(".form_datetime").datetimepicker({format: 'yyyy-mm-dd hh:mm'});
</script>
</body>
</html>
