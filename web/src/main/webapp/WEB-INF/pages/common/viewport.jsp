<%-- 
    Document   : viewport
    Created on : Aug 25, 2017, 11:23:02 PM
    Author     : LongDQ
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<script>
    
     Ext.create('Ext.Viewport', {
                layout: 'border',
                title: 'Ext Layout Browser',
                hideCollapseTool: true,
                titleCollapse: true,
                collapsible: true,
                defaults: {
                    collapsible: true,
                    split: true
                },
                items: [
                    Ext.create('Ext.tab.Panel',
                            {
                                region: 'center',
                                deferredRender: false,
                                margins: '43 0 30 0',
                                activeTab: 0,
                                items: [
                                    {
                                        contentEl: 'tabs-1',
                                        title: 'Active alarm list',
                                        id: 'tabs1Id'
                                    },
                                ], listeners: {
                                    resize: function (width, height, oldWidth, oldHeight, eOpts) {
                                        setTimeout(function () {
                                            Ext.getCmp("activeAlarmList").setHeight(Ext.getCmp("tabs1Id").getHeight() - Ext.getCmp("filterForm").getHeight());
                                            Ext.getCmp("activeAlarmList").doLayout();
                                            Ext.getCmp("filterForm").doLayout();
                                        }, 1);
                                    },
                                },
                            })
                ],
                listeners: {
                    resize: function (thisGrid, width, height, oldWidth, oldHeight, eOpts) {
                        setTimeout(function () {
                            Ext.getCmp("activeAlarmList").setHeight(Ext.getCmp("tabs1Id").getHeight() - Ext.getCmp("filterForm").getHeight());
                            Ext.getCmp("activeAlarmList").doLayout();
                            Ext.getCmp("filterForm").doLayout();
                        }, 1);
                    }
                },
            });
    
</script>
