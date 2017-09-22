<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    var selectedSystem = null;

    function updateLayOut() {
        Ext.getCmp("searchform").updateLayout();
        Ext.getCmp('gridUser').setWidth(Ext.getCmp("searchform").getWidth());
        Ext.getCmp('gridUser').setHeight(Ext.getCmp("viewport").getHeight() - Ext.getCmp("searchform").getHeight() - 110);
        Ext.getCmp("gridUser").updateLayout();
        treeSystem.setHeight(Ext.getCmp("gridUser").getHeight() - 5);
    }
</script>