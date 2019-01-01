angular.module('datarequest', [])
  .controller('MainCtrl', [function() {
    var self = this;

    self.change = function() {
	  self.user = {'firstName' : 'Robert', 'lastName' : 'Robot'};
	  self.data = {
		'requestType' : 1,
		'area1' : 'Hepanation UK',
		'responsible1' : 'Dr Eleanor Parker',
		'organisation1' : 'MacArthur Research UK',
		'objective1' : 'Study Effects of Retroviral Drugs compared to Antibiotic Treatment',
		'benefits1' : 'Improved treatment outcomes for patients with viral infection. Reduction in antibiotic prescription. Reduced cost for treatment of viral disease',
		'recApproval' : 1,
		'recApprovalNumber' : 'BCK-123',
		'population1' : 'Subjects recruited from C&I Community Clinics',
		'identifiable1' : 1,
		'identifiers' : {'ptName' : 1, 'nhsNumber' : 1},
		'pidJustify1' : 'NHS Number is needed to link data to Community Clinic records. Patient Name will be used to check correct matching of patient details',
		'legalBasis1' : 1,
		'disclosure1' : 1,
		'disclosureIdSpecification1' : 'Study data will be shared with other participating sites: RFH and MNUH',
		'disclosureContract1' : 'Data Sharing agreements have been approved at UCLH, Royal Free and North Middx',
		'publish1' : 1,
		'publishIdSpecification1' : 'Results to be published in Medical Journals.',
		'storing' : 'Data will be held on secure servers in the MacArthur Research UK data centre. Data centre data remains within the EU',
		'secure' : 'Access to data will be controlled by role-based access permissions. Sensitive data items will be limited to research project administrators only',
		'completion' : 'Project is scheduled for completion in July 2020. Data will be held in archive format for 5 more years when it will be securely deleted',
		'completionDate' : '2023-12-31',
		'additional1' : 'More info to follow...',
		'pathology' : true, 
		'pathologyDetails' : 'Blood tests and Virology results',
		'pharmacy' : true, 
		'pharmacyDetails' : 'Anti-viral and antibiotic prescriptions',
		'other' : true, 
		'otherDetails' : 'Outstanding PPI claims',
		'consent' : 1,
		'identifiableSpecification1' : 'National Insurance Number',
	  };
    };

    self.submit = function() {
	  console.log('User clicked submit with ', 
	    self.username, self.password);
    };
if (typeof request !== 'undefined') {
    self.user = request.user;
    if (typeof request.data !== 'undefined') {
	    self.data = request.data;
            if (self.data.pathologyDetails) { self.data.pathology = true; }
            if (self.data.diagnosisDetails) { self.data.diagnosis = true; }
            if (self.data.radiologyDetails) { self.data.radiology = true; }
            if (self.data.pharmacyDetails) { self.data.pharmacy = true; }
            if (self.data.episodeDetails) { self.data.episode = true; }
            if (self.data.theatreDetails) { self.data.theatre = true; }
            if (self.data.cardiologyDetails) { self.data.cardiology = true; }
            if (self.data.chemotherapyDetails) { self.data.chemotherapy = true; }
            if (self.data.otherDetails) { self.data.other = true; }
   } else {
	    self.data = {'pathology' : false,
		'diagnosis' : false,
		'radiology' : false,
		'pharmacy' : false,
		'episode' : false,
		'theatre' : false,
		'cardiology' : false,
		'chemotherapy' : false,
	    };
   }
}

  }]);
