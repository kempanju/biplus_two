<%@ page import="com.softhama.loans.Employee; com.softhama.loans.LoanRepayment; com.softhama.loans.LoanRequest; com.softhama.SecUser" %>

<%

    def activePage = session["activePage"]

%>

<div class="sidebar sidebar-main">
    <div class="sidebar-content">

        <!-- User menu -->
        <div class="sidebar-user">
            <div class="category-content">
                <sec:ifLoggedIn>
                    <% def userIntance = SecUser.get(sec.loggedInUserInfo(field: 'id')) %>

                    <div class="media">
                        <a href="#" class="media-left">
                            <img src="${imagePathsProfile(name: "default_user.jpg")}"
                                 class="img-circle img-sm" alt="">

                        </a>

                        <div class="media-body">
                            <g:link controller="secUser" action="show" id="${sec.loggedInUserInfo(field: 'id')}"><span
                                    class="media-heading text-semibold">${userIntance.full_name}
                            </span></g:link>
                            <div class="text-size-mini text-muted">
                                <i class="icon-pin text-size-small"></i> &nbsp;<sec:loggedInUserInfo field='username'/>
                            </div>

                        </div>

                        <div class="media-right media-middle">
                            <ul class="icons-list">
                                <li>
                                    <g:link class="list" controller="secUser" action="show"
                                            id="${sec.loggedInUserInfo(field: 'id')}"><i
                                            class="icon-cog3"></i></g:link>
                                </li>
                            </ul>
                        </div>
                    </div>
                </sec:ifLoggedIn>
            </div>
        </div>
        <!-- /user menu -->


        <!-- Main navigation -->
        <div class="sidebar-category sidebar-category-visible">
            <div class="category-content no-padding">
                <ul class="navigation navigation-main navigation-accordion">

                    <!-- Main -->
                    <li class="navigation-header"><span>Main</span> <i class="icon-menu" title="Main pages"></i></li>
                    <li class="<g:if test="${activePage=='dashboard'}">active</g:if>">

                        <g:link class="list" controller="home" action="index"><i
                            class="icon-home4"></i> <span>Dashboard</span></g:link></li>

                    <sec:ifLoggedIn>
                        <li class="<g:if test="${activePage=='users'}">active</g:if>">
                            <a href="#"><i class="icon-users4"></i> <span>Users</span></a>
                            <ul>
                                <li><g:link controller='employee' action="index">Users List<span
                                        class="label bg-blue-400">${Employee.countByUser_group(userIntance?.customer)}</span></g:link></li>
                            </ul>
                        </li>

                    </sec:ifLoggedIn>



                        <li class="<g:if test="${activePage=='loans'}">active</g:if>">
                            <a href="#"><i class=" icon-coins"></i> <span>Loans</span></a>
                        <ul>

                            <li><g:link controller="loanRequest" action="index"><i
                                    class="icon-credit-card"></i> <span>Requested<span
                                    class="label bg-warning-400">${LoanRequest.countByCustomer_id(userIntance?.customer)}</span></span>
                            </g:link>
                            </li>
                            <li><g:link controller='loanRepayment' action="index"><i
                                    class="icon-coins"></i> <span>Repayment
                            </span></g:link></li>

                        </ul>

                        </li>


                </ul>
            </div>
        </div>
        <!-- /main navigation -->

    </div>
</div>