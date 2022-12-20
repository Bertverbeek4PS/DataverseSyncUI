page 70101 "Dataverse UI Fields"
{
    PageType = List;
    SourceTable = "Dataverse UI Field";

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field("Mapping Name"; Rec."Mapping Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("BC Table"; Rec."BC Table")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("BC Table Caption"; Rec."BC Table Caption")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("BC Field"; Rec."BC Field")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Fld: Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Fld.SetRange(TableNo, Rec."BC Table");
                        if FieldSelection.Open(Fld) then begin
                            Rec.Validate("BC Field", Fld."No.");
                        end;
                    end;
                }
                field("BC Field Caption"; Rec."BC Field Caption")
                {
                    ApplicationArea = All;
                }
                field("Dataverse Table"; Rec."Dataverse Table")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Dataverse Table Caption"; Rec."Dataverse Table Caption")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dataverse Field"; Rec."Dataverse Field")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Fld: Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Fld.SetRange(TableNo, Rec."Dataverse Table");
                        if FieldSelection.Open(Fld) then begin
                            Rec.Validate("Dataverse Field", Fld."No.");
                        end;
                    end;
                }
                field("Dataverse Field Caption"; Rec."Dataverse Field Caption")
                {
                    ApplicationArea = All;
                }
                field("Sync Direction"; Rec."Sync Direction")
                {
                    ApplicationArea = All;
                }
                field("Const Value"; Rec."Const Value")
                {
                    ApplicationArea = All;
                }
                field("Validate Field"; Rec."Validate Field")
                {
                    ApplicationArea = All;
                }
                field("Validate Integr Table Field"; Rec."Validate Integr Table Field")
                {
                    ApplicationArea = All;
                }
                field("Show Field on Page"; Rec."Field on CDS Page")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record Field;
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, Database::"Dataverse UI Temp Table");
                        Field.SetFilter("No.", '<>1&..1999999999');
                        if FieldSelection.Open(Field) then begin
                            Rec."Field on CDS Page" := Field."No.";
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SelectAll)
            {
                Caption = 'Enable all valid fields';
                ApplicationArea = All;
                ToolTip = 'Enables all fields of the table that can be enabled.';
                Image = Apply;

                trigger OnAction()
                var
                    SomeFieldsCouldNotBeEnabled: Boolean;
                    Fld: Record Field;
                    DataverseUITable: Record "Dataverse UI Table";
                begin
                    if DataverseUITable.Get(Rec."Mapping Name") then;

                    Fld.SetRange(TableNo, Rec."BC Table");
                    Fld.SetFilter(Type, '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12',
                    Fld.Type::BigInteger,
                    Fld.Type::Boolean,
                    Fld.Type::Code,
                    Fld.Type::Date,
                    Fld.Type::DateFormula,
                    Fld.Type::DateTime,
                    Fld.Type::Decimal,
                    Fld.Type::Duration,
                    Fld.Type::Guid,
                    Fld.Type::Integer,
                    Fld.Type::Option,
                    Fld.Type::Text
                    );
                    Fld.SetFilter("No.", '<%1', 2000000000);
                    if Fld.FindSet() then
                        repeat
                            if Rec.CanFieldBeInserted(Fld) then begin
                                Rec.Init;
                                Rec."BC Field" := Fld."No.";
                                Rec."Dataverse Table" := DataverseUITable."Dataverse Table";
                                Rec.Insert(true);
                            end else
                                SomeFieldsCouldNotBeEnabled := true;
                        until Fld.Next() = 0;
                    if SomeFieldsCouldNotBeEnabled then
                        Message(SomeFieldsCouldNotBeEnabledMsg);
                end;
            }
            action(MapFields)
            {
                Caption = 'Map Dataverse Fields';
                ApplicationArea = All;
                ToolTip = 'Map and insert Dataverse Fields.';
                Image = Apply;

                trigger OnAction()
                begin
                    Rec.MapFields(Rec."Mapping Name", Rec."BC Table", Rec."Dataverse Table");
                end;
            }
        }
    }
    var
        SomeFieldsCouldNotBeEnabledMsg: Label 'One or more fields could not be inserted.';
}