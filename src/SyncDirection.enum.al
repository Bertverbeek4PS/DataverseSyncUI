enum 70100 "Sync Direction"
{
    Extensible = false;

    value(0; Bidirectional)
    {
        Caption = 'Bidirectional';
    }
    value(1; ToIntegrationTable)
    {
        Caption = 'To Integration Table';
    }
    value(2; FromIntegrationTable)
    {
        Caption = 'From Integration Table';
    }
}