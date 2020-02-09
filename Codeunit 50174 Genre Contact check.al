codeunit 50174 "Gender contact check"
{
    trigger OnRun()
    var
        Contact: Record Contact;
    begin
        if Page.RunModal(0, Contact) = action::LookupOK then
            Message(GetContactImageGender(Contact));
    end;

    procedure GetContactImageGender(Contact: Record Contact) Gender: Text
    var
        OutStreamPicture: OutStream;
        InStreamPicture: InStream;
        WatsonManagement: Codeunit "Watson Management";
        RespuestaWatson: Text;
        JSONBuffer: Record "JSON Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        NewTempBlob: Record "New Temp Blob";
        BufferImage: Record "Buffer image";
    begin
        if not Contact.Image.HasValue then
            exit;
        //TempBlob.CreateOutStream(OutStreamPicture);
        //NewTempBlob.Blob.CreateOutStream(OutStreamPicture);
        BufferImage.Image.CreateOutStream(OutStreamPicture);
        Contact.Image.ExportStream(OutStreamPicture);
        BufferImage.image.CreateInStream(InStreamPicture);
        //NewTempBlob.Blob.CreateInStream(InStreamPicture);
        //TempBlob.CreateInStream(InStreamPicture);
        RespuestaWatson := WatsonManagement.GetWatsonImageResponse(InStreamPicture);
        JSONBuffer.ReadFromText(RespuestaWatson);
        JSONBuffer.SetRange(Path, GenderPath);
        if JSONBuffer.FindLast then
            Gender := JSONBuffer.Value;
    end;

    procedure GetContactSalutationGender(Contact: Record Contact) Gender: Text
    var
        Salutation: Record Salutation;
        CapsDescription: Text;
    begin
        if not Salutation.get(Contact."Salutation Code") then
            exit;
        CapsDescription := UpperCase(Salutation.Description);
        if StrPos(CapsDescription, GeneroMasculinoText) <> 0 then
            exit(MaleGenderText);
        if StrPos(CapsDescription, GeneroFemeninoText) <> 0 then
            exit(FemaleGenderText);
    end;

    procedure CheckAllContactsGender()
    var
        Contact: Record Contact;
    begin
        with Contact do begin
            SetRange(Type, Contact.Type::Person);
            if not FindSet() then
                exit;
            repeat
                if GetContactImageGender(Contact) <> GetContactSalutationGender(Contact) then
                    Mark(true);
            until next = 0;
            MarkedOnly(true);
            if not FindFirst then begin
                Message(MsgGenderOK);
                exit;
            end;
            Page.RunModal(0, Contact);
        end;
    end;

    var
        GenderPath: TextConst ENU = 'images[0].faces[0].gender.gender';
        GeneroMasculinoText: TextConst ENU = 'HOMBRE';
        GeneroFemeninoText: TextConst ENU = 'MUJER';
        MaleGenderText: TextConst ENU = 'MALE';
        FemaleGenderText: TextConst ENU = 'FEMALE';
        MsgGenderOK: TextConst ENU = 'All the contacts gender match';
}