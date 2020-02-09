table 50173 "Syntax Token"
{
    //Alfredo has been calling customers for 6 hours
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Token Content"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Part of Speech"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Lemma; Text[50])
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(PK; "No.")
        {

        }
    }
    var
        FilterSyntaxTok: TextConst ENU = 'syntax.tokens*';

    procedure GetWordsFromJSONBuffer(var JSONBuffer: Record "JSON Buffer" temporary)
    var
        EmptyJSONBuffer: Record "JSON Buffer" temporary;
    begin
        JSONBuffer.Reset();
        JSONBuffer.SetFilter(Path, FilterSyntaxTok);
        if not JSONBuffer.FindSet then
            exit;
        ProcessBuffer(JSONBuffer, EmptyJSONBuffer);
    end;

    local procedure ProcessBuffer(var JSONBuffer: Record "JSON Buffer" temporary;
                    PrevJSONBuffer: Record "JSON Buffer" temporary)
    var
        TokenNo: Integer;
    begin
        TokenNo := GetTokenNumber(JSONBuffer.Path);
        if TokenNo <> "No." then
            InsertNewToken(TokenNo);
        if PrevJSONBuffer."Token type" = PrevJSONBuffer."Token type"::"Property Name" then begin
            case PrevJSONBuffer.Value of
                'part_of_speech':
                    "Part of Speech" := JSONBuffer.Value;

                'text':
                    "Token Content" := JSONBuffer.Value;
                'lemma':
                    Lemma := JSONBuffer.Value;
            end;
            if "No." <> 0 then
                Modify();
        end;
        PrevJSONBuffer := JSONBuffer;
        if JSONBuffer.next <> 0 then
            ProcessBuffer(JSONBuffer, PrevJSONBuffer);
    end;

    local procedure GetTokenNumber(TokenText: Text) TokenNumber: Integer
    var
        Inicio: Integer;
        Final: Integer;
        Longitud: Integer;
    begin
        Inicio := StrPos(TokenText, '[');
        Final := StrPos(TokenText, ']');
        if Inicio = 0 then
            exit;
        Inicio := Inicio + 1;
        Longitud := Final - Inicio;
        if Longitud < 1 then
            exit;
        if Evaluate(TokenNumber, TokenText.Substring(Inicio, Longitud)) then
            TokenNumber := TokenNumber + 1;
    end;

    local procedure InsertNewToken(NewTokenNo: Integer)
    begin
        if NewTokenNo = 0 then
            exit;
        "No." := NewTokenNo;
        Insert();
    end;
}