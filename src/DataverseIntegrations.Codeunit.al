codeunit 70100 "Dataverse integrations"
{
    local procedure InsertIntegrationTableMapping(var IntegrationTableMapping: Record "Integration Table Mapping"; MappingName: Code[20]; TableNo: Integer; IntegrationTableNo: Integer; IntegrationTableUIDFieldNo: Integer; IntegrationTableModifiedFieldNo: Integer; TableConfigTemplateCode: Code[10]; IntegrationTableConfigTemplateCode: Code[10]; SynchOnlyCoupledRecords: Boolean; Direction: Option)
    begin
        IntegrationTableMapping.CreateRecord(MappingName, TableNo, IntegrationTableNo, IntegrationTableUIDFieldNo, IntegrationTableModifiedFieldNo, TableConfigTemplateCode, IntegrationTableConfigTemplateCode, SynchOnlyCoupledRecords, Direction, 'CDS');
    end;

    procedure InsertIntegrationFieldMapping(IntegrationTableMappingName: Code[20]; TableFieldNo: Integer; IntegrationTableFieldNo: Integer; SynchDirection: Option; ConstValue: Text; ValidateField: Boolean; ValidateIntegrationTableField: Boolean)
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName, TableFieldNo, IntegrationTableFieldNo, SynchDirection,
            ConstValue, ValidateField, ValidateIntegrationTableField);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CDS Setup Defaults", 'OnAfterResetConfiguration', '', true, true)]
    local procedure HandleOnAfterResetConfiguration(CDSConnectionSetup: Record "CDS Connection Setup")
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        DataverseTables: Record "Dataverse Table";
        DataverseFields: Record "Dataverse Field";
    begin
        //tables
        DataverseTables.Reset;
        if DataverseTables.FindSet then
            repeat
                InsertIntegrationTableMapping(
                    IntegrationTableMapping, DataverseTables."Mapping Name",
                    DataverseTables."BC Table", DataverseTables."Dataverse Table",
                    DataverseTables."Dataverse UID", DataverseTables."Modified Field",
                    '', '', DataverseTables."Sync Only Coupled Records",
                    DataverseTables."Sync Direction".AsInteger());

                //fields
                DataverseFields.Reset;
                DataverseFields.SetRange("Mapping Name", DataverseTables."Mapping Name");
                if DataverseFields.FindSet then
                    repeat
                        InsertIntegrationFieldMapping(
                            DataverseFields."Mapping Name",
                            DataverseFields."BC Field",
                            DataverseFields."Dataverse Field",
                            DataverseFields."Sync Direction".AsInteger(),
                            DataverseFields."Const Value",
                            DataverseFields."Validate Field",
                            DataverseFields."Validate Integr Table Field");
                    until DataverseFields.Next = 0;
            until DataverseTables.Next() = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Integration Management", 'OnBeforeHandleCustomIntegrationTableMapping', '', false, false)]
    local procedure HandleCustomIntegrationTableMappingReset(var IsHandled: Boolean; IntegrationTableMappingName: Code[20])
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        DataverseTables: Record "Dataverse Table";
        DataverseFields: Record "Dataverse Field";
    begin
        DataverseTables.Reset;
        DataverseTables.SetRange("Mapping Name", IntegrationTableMappingName);
        if DataverseTables.FindFirst() then begin
            InsertIntegrationTableMapping(
                IntegrationTableMapping, DataverseTables."Mapping Name",
                DataverseTables."BC Table", DataverseTables."Dataverse Table",
                DataverseTables."Dataverse UID", DataverseTables."Modified Field",
                '', '', DataverseTables."Sync Only Coupled Records",
                DataverseTables."Sync Direction".AsInteger());
            //fields
            DataverseFields.Reset;
            DataverseFields.SetRange("Mapping Name", IntegrationTableMappingName);
            if DataverseFields.FindSet then
                repeat
                    InsertIntegrationFieldMapping(
                        DataverseFields."Mapping Name",
                        DataverseFields."BC Field",
                        DataverseFields."Dataverse Field",
                        DataverseFields."Sync Direction".AsInteger(),
                        DataverseFields."Const Value",
                        DataverseFields."Validate Field",
                        DataverseFields."Validate Integr Table Field");
                until DataverseFields.Next = 0;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnGetCDSTableNo', '', false, false)]
    local procedure HandleOnGetCDSTableNo(BCTableNo: Integer; var CDSTableNo: Integer; var handled: Boolean)
    var
        DataverseTables: Record "Dataverse Table";
    begin
        DataverseTables.Reset;
        if DataverseTables.FindSet then
            repeat
                if BCTableNo = DataverseTables."BC Table" then begin
                    CDSTableNo := DataverseTables."Dataverse Table";
                    handled := true;
                end;
            until DataverseTables.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnAddEntityTableMapping', '', true, true)]
    local procedure HandleOnAddEntityTableMapping(var TempNameValueBuffer: Record "Name/Value Buffer" temporary);
    var
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
        DataverseTables: Record "Dataverse Table";
    begin
        DataverseTables.Reset;
        if DataverseTables.FindSet then
            repeat
                CRMSetupDefaults.AddEntityTableMapping(DataverseTables."Table Name Dataverse", DataverseTables."BC Table", TempNameValueBuffer);
                CRMSetupDefaults.AddEntityTableMapping(DataverseTables."Table Name Dataverse", DataverseTables."Dataverse Table", TempNameValueBuffer);
            until DataverseTables.Next = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lookup CRM Tables", 'OnLookupCRMTables', '', true, true)]
    local procedure HandleOnLookupCRMTables(CRMTableID: Integer; NAVTableId: Integer; SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text; var Handled: Boolean)
    var
        Dataverse: Page "CDS List";
        DataverseTemp: Record "Dataverse Temp";
    begin
        Dataverse.SetGlobalVar(CRMTableID, NAVTableId, SavedCRMId, CRMId, IntTableFilter);

        Dataverse.LookupMode(true);
        if Dataverse.RunModal = ACTION::LookupOK then begin
            Dataverse.GetRecord(DataverseTemp);
            CRMId := DataverseTemp.CRMId;
        end;
    end;
}