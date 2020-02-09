table 50170 "Buffer image"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Image; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(3; "Image To Compare"; Blob)
        {
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }

    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }

}