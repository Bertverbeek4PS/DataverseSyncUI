codeunit 70101 "Dataverse UI Dataverse Integr."
{
    internal procedure CreateTable(DataverseUITable: Record "Dataverse UI Table")
    var
        DataverseUIField: Record "Dataverse UI Field";
        DataverseUIField2: Record "Dataverse UI Field";
        DataverseUISetup: Record "Dataverse UI Setup";
        PMKey: Record Field;
        ResponseMessageContent: HttpContent;
        FeatureTelemetry: Codeunit "Feature Telemetry";
        ErrorField: Boolean;
        PmKeyTrue: Boolean;
        FeatureUptakeStatus: Enum "Feature Uptake Status";
        ResponseMessage: HttpResponseMessage;
        JsonBody: JsonObject;
        FieldUpdateFFailedLbl: Label 'But some field(s) are failed. Please look in the fields page.';
        TablecreatedLbl: Label 'Table %1 is created in Dataverse', comment = '%1 = BC table';
        TableupdatedLbl: Label 'Table %1 is updated in Dataverse. %2', comment = '%1 = BC table, %2 = Dataverse table';
        FailOnPKErr: Label 'No good Primary Key is selected. Please select also a field of type code or text.';
        Body: Text;
        HttpErrorMessage: Text;
        EntityId: Text;
        DataverseNameLbl: Label '%1_%2', comment = '%1 = Prefix, %2 = Table name';
    begin

        if DataverseUISetup.Get() then;

        DataverseUIField.Reset();
        DataverseUIField.SetRange("BC Table", DataverseUITable."BC Table");
        DataverseUIField.SetRange("Dataverse Field Added", false);

        //Update table in Dataverse
        if DataverseUITable."Dataverse Table" <> 0 then begin
            ErrorField := false;
            EntityId := GetEntityIdDataverse(DataverseUITable);

            if DataverseUIField.FindSet() then
                repeat
                    //For each field it must be a seperate call
                    Clear(ResponseMessage);
                    if DataverseUIField."Dataverse Lookup Field" = 0 then begin
                        JsonBody := CreateFieldJson(DataverseUIField."BC Table", DataverseUIField."BC Field", DataverseUIField);
                        JsonBody.WriteTo(Body);

                        if DataverseUISetup."Debug mode" then begin
                            Message(Body);
                        end;

                        ResponseMessage := SendHttpRequest(Body, EntityId, true, false);
                    end else begin
                        JsonBody := Lookupfield(DataverseUIField);
                        JsonBody.WriteTo(Body);

                        if DataverseUISetup."Debug mode" then begin
                            Message(Body);
                        end;

                        ResponseMessage := SendHttpRequest(Body, EntityId, true, true);
                    end;

                    if ResponseMessage.HttpStatusCode = 204 then begin
                        DataverseUIField2.Get(DataverseUIField."Mapping Name", DataverseUIField."BC Table", DataverseUIField."BC Field");
                        DataverseUIField2."Dataverse Field Added" := true;
                        DataverseUIField2.Modify(true);
                    end else
                        ErrorField := true;
                until DataverseUIField.Next() = 0;

            if ErrorField then begin
                Message(StrSubstNo(TableupdatedLbl, DataverseUITable."BC Table Caption", FieldUpdateFFailedLbl));
                FeatureTelemetry.LogError('DVUI010', 'Dataverse UI', 'Update Dataverse Table', ResponseMessage.ReasonPhrase);
            end else
                Message(StrSubstNo(TableupdatedLbl, DataverseUITable."BC Table Caption", ''))

        end else begin
            //Create new table in Dataverse
            PmKeyTrue := false;
            DataverseUIField2.Reset();
            DataverseUIField2.SetRange("BC Table", DataverseUITable."BC Table");
            DataverseUIField2.SetRange("Primary Key", true);
            if DataverseUIField2.FindSet() then
                repeat
                    PMKey.Get(DataverseUIField2."BC Table", DataverseUIField2."BC Field");
                    if PMKey.Type = PMKey.Type::Text then
                        PmKeyTrue := true;
                    if PMKey.Type = PMKey.Type::Code then
                        PmKeyTrue := true;
                until DataverseUIField2.Next = 0;

            if not PmKeyTrue then
                Error(FailOnPKErr);

            Clear(ResponseMessage);
            DataverseUIField.SetRange("Dataverse Lookup Field", 0);
            JsonBody := CreateTableJson(DataverseUITable, DataverseUIField);
            JsonBody.WriteTo(Body);

            if DataverseUISetup."Debug mode" then begin
                Message(Body);
            end;

            ResponseMessage := SendHttpRequest(Body, '', false, false);

            if ResponseMessage.HttpStatusCode = 204 then begin
                if DataverseUITable."Table Name Dataverse" = '' then begin
                    DataverseUITable."Table Name Dataverse" := CopyStr(LowerCase(StrSubstNo(DataverseNameLbl,
                        DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(DataverseUITable."BC Table Caption"))), 1, 100);
                    DataverseUITable.Modify(true);
                end;
                //Start for each lookup field a request
                DataverseUIField.Reset();
                DataverseUIField.SetRange("BC Table", DataverseUITable."BC Table");
                DataverseUIField.SetFilter("Dataverse Lookup Field", '<>%1', 0);
                if DataverseUIField.FindSet() then
                    repeat
                        Clear(ResponseMessage);
                        Clear(JsonBody);
                        JsonBody := Lookupfield(DataverseUIField);
                        JsonBody.WriteTo(Body);
                        ResponseMessage := SendHttpRequest(Body, EntityId, true, true);

                        if ResponseMessage.HttpStatusCode = 204 then;
                    until DataverseUIField.Next() = 0;

                DataverseUIField.Reset();
                DataverseUIField.SetRange("BC Table", DataverseUITable."BC Table");
                DataverseUIField.ModifyAll("Dataverse Field Added", true); //Modify if everything is successfull

                Message(StrSubstNo(TablecreatedLbl, DataverseUITable."BC Table Caption"));
            end else begin
                Message(ResponseMessage.ReasonPhrase);
                if DataverseUISetup."Debug mode" then begin
                    ResponseMessageContent := ResponseMessage.Content;
                    ResponseMessageContent.ReadAs(HttpErrorMessage);
                    Message(HttpErrorMessage);
                end;
                FeatureTelemetry.LogError('DVUI010', 'Dataverse UI', 'Create Dataverse Table', ResponseMessage.ReasonPhrase);
            end;
        end;

        FeatureTelemetry.LogUptake('DVUI010', 'Dataverse UI', FeatureUptakeStatus::Used);
    end;

    internal procedure GetDataverseCompliantName(Name: Text) Result: Text
    var
        AddToResult: Boolean;
        Index: Integer;
        AlphabetsLowerTxt: Label 'abcdefghijklmnopqrstuvwxyz', Locked = true;
        AlphabetsUpperTxt: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', Locked = true;
        NumeralsTxt: Label '1234567890', Locked = true;
        Letter: Text;
        ResultBuilder: TextBuilder;
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

    local procedure BooleanJsonField(var FieldJson: JsonObject)
    var
        JArrLocalizedLabels: JsonArray;
        JAObjLocalizedLabels: JsonObject;
        JArrProperty: JsonObject;
        JObjLabel: JsonObject;
        JObjOption: JsonObject;
    begin
        FieldJson.Add('@odata.type', 'Microsoft.Dynamics.CRM.BooleanAttributeMetadata');
        FieldJson.Add('AttributeType', 'Boolean');
        JArrProperty.Add('Value', 'BooleanType');
        FieldJson.Add('AttributeTypeName', JArrProperty);
        FieldJson.Add('DefaultValue', false);

        Clear(JArrProperty);
        Clear(JAObjLocalizedLabels);
        Clear(JArrLocalizedLabels);
        Clear(JObjLabel);
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

    local procedure CreateFieldJson(lTable: Integer; lField: Integer; var DataverseUIField1: Record "Dataverse UI Field"): JsonObject
    var
        DataverseUIField: Record "Dataverse UI Field";
        DataverseUISetup: Record "Dataverse UI Setup";
        FieldBC: Record Field;
        JArrLocalizedLabels: JsonArray;
        FieldJson: JsonObject;
        JAObjLocalizedLabels: JsonObject;
        JArrProperty: JsonObject;
        SchemaNameLbl: Label '%1_%2', comment = '%1 = Prefix, %2 = BC Field Name';
        LabelLbl: Label 'Type the %1 of the %2', comment = '%1 field name, %2 = Table name';
    begin
        FieldBC.SetRange(TableNo, lTable);
        FieldBC.SetRange("No.", lField);
        if FieldBC.FindFirst() then begin
            //Check if field can be exported
            DataverseUIField.CheckFieldTypeForSync(FieldBC);

            if DataverseUISetup.Get() then;

            Clear(JArrProperty);
            Clear(JArrLocalizedLabels);
            Clear(JAObjLocalizedLabels);

            //General properties
            FieldJson.Add('SchemaName', StrSubstNo(SchemaNameLbl, DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(FieldBC.FieldName)));

            case FieldBC.Type of
                FieldBC.Type::Boolean:
                    BooleanJsonField(FieldJson);
                FieldBC.Type::Option:
                    OptionJsonField(FieldJson, FieldBC);
                else
                    JsonField(FieldJson, FieldBC);
            end;

            if DataverseUIField1."Primary Key" then
                FieldJson.Add('IsPrimaryName', 'true');

            Clear(JArrProperty);
            Clear(JAObjLocalizedLabels);
            Clear(JArrLocalizedLabels);
            //Description of the field
            JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', StrSubstNo(LabelLbl, FieldBC.FieldName, FieldBC.TableName));
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
            JAObjLocalizedLabels.Add('Label', FieldBC.FieldName);
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

    local procedure CreateTableJson(DataverseUITable: Record "Dataverse UI Table"; var DataverseUIField: Record "Dataverse UI Field"): JsonObject
    var
        DataverseUISetup: Record "Dataverse UI Setup";
        JArrFields: JsonArray;
        JArrLocalizedLabels: JsonArray;
        JAObjLocalizedLabels: JsonObject;
        JArrProperty: JsonObject;
        JsonField: JsonObject;
        TableJson: JsonObject;
        SchemaNameLbl: Label '%1_%2', comment = '%1 = Prefix, %2 = Table name';
        DescriptionLbl: Label 'An entity to store information about %1', comment = '%1 = Table name';
        DisplayCollectionNameLbl: Label '%1s', comment = '%1 = Table name';
    begin
        if DataverseUISetup.Get() then;

        //Global Properties
        TableJson.Add('@odata.typ', 'Microsoft.Dynamics.CRM.EntityMetadata');
        TableJson.Add('HasActivities', 'false');
        TableJson.Add('HasNotes', 'false');
        TableJson.Add('IsActivity', 'false');
        TableJson.Add('OwnershipType', 'UserOwned');
        TableJson.Add('SchemaName', StrSubstNo(SchemaNameLbl,
            DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(DataverseUITable."BC Table Caption")));

        //Description of the table
        JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
        JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
        JAObjLocalizedLabels.Add('Label', StrSubstNo(DescriptionLbl, DataverseUITable."BC Table Caption"));
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
        JAObjLocalizedLabels.Add('Label', StrSubstNo(DisplayCollectionNameLbl, DataverseUITable."BC Table Caption"));
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
                JsonField := CreateFieldJson(DataverseUIField."BC Table", DataverseUIField."BC Field", DataverseUIField);
                JArrFields.Add(JsonField);
            until DataverseUIField.Next() = 0;

        TableJson.Add('Attributes', JArrFields);

        exit(TableJson);
    end;

    [NonDebuggable]
    internal procedure GetAccessToken(): Text
    var
        CDSConnectionSetup: Record "CDS Connection Setup";
        DataverseUISetup: Record "Dataverse UI Setup";
        Oauth2: Codeunit OAuth2;
        UriLbl: Label 'https://login.microsoftonline.com/%1/oauth2/token', Locked = true;
        Scope: List of [Text];
        [NonDebuggable]
        AccessToken: Text;
        RedirectUrl: Text;
    begin
        if DataverseUISetup.Get() then;
        if CDSConnectionSetup.Get() then;

        Oauth2.GetDefaultRedirectURL(RedirectUrl);
        Scope.Add(CDSConnectionSetup."Server Address" + '/.default');

        Oauth2.AcquireTokenWithClientCredentials(DataverseUISetup."Client ID",
                                            DataverseUISetup.GetClientSecret(),
                                            StrSubstNo(UriLbl, DataverseUISetup."Tenant ID") + '?resource=' + CDSConnectionSetup."Server Address",
                                            RedirectUrl,
                                            Scope,
                                            AccessToken

        );
        exit(AccessToken);
    end;

    local procedure GetEntityIdDataverse(DataverseUITable: Record "Dataverse UI Table"): Text
    var
        CDSConnectionSetup: Record "CDS Connection Setup";
        DataverseUISetup: Record "Dataverse UI Setup";
        Client: HttpClient;
        Content: HttpContent;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        JsonResponse: JsonObject;
        JsonEnityIdToken: JsonToken;
        EnitiyLabelNotFoundErr: Label 'Entitylabel in response is not found.';
        TableNotFoundErr: Label 'Dataverse table with name %1 is not found.', comment = '%1 = Dataverse name';
        UriLbl: Label '%1/api/data/v%2/entities?$filter=logicalname%20eq%20''%3''&$select=entityid', Locked = true;
        AuthorizationLbl: Label 'Bearer %1', comment = '%1 = Authorization token';
        [NonDebuggable]
        AccessToken: Text;
        TextResponse: Text;
    begin
        AccessToken := GetAccessToken();

        if DataverseUISetup.Get() then;
        if CDSConnectionSetup.Get() then;

        //Get entityID
        RequestMessage.Method('GET');
        RequestMessage.SetRequestUri(StrSubstNo(UriLbl, CDSConnectionSetup."Server Address", DataverseUISetup."Version API", DataverseUITable."Table Name Dataverse"));
        Client.DefaultRequestHeaders().Add('Authorization', StrSubstNo(AuthorizationLbl, AccessToken));
        Client.DefaultRequestHeaders().Add('Accept', 'application/json');
        if Client.Send(RequestMessage, ResponseMessage) then
            if ResponseMessage.HttpStatusCode = 200 then begin
                Content := ResponseMessage.Content;
                Content.ReadAs(TextResponse);
                JsonResponse.ReadFrom(TextResponse);
                if JsonResponse.SelectToken('$.value[0].entityid', JsonEnityIdToken) then
                    exit(JsonEnityIdToken.AsValue().AsText())
                else
                    Message(EnitiyLabelNotFoundErr);
            end else
                Message(StrSubstNo(TableNotFoundErr, DataverseUITable."Table Name Dataverse"));
    end;

    local procedure JsonField(var FieldJson: JsonObject; Fld: Record Field)
    var
        JArrProperty: JsonObject;
        AttributeType: Text;
        AttributeTypeName: Text;
        OdataType: Text;
    begin
        Clear(OdataType);
        Clear(AttributeType);
        Clear(AttributeTypeName);
        case Fld.Type of
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
                    if Fld.Type = Fld.Type::Date then
                        FieldJson.Add('Format', 'DateOnly');
                    if Fld.Type = Fld.Type::DateTime then
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

    local procedure Lookupfield(var DataverseUIField: Record "Dataverse UI Field"): JsonObject
    var
        DataverseUISetup: Record "Dataverse UI Setup";
        DataverseUITable: Record "Dataverse UI Table";
        Fld: Record Field;
        FldLookUp: Record Field;
        JArrLocalizedLabels: JsonArray;
        JsonArr: JsonArray;
        FieldJson: JsonObject;
        JAObjLocalizedLabels: JsonObject;
        JArrProperty: JsonObject;
        JsonObject1: JsonObject;
        JsonObject2: JsonObject;
        SchemaNameLookupLbl: Label '%1_%2_%3', comment = '%1 = Prefix, %2 = field name, %3 = lookup field name';
        SchemaNameLbl: Label '%1_%2', comment = '%1 = Prefix, %2 = BC Field Name';
        LabelLbl: Label 'Type the %1 of the %2', comment = '%1 = Field Name, %2 = Table Name';
    begin
        Fld.SetRange(TableNo, DataverseUIField."BC Table");
        Fld.SetRange("No.", DataverseUIField."BC Field");
        if Fld.FindFirst() then begin
            DataverseUISetup.Get();
            FldLookUp.Get(DataverseUIField."Dataverse Lookup Table", DataverseUIField."Dataverse Lookup Field");

            FieldJson.Add('SchemaName', StrSubstNo(SchemaNameLookupLbl, DataverseUISetup."Prefix Dataverse", LowerCase(GetDataverseCompliantName(Fld.FieldName)), LowerCase(GetDataverseCompliantName(FldLookUp.FieldName))));
            FieldJson.Add('@odata.type', 'Microsoft.Dynamics.CRM.OneToManyRelationshipMetadata');

            Clear(JsonObject1);
            Clear(JArrProperty);
            Clear(JAObjLocalizedLabels);
            Clear(JArrLocalizedLabels);
            Clear(JsonArr);
            //AssociatedMenuConfiguration
            JsonObject1.Add('Behavior', 'UseCollectionName');
            JsonObject1.Add('Group', 'Details');

            JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', Fld.FieldName);
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JArrLocalizedLabels.Add(JAObjLocalizedLabels);
            JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);
            Clear(JAObjLocalizedLabels);
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', Fld.FieldName);
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JArrProperty.Add('UserLocalizedLabel', JAObjLocalizedLabels);

            JsonObject1.Add('Label', JArrProperty);
            JsonObject1.Add('Order', 10000);

            FieldJson.Add('AssociatedMenuConfiguration', JsonObject1);

            Clear(JsonObject1);
            Clear(JsonObject2);
            //CascadeConfiguration
            JsonObject1.Add('Assign', 'NoCascade');
            JsonObject1.Add('Delete', 'RemoveLink');
            JsonObject1.Add('Merge', 'NoCascade');
            JsonObject1.Add('Reparent', 'NoCascade');
            JsonObject1.Add('Share', 'NoCascade');
            JsonObject1.Add('Unshare', 'NoCascade');
            JsonObject1.Add('Archive', 'RemoveLink');
            FieldJson.Add('CascadeConfiguration', JsonObject1);
            FieldJson.Add('ReferencedAttribute', DataverseUIField."Dataverse Lookup Field Caption");
            FieldJson.Add('ReferencedEntity', DataverseUIField."Dataverse Lookup Table Caption");

            DataverseUITable.Get(DataverseUIField."Mapping Name");
            if DataverseUITable."Table Name Dataverse" <> '' then
                FieldJson.Add('ReferencingEntity', DataverseUITable."Table Name Dataverse")
            else
                FieldJson.Add('ReferencingEntity', StrSubstNo(SchemaNameLbl,
                DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(DataverseUITable."BC Table Caption")));

            Clear(JsonObject1);
            Clear(JsonObject2);
            //Lookup
            JsonObject1.Add('AttributeType', 'Lookup');
            JsonObject1.Add('AttributeTypeName', JsonObject2);
            JsonObject2.Add('Value', 'LookupType');

            Clear(JArrProperty);
            Clear(JAObjLocalizedLabels);
            Clear(JArrLocalizedLabels);
            //Description of the field
            JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', StrSubstNo(LabelLbl, Fld.FieldName, Fld.TableName));
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JArrLocalizedLabels.Add(JAObjLocalizedLabels);
            JArrProperty.Add('LocalizedLabels', JArrLocalizedLabels);

            Clear(JAObjLocalizedLabels);
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', StrSubstNo(LabelLbl, Fld.FieldName, Fld.TableName));
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JArrProperty.Add('UserLocalizedLabel', JAObjLocalizedLabels);
            JsonObject1.Add('Description', JArrProperty);

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
            Clear(JAObjLocalizedLabels);
            JAObjLocalizedLabels.Add('@odata.type', 'Microsoft.Dynamics.CRM.LocalizedLabel');
            JAObjLocalizedLabels.Add('Label', Fld.FieldName);
            JAObjLocalizedLabels.Add('LanguageCode', 1033);
            JArrProperty.Add('UserLocalizedLabel', JAObjLocalizedLabels);
            JsonObject1.Add('DisplayName', JArrProperty);

            Clear(JsonObject2);
            //RequiredLevel of the field
            JsonObject2.Add('Value', 'ApplicationRequired');
            JsonObject2.Add('CanBeChanged', true);
            JsonObject2.Add('ManagedPropertyLogicalName', 'canmodifyrequirementlevelsettings');
            JsonObject1.Add('RequiredLevel', JsonObject2);

            JsonObject1.Add('SchemaName', StrSubstNo(SchemaNameLbl, DataverseUISetup."Prefix Dataverse", GetDataverseCompliantName(Fld.FieldName)));
            JsonObject1.Add('@odata.type', 'Microsoft.Dynamics.CRM.LookupAttributeMetadata');
            FieldJson.Add('Lookup', JsonObject1);

            exit(FieldJson);
        end;
    end;

    local procedure MoneyJsonField(var FieldJson: JsonObject; DecimalPlaces: Integer)
    var
        JArrProperty: JsonObject;
    begin
        FieldJson.Add('@odata.type', 'Microsoft.Dynamics.CRM.MoneyAttributeMetadata');
        FieldJson.Add('PrecisionSource', DecimalPlaces);
        FieldJson.Add('AttributeType', 'Money');
        JArrProperty.Add('Value', 'MoneyType');
        FieldJson.Add('AttributeTypeName', JArrProperty);
    end;

    local procedure OptionJsonField(var FieldJson: JsonObject; Fld: Record Field)
    var
        JArrLocalizedLabels: JsonArray;
        JObjOption: JsonArray;
        JAObjLocalizedLabels: JsonObject;
        JArrProperty: JsonObject;
        JObjLabel: JsonObject;
        JObjOptionSet: JsonObject;
        OptionStringList: List of [Text];
        OptionStringList2: List of [Text];
        OptionString: Text;
        FieldRefValueInt: Integer;
        FldRef: FieldRef;
        RecRef: RecordRef;
    begin
        FieldJson.Add('@odata.type', 'Microsoft.Dynamics.CRM.PicklistAttributeMetadata');
        FieldJson.Add('AttributeType', 'Picklist');
        JArrProperty.Add('Value', 'PicklistType');
        FieldJson.Add('AttributeTypeName', JArrProperty);
        FieldJson.Add('DefaultFormValue', 0);

        OptionStringList2 := Fld.OptionString.Split(',');
        foreach OptionString in OptionStringList2 do begin
            if not OptionStringList.Contains(OptionString) then
                OptionStringList.Add(OptionString);
        end;

        foreach OptionString in OptionStringList do begin
            Clear(JArrProperty);
            Clear(JAObjLocalizedLabels);
            Clear(JArrLocalizedLabels);
            Clear(JObjLabel);
            FieldRefValueInt := -1;
            RecRef.Close();
            RecRef.Open(Fld.TableNo);
            FldRef := RecRef.Field(fld."No.");
            if Evaluate(FldRef, OptionString) then
                FieldRefValueInt := FldRef.Value();

            JArrProperty.Add('@odata.type', 'Microsoft.Dynamics.CRM.Label');
            JObjLabel.Add('Value', FieldRefValueInt);
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

    local procedure SendHttpRequest(Body: Text; EntityId: Text; Update: Boolean; LookupField: Boolean): HttpResponseMessage
    var
        CDSConnectionSetup: Record "CDS Connection Setup";
        DataverseUISetup: Record "Dataverse UI Setup";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        CreateLookupLbl: Label '%1/api/data/v%2/RelationshipDefinitions', Locked = true;
        UriCreateLbl: Label '%1/api/data/v%2/EntityDefinitions', Locked = true;
        UriUpdateLbl: Label '%1/api/data/v%2/EntityDefinitions(%3)/Attributes', Locked = true;
        AuthorizationLbl: Label 'Bearer %1', comment = '%1 = Authorization token';
        [NonDebuggable]
        AccessToken: Text;
    begin
        Clear(RequestMessage);
        Client.Clear();
        Content.Clear();
        ContentHeaders.Clear();
        Clear(ResponseMessage);

        if DataverseUISetup.Get() then;
        if CDSConnectionSetup.Get() then;

        AccessToken := GetAccessToken();

        RequestMessage.Method('POST');
        if Update and not LookupField then
            RequestMessage.SetRequestUri(StrSubstNo(UriUpdateLbl, CDSConnectionSetup."Server Address", DataverseUISetup."Version API", EntityId));
        if not Update and not LookupField then
            RequestMessage.SetRequestUri(StrSubstNo(UriCreateLbl, CDSConnectionSetup."Server Address", DataverseUISetup."Version API"));
        if LookupField then
            RequestMessage.SetRequestUri(StrSubstNo(CreateLookupLbl, CDSConnectionSetup."Server Address", DataverseUISetup."Version API"));

        Client.DefaultRequestHeaders().Add('Authorization', StrSubstNo(AuthorizationLbl, AccessToken));
        Client.DefaultRequestHeaders().Add('Accept', 'application/json');

        Content.WriteFrom(Body);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        RequestMessage.Content(Content);

        if Client.Send(RequestMessage, ResponseMessage) then
            exit(ResponseMessage);
    end;
}