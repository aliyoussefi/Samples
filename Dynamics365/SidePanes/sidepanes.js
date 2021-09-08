
function CreateReservationSidePane(executionContext){
    Xrm.App.sidePanes.createPane({
        title: "Reservations",
        imageSrc: "WebResources/mce_WebResources/sample_product_icon",
        paneId: "ReservationList",
        canClose: false
    }).then((pane) => {
        pane.navigate({
            pageType: "entitylist",
            entityName: "account",
        })
    });
}