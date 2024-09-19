import ballerina/http;
import ballerina/io;
import ballerina/time;


type Programme record {| 
    readonly string programmeCode;
    int nqfLevel;
    string facultyName;
    string departmentName;
    string programmeTitle;
    string registrationDate;
    Course[] courses;
|};

type Course record {
    string courseName;
    string courseCode;
    int nqfLevel;
};

// In-memory data storage for programmes using a table
table<Programme> key(programmeCode) programmes = table [];

// Service to manage programme records
service /programme on new http:Listener(8080) {

    //  Add a new programme
    resource function post addProgramme(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        Programme newProgramme = check payload.cloneWithType(Programme);
        
        // Check if programme exists
        var existingProgramme = programmes.get(newProgramme.programmeCode);
        if (existingProgramme is Programme) {
            check caller->respond("Programme with this code already exists");
        } else {
            // Add the new programme to the table
            programmes.add(newProgramme);
            check caller->respond("Programme added successfully");
        }
    }

    //  Returns all programmes
    resource function get allProgrammes(http:Caller caller) returns error? {
    var allProgrammes = programmes.toArray() , toJson();
    check caller->respond(allProgrammes);
}


    //  Update an existing programme by programme code
    resource function put updateProgramme(http:Caller caller, http:Request req, string programmeCode) returns error? {
        // Check if the programme exists
        var existingProgramme = programmes.get(programmeCode);
        if (existingProgramme is Programme) {
            json payload = check req.getJsonPayload();
            Programme updatedProgramme = check payload.cloneWithType(Programme);
            // Update the programme in the table
            programmes.put(updatedProgramme);
            check caller->respond("Programme updated successfully");
        } else {
            check caller->respond("Programme not found");
        }
    }

    //  Return the details of a specific programme by their programme code
    resource function get programmeByCode(http:Caller caller, string programmeCode) returns error? {
        var programme = programmes.get(programmeCode);
        if (programme is Programme) {
            check caller->respond(programme.toJson());
        } else {
            check caller->respond("Programme not found");
        }
    }

    //  Delete a programme's record by their programme code
    resource function delete deleteProgramme(http:Caller caller, string programmeCode) returns error? {
        var programme = programmes.get(programmeCode);
        if (programme is Programme) {
            // Remove the programme from the table
            Programme remove = programmes.remove(programmeCode);
            check caller->respond("Programme deleted successfully");
        } else {
            check caller->respond("Programme not found", 404);
        }
    }

    //  Returns all programmes due for review (after 5 years)
    resource function get programmesForReview(http:Caller caller) returns error? {
        json[] reviewProgrammes = [];  // Define as a json array
        foreach var programme in programmes {
            if check checkYearsForReview(programme.registrationDate) {
                reviewProgrammes.push(programme.toJson());  // Add to json array
            }
        }
        check caller->respond(reviewProgrammes);
    }

    //  Return all  programmes of the same faculty
    resource function get programmesByFaculty(http:Caller caller, string facultyName) returns error? {
        json[] facultyProgrammes = [];  // Define as a json array
        foreach var programme in programmes {
            if programme.facultyName == facultyName {
                facultyProgrammes.push(programme.toJson());  // Add to json array
            }
        }
        check caller->respond(facultyProgrammes);
    }
}

//  checking if  programme is due for review (after 5 years)
function checkYearsForReview(string registrationDate) returns boolean|error {
    // Extract the year from the registration date (assuming the format is "YYYY-MM-DD")
    int yearRegistered = check 'int:fromString(registrationDate.substring(0, 4));
    int currentYear = 2024;  // Replace with the current year dynamically in a real system
    // Check if 5 or more years have passed since registration
    return (currentYear - yearRegistered) >= 5;
}


THE SERVER SIDE ONLY,THERE IS TWO ERRORS,RUN ON GITHUB FOR MORE INFO
