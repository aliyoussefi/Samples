	function retrieveCaseDetailsXRM() {
 
		// Use Xrm.Page to access the context and data of the current record (case)
		//const caseContext = parent.Xrm.Page.context;
		var caseEntity = parent.Xrm.Page.data.entity;
   
		// Retrieve the case details using Xrm.Page methods and attributes
		var caseID = caseEntity.getId(); 
		var caseNumber = parent.Xrm.Page.getAttribute("ticketnumber") ? parent.Xrm.Page.getAttribute("ticketnumber").getValue() : "caseId not found";

   
		var customerAttribute = parent.Xrm.Page.getAttribute("customerid");
		var customerName = customerAttribute && customerAttribute.getValue() ? customerAttribute.getValue()[0].name : null;
		  
		// Return an object containing the case details
		return {
		  caseID: caseID,
		  caseNumber: caseNumber,
		  customerName: customerName
		};
	  }