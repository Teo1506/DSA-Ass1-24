import ballerina/http;
import ballerina/io;

// Define Programme and Course records
type Course record {|
    string courseCode;
    string courseName;
    int nqfLevel;
|};

type Programme record {|
    string programmeCode;
    string title;
    int nqfLevel;
    string faculty;
    string department;
    string registrationDate;
    Course[] courses;
|};

public function main() returns error? {

    string baseUrl = "http://localhost:8080/programmes";

    // Create the HTTP client
    http:Client apiClient = check new (baseUrl);

    // Add a new programme (POST)
    Programme newProgramme = {
        programmeCode: "07BCMS",
        title: "Computer Science",
        nqfLevel: 7,
        faculty: "Faculty of Computing and Informatics",
        department: "Software Development",
        registrationDate: "2020-01-17",
        courses: [
            {courseCode: "CTE711S", courseName: "Compiler Techniques", nqfLevel: 7},
            {courseCode: "MAP711S", courseName: "Mobile Application Development", nqfLevel: 6},
            {courseCode: "DSA612S", courseName: "Distributed Systems", nqfLevel: 6},
            {courseCode: "SVV711S", courseName: "Software Verification and Validation", nqfLevel: 7}
        
        ]
    };
    var postResponse = apiClient->post("/newProgramme", newProgramme);
    if (postResponse is http:Response) {
        io:println("Add Programme Response: ", postResponse.getJsonPayload());
    } else {
        io:println("POST request failed: ", postResponse.message());
    }

    // Retrieve a list of all programmes (GET)
    var getAllResponse = apiClient->get("/allProgrammes");
    if (getAllResponse is http:Response) {
        json allProgrammes = check getAllResponse.getJsonPayload();
        io:println("All Programmes: ", allProgrammes.toJsonString());
    } else {
        io:println("GET request failed: ", getAllResponse.message());
    }

    // Update a programme (PUT)
    Programme updatedProgramme = newProgramme;
    updatedProgramme.title = "Computer Science and Informatics (Updated)";
    var putResponse = apiClient->put("/updateProgramme/" + newProgramme.programmeCode, updatedProgramme);
    if (putResponse is http:Response) {
        io:println("Update Programme Response: ", putResponse.getJsonPayload());
    } else {
        io:println("PUT request failed: ", putResponse.message());
    }

    // Retrieve a specific programme using it's code (GET)
    string programmeCode = "07BCMS";
    var getOneResponse = apiClient->get("/programme/" + programmeCode);
    if (getOneResponse is http:Response) {
        json programmeDetails = check getOneResponse.getJsonPayload();
        io:println("Programme Details: ", programmeDetails.toJsonString());
    } else {
        io:println("GET request failed: ", getOneResponse.message());
    }

    // Delete a programme using programme code (DELETE)
    var deleteResponse = apiClient->delete("/removeProgramme/" + programmeCode);
    if (deleteResponse is http:Response) {
        io:println("Delete Programme Response: ", deleteResponse.getJsonPayload());
    } else {
        io:println("DELETE request failed: ", deleteResponse.message());
    }

    // Retrieve all programmes due for review (GET)
    var getDueForReviewResponse = apiClient->get("/dueForReview");
    if (getDueForReviewResponse is http:Response) {
        json dueProgrammes = check getDueForReviewResponse.getJsonPayload();
        io:println("Programmes Due for Review: ", dueProgrammes.toJsonString());
    } else {
        io:println("GET request failed: ", getDueForReviewResponse.message());
    }

    // Retrieve programmes using faculty (GET)
    string faculty = "Faculty of Computing";
    var getByFacultyResponse = apiClient->get("/programmesByFaculty/" + faculty);
    if (getByFacultyResponse is http:Response) {
        json facultyProgrammes = check getByFacultyResponse.getJsonPayload();
        io:println("Programmes in Faculty: ", facultyProgrammes.toJsonString());
    } else {
        io:println("GET request failed: ", getByFacultyResponse.message());
    }
};
