pragma solidity ^0.6.12;

contract HealthCare {
    
    struct Patient {  
        address patID;         
        string name;
        uint age;
        string contact;
        string homeAddress;
        string anamnesis;
        uint[] treatments;
        address[] doctors;
    }
    
    mapping (address=>Patient) patients;

    function addPatient(string calldata name, uint age, string calldata contact, string calldata homeAddress) public {
        require(patients[msg.sender].patID==address(0));
        address patID=msg.sender;
        patients[patID].patID=patID;
        patients[patID].name=name;
        patients[patID].age=age;
        patients[patID].contact=contact;
        patients[patID].homeAddress=homeAddress;
    }
    
    function getPatient(address patID) public view returns (string memory _name, uint _age, string memory _anamnesis, string memory _contact, string memory _homeAddress) {
        require(msg.sender==patID || doctors[msg.sender].docID==msg.sender);
        _name = patients[patID].name;
        _age = patients[patID].age;
        _contact = patients[patID].contact;
        _homeAddress = patients[patID].homeAddress;
        _anamnesis = patients[patID].anamnesis;
    }
    
    function newAnamnesis(address patID, string calldata _anamnesis) public {
        require(doctors[msg.sender].docID==msg.sender);
        patients[patID].anamnesis = _anamnesis;
    }
    

    struct Doctor{
        address docID;
        string name;
        string medicalFacility;
        string medicalSpecialty;
    }
    
    mapping(address=>Doctor) doctors;
    
    function addDoctor(string calldata name, string calldata medicalFacility, string calldata medicalSpecialty) public {
        require(doctors[msg.sender].docID==address(0));
        address docID=msg.sender;
        doctors[docID].docID=docID;
        doctors[docID].name = name;
        doctors[docID].medicalFacility = medicalFacility;
        doctors[docID].medicalSpecialty = medicalSpecialty;
    }
    
    function getDoctorDetails(address docID) public view returns (string memory _name, string memory _medicalFacility, string memory _medicalSpecialty) {
        _name = doctors[docID].name;
        _medicalFacility = doctors[docID].medicalFacility;
        _medicalSpecialty = doctors[docID].medicalSpecialty;
    }
    
    function treatPatient(address patID) public {
        require(doctors[msg.sender].docID==msg.sender);
        patients[patID].doctors.push(doctors[msg.sender].docID);
    }
    
    
    struct Treatment {
        address patientID;
        address doctorID;
        string diagnosis;
        string medicine;
        uint date;
        uint bill;
    }
    
    uint lastTreatmentID = 0;
    
    mapping (uint=>Treatment) treatments;
    
    function createTreatment(address patientID, address doctorID, string calldata diagnosis, uint bill, string calldata medicine) public returns (uint) {
        require(doctors[msg.sender].docID==msg.sender);
        uint id=lastTreatmentID;
        treatments[id].patientID = patientID;
        treatments[id].doctorID = doctorID;
        treatments[id].diagnosis = diagnosis;
        treatments[id].medicine = medicine;
        treatments[id].date = now;
        treatments[id].bill = bill;
        patients[patientID].treatments.push(id);
        lastTreatmentID++;
        return id;
    }
    
    function getTreatmentDetails(uint treatmentID) public view returns (address _patientID, address _doctorID, string memory _diagnosis, string memory _medicine, uint _date, uint _bill) {
        require(msg.sender==treatments[treatmentID].patientID || doctors[msg.sender].docID==msg.sender);
        _patientID = treatments[treatmentID].patientID;
        _doctorID = treatments[treatmentID].doctorID;
        _medicine = treatments[treatmentID].medicine;
        _diagnosis = treatments[treatmentID].diagnosis;
        _date = treatments[treatmentID].date;
        _bill = treatments[treatmentID].bill;
    }
    
    
    //Function for adding funds to contract
    receive() external payable {}
    
    function withdrow(uint treatmentID) external {
        require(msg.sender==treatments[treatmentID].doctorID);
        msg.sender.transfer(treatments[treatmentID].bill);
    }
}
