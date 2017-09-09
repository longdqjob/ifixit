<%@ include file="/common/taglibs.jsp" %>

<head>
    <title><fmt:message key="company.title"/></title>
    <meta name="menu" content="AdminMenu"/>
</head>

<style type="text/css">
    p {
        margin:5px;
    }
    .settings {
        background-image:url(../images/folder_wrench.png);
    }
    .navpn {
        background-image:url(../images/folder_go.png);
    }
    .info {
        background-image:url(../images/information.png);
    }
</style>

<jsp:include page="../common/require.jsp" />
<jsp:include page="../script.jsp" />
<jsp:include page="../common/chooseMechanicType.jsp" />
<jsp:include page="../common/treeMechanic.jsp" />
<jsp:include page="../common/treeCompany.jsp" />
<jsp:include page="functionJs.jsp" />
<jsp:include page="mechanic/gridHistory.jsp" />
<jsp:include page="mechanic/functionJs.jsp" />
<jsp:include page="mechanic/formMechanic.jsp" />
<jsp:include page="formCompany.jsp" />
<jsp:include page="navigation.jsp" />
<jsp:include page="search.jsp" />
<jsp:include page="grid.jsp" />
<jsp:include page="layout.jsp" />

<body>
    <!-- use class="x-hide-display" to prevent a brief flicker of the content -->
    <div id="west" class="x-hide-display"></div>
    <!--<div id="center1" class="x-hide-display"></div>-->
    <div id="props-panel" class="x-hide-display" style="width:200px;height:200px;overflow:hidden;">
    </div>
    <div id="south" class="x-hide-display">
        <p>south - generally for informational stuff, also could be for status bar</p>
    </div>
</body>

