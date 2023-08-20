<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html >
<head>
    <title>
        Statement
    </title>
    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="bootstrap.css"/>

    <asset:stylesheet src="core.css"/>
    <asset:stylesheet src="components.css"/>
    <asset:stylesheet src="colors.css"/>
    <asset:stylesheet src="general.css"/>
</head>
<body>
<h1>Card printed by Date</h1>
<div class="row">
    <div class="col-lg-10">


        <!-- Marketing campaigns -->
        <div class="panel panel-flat">

            <div class="table-responsive">



                <table class="table border-blue" border="1" style="width: 50%">




                    <tr>
                        <td colspan="2" class="text-center"><h3>
                            <span class="text-bold numbers text-center">Reports</span>
                        </h3></td></tr>

                    <tr><td>No</td><td>Date</td> <td>Paid No</td></tr>
                    <g:each in="${report}" status="i" var="cardInstance">
                        <tr>
                            <td>${i+1}</td>
                            <td>${cardInstance[1]}</td>

                            <td>${cardInstance[0]}</td>
                        </tr>

                    </g:each>


                </table>

            </div>
        </div>
        <!-- /marketing campaigns -->

    </div>
</div>
</body>
</html>