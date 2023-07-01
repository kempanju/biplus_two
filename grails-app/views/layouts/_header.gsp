<%@ page import="finance.SecUser" %>
<!-- Main navbar -->
<div class="navbar navbar-inverse panel" style="background-color: #689300;">
    <div class="navbar-header">
<g:link controller="loanRequest" action="reports" class="navbar-brand">

            <img  height="40px"
                 src="${createLinkTo(dir: 'images', file: 'biplus.png')}"/>

</g:link>

        <ul class="nav navbar-nav visible-xs-block">
            <li><a data-toggle="collapse" data-target="#navbar-mobile"><i class="icon-tree5"></i></a></li>
            <li><a class="sidebar-mobile-main-toggle"><i class="icon-paragraph-justify3"></i></a></li>
        </ul>
    </div>

    <div class="navbar-collapse collapse" id="navbar-mobile">
        <ul class="nav navbar-nav">
            <li><a class="sidebar-control sidebar-main-toggle hidden-xs"><i class="icon-paragraph-justify3"></i></a></li>
        </ul>


       %{-- <sec:ifNotLoggedIn>
            <p class="navbar-text">Hi,
                <g:link controller='login'>Sign in</g:link>
            or
                <g:link controller='home' action="userRegistration">Register</g:link>
            </p>
        </sec:ifNotLoggedIn>
--}%

        <ul class="nav navbar-nav navbar-right">
    %{--    <li>
            <g:link class="dropdown-toggle" controller='home' action="shop">
                <span>Shop</span>
                <i class="caret"></i>
            </g:link>
        </li>
--}%
        %{--<g:if test="${session.uniqueuserID}">
        <li>
            <g:link controller="shoppingCart" action="show" class="dropdown-toggle" >
                <i class="icon-cart-add"> Basket</i>
                <span class="visible-xs-inline-block position-right">Basket</span>
                <span class="badge bg-warning-400">${com.tacip.shopping.ShoppingCart.findAllByUnique_user_id(session.uniqueuserID).size()}</span>
            </g:link>
        </li>
        </g:if>--}%


<sec:ifAnyGranted roles="ROLE_ADMIN">

    <li class="dropdown-toggle">
        <a class="dropdown-toggle" data-toggle="dropdown">
    <span> <i class="icon-cog3"> Admin</i>
            </span>
            <i class="caret"></i>

        </a>

        <ul class="dropdown-menu dropdown-menu-right">
%{--
            <li><g:link controller='user' action="systemusers"><i class="icon-users4"></i> System users</g:link></li>
--}%

            <li><g:link controller='userLogs' action="index"><i class="icon-users4"></i> Logs</g:link></li>



            <li><g:link controller='role' action="index"><i class="icon-user-plus"></i> Roles</g:link></li>


            <li><g:link controller='dictionary' action="index"><i
                    class="icon-user-plus"></i> Dictionary</g:link></li>
            <li><g:link controller='dictionaryItem' action="index"><i
                    class="icon-user-plus"></i> Dictionary item</g:link></li>
            <li><g:link controller='region' action="index"><i class="icon-user-plus"></i> Regions</g:link>
            </li>
            <li><g:link controller='district' action="index"><i
                    class="icon-user-plus"></i> Districts</g:link></li>
            <li><g:link controller='paymentConfig' action="index"><i
                    class="icon-user-plus"></i> Admin panel</g:link></li>


        </ul>
    </li>
        </sec:ifAnyGranted>


<sec:ifLoggedIn>





            <li class="dropdown dropdown-user">
                <a class="dropdown-toggle" data-toggle="dropdown">
                    <img src="${imagePathsProfile(name:SecUser.get(sec.loggedInUserInfo(field: 'id')).recent_photo)}" alt="">
                    <span><sec:loggedInUserInfo field='username'/></span>
                    <i class="caret"></i>
                </a>

                <ul class="dropdown-menu dropdown-menu-right">
                    <li><g:link  controller="secUser" action="show" id="${sec.loggedInUserInfo(field: 'id')}" ><i class="icon-user-plus"></i> My profile
                    </g:link>
                    </li>

                </ul>
            </li>
        </ul>
</sec:ifLoggedIn>
        <sec:ifLoggedIn>
            <ul class="nav navbar-nav">
                <li class="text-center" style="margin-top: 4px">
                    <g:form controller="logout">
                        <button class="btn btn-info btn-xs" type="submit">LOGOUT</button>
                    </g:form>
                </li></ul>
        </sec:ifLoggedIn>
    </div>
</div>
<!-- /main navbar -->
