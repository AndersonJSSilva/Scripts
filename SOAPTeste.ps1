[xml]$xml = '<ns3:Envelope xmlns:ns2="http://ptu.unimed.coop.br/schemas/V60_00" xmlns:ns4="http://ptu.unimed.com.br/schemas/V1_01_50" xmlns:ns3="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns5="http://ptu.unimed.com.br/schemas/batch/V1_00_00">
    <ns3:Body>
        <ns2:consultaDadosBeneficiarioWS>
            <ns2:cabecalhoTransacao>
                <ns2:codigoTransacao>00412</ns2:codigoTransacao>
                <ns2:tipoCliente>UNIMED</ns2:tipoCliente>
                <ns2:codigoUnimedPrestadora>17</ns2:codigoUnimedPrestadora>
                <ns2:codigoUnimedOrigemBeneficiario>37</ns2:codigoUnimedOrigemBeneficiario>
            </ns2:cabecalhoTransacao>
            <ns2:consultaDadosBeneficiario>
                <ns2:numeroTransacaoPrestadora>53891382</ns2:numeroTransacaoPrestadora>
                <ns2:codigoUnimed>37</ns2:codigoUnimed>
                <ns2:codigoIdentificacao>30823407</ns2:codigoIdentificacao>
                <ns2:numeroCPF>99999999999</ns2:numeroCPF>
                <ns2:numeroCNS>999999999999999</ns2:numeroCNS>
                <ns2:numeroVersaoPTU>050</ns2:numeroVersaoPTU>
            </ns2:consultaDadosBeneficiario>
            <ns2:hash>9041cfca927529076100e9ccb265c130</ns2:hash>
        </ns2:consultaDadosBeneficiarioWS>
    </ns3:Body>
</ns3:Envelope>'

[xml]$xml ='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:out="http://www.outsystems.com">
   <soapenv:Header>
      <User>emsventura</User>
        <Password>$1$3NfO7VL6DqHN71rR2ekQgmrNDm4bXZFuHOiF33YbB94=552165AACE237BE625F81AB660A267B04A4836E7179F442756FE5FF75EB1A663911386421E17F9479AEB1322820E1E2068D0FBDC6A6D0BA64B2E8A4D9A24E025</Password>
      <Token>0385A7EDA9E5142E77E1661ADA58CA24</Token>
   </soapenv:Header>
   <soapenv:Body>
      <out:ClonarVigencia>
         <out:Tabela>TUSSMEDRIO</out:Tabela>
         <out:Vigencia_de>20/12/2016</out:Vigencia_de>
         <out:Vigencia_para>12/01/2017</out:Vigencia_para>
      </out:ClonarVigencia>
   </soapenv:Body>
</soapenv:Envelope>
'

#cmbs
[xml]$xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://mi.unimed.coop.br/schemas/V1_00_00">
   <soapenv:Header/>
   <soapenv:Body>
      <v1:solicitarBaixaWS>
         <v1:cabecalhoTransacao>
            <v1:codigoUnimedOrigemMensagem>37</v1:codigoUnimedOrigemMensagem>
            <v1:codigoUnimedDestinoMensagem>999</v1:codigoUnimedDestinoMensagem>
            <v1:versaoTransacao>1</v1:versaoTransacao>
         </v1:cabecalhoTransacao>
         <v1:solicitarBaixa>
            <v1:dadosCobranca>
               <v1:codigoUnimedRecebeuCobranca>0025</v1:codigoUnimedRecebeuCobranca>
               <v1:numeroDocumento1>23851943</v1:numeroDocumento1>
               <v1:tpDocumento1>1</v1:tpDocumento1>
               <v1:valorTotalPagoDoc1>903.93</v1:valorTotalPagoDoc1>
               <v1:dataPagamentoDoc1>2017-05-17</v1:dataPagamentoDoc1>
               <v1:identificadorPagamentoDoc1>2</v1:identificadorPagamentoDoc1>
            </v1:dadosCobranca>
         </v1:solicitarBaixa>
         <v1:hash>915939c169b869d627dffa2c0dd506c6</v1:hash>
      </v1:solicitarBaixaWS>
   </soapenv:Body>
</soapenv:Envelope>'

#osappprd
[xml]$xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://mi.unimed.coop.br/schemas/V1_00_00">
   <soapenv:Header/>
   <soapenv:Body>
      <v1:SolicitarBaixa>
         <v1:SolicitarBaixaIn>
            <v1:CodigoUnimedOrigemMensagem>37</v1:CodigoUnimedOrigemMensagem>
            <v1:CodigoUnimedDestinoMensagem>999</v1:CodigoUnimedDestinoMensagem>
            <v1:VersaoTransacao>1</v1:VersaoTransacao>
            <v1:CodigoUnimedRecebeuCobranca>0025</v1:CodigoUnimedRecebeuCobranca>
            <v1:NumeroDocumento1>23851943</v1:NumeroDocumento1>
            <v1:TpDocumento1>1</v1:TpDocumento1>
            <v1:ValorTotalPagoDoc1>903.93</v1:ValorTotalPagoDoc1>
            <v1:DataPagamentoDoc1>2017-05-17</v1:DataPagamentoDoc1>
            <v1:IdentificadorPagamentoDoc1>2</v1:IdentificadorPagamentoDoc1>
         </v1:SolicitarBaixaIn>
      </v1:SolicitarBaixa>
   </soapenv:Body>
</soapenv:Envelope>'

[xml]$xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:td="http://schemas.datacontract.org/2004/07/TD.Ura.Service.DAL.Models">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:GeracaoProtocolo>
         <!--Optional:-->
         <tem:request>
            <!--Optional:-->
            <td:Telefone>21987857070</td:Telefone>
         </tem:request>
      </tem:GeracaoProtocolo>
   </soapenv:Body>
</soapenv:Envelope>'

$URI = "https://app.unimedrio.com.br/ems_ventura_entrega2/ems_ventura.asmx"
$URI = "https://app.unimedrio.com.br/PTU_ONLINE/consultaBenef.asmx?wsdl"
$URI = "https://cmbsvc.unimed.coop.br/ws/inadimplencia/solicitarBaixa?wsdl"
$URI = "http://ptuwsprd01/Neo.Site/Intercambio/ContasMedicas/InterfaceUnimedPTU/PTUA510/WS.asmx?wsdl"
$URI = "http://neodsv01/Neo.Site/Intercambio/ContasMedicas/InterfaceUnimedPTU/PTUA510/WS.asmx?wsdl"
$URI = "http://osappprd02/PTU_A510_A515/WS.asmx?wsdl"
$URI = "https://tsaudeappinv01.unimedrio.com.br/ws/Td.Ura.Service/Service.svc?wsdl"

#$certificate = Get-PfxCertificate C:\temp\unimed_37.p12
$header = @{"SOAPAction" = "http://tempuri.org/IService/GeracaoProtocolo"}

$result = Invoke-WebRequest $URI –contentType "text/xml" –method POST -Body $xml -Headers $header
$result.RawContent

$result = (Invoke-WebRequest $URI –contentType "text/xml" –method POST -Body $xml  )
$result.RawContent