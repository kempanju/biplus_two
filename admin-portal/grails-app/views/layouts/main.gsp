<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="Grails"/>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico" />

    <asset:stylesheet href="https://fonts.googleapis.com/css?family=Roboto:400,300,100,500,700,900" />
    <asset:stylesheet src="icons/icomoon/styles.css"/>

    <asset:stylesheet src="application.css"/>
    <asset:stylesheet src="bootstrap.css"/>
    <asset:stylesheet src="darkbox.css"/>
    <asset:stylesheet src="core.css"/>
    <asset:stylesheet src="components.css"/>
    <asset:stylesheet src="colors.css"/>
    <asset:stylesheet src="general.css"/>
    <asset:stylesheet src="jquery-ui.css"/>
    <asset:stylesheet src="bootstrap-datetimepicker.min.css"/>


    <asset:javascript src="plugins/loaders/pace.min.js"/>

    <asset:javascript src="core/libraries/jquery.min.js"/>

    <asset:javascript src="jquery-ui/jquery-ui.js"/>
    <asset:javascript src="core/libraries/bootstrap.min.js"/>
    <asset:javascript src="plugins/loaders/blockui.min.js"/>

    <asset:javascript src="plugins/ui/moment/moment.min.js"/>
    <asset:javascript src="core/app.js"/>

    <asset:javascript src="core/libraries/jquery_ui/interactions.min.js"/>




    <asset:javascript src="forms/styling/uniform.min.js"/>

    <asset:javascript src="jquery.elevatezoom.js"/>
    <asset:javascript src="darkbox.js"/>
    <asset:javascript src="bootstrap-datetimepicker.min.js"/>
    <script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.min.js"></script>


    %{--<asset:javascript src="core/app.js"/>
    <asset:javascript src="pages/gallery.js"/>--}%
%{--
    <asset:javascript src="plugins/loaders/pace.min.js"/>
--}%


    %{--<asset:javascript src="core/libraries/bootstrap.min.js"/>
    <asset:javascript src="plugins/loaders/blockui.min.js"/>
    <asset:javascript src="jquery-ui/jquery-ui.js"/>

    <asset:javascript src="forms/styling/uniform.min.js"/>

--}%%{--
    <asset:javascript src="pages/form_inputs.js"/>
--}%%{--


    <asset:javascript src="pages/form_inputs.js"/>
--}%
%{--
    <asset:javascript src="plugins/forms/selects/select2.min.js"/>
--}%

    %{--
        <asset:javascript src="plugins/loaders/pace.min.js"/>
            <asset:javascript src="plugins/media/fancybox.min.js"/>

    --}%


%{--
    <asset:javascript src="plugins/forms/selects/select2.min.js"/>
--}%


   %{-- <asset:javascript src="plugins/notifications/jgrowl.min.js"/>
    <asset:javascript src="plugins/ui/moment/moment.min.js"/>
    <asset:javascript src="pages/gallery.js"/>
--}%
%{--
    <asset:javascript src="core/app.js"/>
--}%

   %{-- <asset:javascript src="pages/form_select2.js"/>--}%


%{--
    <asset:javascript src="core/app.js"/>
--}%
    <g:layoutHead/>
</head>
<body class="navbar-bottom">

<g:render template="/layouts/header"/>
<div class="page-container">
<g:render template="/layouts/sidemenu"/>

%{--
<g:render template="/layouts/pageheader"/>
--}%
<!-- Page container -->
<div class="content-wrapper">
<g:layoutBody/>
</div>

%{--
    <asset:javascript src="application.js"/>
--}%

</body>
</html>
