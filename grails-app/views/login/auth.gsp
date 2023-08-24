<!DOCTYPE HTML>

<g:set var='securityConfig' value='${applicationContext.springSecurityService.securityConfig}'/>

<html>
<head>
    <title>BiPlus</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <asset:link rel="icon" href="favicon.ico" type="image/x-ico" />
    <asset:stylesheet src="bootstrap.css"/>

    <asset:stylesheet src="login/main.css"/>

<asset:javascript src="core/libraries/jquery.min.js"/>
<asset:javascript src="skel.min.js"/>
<asset:javascript src="util.js"/>
<asset:javascript src="main.js"/>

<!-- Scripts -->


</head>
<body>

<!-- Header -->
<header id="header">
    <div class="inner">
        <a href="index.html" class="logo"><strong>BiPlus</strong> PORTAL</a>
        <nav id="nav">
            <g:link controller='home' action="index">Home</g:link>
            <a href="#">About us</a>
            <a href="#">Contact us</a>
        </nav>
        <a href="#navPanel" class="navPanelToggle"><span class="fa fa-bars"></span></a>
    </div>
</header>

<!-- Banner -->
<section id="banner">
    <div class="inner">
        <header>
            <h1>Welcome to BiPlus Finance</h1>
        </header>

        <footer>
            <a href="#" class="button">Please log in</a>
        </footer>
    %{--
                    <h2><g:message code='spring.security.ui.login.signin'/></h2>
    --}%
        <div class="half" style="padding: 10px">

        <g:if test='${flash.message}'>
            <div class='login_message alert alert-success no-border' style="padding: 20px">${flash.message}</div>
        </g:if>

        <s2ui:form type='login' focus='username' >

            <div class="field half first">
                <label for="name">Username</label>
                <input type="text" name="${securityConfig.apf.usernameParameter}" id="username" placeholder="Username" class='formLogin' size="20"/>

            </div>
            <div class="field half">
                <label for="email">Password</label>
                <input type="password" name="${securityConfig.apf.passwordParameter}" id="password" placeholder="Password" size="20"/>

            </div>

            <ul class="actions">
                <li><input value="Log in" class="button alt" type="submit"></li>
            </ul>
        </s2ui:form>
    </div>

       <div class="flex ">




    </div>
</section>





</body>
</html>
