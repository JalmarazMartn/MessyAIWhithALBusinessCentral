codeunit 50170 "Cloudmersive Natural Language"
{
    var
        CloudMersiveURL: TextConst ENU = 'https://api.cloudmersive.com/nlp/';
        ProperNounMethod: TextConst ENU = 'get/words/properNouns/string';
        VerbsMethod: TextConst ENU = 'get/words/verbs/string';


    procedure CallCloudMersiveNL(NatualLenguageText: Text; Method: Text)
                TextoRespuesta: Text;
    var
        ClienteHttp: HttpClient;
        RequestEntity: HttpRequestMessage;
        Cabecera: HttpHeaders;
        Respuesta: HttpResponseMessage;
        Cuerpo: HttpContent;
        url: Text;
    begin
        url := CloudMersiveURL + Method;
        RequestEntity.SetRequestUri(Url);
        RequestEntity.Method('POST');
        Cuerpo.WriteFrom(NatualLenguageText);
        Cuerpo.GetHeaders(Cabecera);
        Cabecera.Add('Apikey', GetsubscriptionKey);
        Cabecera.Remove('Content-Type');
        Cabecera.Add('Content-Type', 'application/json');
        RequestEntity.Content(Cuerpo);
        if not ClienteHttp.send(RequestEntity, Respuesta) then
            Error('Call failed');
        Respuesta.Content.ReadAs(TextoRespuesta);
    end;

    procedure FiilJSONBufferCloudMersiveNL(var JSONBuffer: Record "JSON Buffer" Temporary;
                    NatualLenguageText: Text; Method: Text) TextoRespuesta: Text;
    var
    begin
        JSONBuffer.ReadFromText(CallCloudMersiveNL(NatualLenguageText, Method));
    end;

    local procedure GetProperNoun(NaturalLenguageText: Text) ProperNoun: Text[100];
    begin
        ProperNoun := CallCloudMersiveNL(NaturalLenguageText, ProperNounMethod);
        ProperNoun := RemoveColonsAndTag(ProperNoun, '/NNP',
                'There is not a proper noun in the text');
    end;

    local procedure RemoveColonsAndTag(InputText: Text[100]; TagSearch: Code[10]; ErrMessage: text[200])
                    OutputText: Text[100];
    var
        TagPosition: Integer;
    begin
        OutputText := DelChr(InputText, '=', '"');
        TagPosition := StrPos(OutputText, TagSearch);
        if TagPosition = 0 then
            error(ErrMessage);
        OutputText := CopyStr(OutputText, 1, TagPosition - 1);
    end;

    procedure GetResourceNo(NaturalLenguageText: Text) ResourceNo: Code[20];
    var
        Resource: Record Resource;
        ProperNoun: text[100];
    begin
        with Resource do begin
            ProperNoun := GetProperNoun(NaturalLenguageText);
            SetFilter(Name, '*' + ProperNoun + '*');
            if count = 1 then begin
                ;
                FindFirst();
                exit("No.");
            end;
            if Count() = 0 then
                Reset();
            if Page.RunModal(0, Resource) = Action::LookupOK then
                exit("No.");
        end;
    end;

    procedure GetWorkTypeCode(NaturalLenguageText: Text) WorkTypeCode: Code[20];
    var
        WorkType: Record "Work Type";
        MainVerb: text[100];
        RoothVerb: Text[100];
    begin
        with WorkType do begin
            MainVerb := GetMainVerb(NaturalLenguageText);
            MainVerb := CopyStr(MainVerb, 1, 2);
            SetFilter(Description, '@' + MainVerb + '*');
            FindFirst();
            if count = 1 then
                exit(Code);
            if Page.RunModal(0, WorkType) = Action::LookupOK then
                exit(Code);
        end;
    end;

    local procedure GetMainVerb(NaturalLenguageText: Text) MainVerb: Text[100];
    var
        AllVerbs: Text;
        ListOfVerbs: List of [Text];
        NumElem: Integer;
        CurrentVerb: Text;
        i: Integer;
    begin
        AllVerbs := CallCloudMersiveNL(NaturalLenguageText, VerbsMethod);
        ListOfVerbs := AllVerbs.Split(',');
        if ListOfVerbs.Count = 0 then
            error('There are not verbs in the text.');
        for i := 1 to ListOfVerbs.Count do begin
            ListOfVerbs.get(i, CurrentVerb);
            if strpos(CurrentVerb, '/VBG') <> 0 then begin
                MainVerb := RemoveColonsAndTag(CurrentVerb, '/VBG', 'There is no verb');
                exit;
            end;
            if strpos(CurrentVerb, '/VBD') <> 0 then begin
                MainVerb := RemoveColonsAndTag(CurrentVerb, '/VBD', 'There is no verb');
                exit;
            end;
            if strpos(CurrentVerb, '/VBN') <> 0 then begin
                MainVerb := RemoveColonsAndTag(CurrentVerb, '/VBN', 'There is no verb');
                exit;
            end;
        end;
    end;

    procedure ProcessDescResjnlLine(var ResJournalLine: Record "Res. Journal Line")
    var
        DescriptionAnt: Text;
    begin
        with ResJournalLine do begin
            DescriptionAnt := Description;
            Validate("Resource No.", GetResourceNo(DescriptionAnt));
            Validate("Work Type Code", GetWorkTypeCode(DescriptionAnt));
            Description := DescriptionAnt;
        end;
    end;

    [EventSubscriber(ObjectType::page, page::"Resource Journal", 'OnAfterValidateEvent', 'Description', true, true)]
    local procedure ValidateDescription(var Rec: Record "Res. Journal Line")
    begin
        ProcessDescResjnlLine(Rec);
    end;

    local procedure GetsubscriptionKey(): Text[50]
    var
        AIServicesSetup: Record "AI Services Setup";
    begin
        AIServicesSetup.Get();
        AIServicesSetup.TestField("CloudMersive ApiKey");
        exit(AIServicesSetup."CloudMersive ApiKey");
    end;
}