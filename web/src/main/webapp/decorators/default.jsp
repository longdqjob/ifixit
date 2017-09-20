<!DOCTYPE html>
<%@ include file="/common/taglibs.jsp"%>
<html lang="en">
    <head>
        <meta http-equiv="Cache-Control" content="no-store"/>
        <meta http-equiv="Pragma" content="no-cache"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="<c:url value="/images/favicon.ico"/>"/>



              <title><decorator:title/> | <fmt:message key="webapp.name"/></title>
    <t:assets type="css"/>
    <decorator:head/>
    <!--<link href="../scripts/resources/theme-neptune-all.css" rel="stylesheet" type="text/css"/>-->
    <link href="../scripts/resources/theme-neptune-all-debug.css" rel="stylesheet" type="text/css"/>
    <link href="../scripts/resources/theme-neptune-all-rtl-debug.css" rel="stylesheet" type="text/css"/>
    <link href="../styles/style.css" rel="stylesheet" type="text/css"/>
    <!--    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">-->


    <script src="../scripts/jquery-3.2.1.min.js" type="text/javascript"></script>
    <script src="../scripts/resources/ext-all-debug.js" type="text/javascript"></script>
    <script src="../scripts/resources/theme-neptune.js" type="text/javascript"></script>
    <style type="text/css">
        #content {
            margin-top:  800px;
            margin: 0 0 0 0;
        } 

        :hover {
            text-decoration: none !important;
        }
        #navbar {
            height: 20px !important;
        }

    </style>
</head>

<c:set var="currentMenu" scope="request"><decorator:getProperty property="meta.menu"/></c:set>
<div class="navbar navbar-default navbar-fixed-top" role="navigation">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="<c:url value='/'/>"><fmt:message key="webapp.name"/></a>
    </div>
    <div style="align-items: center">
        <%@ include file="/common/menu.jsp" %>
        <c:if test="${pageContext.request.locale.language ne 'en'}">
            <div id="switchLocale"><a href="<c:url value='/?locale=en'/>">
                    <fmt:message key="webapp.name"/> in English</a>
            </div>
        </c:if>
    </div>
</div>
<body<decorator:getProperty property="body.id" writeEntireProperty="true"/><decorator:getProperty property="body.class" writeEntireProperty="true"/>>

<div class="container-fluid" id="content">
    <%@ include file="/common/messages.jsp" %>
    <div class="row">
        <decorator:body/>


    </div>
</div>
</body>


<div id="footer" class="container-fluid navbar-fixed-bottom">
    <span class="col-sm-6 text-left"><fmt:message key="webapp.version"/>
        <c:if test="${pageContext.request.remoteUser != null}">
            | <fmt:message key="user.status"/> ${pageContext.request.remoteUser}
        </c:if>
    </span>
    <span class="col-sm-6 text-right">
        &copy; <fmt:message key="copyright.year"/> <a href="<fmt:message key="company.url"/>"><fmt:message key="company.name"/></a>
    </span>
</div>

<t:assets type="js"/>    
<%= (request.getAttribute("scripts") != null) ? request.getAttribute("scripts") : ""%>
</html>
