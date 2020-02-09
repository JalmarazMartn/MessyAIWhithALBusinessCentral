codeunit 50171 "Watson Management"
{
    trigger OnRun()
    begin

    end;

    var
        WatsonURL: TextConst ENU = 'https://gateway-lon.watsonplatform.net/natural-language-understanding/api/v1/analyze?version=2018-03-19';
        SyntaxAnalysisMethod: TextConst ENU = '&features=syntax&syntax.tokens=true&syntax.tokens.lemma=true&syntax.tokens.part_of_speech=true&syntax.sentences=true';
        EmotionAndSentimentMethod: TextConst ENU = '&features=keywords,entities&entities.emotion=true&entities.sentiment=true&keywords.emotion=true&keywords.sentiment=true';
        SemanticRoleMethod: TextConst ENU = '&features=semantic_roles&semantic_roles.keywords=true&semantic_roles.entities=true';
        WatsonURLDetectFaces: TextConst ENU = 'https://gateway.watsonplatform.net/visual-recognition/api/v3/detect_faces?version=2018-03-19';
        WatsonNaturalLangReqBody: TextConst ENU = '{"text":"%1","language":"en","features":{"syntax":{"tokens":{"lemma":true,"part_of_speech":true},"sentences":true},"entities":{"tokens":{"mentions":true,"sentiment":true,"emotion":true}},"keywords":{"tokens":{"sentiment":true,"emotion":true}}}}';

    procedure GetWatsonNaturalLanguagePost(InputText: Text) TextoResponse: text;
    var
        HttpClient: HttpClient;
        RequestWatson: HttpRequestMessage;
        Header: HttpHeaders;
        Response: HttpResponseMessage;
        ReqBody: HttpContent;
        url: Text;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        url := WatsonURL;
        RequestWatson.SetRequestUri(Url);
        RequestWatson.Method('POST');
        RequestWatson.GetHeaders(Header);
        Header.Add('Authorization',
                    'Basic ' + Base64Convert.ToBase64(
                    'apikey:' + GetsubscriptionKey));
        EscribirReqBodyEntero(ReqBody, InputText);
        RequestWatson.Content(ReqBody);
        HttpClient.send(RequestWatson, Response);
        Response.Content.ReadAs(TextoResponse);
    end;

    procedure GetWatsonJSON(Method: Text; InputText: Text; var JSONBuffer: Record "JSON Buffer" Temporary)
    var
        TextoResponse: Text;
    begin
        TextoResponse := GetWatsonResponseWithGet(Method, InputText);
        JSONBuffer.ReadFromText(TextoResponse);
    end;

    procedure GetWatsonSyntaxResponse(InputText: Text) TextoResponse: text;
    var
    begin
        TextoResponse := GetWatsonResponseWithGet(SyntaxAnalysisMethod, InputText);
    end;

    procedure GetWatsonEmotionsAndSentiment(InputText: Text) TextoResponse: text;
    var
    begin
        TextoResponse := GetWatsonResponseWithGet(EmotionAndSentimentMethod, InputText);
    end;

    procedure GetWatsonSemanticRole(InputText: Text) TextoResponse: text;
    var
    begin
        TextoResponse := GetWatsonResponseWithGet(SemanticRoleMethod, InputText);
    end;

    local procedure EscribirReqBodyEntero(var ReqBody: HttpContent; InputText: Text)
    var
        JSONInput: JsonObject;
        JSONFeat: JsonObject;
        TextReqBody: Text;
        Header: HttpHeaders;

    begin

        ReqBody.GetHeaders(Header);
        TextReqBody := StrSubstNo(WatsonNaturalLangReqBody, InputText);
        Message(TextReqBody);
        ReqBody.WriteFrom(TextReqBody);
        Header.Remove('Content-Type');
        Header.Add('Content-Type', 'application/json');
    end;

    local procedure JsonToText(var InputJSON: JsonObject) OutputText: Text;
    begin
        InputJSON.WriteTo(OutputText);
    end;

    procedure GetWatsonResponseWithGet(Method: Text; InputText: Text) TextoResponse: text;
    var
        HttpClient: HttpClient;
        RequestWatson: HttpRequestMessage;
        Header: HttpHeaders;
        Response: HttpResponseMessage;
        ReqBody: HttpContent;
        url: Text;
        TestReqBody: Text;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        //url := WatsonURL + '/' + Method + '&text=' + InputText +
        url := WatsonURL +
        '&text=' + InputText +
        Method;
        RequestWatson.GetHeaders(Header);
        Header.Add('Authorization',
                    'Basic ' + Base64Convert.ToBase64(
                    'apikey:' + GetsubscriptionKey));
        //HttpClient.send(RequestWatson, Response);
        RequestWatson.Method('GET');
        RequestWatson.SetRequestUri(url);
        HttpClient.Send(RequestWatson, Response);
        Response.Content.ReadAs(TextoResponse);
    end;

    procedure GetWatsonImageResponse(ImageStream: InStream) TextoResponse: text;
    var
        ReqClient: HttpClient;
        RequestWatson: HttpRequestMessage;
        Header: HttpHeaders;
        Response: HttpResponseMessage;
        ReqBody: HttpContent;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        RequestWatson.SetRequestUri('https://gateway.watsonplatform.net/visual-recognition/api/v3/detect_faces?version=2018-03-19');
        RequestWatson.Method('POST');
        RequestWatson.GetHeaders(Header);
        Header.Add('Authorization',
                    'Basic ' + Base64Convert.ToBase64(
                    'apikey:' + GetsubscriptionKeyVisual));
        ReqBody.WriteFrom(ImageStream);
        RequestWatson.Content(ReqBody);
        ReqClient.send(RequestWatson, Response);
        Response.Content.ReadAs(TextoResponse);
    end;

    procedure GetWatsonImageResponseFromBuffer(var BufferImage: Record "Buffer image" temporary) TextoResponse: text;
    var
        ImageStream: InStream;
    begin
        BufferImage.Image.CreateInStream(ImageStream);
        TextoResponse := GetWatsonImageResponse(ImageStream);
    end;

    local procedure GetsubscriptionKey(): Text[50]
    var
        AIServicesSetup: Record "AI Services Setup";
    begin
        AIServicesSetup.Get;
        AIServicesSetup.TestField("Watson Syntax Apikey");
        exit(AIServicesSetup."Watson Syntax Apikey");
    end;

    local procedure GetsubscriptionKeyVisual(): Text[50]
    var
        AIServicesSetup: Record "AI Services Setup";
    begin
        AIServicesSetup.Get;
        AIServicesSetup.TestField("Watson Image Apikey");
        exit(AIServicesSetup."Watson Image Apikey");
    end;
}