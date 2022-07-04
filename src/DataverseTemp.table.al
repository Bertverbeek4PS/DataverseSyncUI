table 70105 "Dataverse Temp"
{
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; CRMId; GUID)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Id; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Text; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; CRMId)
        {
            Clustered = true;
        }
    }
}