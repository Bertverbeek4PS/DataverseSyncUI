codeunit 70103 "Dataverse UI BC Proxy Gen."
{
    internal procedure CreateBCProxyTable(DataverseUITable: Record "Dataverse UI Table")
    var
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        TextBld: TextBuilder;
        RespMsgHttpResponseMessage: HttpResponseMessage;
        ContentHttpContent: HttpContent;
        DataverseTable: Text;
        FileName: Text;
    begin
        RespMsgHttpResponseMessage := SendHttpRequest(DataverseUITable."Table Name Dataverse", '', '');
        ContentHttpContent := RespMsgHttpResponseMessage.Content();
        ContentHttpContent.ReadAs(DataverseTable);
        TempBlob.CreateOutStream(OutStr);

        CreateGeneralProperties(TextBld, DataverseUITable);
        CreateFields(TextBld, DataverseTable, DataverseUITable);
        CreateKeys(TextBld);
        CreateFieldGroups(TextBld);

        TextBld.AppendLine('}'); //Closing bracket

        //Fixme. Creating table extension if table already excists.

        OutStr.Write(TextBld.ToText());
        FileName := DataverseUITable."Table Name Dataverse" + '.Table.al';
        TempBlob.CreateInStream(InStr);
        DownloadFromStream(InStr, '', '', '', FileName);

    end;

    local procedure CreateGeneralProperties(var TextBld: TextBuilder; DataverseUITable: Record "Dataverse UI Table")
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        //Look if there is already a CRM table for it.
        AllObjWithCaption.Reset();
        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        AllObjWithCaption.SetRange("Object Subtype", 'CRM');
        AllObjWithCaption.SetFilter("Object Name", '%1', '@*' + DataverseUITable."Table Name Dataverse" + '*');
        if AllObjWithCaption.FindFirst() then
            TextBld.AppendLine('tableextension 50000 "CDS ' + DataverseUITable."Table Name Dataverse" + ' Ext" extends "' + AllObjWithCaption."Object Name" + '"')
        else begin
            TextBld.AppendLine('table 50000 "CDS ' + DataverseUITable."Table Name Dataverse" + '"');
            TextBld.AppendLine('{');
            TextBld.AppendLine('ExternalName = ''' + DataverseUITable."Table Name Dataverse" + ''';');
            TextBld.AppendLine('TableType = CDS;');
        end;

        TextBld.AppendLine('Description = ''An entity to store information about ' + DataverseUITable."BC Table Caption" + ''';');
    end;

    local procedure CreateFields(var TextBld: TextBuilder; DataverseTable: Text; DataverseUITable: Record "Dataverse UI Table")
    var
        AllObjWithCaption: Record AllObjWithCaption;
        CRMField: Record Field;
        JsonTokenList: List of [JsonToken];
        JsonTkn: JsonToken;
        JsonTknClmNumber: JsonToken;
        JsonTknDataType: JsonToken;
        JsonTknDateTimeBehavior: JsonToken;
        JsonTknLogicalName: JsonToken;
        JsonTknFormat: JsonToken;
        JsonTknAttributeTypeName: JsonToken;
        JsonTknAttributeType: JsonToken;
        JsonTknAttributeOf: JsonToken;
        JsonTknMaxLength: JsonToken;
        JsonTknDescription: JsonToken;
        JsonTknDisplayName: JsonToken;
        JsonTknImeMode: JsonToken;
        JsonTknTarget: JsonToken;
        JsonTknTarget1: JsonToken;
        JsonTknPrimaryId: JsonToken;
        JsonTknPrimaryName: JsonToken;
        JsonValAttributeOf: JsonValue;
        JsonObj: JsonObject;
        JsonArr: JsonArray;
        JsonArrTarget: JsonArray;
        i: Integer;
        BCField: Text;
        MaxLength: Text;
        SkipField: Boolean;
        TableRelation: Boolean;
    begin
        TextBld.AppendLine('fields');
        TextBld.AppendLine('{');
        JsonObj.ReadFrom(DataverseTable);
        JsonTokenList := JsonObj.Values();
        JsonArr := JsonTokenList.Get(2).AsArray();

        // Format of a field
        // field(1; fps_EmployeeId; GUID)
        // {
        //     ExternalName = 'fps_employeeid';
        //     ExternalType = 'Uniqueidentifier';
        //     ExternalAccess = Insert;
        //     Description = 'Unieke id van entiteitsexemplaren';
        //     Caption = 'Employee';
        // }
        for i := 0 to (JsonArr.Count - 1) do begin
            Clear(JsonTknClmNumber);
            Clear(JsonTknLogicalName);
            Clear(JsonTknFormat);
            Clear(JsonTknAttributeTypeName);
            Clear(JsonTknAttributeType);
            Clear(JsonTknAttributeOf);
            Clear(JsonTknMaxLength);
            Clear(JsonTknDescription);
            Clear(JsonTknDisplayName);
            Clear(JsonTknImeMode);
            Clear(JsonTknTarget);
            Clear(JsonTknPrimaryId);
            Clear(JsonTknPrimaryName);
            Clear(JsonTknDateTimeBehavior);
            JsonArr.Get(i, JsonTkn);
            JsonTkn.SelectToken('AttributeTypeName.Value', JsonTknAttributeTypeName);
            JsonTkn.SelectToken('AttributeOf', JsonTknAttributeOf);
            JsonValAttributeOf := JsonTknAttributeOf.AsValue();

            if JsonTknAttributeTypeName.AsValue().AsText() = 'DateTimeType' then
                JsonTkn.SelectToken('DateTimeBehavior.Value', JsonTknDateTimeBehavior);

            //Skip fields
            SkipField := false;
            TableRelation := false;
            if JsonTknAttributeTypeName.AsValue().AsText() = 'VirtualType' then
                SkipField := true;
            if JsonTknAttributeTypeName.AsValue().AsText() = 'EntityNameType' then
                SkipField := true;
            if JsonTknAttributeTypeName.AsValue().AsText() = 'DateTimeType' then
                if JsonTknDateTimeBehavior.AsValue().AsText() = 'TimeZoneIndependent' then
                    SkipField := true;
            if not JsonValAttributeOf.IsNull then
                SkipField := true;

            if JsonTknAttributeTypeName.AsValue().AsText() = 'LookupType' then begin
                JsonTkn.SelectToken('Targets', JsonTknTarget);
                JsonArrTarget := JsonTknTarget.AsArray();
                JsonArrTarget.Get(0, JsonTknTarget1); //Always select the first in the array
                AllObjWithCaption.Reset();
                AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
                AllObjWithCaption.SetRange("Object Subtype", 'CRM');
                AllObjWithCaption.SetFilter("Object Name", '%1', '@*' + JsonTknTarget1.AsValue().AsText() + '*');
                if AllObjWithCaption.FindFirst() then begin //FIXME how to deal with multiple PK?
                    CRMField.Reset();
                    CRMField.SetRange(TableNo, AllObjWithCaption."Object ID");
                    CRMField.SetRange(IsPartOfPrimaryKey, true);
                    If CRMField.FindFirst() then
                        TableRelation := true;
                end else
                    SkipField := true;
            end;

            if not SkipField then begin

                JsonTkn.SelectToken('ColumnNumber', JsonTknClmNumber);
                JsonTkn.SelectToken('LogicalName', JsonTknLogicalName);

                if JsonTknAttributeTypeName.AsValue().AsText() = 'StringType' then begin
                    JsonTkn.SelectToken('MaxLength', JsonTknMaxLength);
                    MaxLength := JsonTknMaxLength.AsValue().AsText();
                end;

                if JsonTkn.SelectToken('Format', JsonTknFormat) then
                    BCField := ConvertDVFieldtoBCField(JsonTknFormat.AsValue().AsText(), JsonTknAttributeTypeName.AsValue().AsText(), MaxLength)
                else
                    BCField := ConvertDVFieldtoBCField('', JsonTknAttributeTypeName.AsValue().AsText(), MaxLength);

                TextBld.AppendLine('field(' + JsonTknClmNumber.AsValue().AsText() + '; ' + JsonTknLogicalName.AsValue().AsText() + '; ' + BCField + ')');
                TextBld.AppendLine('{');
                TextBld.AppendLine('ExternalName = ''' + JsonTknLogicalName.AsValue().AsText() + ''';');

                JsonTkn.SelectToken('AttributeType', JsonTknAttributeType);
                TextBld.AppendLine('ExternalType = ''' + JsonTknAttributeType.AsValue().AsText() + ''';');

                if JsonTkn.SelectToken('ImeMode', JsonTknImeMode) then
                    case JsonTknImeMode.AsValue().AsText() of
                        'Inactive':
                            TextBld.AppendLine('ExternalAccess = Read;');
                        'Active':
                            TextBld.AppendLine('ExternalAccess = Insert;');
                        'Disabled':
                            TextBld.AppendLine('ExternalAccess = Read;');
                    end;

                JsonTkn.SelectToken('Description.LocalizedLabels', JsonTknDescription);
                TextBld.AppendLine('Description = ''' + GetLocalizedLabelsValue(JsonTknDescription, '1033', 'Label') + ''';');

                JsonTkn.SelectToken('DisplayName.LocalizedLabels', JsonTknDisplayName);
                TextBld.AppendLine('Caption = ''' + GetLocalizedLabelsValue(JsonTknDisplayName, '1033', 'Label') + ''';');

                //Fields for option
                if BCField = 'Option' then begin
                    clear(JsonTknDataType);
                    JsonTkn.SelectToken('[''@odata.type'']', JsonTknDataType);
                    AddOptionProperties(TextBld, JsonTknLogicalName.AsValue().AsText(), DataverseUITable, DelChr(JsonTknDataType.AsValue().AsText(), '=', '#'));
                end;

                //Fields for Lookup
                //TableRelation = "CRM Systemuser".SystemUserId;
                if JsonTknAttributeTypeName.AsValue().AsText() = 'LookupType' then
                    if TableRelation then
                        TextBld.AppendLine('TableRelation = "' + AllObjWithCaption."Object Name" + '"."' + CRMField.FieldName + '";');

                TextBld.AppendLine('}');

                //Keys
                JsonTkn.SelectToken('IsPrimaryId', JsonTknPrimaryId);
                JsonTkn.SelectToken('IsPrimaryName', JsonTknPrimaryName);
                if JsonTknPrimaryId.AsValue().AsText() = 'true' then
                    PrimaryId := JsonTknLogicalName.AsValue().AsText();
                if JsonTknPrimaryName.AsValue().AsText() = 'true' then
                    PrimaryName := JsonTknLogicalName.AsValue().AsText();
            end;
        end;

        TextBld.AppendLine('}');
    end;

    local procedure CreateKeys(var TextBld: TextBuilder)
    begin
        //format of keys
        // keys
        // {
        //     key(PK; fps_EmployeeId)
        //     {
        //         Clustered = true;
        //     }
        //     key(Name; fps_No)
        //     {
        //     }
        // }

        TextBld.AppendLine('keys');
        TextBld.AppendLine('{');
        TextBld.AppendLine('key(PK; ' + PrimaryId + ')');
        TextBld.AppendLine('{');
        TextBld.AppendLine('Clustered = true;');
        TextBld.AppendLine('}');
        TextBld.AppendLine('key(Name; ' + PrimaryName + ')');
        TextBld.AppendLine('{');
        TextBld.AppendLine('}');
        TextBld.AppendLine('}');
    end;

    local procedure CreateFieldGroups(var TextBld: TextBuilder)
    begin
        // format of fieldgroups
        // fieldgroups
        // {
        //     fieldgroup(DropDown; fps_No)
        //     {
        //     }
        // }
        TextBld.AppendLine('fieldgroups');
        TextBld.AppendLine('{');
        TextBld.AppendLine('fieldgroup(Dropdown; ' + PrimaryName + ')');
        TextBld.AppendLine('{');
        TextBld.AppendLine('}');
        TextBld.AppendLine('}');
    end;

    local procedure ConvertDVFieldtoBCField(Format: Text; AttributeTypeName: Text; MaxLength: Text): Text
    begin
        //https://github.com/MicrosoftDocs/powerapps-docs/blob/main/powerapps-docs/developer/data-platform/entity-attribute-metadata.md
        case AttributeTypeName of
            'BooleanType':
                exit('Boolean');
            'PicklistType':
                exit('Option');
            'DateTimeType':
                if Format = 'DateEndTime' then
                    exit('Datetime')
                else
                    exit('Date');
            'BigIntType':
                exit('BigInteger');
            'DecimalType':
                exit('Decimal');
            'IntegerType':
                if Format = 'Duration' then
                    exit('Duration')
                else
                    exit('Integer');
            'StringType':
                exit('Text[' + MaxLength + ']');
            'OwnerType':
                exit('GUID');
            'StatusType':
                exit('Option');
            'UniqueidentifierType':
                exit('GUID');
            'StateType':
                exit('Option');
            'LookupType':
                exit('GUID'); //FIXME is this always GUID??
        end;

    end;

    local procedure AddOptionProperties(TextBld: TextBuilder; LogicalName: Text; DataverseUITable: Record "Dataverse UI Table"; OdataType: Text)
    var
        RespMsgHttpResponseMessage: HttpResponseMessage;
        ContentHttpContent: HttpContent;
        JsonObj: JsonObject;
        JsonTkn: JsonToken;
        JsonTknValue: JsonToken;
        JsonTknLocalizedLabels: JsonToken;
        JsonArr: JsonArray;
        i: Integer;
        DataverseOptionField: Text;
        OptionMembersTxt: Text;
        OptionOrdinalValuesTxt: Text;
    begin
        // Format of the Boolean properties
        // InitValue = " ";
        // OptionMembers = " ",Active,Inactive,Terminated;
        // OptionOrdinalValues = -1, 100000000, 100000001, 100000002;

        RespMsgHttpResponseMessage := SendHttpRequest(DataverseUITable."Table Name Dataverse", LogicalName, OdataType);
        ContentHttpContent := RespMsgHttpResponseMessage.Content();
        ContentHttpContent.ReadAs(DataverseOptionField);
        JsonObj.ReadFrom(DataverseOptionField);
        if JsonObj.Get('OptionSet', JsonTkn) then begin
            Clear(JsonObj);
            JsonObj := JsonTkn.AsObject();
            Clear(JsonTkn);
            if JsonObj.Get('Options', JsonTkn) then begin
                JsonArr := JsonTkn.AsArray();

                OptionMembersTxt := '" "';
                OptionOrdinalValuesTxt := '-1';
                for i := 0 to (JsonArr.Count - 1) do begin
                    Clear(JsonTkn);
                    JsonArr.Get(i, JsonTkn);
                    JsonTkn.SelectToken('Value', JsonTknValue);
                    OptionOrdinalValuesTxt := OptionOrdinalValuesTxt + ', ' + JsonTknValue.AsValue().AsText();

                    JsonTkn.SelectToken('Label.LocalizedLabels', JsonTknLocalizedLabels);
                    if GetLocalizedLabelsValue(JsonTknLocalizedLabels, '1033', 'Label') = ' ' then
                        OptionMembersTxt := OptionMembersTxt + ', ' + GetLocalizedLabelsValue(JsonTknLocalizedLabels, '1033', 'Label')
                    else
                        OptionMembersTxt := OptionMembersTxt + ', "' + GetLocalizedLabelsValue(JsonTknLocalizedLabels, '1033', 'Label') + '"';
                end;

                TextBld.AppendLine('InitValue = " ";');
                TextBld.AppendLine('OptionMembers = ' + OptionMembersTxt + ';');
                TextBld.AppendLine('OptionOrdinalValues = ' + OptionOrdinalValuesTxt + ';');
            end;
        end;
    end;

    local procedure GetLocalizedLabelsValue(JsonTkn: JsonToken; LanguageCode: Text; FieldTxt: Text): Text
    var
        JsonArr: JsonArray;
        JsonTknLabels: JsonToken;
        JsonTknField: JsonToken;
        i: Integer;
    begin
        JsonArr := JsonTkn.AsArray();
        for i := 0 to (JsonArr.Count - 1) do begin
            JsonArr.Get(i, JsonTkn);
            JsonTkn.SelectToken('LanguageCode', JsonTknLabels);
            if JsonTknLabels.AsValue().AsText() = LanguageCode then begin
                JsonTkn.SelectToken(FieldTxt, JsonTknField);
                exit(DELCHR(JsonTknField.AsValue().AsText(), '=', '''|"'));
            end else begin
                JsonTkn.SelectToken(FieldTxt, JsonTknField);
                exit(DELCHR(JsonTknField.AsValue().AsText(), '=', '''|"'));
            end;
        end;
    end;

    local procedure SendHttpRequest(EntityId: Text; LogicalName: Text; OdataType: Text): HttpResponseMessage
    var
        CDSConnectionSetup: Record "CDS Connection Setup";
        DataverseUISetup: Record "Dataverse UI Setup";
        DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
        ClientHttpClient: HttpClient;
        RqMsgHttpRequestMessage: HttpRequestMessage;
        RespMsgHttpResponseMessage: HttpResponseMessage;
        UriAttributesLbl: Label '%1/api/data/v%2/EntityDefinitions(LogicalName=''%3'')/Attributes', Locked = true;
        UriPicklistLbl: Label '%1/api/data/v%2/EntityDefinitions(LogicalName=''%3'')/Attributes(LogicalName=''%4'')/%5?$select=LogicalName&$expand=OptionSet,GlobalOptionSet', Locked = true;
        AuthorizationLbl: Label 'Bearer %1', comment = '%1 = Authorization token';
        [NonDebuggable]
        AccessToken: Text;
    begin
        if DataverseUISetup.Get() then;
        if CDSConnectionSetup.Get() then;

        AccessToken := DataverseUIDataverseIntegr.GetAccessToken();

        RqMsgHttpRequestMessage.Method('GET');
        if LogicalName = '' then
            RqMsgHttpRequestMessage.SetRequestUri(StrSubstNo(UriAttributesLbl, CDSConnectionSetup."Server Address", DataverseUISetup."Version API", EntityId))
        else
            RqMsgHttpRequestMessage.SetRequestUri(StrSubstNo(UriPicklistLbl, CDSConnectionSetup."Server Address", DataverseUISetup."Version API", EntityId, LogicalName, OdataType));

        ClientHttpClient.DefaultRequestHeaders().Add('Authorization', StrSubstNo(AuthorizationLbl, AccessToken));
        ClientHttpClient.DefaultRequestHeaders().Add('Accept', 'application/json');

        if ClientHttpClient.Send(RqMsgHttpRequestMessage, RespMsgHttpResponseMessage) then
            exit(RespMsgHttpResponseMessage)
    end;

    var
        PrimaryId: Text;
        PrimaryName: Text;
}