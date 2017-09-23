<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<script>
    function searchUser(systemId) {
        var prEng = null;
        if (systemId) {
            prEng = systemId;
        } else {
            if (selectedSystem) {
                prEng = selectedSystem.get("id");
            } else {
                prEng = systemIdSs;
            }
        }
        gridUser.getStore().getProxy().extraParams = {
            systemId: prEng,
            username: searchUsermame.getValue(),
            name: searchName.getValue(),
            email: "",
        };
        gridUser.getStore().loadPage(1, {
            callback: function (records, operation, success) {
                storeRedirectIfNotAuthen(operation);
            }
        });
    }
</script>