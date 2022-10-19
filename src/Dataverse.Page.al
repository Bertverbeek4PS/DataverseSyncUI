page 70102 "CDS List"
{
    PageType = List;
    SourceTable = "Dataverse Temp";
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
                    DataverseTemp: Record "Dataverse Temp";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    DataverseTabled: Record "Dataverse Table";
                    RecRef: RecordRef;
                    MyFieldRef: FieldRef;
                    RecID: RecordId;
                begin
                    CurrPage.GetRecord(DataverseTemp);
                    DataverseTabled.Reset;
                    DataverseTabled.SetRange("BC Table", NAVTableId);
                    if DataverseTabled.FindFirst() then begin
                        RecRef.Open(DataverseTabled."Dataverse Table");
                        MyFieldRef := RecRef.Field(DataverseTabled."Dataverse UID");
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

    local procedure InsertDataverseTempRecords(CRMTableID: Integer; NAVTableId: Integer; var DataverseTemp: Record "Dataverse Temp");
    var
        CDSTable: RecordRef;
        FldRef: FieldRef;
        DataverseFields: Record "Dataverse Field";
        DataverseTable: Record "Dataverse Table";
    begin
        CDSTable.Open(CRMTableID);
        if CDSTable.FindSet() then
            repeat
                DataverseFields.Reset;
                DataverseFields.SetRange("Dataverse Table", CDSTable.Number);
                DataverseFields.SetFilter("Field on CDS Page", '<>%1', 0);
                If DataverseFields.FindSet then
                    repeat
                        InsertValue(DataverseTemp, DataverseFields."Field on CDS Page", CDSTable, DataverseFields."Dataverse Field");
                    Until DataverseFields.Next = 0;
                DataverseTable.Reset;
                DataverseTable.SetRange("Dataverse Table", CRMTableID);
                If DataverseTable.FindFirst then begin
                    DataverseTemp.CRMId := CDSTable.FIELD(DataverseTable."Dataverse UID").Value;
                end;
                DataverseTemp.Insert;
            Until CDSTable.Next = 0;
    end;

    local procedure InsertValue(var DataverseTemp: Record "Dataverse Temp"; Fieldno: integer; CDSTable: RecordRef; CDSFieldNo: Integer);
    begin
        if DataverseTemp.FieldNo(id) = Fieldno then
            DataverseTemp.Id := CDSTable.FIELD(CDSFieldNo).Value;
        if DataverseTemp.FieldNo(Textfield1) = Fieldno then
            DataverseTemp.Textfield1 := CDSTable.FIELD(CDSFieldNo).Value;
        if DataverseTemp.FieldNo(Textfield2) = Fieldno then
            DataverseTemp.Textfield2 := CDSTable.FIELD(CDSFieldNo).Value;
        if DataverseTemp.FieldNo(Textfield3) = Fieldno then
            DataverseTemp.Textfield3 := CDSTable.FIELD(CDSFieldNo).Value;
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