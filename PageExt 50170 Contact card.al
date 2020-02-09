pageextension 50170 "Contact Card Extension" extends "Contact Card"
{
    layout
    {
        addlast(General)
        {
            field(SalutationCode; "Salutation Code")
            {
                ApplicationArea = All;
            }
        }
    }


    var
        myInt: Integer;
}