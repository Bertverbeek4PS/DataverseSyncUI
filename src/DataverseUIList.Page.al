page 70102 "Dataverse UI List"
{
    PageType = List;
    SourceTable = "Dataverse UI Temp Table";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field(Id; rec.Id)
                {
                }
                field(Textfield1; rec.Textfield1)
                {
                }
                field(Textfield2; rec.Textfield2)
                {
                }
                field(Textfield3; rec.Textfield3)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateFromCDS)
            {
                ApplicationArea = All;
                Caption = 'Create in Business Central';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the table from the coupled Microsoft Dataverse worker.';

                trigger OnAction()
                var
                    DataverseUITempTable: Record "Dataverse UI Temp Table";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    DataverseUITable: Record "Dataverse UI Table";
                    RecRef: RecordRef;
                    MyFieldRef: FieldRef;
                    RecID: RecordId;
                begin
                    CurrPage.GetRecord(DataverseUITempTable);
                    DataverseUITable.Reset;
                    DataverseUITable.SetRange("BC Table", NAVTableId);
                    if DataverseUITable.FindFirst() then begin
                        RecRef.Open(DataverseUITable."Dataverse Table");
                        MyFieldRef := RecRef.Field(DataverseUITable."Dataverse UID");
                        MyFieldRef.Value := gCRMId;
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
        CRMTableID: Integer;
        NAVTableId: Integer;
        SavedCRMId: Guid;
        gCRMId: Guid;
        IntTableFilter: Text;

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    trigger OnOpenPage()
    begin
        InsertDataverseTempRecords(CRMTableID, NAVTableId, Rec);
        Rec.SetView(IntTableFilter);

        if rec.Get(gCRMId) then
            CurrPage.SetRecord(rec);
    end;

    local procedure InsertDataverseTempRecords(CRMTableID: Integer; NAVTableId: Integer; var DataverseUITempTable: Record "Dataverse UI Temp Table");
    var
        CDSTable: RecordRef;
        FldRef: FieldRef;
        DataverseUIField: Record "Dataverse UI Field";
        DataverseUITable: Record "Dataverse UI Table";
    begin
        CDSTable.Open(CRMTableID);
        if CDSTable.FindSet() then
            repeat
                DataverseUIField.Reset;
                DataverseUIField.SetRange("Dataverse Table", CDSTable.Number);
                DataverseUIField.SetFilter("Field on CDS Page", '<>%1', 0);
                If DataverseUIField.FindSet then
                    repeat
                        InsertValue(DataverseUITempTable, DataverseUIField."Field on CDS Page", CDSTable, DataverseUIField."Dataverse Field");
                    Until DataverseUIField.Next = 0;
                DataverseUITable.Reset;
                DataverseUITable.SetRange("Dataverse Table", CRMTableID);
                If DataverseUITable.FindFirst then begin
                    DataverseUITempTable.CRMId := CDSTable.FIELD(DataverseUITable."Dataverse UID").Value;
                end;
                DataverseUITempTable.Insert;
            Until CDSTable.Next = 0;
    end;

    local procedure InsertValue(var DataverseUITempTable: Record "Dataverse UI Temp Table"; Fieldno: integer; CDSTable: RecordRef; CDSFieldNo: Integer);
    begin
        if DataverseUITempTable.FieldNo(id) = Fieldno then
            DataverseUITempTable.Id := CDSTable.FIELD(CDSFieldNo).Value;
        if DataverseUITempTable.FieldNo(Textfield1) = Fieldno then
            DataverseUITempTable.Textfield1 := CDSTable.FIELD(CDSFieldNo).Value;
        if DataverseUITempTable.FieldNo(Textfield2) = Fieldno then
            DataverseUITempTable.Textfield2 := CDSTable.FIELD(CDSFieldNo).Value;
        if DataverseUITempTable.FieldNo(Textfield3) = Fieldno then
            DataverseUITempTable.Textfield3 := CDSTable.FIELD(CDSFieldNo).Value;
    end;


    procedure SetGlobalVar(lCRMTableID: Integer; lNAVTableId: Integer; lSavedCRMId: Guid; lCRMId: Guid; lIntTableFilter: Text)
    begin
        CRMTableID := lCRMTableID;
        NAVTableId := lNAVTableId;
        SavedCRMId := lSavedCRMId;
        gCRMId := lCRMId;
        IntTableFilter := lIntTableFilter;
    end;
}