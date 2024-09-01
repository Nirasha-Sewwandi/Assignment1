import ballerina/http;

// Define an Employee record type
type Employee record {|
    readonly string id;
    string name;
    string age;
    string department;
    string email;
|};

// Define custom error types for better error handling
public type ConflictingRecordError record {|
    *http:Conflict;
    ErrorMsg body;
|};

public type InvalidIDError record {|
    *http:NotFound;
    ErrorMsg body;
|};

public type ErrorMsg record {|
    string errmsg;
|};

// In-memory storage for employees
table<Employee> key(id) employees = table [
    {id: "1", name: "Nirasha", age: "24", department: "Engineering", email: "nirasha@gmail.com"},
    {id: "2", name: "Sewwandi", age: "25", department: "HR", email: "sewwandi@gmail.com"}
];

// Define the Employee Management Service
service /employees on new http:Listener(8090) {

    // Endpoint to retrieve all employees
    resource function get employeeList() returns Employee[]|error {
        return employees.toArray();
    }

    // Endpoint to add a new employee
    resource function post employeeList(@http:Payload Employee employee) returns Employee|ConflictingRecordError {
        if employees.hasKey(employee.id) {
            return {
                body: {
                    errmsg: "Employee ID Already Exists"
                }
            };
        }
        employees.add(employee);
        return employee;
    }

    // Endpoint to update an existing employee
    resource function put employeeList(@http:Payload Employee employee) returns Employee|InvalidIDError {
        Employee? existingEmployee = employees[employee.id];

        if existingEmployee is () {
            return {
                body: {
                    errmsg: "Employee record not found. Invalid ID"
                }
            };
        }

        existingEmployee.name = employee.name;
        existingEmployee.age = employee.age;
        existingEmployee.department = employee.department;
        existingEmployee.email = employee.email;

        return employee;
    }

    // Endpoint to delete an employee by ID
    resource function delete employeeList/[string id]() returns string|InvalidIDError {
        if employees.hasKey(id) {
            _ = employees.remove(id);
            return "Employee Deleted Successfully";
        } else {
            return {
                body: {
                    errmsg: "Employee record not found. Invalid ID"
                }
            };
        }
    }
}
