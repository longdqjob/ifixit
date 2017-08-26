<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="home.title"/></title>
    <meta name="menu" content="Home"/>
</head>
<body class="home">

    <h2><fmt:message key="home.heading"/></h2>
    <p><fmt:message key="home.message"/></p>

    <ul class="glassList">
        <li>
            <a href="<c:url value='/editProfile'/>"><fmt:message key="menu.user"/></a>
        </li>
        <li>
            <a href="<c:url value='/selectFile'/>"><fmt:message key="menu.selectFile"/></a>
        </li>
    </ul>
    <div id="demo">

    </div>

    <script>
        Ext.onReady(function () {
            alert('hello');
            var store = Ext.create('Ext.data.Store', {
                fields: ['name', 'email', 'phone'],
                data: [
                    {'name': 'Lisa', "email": "lisa@simpsons.com", "phone": "555-111-1224"},
                    {'name': 'Bart', "email": "bart@simpsons.com", "phone": "555-222-1234"},
                    {'name': 'Homer', "email": "home@simpsons.com", "phone": "555-222-1244"},
                    {'name': 'Marge', "email": "marge@simpsons.com", "phone": "555-222-1254"}
                ]
            });

            Ext.create('Ext.grid.Panel', {
                title: 'Simpsons',
                renderTo: 'demo',
                store: store,
                columns: [
                    {text: 'Name', dataIndex: 'name', width: 200},
                    {text: 'Email', dataIndex: 'email', width: 250},
                    {text: 'Phone', dataIndex: 'phone', width: 120}
                ],
                height: 200,
                layout: 'fit',
                fullscreen: true
            });
        });
    </script>

    <script>


    </script>
</body>