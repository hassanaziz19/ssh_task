*** Settings ***
Library             RequestsLibrary
Library             Collections


*** Variables ***
${BASE_URL}        http://${ARG1}:5001
${name}            Initial Value

*** Test Cases ***
GET_SINGLE_ITEM_WITH_INVALID_NAME
    ${response} =    GET    ${BASE_URL}/items/item_9    expected_status=404
    ${json_data} =   Set Variable    ${response.json()}
    ${my_dict} =    Create Dictionary    error=Item not found: item_9
    Dictionaries Should Be Equal     ${json_data}      ${my_dict}

ADD_DUPLICATE_ITEM
    ${data} =    Create Dictionary    name=item_1
    ${json_data}=    Evaluate    json.dumps($data)
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response} =    POST    ${BASE_URL}/items    data=${json_data}    headers=${headers}    expected_status=400
    ${json_data} =   Set Variable    ${response.json()}
    ${my_dict} =    Create Dictionary    error=Duplicate name: item_1
    Dictionaries Should Be Equal     ${json_data}      ${my_dict}

DELETE_NON_EXISTING_ITEM
    ${data} =    Create Dictionary    name=item_8
    ${response} =    DELETE    ${BASE_URL}/items/item_8    expected_status=404
    ${json_data} =   Set Variable    ${response.json()}
    ${my_dict} =    Create Dictionary    error=Item not found: item_8
    Dictionaries Should Be Equal     ${json_data}      ${my_dict}

