codeunit 50175 "Cloudmersive Face"
{
    var
        CloudMersiveURL: TextConst ENU = 'https://api.cloudmersive.com/';
        FaceCompareMethod: TextConst ENU = 'image/face/compare-and-match';
        FaceAgeMethod: TextConst ENU = 'image/face/detect-age';

    procedure CallCloudMersiveSingleImage(Method: Text; ImageStream1: InStream)
                TextoRespuesta: Text;
    var
        ClienteHttp: HttpClient;
        RequestEntity: HttpRequestMessage;
        Cabecera: HttpHeaders;
        Respuesta: HttpResponseMessage;
        Cuerpo: HttpContent;
        url: Text;
        Prueba: Text;
        TypeHelper: Codeunit "Type Helper";
    begin
        url := CloudMersiveURL + Method;
        RequestEntity.SetRequestUri(Url);
        RequestEntity.Method('POST');
        Cuerpo.WriteFrom(ImageStream1);
        Cuerpo.GetHeaders(Cabecera);
        Cabecera.Add('Apikey', GetsubscriptionKey);
        Cabecera.Remove('Content-Type');
        Cabecera.Add('Content-Type', 'octect-stream');
        Cuerpo.ReadAs(Prueba);
        Message(Prueba);
        RequestEntity.Content(Cuerpo);
        ClienteHttp.send(RequestEntity, Respuesta);
        Respuesta.Content.ReadAs(TextoRespuesta);
    end;

    procedure CallCloudMersiveImage(Method: Text; ImageStream1: InStream; ImageStream2: InStream)
                TextoRespuesta: Text;
    var
        ClienteHttp: HttpClient;
        RequestEntity: HttpRequestMessage;
        Cabecera: HttpHeaders;
        Respuesta: HttpResponseMessage;
        Cuerpo: HttpContent;
        url: Text;
        Prueba: Text;
        TypeHelper: Codeunit "Type Helper";
    begin
        url := CloudMersiveURL + Method;
        RequestEntity.SetRequestUri(Url);
        RequestEntity.Method('POST');
        Cuerpo.WriteFrom('inputImage:');
        Cuerpo.WriteFrom(ImageStream1);
        Cuerpo.WriteFrom('matchFace:');
        Cuerpo.WriteFrom(ImageStream1);
        Cuerpo.GetHeaders(Cabecera);
        Cabecera.Add('Apikey', GetsubscriptionKey);
        Cabecera.Remove('Content-Type');
        Cabecera.Add('Content-Type', 'multipart/form-data');
        //Cabecera.Add('inputImage', Prueba);
        //Cabecera.Add('matchFace', Prueba);
        Cuerpo.ReadAs(Prueba);
        Message(Prueba);
        RequestEntity.Content(Cuerpo);
        ClienteHttp.send(RequestEntity, Respuesta);
        Respuesta.Content.ReadAs(TextoRespuesta);
    end;

    procedure FiilJSONBufferCloudMersiveImage(var JSONBuffer: Record "JSON Buffer" Temporary;
                    NatualLenguageText: Text; Method: Text; ImageStream1: InStream; ImageStream2: InStream)
                    TextoRespuesta: Text;
    var
    begin
        JSONBuffer.ReadFromText(CallCloudMersiveImage(Method, ImageStream1, ImageStream2));
    end;

    procedure GetCompareFaces(var BufferImage1: Record "Buffer image" temporary;
    var BufferImage2: Record "Buffer image" temporary) TextoResponse: text;
    var
        ImageStream1: InStream;
        ImageStream2: InStream;
    begin
        BufferImage1.Image.CreateInStream(ImageStream1);
        BufferImage2.Image.CreateInStream(ImageStream2);
        TextoResponse := CallCloudMersiveImage(FaceCompareMethod, ImageStream1, ImageStream2);
    end;

    procedure GetDetectAge(var BufferImage1: Record "Buffer image" temporary) TextoResponse: text;
    var
        ImageStream1: InStream;
    begin
        BufferImage1.Image.CreateInStream(ImageStream1);
        TextoResponse := CallCloudMersiveSingleImage(FaceCompareMethod, ImageStream1);
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