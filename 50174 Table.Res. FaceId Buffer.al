table 50174 "Resource FaceId Buffer"
{

    fields
    {
        field(1; "Resource No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; FaceId; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Resource No.")
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