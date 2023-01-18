page 70102 "Dataverse UI List"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    SourceTable = "Dataverse UI Temp Table";
    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field(Textfield1; Rec.Textfield1)
                {
                    ToolTip = 'Specifies the value of the Textfield1 field.';
                }
                field(Textfield2; Rec.Textfield2)
                {
                    ToolTip = 'Specifies the value of the Textfield2 field.';
                }
                field(Textfield3; Rec.Textfield3)
                {
                    ToolTip = 'Specifies the value of the Textfield3 field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateFromCDS)
            {
                Caption = 'Create in Business Central';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the table from the coupled Microsoft Dataverse worker.';

                trigger OnAction()
                var
                    DataverseUITable: Record "Dataverse UI Table";
                    DataverseUITempTable: Record "Dataverse UI Temp Table";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    RecID: RecordId;
                    RecRef: RecordRef;
                    MyFieldRef: FieldRef;
                begin
                    CurrPage.GetRecord(DataverseUITempTable);
                    DataverseUITable.Reset();
                    DataverseUITable.SetRange("BC Table", NAVTableId);
                    if DataverseUITable.FindFirst() then begin
                        RecRef.Open(DataverseUITable."Dataverse Table");
                        MyFieldRef := RecRef.Field(DataverseUITable."Dataverse UID");
                        MyFieldRef.Value := ExternalCRMId;
                        if RecRef.Find('=') then begin
                            RecID := RecRef.RecordId;
                            RecRef.Get(RecID);
                        end;
                    end;

                    CRMIntegrationManagement.CreateNewRecordsFromCRM(RecRef);
                end;
            }
        }
    }

    var
        ExternalCRMId: Guid;
        SavedCRMId: Guid;
        CRMTableID: Integer;
        NAVTableId: Integer;
        IntTableFilter: Text;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    trigger OnOpenPage()
    begin
        InsertDataverseTempRecords(CRMTableID, Rec);
        Rec.SetView(IntTableFilter);

        if Rec.Get(ExternalCRMId) then
            CurrPage.SetRecord(Rec);
    end;

    procedure SetGlobalVar(SetCRMTableID: Integer; SetNAVTableId: Integer; SetSavedCRMId: Guid; SetCRMId: Guid; SetIntTableFilter: Text)
    begin
        CRMTableID := SetCRMTableID;
        NAVTableId := SetNAVTableId;
        SavedCRMId := SetSavedCRMId;
        ExternalCRMId := SetCRMId;
        IntTableFilter := SetIntTableFilter;
    end;

    local procedure InsertDataverseTempRecords(CRMTable: Integer; var DataverseUITempTable: Record "Dataverse UI Temp Table");
    var
        DataverseUIField: Record "Dataverse UI Field";
        DataverseUITable: Record "Dataverse UI Table";
        CDSTableRef: RecordRef;
    begin
        CDSTableRef.Open(CRMTable);
        if CDSTableRef.FindSet() then
            repeat
                DataverseUIField.Reset();
                DataverseUIField.SetRange("Dataverse Table", CDSTableRef.Number);
                DataverseUIField.SetFilter("Field on CDS Page", '<>%1', 0);
                if DataverseUIField.FindSet() then
                    repeat
                        InsertValue(DataverseUITempTable, DataverseUIField."Field on CDS Page", CDSTableRef, DataverseUIField."Dataverse Field");
                    until DataverseUIField.Next() = 0;
                DataverseUITable.Reset();
                DataverseUITable.SetRange("Dataverse Table", CRMTable);
                if DataverseUITable.FindFirst() then
                    DataverseUITempTable.CRMId := CDSTableRef.Field(DataverseUITable."Dataverse UID").Value;
                DataverseUITempTable.Insert();
            until CDSTableRef.Next() = 0;
    end;

    local procedure InsertValue(var DataverseUITempTable: Record "Dataverse UI Temp Table"; Fieldno: Integer; CDSTable: RecordRef; CDSFieldNo: Integer);
    begin
        if DataverseUITempTable.FieldNo(Id) = Fieldno then
            DataverseUITempTable.Id := CDSTable.Field(CDSFieldNo).Value;
        if DataverseUITempTable.FieldNo(Textfield1) = Fieldno then
            DataverseUITempTable.Textfield1 := CDSTable.Field(CDSFieldNo).Value;
        if DataverseUITempTable.FieldNo(Textfield2) = Fieldno then
            DataverseUITempTable.Textfield2 := CDSTable.Field(CDSFieldNo).Value;
        if DataverseUITempTable.FieldNo(Textfield3) = Fieldno then
            DataverseUITempTable.Textfield3 := CDSTable.Field(CDSFieldNo).Value;
    end;
}