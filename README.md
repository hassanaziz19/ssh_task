SSH COMMUNICATIONS SECURITY CORPORATION
Senior Quality Engineer Code Assignment


THE ASSIGNMENT:
===============
Your task is to write tests for the simple REST server implementation.
Include a report file describing your actions and missing tests if any.

This task should not take more than a few working hours. You can also provide
a partial solution if the task turns to be substantially larger, but please
inform us that you run out of time and you skipped some parts of the task.
Your code will be used in evaluation, so please follow software engineering
practices as you see the best fit. Please be prepared to defend your solution
in the possible interview later on. Code must be on the substantial parts your
own handwriting. You are encouraged to use open source components and public
IPR code, but please mark the copyrights clearly.

 * Write tests for the simple test server using the provided APIs.
 * Run the server and the tests on separate docker containers.
 * Send the test code and instructions how to run the server and tests for
   review.
 * Document your doings, include any notes worth mentioning.


REST SERVER:
============
No need to do changes to the server implementation. The server implementation
may contain bugs.

Run the REST server:
    python3 server/server.py

 * No authorization required for the server.
 * The server creates five items to the database on initialization.
 * Name is the only required parameter for an item.

[GET]    /items/(?param=value)
Description
    List all items when no param given.
    Filter by param=value, for example /items/?tag=test
Response
    200    [{'name': 'item_1', ...}, ...]

[GET]    /items/<name>/
Description
    Get an item by name.
Response
    200    {'name': 'item_1', 'serial': '12345', ...}
    404    {'error': 'message'}

[POST]   /items/
Description
    Add new item.
Input
    {'name': 'item_name', 'email': 'test@ssh.com', ...}
Response
    201    {'name': 'item_name', ...}
    400    {'error': 'message'}

[DELETE] /items/<name>/
Description
    Delete an item by name.
Response
    204
    404    {'error': 'message'}


# # Tasks Solution

## Solution Summary
The ```run.sh``` is used to build and run 2 separate docker containers for Flask and Robot. The script will
also execute the tests and export the testResults. The IP address for Flask container is obtained and used as an argument to point the Robot tests against correct URL for server. There are 2 test suite, one for testing positive scenarions and other suite to test negatives. The detailed structure and instructions on running the tests are below.

## Solution Structure
The solution consists of following:
 * [Project](./)
   * [tests](./tests) Contains test suites
     * [api_tests](./tests/api_tests) Contains tests for API
     * [test_data](./tests/test_data) Contains test data for the API response
   * [DockerfileFlask](./DockerfileFlask) Docker file for Flask
   * [DockerfileRobot](./DockerfileRobot) Docker file for Robot
   * [run.sh](./run.sh) Script to setup containers and run tests
   * [.gitignore](./.gitignore) Ignore testResults from git

## Pre-requisites
- Python is in path. This can be checked with following command
```python3 -V```
- Docker is installed and running

## How to run tests
- Run the command to set the permissions
```
chmod +x run.sh
```
- Run the script
```
./run.sh
```
- After test run is completed, the results and reports can be found under ```testResults``` folder.

FUTURE IMPROVEMENTS:
====================
The solution is created with time limtitation. With more time, the following areas of the solution would need improvements

 * Tests dependency: Currently the tests have dependency on each other, meaning if one tests fail it will cause
   the other test to fail as well since there is no testSetup or testTeardown to reset the response data of the server.
 * Tests can be extended to cover other cases eg POST method with multiple key values, DELETE multiple records.
 * Improving the run.sh script to check the existing running containers before removing and building images again.
 * There is duplicate code in test file for calling GET method (all items). This could be abstracted to seperate keyword.
 * Some test data is duplicated in both suites, and can be moved to separate file.
 * Negative tests contain hard-coded assertions (error messages), this can be improved to provide dynamic data to test and assertions.
 * Docker images can be refined to use only the required server/test files and requirements.