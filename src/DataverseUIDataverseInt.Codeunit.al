codeunit 70101 "Dataverse UI Dataverse Integr."
{
    trigger OnRun()
    begin

    end;

    internal procedure CreateTable(DataverseUITable: Record "Dataverse UI Table"; UpdateTable: Boolean)
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        JsonBody: JsonObject;
        Body: Text;
        EntityId: Text;
        [NonDebuggable]
        AccessToken: Text;
        DataverseUISetup: Record "Dataverse UI Setup";
        UriCreate: Label '%1/api/data/v%2/EntityDefinitions', Locked = true;
        UriUpdate: Label '%1/api/data/v%2/EntityDefinitions(%3)/Attributes', Locked = true;
        Tablecreated: Label 'Table %1 is created in Dataverse';
        Tableupdated: Label 'Table %1 is updated in Dataverse. %2';
        FieldUpdateFFailed: Label 'But some field(s) are failed. Please look in the fields page.';
        DataverseUIField: Record "Dataverse UI Field";
        DataverseUIField2: Record "Dataverse UI Field";
        ErrorField: Boolean;
    begin
        AccessToken := GetAccessToken();

        if DataverseUISetup.Get() then;

        RequestMessage.Method('POST');
        if UpdateTable then begin
            EntityId := GetEntityIdDataverse(DataverseUITable);
            RequestMessage.SetRequestUri(StrSubstNo(UriUpdate, DataverseUISetup."Web API endpoint", DataverseUISetup."Version API", EntityId));
        end else begin
            RequestMessage.SetRequestUri(StrSubstNo(UriCreate, DataverseUISetup."Web API endpoint", DataverseUISetup."Version API"));
        end;

        if UpdateTable then begin
            ErrorField := false;

            DataverseUIField.Reset;
            DataverseUIField.SetRange("BC Table", DataverseUITable."BC Table");
            DataverseUIField.SetRange("Dataverse Field Added", false);

            if DataverseUIField.FindSet() then
                repeat
                    //For each field it must be a seperate call
                    Client.Clear();
                    Client.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
                    Client.DefaultRequestHeaders().Add('Accept', 'application/json');
                    Content.Clear();
                    JsonBody := CreateFieldJson(DataverseUIField."BC Table", DataverseUIField."BC Field");
                    JsonBody.WriteTo(Body);
                    Content.WriteFrom(body);
                    Content.GetHeaders(ContentHeaders);
                    ContentHeaders.Remove('Content-Type');
                    ContentHeaders.Add('Content-Type', 'application/json');
                    RequestMessage.Content(Content);

                    if Client.Send(RequestMessage, ResponseMessage) then begin
                        if ResponseMessage.HttpStatusCode = 204 then begin
                            DataverseUIField2.Get(DataverseUIField."Mapping Name", DataverseUIField."BC Table", DataverseUIField."BC Field");
                            DataverseUIField2."Dataverse Field Added" := true;
                            DataverseUIField2.Modify(true);
                        end;
                    end else
                        ErrorField := true;

                Until DataverseUIField.Next = 0;

            if ErrorField then
                Message(StrSubstNo(Tableupdated, DataverseUITable."BC Table Caption", FieldUpdateFFailed))
            else
                Message(StrSubstNo(Tableupdated, DataverseUITable."BC Table Caption", ''))

        end else begin
            JsonBody := CreateTableJson(DataverseUITable, DataverseUIField);

            JsonBody.WriteTo(Body);
            Content.WriteFrom(body);
            Content.GetHeaders(ContentHeaders);
            ContentHeaders.Remove('Content-Type');
            ContentHeaders.Add('Content-Type', 'application/json');
            RequestMessage.Content(Content);

            Client.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
            Client.DefaultRequestHeaders().Add('Accept', 'application/json');

            if Client.Send(RequestMessage, ResponseMessage) then begin
                if ResponseMessage.HttpStatusCode = 204 then begin
                    if DataverseUITable."Table Name Dataverse" = '' then begin
                        DataverseUITable."Table Name Dataverse" := text.LowerCase(StrSubstNo('%1_%2',
                DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(DataverseUITable."BC Table Caption")));
                        DataverseUITable.Modify(true);
                    end;
                    DataverseUIField.ModifyAll("Dataverse Field Added", true); //Modify if everything is successfull

                    Message(StrSubstNo(tablecreated, DataverseUITable."BC Table Caption"));
                end;
            end;
        end;
    end;

    internal procedure GetEntityIdDataverse(DataverseUITable: Record "Dataverse UI Table"): Text
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        JsonResponse: JsonObject;
        TextResponse: Text;
        JsonEnityIdToken: JsonToken;
        [NonDebuggable]
        AccessToken: Text;
        DataverseUISetup: Record "Dataverse UI Setup";
        Uri: Label '%1/api/data/v%2/entities?$filter=logicalname%20eq%20''%3''&$select=entityid', Locked = true;
        TableNotFound: Label 'Dataverse table with name %1 is not found.';
        EnitiyLabelNotFound: Label 'Entitylabel in response is not found.';
    begin
        AccessToken := GetAccessToken();

        if DataverseUISetup.Get() then;

        //Get entityID
        RequestMessage.Method('GET');
        RequestMessage.SetRequestUri(StrSubstNo(uri, DataverseUISetup."Web API endpoint", DataverseUISetup."Version API", DataverseUITable."Table Name Dataverse"));
        Client.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
        Client.DefaultRequestHeaders().Add('Accept', 'application/json');
        if Client.Send(RequestMessage, ResponseMessage) then begin
            if ResponseMessage.HttpStatusCode = 200 then begin
                Content := ResponseMessage.Content;
                Content.ReadAs(TextResponse);
                JsonResponse.ReadFrom(TextResponse);
                if JsonResponse.SelectToken('$.value[0].entityid', JsonEnityIdToken) then
                    exit(JsonEnityIdToken.AsValue().AsText())
                else
                    Message(EnitiyLabelNotFound);
            end else begin
                Message(StrSubstNo(TableNotFound, DataverseUITable."Table Name Dataverse"));
            end;
        end;
    end;

    [NonDebuggable]
    local procedure GetAccessToken(): Text
    var
        [NonDebuggable]
        AccessToken: Text;
        DataverseUISetup: Record "Dataverse UI Setup";
        Uri: Label 'https://login.microsoftonline.com/%1/oauth2/token', Locked = true;
        Scope: List of [Text];
        Oauth2: Codeunit OAuth2;
        RedirectUrl: Text;
    begin
        if DataverseUISetup.Get() then;

        Oauth2.GetDefaultRedirectURL(RedirectURL);
        Scope.Add(DataverseUISetup."Web API endpoint" + '/.default');

        Oauth2.AcquireTokenWithClientCredentials(DataverseUISetup."Client ID",
                                            DataverseUISetup.GetClientSecret(),
                                            StrSubstNo(uri, DataverseUISetup."Tenant ID") + '?resource=' + DataverseUISetup."Web API endpoint",
                                            RedirectURL,
                                            Scope,
                                            AccessToken

        );
        exit(AccessToken);
    end;

    local procedure CreateTableJson(DataverseUITable: Record "Dataverse UI Table"; var DataverseUIField: Record "Dataverse UI Field"): JsonObject
    var
        TableJson: JsonObject;
        JArrProperty: JsonObject;
        JArrLocalizedLabels: JsonArray;
        JAObjLocalizedLabels: JsonObject;
        JsonField: JsonObject;
        JArrFields: JsonArray;
        DataverseUISetup: Record "Dataverse UI Setup";
    begin
        if DataverseUISetup.Get() then;

        //Global Properties
        TableJson.Add('@odata.typ', 'Microsoft.Dynamics.CRM.EntityMetadata');
        TableJson.Add('HasActivities', 'false');
        TableJson.Add('HasNotes', 'false');
        TableJson.Add('IsActivity', 'false');
        TableJson.Add('OwnershipType', 'UserOwned');
        TableJson.Add('SchemaName', StrSubstNo('%1_%2',
            DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(DataverseUITable."BC Table Caption")));

        //Description of the table
        JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
        JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
        JAObjLocalizedLabels.Add('Label', StrSubstNo('An entity to store information about %1', DataverseUITable."BC Table Caption"));
        JAObjLocalizedLabels.Add('LanguageCode', 1033);
        JArrLocalizedLabels.Add(JAObjLocalizedLabels);
        JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
        TableJson.Add('Description', JArrProperty);

        Clear(JArrProperty);
        Clear(JAObjLocalizedLabels);
        Clear(JArrLocalizedLabels);
        //DisplayCollectionName of the table
        JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
        JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
        JAObjLocalizedLabels.Add('Label', StrSubstNo('%1s', DataverseUITable."BC Table Caption"));
        JAObjLocalizedLabels.Add('LanguageCode', 1033);
        JArrLocalizedLabels.Add(JAObjLocalizedLabels);
        JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
        TableJson.Add('DisplayCollectionName', JArrProperty);

        Clear(JArrProperty);
        Clear(JAObjLocalizedLabels);
        Clear(JArrLocalizedLabels);
        //DisplayName of the table
        JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
        JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
        JAObjLocalizedLabels.Add('Label', DataverseUITable."BC Table Caption");
        JAObjLocalizedLabels.Add('LanguageCode', 1033);
        JArrLocalizedLabels.Add(JAObjLocalizedLabels);
        JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
        TableJson.Add('DisplayName', JArrProperty);

        //Add fields
        Clear(JArrFields);

        if DataverseUIField.FindSet() then
            repeat
                Clear(JsonField);
                JsonField := CreateFieldJson(DataverseUIField."BC Table", DataverseUIField."BC Field");
                JArrFields.Add(JsonField);
            Until DataverseUIField.Next = 0;

        TableJson.Add('Attributes', JArrFields);

        exit(TableJson);
    end;

    local procedure CreateFieldJson(lTable: Integer; lField: Integer): JsonObject
    var
        Fld: Record Field;
        FieldJson: JsonObject;
        JArrProperty: JsonObject;
        JArrLocalizedLabels: JsonArray;
        JAObjLocalizedLabels: JsonObject;
        DataverseUISetup: Record "Dataverse UI Setup";
        DataverseUIField: Record "Dataverse UI Field";
    begin
        Fld.SetRange(TableNo, lTable);
        fld.SetRange("No.", lField);
        if Fld.FindFirst() then begin
            //Check if field can be exported
            DataverseUIField.CheckFieldTypeForSync(fld);

            if DataverseUISetup.Get() then;

            Clear(JArrProperty);
            Clear(JArrLocalizedLabels);
            Clear(JAObjLocalizedLabels);

            //General properties
            FieldJson.Add('SchemaName', StrSubstNo('%1_%2', DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(Fld.FieldName)));

            case Fld.Type of
                Fld.Type::Boolean:
                    BooleanJsonField(FieldJson, Fld);
                Fld.Type::Option:
                    OptionJsonField(FieldJson, Fld);
                else
                    JsonField(FieldJson, Fld);
            end;

            if Fld.IsPartOfPrimaryKey then
                FieldJson.Add('IsPrimaryName', 'true');

            Clear(JArrProperty);
            Clear(JAObjLocalizedLabels);
            Clear(JArrLocalizedLabels);
            //Description of the field
            JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', StrSubstNo('Type the %1 of the %2', Fld.FieldName, Fld.TableName));
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JArrLocalizedLabels.Add(JAObjLocalizedLabels);
            JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
            FieldJson.Add('Description', JArrProperty);

            Clear(JArrProperty);
            Clear(JAObjLocalizedLabels);
            Clear(JArrLocalizedLabels);
            //DisplayName of the field
            JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', Fld.FieldName);
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JArrLocalizedLabels.Add(JAObjLocalizedLabels);
            JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
            FieldJson.Add('DisplayName', JArrProperty);

            Clear(JArrProperty);
            //RequiredLevel of the field
            JArrProperty.Add('Value', 'None');
            JArrProperty.Add('CanBeChanged', 'true');
            JArrProperty.Add('ManagedPropertyLogicalName', 'canmodifyrequirementlevelsettings');
            FieldJson.Add('RequiredLevel', JArrProperty);

            exit(FieldJson);
        end;

    end;

    local procedure JsonField(var FieldJson: JsonObject; Fld: Record Field)
    var
        JArrProperty: JsonObject;
        OdataType: Text;
        AttributeType: Text;
        AttributeTypeName: Text;
    begin
        Clear(OdataType);
        Clear(AttributeType);
        Clear(AttributeTypeName);
        Case Fld.Type of
            Fld.Type::Integer:
                begin
                    OdataType := 'Microsoft.Dynamics.CRM.IntegerAttributeMetadata';
                    AttributeType := 'Integer';
                    AttributeTypeName := 'IntegerType';
                    FieldJson.Add('Format', 'None');
                end;
            Fld.Type::BigInteger:
                begin
                    OdataType := 'Microsoft.Dynamics.CRM.BigIntAttributeMetadata';
                    AttributeType := 'BigInt';
                    AttributeTypeName := 'BigIntType';
                end;
            Fld.Type::Decimal:
                begin
                    OdataType := 'Microsoft.Dynamics.CRM.DecimalAttributeMetadata';
                    AttributeType := 'Decimal';
                    AttributeTypeName := 'DecimalType';
                    FieldJson.Add('Precision', 2);
                end;
            Fld.Type::Duration:
                begin
                    OdataType := 'Microsoft.Dynamics.CRM.IntegerAttributeMetadata';
                    AttributeType := 'Integer';
                    AttributeTypeName := 'IntegerType';
                    FieldJson.Add('Format', 'Duration');
                end;
            Fld.Type::DateTime,
            Fld.Type::Date:
                begin
                    OdataType := 'Microsoft.Dynamics.CRM.DateTimeAttributeMetadata';
                    AttributeType := 'DateTime';
                    AttributeTypeName := 'DateTimeType';
                    if fld.Type = fld.Type::Date then
                        FieldJson.Add('Format', 'DateOnly');
                    if fld.Type = fld.Type::DateTime then
                        FieldJson.Add('Format', 'DateAndTime');
                end;
            else begin
                OdataType := 'Microsoft.Dynamics.CRM.StringAttributeMetadata';
                AttributeType := 'String';
                AttributeTypeName := 'StringType';
                FieldJson.Add('MaxLength', Fld.Len);
                Clear(JArrProperty);
                JArrProperty.Add('Value', 'Text');
                FieldJson.Add('FormatName', JArrProperty);
            end;
        end;
        Clear(JArrProperty);
        FieldJson.Add('@odata.type', OdataType);
        FieldJson.Add('AttributeType', AttributeType);
        JArrProperty.Add('Value', AttributeTypeName);
        FieldJson.Add('AttributeTypeName', JArrProperty);
    end;

    local procedure BooleanJsonField(var FieldJson: JsonObject; Fld: Record Field)
    var
        JArrProperty: JsonObject;
        JAObjLocalizedLabels: JsonObject;
        JArrLocalizedLabels: JsonArray;
        JObjLabel: JsonObject;
        JObjOption: JsonObject;
        JObjOptionSet: JsonObject;
    begin
        FieldJson.Add('@odata.type', 'Microsoft.Dynamics.CRM.BooleanAttributeMetadata');
        FieldJson.Add('AttributeType', 'Boolean');
        JArrProperty.Add('Value', 'BooleanType');
        FieldJson.Add('AttributeTypeName', JArrProperty);
        FieldJson.Add('DefaultValue', false);

        Clear(JArrProperty);
        Clear(JAObjLocalizedLabels);
        Clear(JArrLocalizedLabels);
        CLear(JObjLabel);
        //True option
        JObjLabel.Add('Value', 1);
        JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
        JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
        JAObjLocalizedLabels.Add('Label', 'True');
        JAObjLocalizedLabels.Add('LanguageCode', 1033);
        JAObjLocalizedLabels.Add('IsManaged', false);
        JArrLocalizedLabels.Add(JAObjLocalizedLabels);
        JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
        JObjLabel.Add('Label', JArrProperty);
        JObjOption.Add('TrueOption', JObjLabel);

        Clear(JArrProperty);
        Clear(JAObjLocalizedLabels);
        Clear(JArrLocalizedLabels);
        Clear(JObjLabel);
        //False option
        JObjLabel.Add('Value', 0);
        JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
        JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
        JAObjLocalizedLabels.Add('Label', 'False');
        JAObjLocalizedLabels.Add('LanguageCode', 1033);
        JAObjLocalizedLabels.Add('IsManaged', false);
        JArrLocalizedLabels.Add(JAObjLocalizedLabels);
        JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
        JObjLabel.Add('Label', JArrProperty);
        JObjOption.Add('FalseOption', JObjLabel);
        JObjOption.Add('OptionSetType', 'Boolean');

        FieldJson.Add('OptionSet', JObjOption);
    end;

    local procedure OptionJsonField(var FieldJson: JsonObject; Fld: Record Field)
    var
        OptionString: Text;
        OptionStringList: List of [Text];
        JObjLabel: JsonObject;
        JArrProperty: JsonObject;
        JObjOption: JsonArray;
        JObjOptionSet: JsonObject;
        JAObjLocalizedLabels: JsonObject;
        JArrLocalizedLabels: JsonArray;
        JsonNullValue: JsonValue;
    begin
        FieldJson.Add('@odata.type', 'Microsoft.Dynamics.CRM.PicklistAttributeMetadata');
        FieldJson.Add('AttributeType', 'Picklist');
        JArrProperty.Add('Value', 'PicklistType');
        FieldJson.Add('AttributeTypeName', JArrProperty);

        OptionStringList := Fld.OptionString.Split(',');
        foreach OptionString in OptionStringList do begin
            Clear(JArrProperty);
            Clear(JAObjLocalizedLabels);
            Clear(JArrLocalizedLabels);
            CLear(JObjLabel);
            JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
            JsonNullValue.SetValueToNull();
            JObjLabel.Add('Value', JsonNullValue);
            JObjLabel.Add('IsManaged', 'false');
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', OptionString);
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JAObjLocalizedLabels.Add('IsManaged', false);
            JArrLocalizedLabels.Add(JAObjLocalizedLabels);
            JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
            JObjLabel.Add('Label', JArrProperty);
            JObjOption.Add(JObjLabel);
        end;
        JObjOptionSet.Add('IsGlobal', false);
        JObjOptionSet.Add('IsManaged', false);
        JObjOptionSet.Add('Options', JObjOption);
        FieldJson.Add('OptionSet', JObjOptionSet);
    end;

    local procedure MoneyJsonField(var FieldJson: JsonObject; Fld: Record Field; DecimalPlaces: Integer)
    var
        JArrProperty: JsonObject;
    begin
        FieldJson.Add('@odata.type', 'Microsoft.Dynamics.CRM.MoneyAttributeMetadata');
        FieldJson.Add('PrecisionSource', DecimalPlaces);
        FieldJson.Add('AttributeType', 'Money');
        JArrProperty.Add('Value', 'MoneyType');
        FieldJson.Add('AttributeTypeName', JArrProperty);
    end;

    internal procedure GetDataverseCompliantName(Name: Text) Result: Text
    var
        ResultBuilder: TextBuilder;
        Index: Integer;
        Letter: Text;
        AddToResult: Boolean;
        AlphabetsLowerTxt: Label 'abcdefghijklmnopqrstuvwxyz', Locked = true;
        AlphabetsUpperTxt: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', Locked = true;
        NumeralsTxt: Label '1234567890', Locked = true;
    begin
        for Index := 1 to StrLen(Name) do begin
            Letter := CopyStr(Name, Index, 1);
            AddToResult := true;
            if StrPos(AlphabetsLowerTxt, Letter) = 0 then
                if StrPos(AlphabetsUpperTxt, Letter) = 0 then
                    if StrPos(NumeralsTxt, Letter) = 0 then
                        AddToResult := false;
            if AddToResult then
                ResultBuilder.Append(Letter);
        end;
        Result := ResultBuilder.ToText();
    end;
}