codeunit 50172 "Cloudmersive Image"
{
    var
        CloudMersiveURL: TextConst ENU = 'https://api.cloudmersive.com/swagger/api/image';
        ImageMethod: TextConst ENU = '/recognize/detect-people';

    procedure CallCloudMersiveNL(StrImage: InStream; Method: Text)
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
        //Cuerpo.WriteFrom(NatualLenguageText);
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
        //JSONBuffer.ReadFromText(CallCloudMersiveNL(NatualLenguageText, Method));
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