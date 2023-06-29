page 70101 "Dataverse UI Fields"
{
    ApplicationArea = All;
    PageType = List;
    SourceTable = "Dataverse UI Field";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(repeaterName)
            {
                field("Mapping Name"; Rec."Mapping Name")
                {
                    Editable = false;
                    ToolTip = 'Is the mapping name that is used in the integration table. If you want to expand an excisting integration table use the same mapping name.';
                    Visible = false;
                }
                field("BC Table"; Rec."BC Table")
                {
                    Editable = false;
                    ToolTip = 'Specifies the BC table that you want to sync.';
                    Visible = false;
                }
                field("BC Table Caption"; Rec."BC Table Caption")
                {
                    ToolTip = 'Caption of the Business Central table.';
                    Visible = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Sets the order of the fields in the integration mapping table.';
                }
                field("Primary Key"; Rec."Primary Key")
                {
                    ToolTip = 'Select the Primary Key of the Dataverse table. At least one field in the Primary Key must be a text field.';
                }
                field("BC Field"; Rec."BC Field")
                {
                    ToolTip = 'Specifies the BC field that you want to sync.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Fld: Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Fld.SetRange(TableNo, Rec."BC Table");
                        Fld.SetRange(ObsoleteState, Fld.ObsoleteState::No);
                        Fld.SetFilter(Type, '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12',
                            Fld.Type::BigInteger,
                            Fld.Type::Boolean,
                            Fld.Type::Code,
                            Fld.Type::Date,
                            Fld.Type::DateFormula,
                            Fld.Type::DateTime,
                            Fld.Type::Decimal,
                            Fld.Type::Duration,
                            Fld.Type::GUID,
                            Fld.Type::Integer,
                            Fld.Type::Option,
                            Fld.Type::Text);
                        if FieldSelection.Open(Fld) then
                            Rec.Validate("BC Field", Fld."No.");
                    end;
                }
                field("BC Field Caption"; Rec."BC Field Caption")
                {
                    ToolTip = 'Caption of the Business Central field.';
                }
                field("Dataverse Table"; Rec."Dataverse Table")
                {
                    Editable = false;
                    ToolTip = 'Specify the Dataverse table that you want to map with the Business Central table.';
                    Visible = false;
                }
                field("Dataverse Table Caption"; Rec."Dataverse Table Caption")
                {
                    ToolTip = 'Caption of the Dataverse table.';
                    Visible = false;
                }
                field("Dataverse Field"; Rec."Dataverse Field")
                {
                    ToolTip = 'Specify the Dataverse field that you want to map with the Business Central table.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Fld: Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Fld.SetRange(TableNo, Rec."Dataverse Table");
                        if FieldSelection.Open(Fld) then
                            if Fld."No." <> 0 then
                                Rec.Validate("Dataverse Field", Fld."No.");
                    end;
                }
                field("Dataverse Field Caption"; Rec."Dataverse Field Caption")
                {
                    ToolTip = 'Caption of the Dataverse field.';
                }
                field("Dataverse Lookup Table"; Rec."Dataverse Lookup Table")
                {
                    ToolTip = 'Specify the Dataverse table that you want to create a lookup to.';
                }
                field("Dataverse Lookup Table Caption"; Rec."Dataverse Lookup Table Caption")
                {
                    ToolTip = 'Caption of the Dataverse lookup table.';
                }
                field("Dataverse Lookup Field"; Rec."Dataverse Lookup Field")
                {
                    ToolTip = 'Specify the Dataverse field that you want to create a lookup to.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Fld: Record "Field";
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Fld.SetRange(TableNo, Rec."Dataverse Lookup Table");
                        if FieldSelection.Open(Fld) then
                            Rec.Validate("Dataverse Lookup Field", Fld."No.");
                    end;
                }
                field("Dataverse Lookup Field Caption"; Rec."Dataverse Lookup Field Caption")
                {
                    ToolTip = 'Caption of the Dataverse lookup field.';
                }
                field("Dataverse Field Added"; Rec."Dataverse Field Added")
                {
                    ToolTip = 'If the field is added in Dataverse this boolean becomes true.';

                    trigger OnValidate()
                    begin
                        if xRec."Dataverse Field Added" = true then
                            if not Confirm(DataverseFieldAddedQst, false) then
                                Rec."Dataverse Field Added" := true;
                    end;
                }
                field("Sync Direction"; Rec."Sync Direction")
                {
                    ToolTip = 'Specify the sync direction of the integration.';
                }
                field("Const Value"; Rec."Const Value")
                {
                    ToolTip = 'Here you can specify a constant value. If you do not want to specify a field.';
                }
                field("Validate Field"; Rec."Validate Field")
                {
                    ToolTip = 'Specify if you want to trigger the validate trigger on the Business Central table when data gets in.';
                }
                field("Validate Integr Table Field"; Rec."Validate Integr Table Field")
                {
                    ToolTip = 'Specify if you want to trigger the validate trigger on the Dataverse table when data gets in.';
                }
                field("Show Field on Page"; Rec."Field on CDS Page")
                {
                    ToolTip = 'Specify which column you want this field in the Dataverse lookup page.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record Field;
                        FieldSelection: Codeunit "Field Selection";
                    begin
                        Field.SetRange(TableNo, Database::"Dataverse UI Temp Table");
                        Field.SetFilter("No.", '<>1&..1999999999');
                        Field.SetRange(ObsoleteState, Field.ObsoleteState::No);
                        if FieldSelection.Open(Field) then
                            Rec."Field on CDS Page" := Field."No.";
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
                Image = Apply;
                ToolTip = 'Enables all fields of the table that can be enabled.';

                trigger OnAction()
                var
                    DataverseUITable: Record "Dataverse UI Table";
                    Fld: Record Field;
                    SomeFieldsCouldNotBeEnabled: Boolean;
                begin
                    if DataverseUITable.Get(Rec."Mapping Name") then;

                    Fld.SetRange(TableNo, Rec."BC Table");
                    Fld.SetRange(ObsoleteState, Fld.ObsoleteState::No);
                    Fld.SetFilter(Type, '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10|%11|%12',
                    Fld.Type::BigInteger,
                    Fld.Type::Boolean,
                    Fld.Type::Code,
                    Fld.Type::Date,
                    Fld.Type::DateFormula,
                    Fld.Type::DateTime,
                    Fld.Type::Decimal,
                    Fld.Type::Duration,
                    Fld.Type::GUID,
                    Fld.Type::Integer,
                    Fld.Type::Option,
                    Fld.Type::Text
                    );
                    Fld.SetFilter("No.", '<%1', 2000000000);
                    if Fld.FindSet() then
                        repeat
                            if Rec.CanFieldBeInserted(Fld) then begin
                                Rec.Init();
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
                Image = Apply;
                ToolTip = 'Map and insert Dataverse Fields.';

                trigger OnAction()
                begin
                    Rec.MapFields(Rec."Mapping Name", Rec."BC Table", Rec."Dataverse Table");
                end;
            }
            action(CreateField)
            {
                Caption = 'Create Fields';
                Image = Insert;
                ToolTip = 'Create the not added field(s) in Dataverse';

                trigger OnAction()
                var
                    DataverseUITable: Record "Dataverse UI Table";
                    DataverseUIDataverseIntegr: Codeunit "Dataverse UI Dataverse Integr.";
                begin
                    if DataverseUITable.Get(Rec."Mapping Name") then;
                    DataverseUIDataverseIntegr.CreateTable(DataverseUITable);
                    CurrPage.Update();
                end;
            }
            action(ValidateFields)
            {
                Caption = 'Validate Fields';
                Image = Apply;
                ToolTip = 'Sets the property validate fields to true.';

                trigger OnAction()
                begin
                    Rec.ModifyAll("Validate Field", true);
                end;
            }
        }
    }
    var
        DataverseFieldAddedQst: Label 'Do you really want to change the setting?';
        SomeFieldsCouldNotBeEnabledMsg: Label 'One or more fields could not be inserted.';
}