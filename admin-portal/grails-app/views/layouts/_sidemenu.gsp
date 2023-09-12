<%@ page import="admin.Wards; admin.District; admin.Region; finance.UserLogs; loans.LoanRepayment; loans.LoanRequest; admin.Customers; finance.SecUser" %>

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
                            <img src="${imagePathsProfile(name: userIntance.recent_photo)}"
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

                        <g:link class="list" controller="loanRequest" action="reports"><i
                            class="icon-home4"></i> <span>Dashboard</span></g:link></li>

                    <sec:ifLoggedIn>
                        <li class="<g:if test="${activePage=='users'}">active</g:if>">
                            <a href="#"><i class="icon-users4"></i> <span>Users</span></a>
                            <ul>
                                <li><g:link controller='secUser' action="index">Users List<span
                                        class="label bg-blue-400">${SecUser.count()}</span></g:link></li>
                                <li class="navigation-divider"></li>
                                <li> <g:link controller="secUser" class="create" action="create">Add user</g:link></li>
                            </ul>
                        </li>


                        <li class="<g:if test="${activePage=='customers'}">active</g:if>">
                            <a href="#"><i class="icon-store"></i> <span>Organizations</span></a>
                            <ul>
                                <li><g:link controller='customers' action="index">Organizations List<span
                                        class="label bg-blue-400">${Customers.count()}</span></g:link></li>
                                <li class="navigation-divider"></li>
                                <li> <g:link controller="customers" class="create" action="create">Add Organization</g:link></li>
                            </ul>
                        </li>



                    </sec:ifLoggedIn>


                    <sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_LOAN,ROLE_MANAGER">

                        <li class="<g:if test="${activePage=='loans'}">active</g:if>">
                            <a href="#"><i class=" icon-coins"></i> <span>Loans</span></a>
                        <ul>

                            <li><g:link controller="loanRequest" action="create"><i
                                    class="icon-add"></i> <span>New Request</span>
                            </g:link>
                            </li>

                            <li><g:link controller="loanRequest" action="index"><i
                                    class="icon-credit-card"></i> <span>Requested<span
                                    class="label bg-warning-400">${LoanRequest.count()}</span></span>
                            </g:link>
                            </li>
                            <li><g:link controller='loanRepayment' action="index"><i
                                    class="icon-coins"></i> <span>Repayment<span
                                    class="label bg-warning-400">${LoanRepayment.count()}</span>
                            </span></g:link></li>
                            <li><g:link controller='unpaidLoan' action="index"><i class="icon-coins"></i> Today Due</g:link>
                            </li>
                            <li><g:link controller='unpaidLoan' action="printLoanExcel"><i class="icon-file-excel"></i>
                                Today Due CSV</g:link></li>
                            <li><g:link controller='secUser' action="loanPointsByUser"><i
                                    class="icon-coins"></i> Loan points</g:link></li>
                            <li><g:link controller='loanGroup' action="index"><i class="icon-coins"></i> Groups</g:link>
                            </li>
                            <li><g:link controller='loanRequest' action="reports"><i
                                    class="icon-coins"></i> Request report</g:link></li>
                        </ul>

                        </li>


                    %{--   <li><g:link controller='secUser' action="notTakenLoanByUser"><i class="icon-coins"></i> Not Taken Loan</g:link>

                       </li>--}%




                    </sec:ifAnyGranted>
                <!-- /main -->



                    <li class="<g:if test="${activePage=='agents'}">active</g:if>">
                        <a href="#"><i class="icon-library2"></i> <span>Agents</span></a>
                        <ul>
                            <li><g:link controller="secUser" action="agentList"><i
                                    class="icon-list-unordered"></i><span>Agents list<span
                                    class="label bg-brown-400">${SecUser.countByUser_group(Customers.findByCode("AGENT"))}</span></span>
                            </g:link>
                            </li>


                            <li><g:link controller="secUser" action="usersAgentList"><i
                                    class="icon-list-unordered"></i><span>Registered Users<span
                                    class="label bg-brown-400">${SecUser.countByAgent_active(true)}</span></span>
                            </g:link>
                            </li>

                            <li><g:link controller='secUser' action="createAgent"><i
                                    class="icon-plus22"></i> Create Agent</g:link></li>
                        </ul>
                    </li>


                    <li class="<g:if test="${activePage=='logs'}">active</g:if>">
                        <a href="#"><i class="icon-book"></i> <span>Logs</span></a>
                        <ul>
                            <li><g:link controller='userLogs' action="index">Logs<span
                                    class="label bg-blue-400">${UserLogs.count()}</span></g:link></li>

                        </ul>
                    </li>

                    <li class="<g:if test="${activePage=='location'}">active</g:if>">
                        <a href="#"><i class="icon-map"></i> <span>Location</span></a>
                        <ul>
                            <li><g:link controller='region' action="index">Region<span
                                    class="label bg-blue-400">${Region.count()}</span></g:link></li>
                            <li class="navigation-divider"></li>

                            <li><g:link controller='district' action="index">District<span
                                    class="label bg-blue-400">${District.countByD_deleted(false)}</span></g:link></li>
                            <li class="navigation-divider"></li>
                            <li><g:link controller='wards' action="index">Region<span
                                    class="label bg-blue-400">${Wards.countByWard_visible(true)}</span></g:link></li>
                            <li class="navigation-divider"></li>

                        </ul>
                    </li>


                    <li class="<g:if test="${activePage=='admin'}">active</g:if>">
                        <a href="#"><i class=" icon-cog3"></i> <span>Admin</span></a>
                        <ul>

                            <li><g:link controller='secRole' action="index">Roles</g:link></li>

                            <li><g:link controller='dictionary' action="index">Dictionary</g:link></li>
                            <li><g:link controller='dictionaryItem' action="index">Dictionary item</g:link></li>
                            <li><g:link controller='region' action="index">Regions</g:link>
                            </li>
                            <li><g:link controller='paymentConfig' action="index">Admin panel</g:link></li>
                        </ul>
                    </li>
                    <li class="<g:if test="${activePage=='employer'}">active</g:if>">
                        <a href="#"><i class=" icon-cog3"></i> <span>Employer portal</span></a>
                        <ul>
                        <li><g:link controller='employeeUser' action="index">Users</g:link></li>
                        </ul>
                    </li>


                </ul>
            </div>
        </div>
        <!-- /main navigation -->

    </div>
</div>