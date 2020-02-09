table 50171 "AI Services Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Watson Image Apikey"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Watson Syntax Apikey"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "CloudMersive ApiKey"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Azure vision ApiKey"; Text[50])
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}