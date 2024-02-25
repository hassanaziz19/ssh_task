*** Settings ***
Library             RequestsLibrary
Library             Collections
Resource            ../test_data/data.robot


*** Variables ***
${BASE_URL}        http://${ARG1}:5001
${name}            Initial Value

*** Test Cases ***
GET_ALL_ITEMS
    ${response} =    GET    ${BASE_URL}/items
    Should Be Equal     ${response.status_code}     ${200}
    ${json_data} =   Set Variable    ${response.json()}
    Lists Should Be Equal    ${json_data}    ${list_of_dicts}

GET_SINGLE_ITEM_WITH_PARAM
    FOR    ${item}    IN    @{list_of_dicts}
        ${response} =    GET    url=${BASE_URL}/items/?name=${item['name']}
        Should Be Equal     ${response.status_code}     ${200}
        ${json_data} =   Set Variable    ${response.json()[0]}
        Dictionaries Should Be Equal     ${json_data}      ${item}
    END

GET_SINGLE_ITEM_WITH_NAME
    FOR    ${item}    IN    @{list_of_dicts}
        ${response} =    GET    ${BASE_URL}/items/${item['name']}
        ${json_data} =   Set Variable    ${response.json()}
        Dictionaries Should Be Equal     ${json_data}      ${item}
    END

ADD_SINGLE_ITEM
    ${data} =    Create Dictionary    name=item_5
    ${json_data}=    Evaluate    json.dumps($data)
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response} =    POST    ${BASE_URL}/items    data=${json_data}    headers=${headers}
    ${json_data} =   Set Variable    ${response.json()}
    Should Be Equal     ${response.status_code}     ${201}
    Dictionaries Should Be Equal     ${json_data}      ${data}

    ${response} =    GET    ${BASE_URL}/items
    Should Be Equal     ${response.status_code}     ${200}
    ${json_data} =   Set Variable    ${response.json()}
    ${item_exists}=    List Should Contain Value    ${json_data}    ${data}

DELETE_SINGLE_ITEM
    ${data} =    Create Dictionary    name=item_5
    ${response} =    DELETE    ${BASE_URL}/items/item_5
    Should Be Equal     ${response.status_code}     ${204}

    ${response} =    GET    ${BASE_URL}/items
    Should Be Equal     ${response.status_code}     ${200}
    ${json_data} =   Set Variable    ${response.json()}
    ${item_exists}=    List Should Not Contain Value    ${json_data}    ${data}


