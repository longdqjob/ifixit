<%@ include file="/common/taglibs.jsp" %>

<head>
    <title><fmt:message key="work.list"/></title>
    <meta name="menu" content="workOrderMenu"/>
</head>

<script>
    var numSpecification = 10;
</script>
<jsp:include page="../pagingmemory.jsp" />
<jsp:include page="../common/require.jsp" />
<jsp:include page="../script.jsp" />
<jsp:include page="../common/chooseMaterial.jsp" />
<jsp:include page="../common/treeEngineer.jsp" />
<jsp:include page="../common/chooseWorkType.jsp" />
<jsp:include page="../common/treeMechanic.jsp" />
<jsp:include page="functionJs.jsp" />
<jsp:include page="workOrder/manHrs_funcion.jsp" />
<jsp:include page="workOrder/stock_function.jsp" />
<jsp:include page="workOrder/manHrs_form.jsp" />
<jsp:include page="workOrder/stock_form.jsp" />
<jsp:include page="workOrder/manHrs_grid.jsp" />
<jsp:include page="workOrder/stock_grid.jsp" />
<jsp:include page="workOrder/workOrder_function.jsp" />
<jsp:include page="workOrder/workOrder_form.jsp" />
<jsp:include page="formEngineer.jsp" />
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
</body>


