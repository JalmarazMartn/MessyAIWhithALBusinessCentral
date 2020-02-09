codeunit 50176 "Azure Vision"
{
    var
        AzureURL: TextConst ENU = 'https://westcentralus.api.cognitive.microsoft.com/vision/v2.0/';
        AzureFaceDetecURL: TextConst ENU = 'https://westeurope.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false&recognitionModel=recognition_01&returnRecognitionModel=false&detectionModel=detection_01';
        AzureVerifyFaceURL: TextConst ENU = 'https://westeurope.api.cognitive.microsoft.com/face/v1.0/verify';
        AzureVerifyBody: TextConst ENU = '{"faceId1": "%1","faceId2": "%2"}';
        AzureVerifyWithGroupPersonBody: TextConst ENU = '{"faceId": "%1","personId": "%2", "personGroupId": "%3"}';
        DefaultMethodCaption: TextConst ENU = 'analyze?visualFeatures=Adult,Brands,Categories,Color,';
        DefaultMethodCaption2: TextConst ENU = 'Description,Faces,ImageType,Objects,Tags';

    procedure GetAzureImageResp(Method: Text; InsStream: InStream) TextoRespuesta: Text;
    var
        url: Text;
    begin
        if Method = '' then
            Method := DefaultMethodCaption + DefaultMethodCaption2;
        url := AzureURL + Method;
        exit(AzureImageAPICallResult(insstream, url));
    end;

    procedure GetLotNoFromImage(InsTream: InStream): Text;
    var
        JSONBuffer: Record "JSON Buffer" temporary;
    begin
        with JSONBuffer do begin
            ReadFromText(GetAzureImageResp('ocr', InsTream));
            //Get value after another text  label 
            //To get regions[0].lines[0].words[0].text
            SetFilter(Path, 'regions*.lines*.words*.text');
            SetRange("Token type", "Token type"::String);
            SetFilter(Value, '@lot*');

            if not FindFirst() then
                exit;
            Message('%1', JSONBuffer);
            SetRange(Value);
            if Next <> 0 then
                exit(Value);
        end;
    end;


    local procedure GetsubscriptionKey(): Text[50]
    var
        AIServicesSetup: Record "AI Services Setup";
    begin
        AIServicesSetup.Get();
        AIServicesSetup.TestField("Azure vision ApiKey");
        exit(AIServicesSetup."Azure vision ApiKey");
    end;

    procedure GetTempFaceID(InsStream: InStream) TextoRespuesta: Text;
    var
    begin
        exit(AzureImageAPICallResult(InsStream, AzureFaceDetecURL));
    end;

    procedure AzureImageAPICallResult(InsStream: InStream; Url: Text) TextoRespuesta: Text;
    var
        ClienteHttp: HttpClient;
        RequestEntity: HttpRequestMessage;
        Cabecera: HttpHeaders;
        Cabecera2: HttpHeaders;
        Respuesta: HttpResponseMessage;
        ReqBody: HttpContent;
    begin
        RequestEntity.SetRequestUri(Url);
        RequestEntity.Method('POST');
        RequestEntity.GetHeaders(Cabecera);
        Cabecera.Add('Ocp-Apim-Subscription-Key', GetsubscriptionKey);
        ReqBody.WriteFrom(InsStream);
        ReqBody.GetHeaders(Cabecera2);
        Cabecera2.Remove('Content-Type');
        Cabecera2.Add('Content-Type', 'application/octet-stream');
        RequestEntity.Content(ReqBody);
        ClienteHttp.send(RequestEntity, Respuesta);
        Respuesta.Content.ReadAs(TextoRespuesta);
    end;

    procedure MatchTwoFaceIds(IDFace1: text[50]; IDFace2: text[50]): Boolean;
    var
        TextoRespuesta: Text;
        JSONBuffer: Record "JSON Buffer" temporary;
    begin
        TextoRespuesta := VerifyFace(IDFace1, IDFace2);
        with JSONBuffer do begin
            ReadFromText(TextoRespuesta);
            SetRange(Path, 'isIdentical');
            SetRange(Value, 'Yes');
            exit(FindFirst);
        end;
    end;

    procedure VerifyFace(IDFace1: text[50]; IDFace2: text[50]) TextoRespuesta: Text;
    var
        ClienteHttp: HttpClient;
        RequestEntity: HttpRequestMessage;
        Cabecera: HttpHeaders;
        Cabecera2: HttpHeaders;
        Respuesta: HttpResponseMessage;
        ReqBody: HttpContent;
        url: Text;
        JSONBody: Text[500];
    begin
        url := AzureVerifyFaceURL;
        RequestEntity.SetRequestUri(Url);
        RequestEntity.Method('POST');
        RequestEntity.GetHeaders(Cabecera);
        Cabecera.Add('Ocp-Apim-Subscription-Key', GetsubscriptionKey);
        JSONBody := StrSubstNo(AzureVerifyBody, IDFace1, IDFace2);
        ReqBody.WriteFrom(JSONBody);
        ReqBody.GetHeaders(Cabecera2);
        Cabecera2.Remove('Content-Type');
        Cabecera2.Add('Content-Type', 'Application/json');
        RequestEntity.Content(ReqBody);
        ClienteHttp.send(RequestEntity, Respuesta);
        Respuesta.Content.ReadAs(TextoRespuesta);
    end;

    procedure FaceIdMatchWithGroupPersonID(FaceID: Text[50]; GroupID: Text[50]; PersonId: Text[50]): Boolean
    var
        ClienteHttp: HttpClient;
        RequestEntity: HttpRequestMessage;
        Cabecera: HttpHeaders;
        Cabecera2: HttpHeaders;
        Respuesta: HttpResponseMessage;
        ReqBody: HttpContent;
        url: Text;
        JSONBody: Text[500];
        TextoRespuesta: Text;
        JSONBuffer: Record "JSON Buffer" temporary;
    begin
        url := AzureVerifyFaceURL;
        RequestEntity.SetRequestUri(Url);
        RequestEntity.Method('POST');
        RequestEntity.GetHeaders(Cabecera);
        Cabecera.Add('Ocp-Apim-Subscription-Key', GetsubscriptionKey);
        JSONBody := StrSubstNo(AzureVerifyWithGroupPersonBody, FaceID, PersonId, GroupID);
        ReqBody.WriteFrom(JSONBody);
        ReqBody.GetHeaders(Cabecera2);
        Cabecera2.Remove('Content-Type');
        Cabecera2.Add('Content-Type', 'Application/json');
        RequestEntity.Content(ReqBody);
        ClienteHttp.send(RequestEntity, Respuesta);
        Respuesta.Content.ReadAs(TextoRespuesta);
        with JSONBuffer do begin
            ReadFromText(TextoRespuesta);
            SetRange(Path, 'isIdentical');
            SetRange(Value, 'Yes');
            exit(FindFirst);
        end;

    end;
}