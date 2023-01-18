table 70106 "Dataverse UI Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Primary key"; Code[10])
        {
            Caption = 'Primary Key';
            Editable = false;
        }
        field(20; "Tenant ID"; Text[40])
        {
            Caption = 'Tenant Id';
        }
        field(30; "Client ID"; Text[40])
        {
            Caption = 'Client Id';
        }
        field(40; "Web API endpoint"; Text[100])
        {
            Caption = 'Environment URL';
            ObsoleteReason = 'Please use field Server Adress from table CDS Connection Setup';
            ObsoleteState = Pending;
        }
        field(50; "Version API"; Text[5])
        {
            Caption = 'Version';
        }
        field(60; "Prefix Dataverse"; Text[5])
        {
            Caption = 'Prefix Dataverse';
        }
    }

    keys
    {
        key(Key1; "Primary key")
        {
            Clustered = true;
        }
    }
    var
        ClientSecretKeyNameLbl: Label 'dataverse-client-secret', Locked = true;
        [NonDebuggable]
        ClientSecret: Text;

    trigger OnInsert()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry";
        FeatureUptakeStatus: Enum "Feature Uptake Status";
    begin
        FeatureTelemetry.LogUptake('DVUI010', 'Dataverse UI', FeatureUptakeStatus::"Set up");
    end;

    trigger OnDelete()
    var
        FeatureTelemetry: Codeunit "Feature Telemetry";
        FeatureUptakeStatus: Enum "Feature Uptake Status";
    begin
        FeatureTelemetry.LogUptake('DVUI010', 'Dataverse UI', FeatureUptakeStatus::Undiscovered);
    end;

    [NonDebuggable]
    internal procedure GetClientSecret(): Text
    begin
        exit(GetSecret(ClientSecretKeyNameLbl));
    end;

    [NonDebuggable]
    internal procedure SetClientSecret(NewClientSecretValue: Text): Text
    begin
        ClientSecret := NewClientSecretValue;
        SetSecret(ClientSecretKeyNameLbl, NewClientSecretValue);
    end;

    [NonDebuggable]
    local procedure GetSecret(KeyName: Text) Secret: Text
    begin
        if not IsolatedStorage.Contains(KeyName, DataScope::Company) then
            exit('');
        IsolatedStorage.Get(KeyName, DataScope::Company, Secret);
    end;

    [NonDebuggable]
    local procedure SetSecret(KeyName: Text; Secret: Text)
    begin
        if EncryptionEnabled() then begin
            IsolatedStorage.SetEncrypted(KeyName, Secret, DataScope::Company);
            exit;
        end;
        IsolatedStorage.Set(KeyName, Secret, DataScope::Company);
    end;
}