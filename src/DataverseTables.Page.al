page 70100 "Dataverse Tables"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Dataverse Table";

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field("Mapping Name"; rec."Mapping Name")
                {
                    ApplicationArea = All;
                }
                field("BC Table"; rec."BC Table")
                {
                    ApplicationArea = All;
                }
                field("BC Table Caption"; rec."BC Table Caption")
                {
                    ApplicationArea = All;
                }
                field("Dataverse Table"; rec."Dataverse Table")
                {
                    ApplicationArea = All;
                }
                field("Dataverse Table Caption"; rec."Dataverse Table Caption")
                {
                    ApplicationArea = All;
                }
                field("Table Name Dataverse"; rec."Table Name Dataverse")
                {
                    ApplicationArea = All;
                }
                field("Dataverse UID"; rec."Dataverse UID")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, rec."Dataverse Table");
                        if FieldSelection.Open(Field) then begin
                            rec."Dataverse UID" := Field."No.";
                        end;
                    end;
                }
                field("Modified Field"; rec."Modified Field")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, rec."Dataverse Table");
                        if FieldSelection.Open(Field) then begin
                            rec."Modified Field" := Field."No.";
                        end;
                    end;
                }
                field("Sync Only Coupled Records"; rec."Sync Only Coupled Records")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Fields)
            {
                ApplicationArea = All;
                Caption = 'Fields';
                RunObject = Page "Dataverse Fields";
                Image = SelectField;
                RunPageLink = "Mapping Name" = field("Mapping Name"), "BC Table" = field("BC Table"), "Dataverse Table" = field("Dataverse Table");
            }
        }
    }
}