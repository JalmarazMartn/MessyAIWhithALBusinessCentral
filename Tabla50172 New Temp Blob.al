table 50172 "New Temp Blob"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PKey; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Blob; Blob)
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(PK; PKey)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}