<%@ include file="/common/taglibs.jsp" %>

<head>
    <title><fmt:message key="material.title"/></title>
    <meta name="menu" content="materialMenu"/>
</head>

<script>
    var numSpecification = 10;
</script>

<jsp:include page="../common/require.jsp" />
<jsp:include page="../script.jsp" />
<jsp:include page="../common/treeMaterial.jsp" />
<jsp:include page="../common/treeItemType.jsp" />
<jsp:include page="material_function.jsp" />
<jsp:include page="itemType_function.jsp" />
<jsp:include page="material_form.jsp" />
<jsp:include page="itemType_form.jsp" />
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
    </div>
</body>


