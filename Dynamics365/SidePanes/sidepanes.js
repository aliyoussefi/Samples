
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

function ShowTableRecordInSidePane(executionContext){
    Xrm.App.sidePanes.createPane({
        title: "Reservation: Ammar Peterson",
        imageSrc: "WebResources/sample_reservation_icon",
        hideHeader: true,
        canClose: true,
        width: 600
    }).then((pane) => {
        pane.navigate({
            pageType: "entityrecord",
            entityName: "sample_reservation",
            entityId: "d4034340-4623-e811-a847-000d3a30c619",
        })
    });
}