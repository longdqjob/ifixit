

<script>
    Ext.require([
        'Ext.data.*',
        'Ext.grid.*',
        'Ext.tree.*',
        'Ext.tip.*',
        'Ext.ux.CheckColumn'
    ]);

//we want to setup a model and store instead of using dataUrl
    Ext.define('Task', {
        extend: 'Ext.data.TreeModel',
        fields: [
            {name: 'task', type: 'string'},
            {name: 'user', type: 'string'},
            {name: 'duration', type: 'string'},
            {name: 'done', type: 'boolean'}
        ]
    });

    Ext.onReady(function () {
        Ext.tip.QuickTipManager.init();



        var store = Ext.create('Ext.data.TreeStore', {
            model: 'Task',
            proxy: {
                type: 'ajax',
                //the store will get the content from the .json file
                url: 'GetAllTask'
            },
            folderSort: true,
        });

        //Ext.ux.tree.TreeGrid is no longer a Ux. You can simply use a tree.TreePanel
        var tree = Ext.create('Ext.tree.Panel', {
//            title: 'Core Team Projects',
//            width: 400,
//            height: 300,
            id: 'sidelefttree',
            header: false,
            renderTo: 'tree',
            collapsible: true,
            useArrows: true,
            rootVisible: true,
            store: store,
            multiSelect: true,
            border:true,
            columns: [{
                    xtype: 'treecolumn', //this is so we know which column will show the tree
                    text: 'Task',
                    width: 200,
                    sortable: true,
                    dataIndex: 'task',
                    locked: true
                },
                {
                    //we must use the templateheader component so we can use a custom tpl
                    xtype: 'templatecolumn',
                    text: 'Duration',
//                    width: 100,
                    sortable: true,
                    dataIndex: 'duration',
                    align: 'center',
                    //add in the custom tpl for the rows
                    tpl: Ext.create('Ext.XTemplate', '{duration:this.formatHours}', {
                        formatHours: function (v) {
                            if (v < 1) {
                                return Math.round(v * 60) + ' mins';
                            } else if (Math.floor(v) !== v) {
                                var min = v - Math.floor(v);
                                return Math.floor(v) + 'h ' + Math.round(min * 60) + 'm';
                            } else {
                                return v + ' hour' + (v === 1 ? '' : 's');
                            }
                        }
                    })
                }
            ],
            listeners: {
                itemclick: function (s, r) {
                    console.log(r.id);
                    alert(r.id);
                }
            }
        });
    });


</script>