
[xml]$xml = '
    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <respostaPedidoAutorizacaoWS xmlns="http://ptu.unimed.coop.br/schemas/V60_00">
         <cabecalhoTransacao>
            <codigoTransacao>00501</codigoTransacao>
            <tipoCliente>UNIMED</tipoCliente>
            <codigoUnimedPrestadora>37</codigoUnimedPrestadora>
            <codigoUnimedOrigemBeneficiario>17</codigoUnimedOrigemBeneficiario>
         </cabecalhoTransacao>
         <respostaPedidoAutorizacao>
            <numeroTransacaoPrestadora>44806697</numeroTransacaoPrestadora>
            <numeroTransacaoOrigemBeneficiario>57719268</numeroTransacaoOrigemBeneficiario>
            <identificacaoBeneficiario>
               <codigoUnimed>17</codigoUnimed>
               <codigoIdentificacao>7005068808008</codigoIdentificacao>
               <nome>Ivanilce Teixeira Da Silv</nome>
            </identificacaoBeneficiario>
            <dataValidadeAutorizacao>2017-12-29</dataValidadeAutorizacao>
            <tpAutorizacao>1</tpAutorizacao>
            <tpAcomodacao>A</tpAcomodacao>
            <numeroVersaoPTU>060</numeroVersaoPTU>
            <tpSexo>3</tpSexo>
            <dtNasc>1944-01-08</dtNasc>
            <blocoServicoRespostaPedido>
               <respostaPedidoServico>
                  <servico>
                     <sqitem>1</sqitem>
                     <tipoTabela>0</tipoTabela>
                     <codigoServico>40103072</codigoServico>
                     <descricaoServico>Audiometria Tonal Limiar Com Testes de Discriminacao</descricaoServico>
                  </servico>
                  <quantidadeAutorizada>1</quantidadeAutorizada>
                  <indicaAutorizacao>2</indicaAutorizacao>
               </respostaPedidoServico>
               <respostaPedidoServico>
                  <servico>
                     <sqitem>2</sqitem>
                     <tipoTabela>0</tipoTabela>
                     <codigoServico>40103099</codigoServico>
                     <descricaoServico>Audiometria Vocal - Pesquisa de Limiar De Discriminacao</descricaoServico>
                  </servico>
                  <quantidadeAutorizada>1</quantidadeAutorizada>
                  <indicaAutorizacao>2</indicaAutorizacao>
               </respostaPedidoServico>
               <respostaPedidoServico>
                  <servico>
                     <sqitem>3</sqitem>
                     <tipoTabela>0</tipoTabela>
                     <codigoServico>40103102</codigoServico>
                     <descricaoServico>Audiometria Vocal - Pesquisa de Limiar De Inteligibilidade</descricaoServico>
                  </servico>
                  <quantidadeAutorizada>1</quantidadeAutorizada>
                  <indicaAutorizacao>2</indicaAutorizacao>
               </respostaPedidoServico>
               <respostaPedidoServico>
                  <servico>
                     <sqitem>4</sqitem>
                     <tipoTabela>0</tipoTabela>
                     <codigoServico>40103439</codigoServico>
                     <descricaoServico>Impedanciometria - timpanometria</descricaoServico>
                  </servico>
                  <quantidadeAutorizada>1</quantidadeAutorizada>
                  <indicaAutorizacao>2</indicaAutorizacao>
               </respostaPedidoServico>
            </blocoServicoRespostaPedido>
         </respostaPedidoAutorizacao>
         <hash>014458e400f0e32d38b3f146779a6d7e</hash>
      </respostaPedidoAutorizacaoWS>
   </soap:Body>
</soap:Envelope>
'
$certificate = Get-PfxCertificate 'C:\temp\UNIMEDRIO PRD.p12'
$URI = "https://wsd.unimed.coop.br/wsdintercambio/intercambioservices/ptu_v60_00/PedidoAutorizacao"
$result = (Invoke-WebRequest $URI –contentType "text/xml" –method POST -Body $xml -Certificate $certificate)
$result.rawcontent