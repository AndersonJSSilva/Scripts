[xml]$xml = '<ns3:Envelope xmlns:ns2="http://ptu.unimed.coop.br/schemas/V70_00" xmlns:ns4="http://ptu.unimed.coop.br/schemas/V60_00" xmlns:ns3="http://schemas.xmlsoap.org/soap/envelope/">
    <ns3:Body>
        <ns4:pedidoAutorizacaoWS>
            <ns4:cabecalhoTransacao>
                <ns4:codigoTransacao>00600</ns4:codigoTransacao>
                <ns4:tipoCliente>UNIMED</ns4:tipoCliente>
                <ns4:codigoUnimedPrestadora>37</ns4:codigoUnimedPrestadora>
                <ns4:codigoUnimedOrigemBeneficiario>17</ns4:codigoUnimedOrigemBeneficiario>
            </ns4:cabecalhoTransacao>
            <ns4:pedidoAutorizacao>
                <ns4:numeroTransacaoPrestadora>44806697</ns4:numeroTransacaoPrestadora>
                <ns4:identificacaoBeneficiario>
                    <ns4:codigoUnimed>17</ns4:codigoUnimed>
                    <ns4:codigoIdentificacao>7005068808008</ns4:codigoIdentificacao>
                    <ns4:numeroViaCartao>0</ns4:numeroViaCartao>
                </ns4:identificacaoBeneficiario>
                <ns4:tpRedeMIN>1</ns4:tpRedeMIN>
                <ns4:prestador>
                    <ns4:codigoUnimed>37</ns4:codigoUnimed>
                    <ns4:codigoPrestador>387926</ns4:codigoPrestador>
                    <ns4:nomePrestador>JOSE ROBERTO CARVALHAES F</ns4:nomePrestador>
                </ns4:prestador>
                <ns4:prestadorRequisitante>
                    <ns4:codigoUnimed>37</ns4:codigoUnimed>
                    <ns4:codigoPrestador>387926</ns4:codigoPrestador>
                </ns4:prestadorRequisitante>
                <ns4:codigoEspecialidadeMedica>45</ns4:codigoEspecialidadeMedica>
                <ns4:idUrgenciaEmergencia>N</ns4:idUrgenciaEmergencia>
                <ns4:dataAtendimento>2017-10-30</ns4:dataAtendimento>
                <ns4:numeroVersaoPTU>060</ns4:numeroVersaoPTU>
                <ns4:idRN>N</ns4:idRN>
                <ns4:idAcidente>9</ns4:idAcidente>
                <ns4:cdUnimedAtend>37</ns4:cdUnimedAtend>
                <ns4:idAnexo>N</ns4:idAnexo>
                <ns4:dataSugeridaInternacao>2017-10-30</ns4:dataSugeridaInternacao>
                <ns4:idOrdemServico>N</ns4:idOrdemServico>
                <ns4:nrVerTiss>3.02.00</ns4:nrVerTiss>
                <ns4:indicacaoClinica>Hipacusia</ns4:indicacaoClinica>
                <ns4:idLiminar>N</ns4:idLiminar>
                <ns4:cdIBGE>3304557</ns4:cdIBGE>
                <ns4:blocoServicoPedido>
                    <ns4:pedidoServico>
                        <ns4:servico>
                            <ns4:sqitem>1</ns4:sqitem>
                            <ns4:tipoTabela>0</ns4:tipoTabela>
                            <ns4:codigoServico>40103072</ns4:codigoServico>
                        </ns4:servico>
                        <ns4:quantidadeServico>1</ns4:quantidadeServico>
                        <ns4:tpAnexo>9</ns4:tpAnexo>
                        <ns4:idPacote>N</ns4:idPacote>
                    </ns4:pedidoServico>
                    <ns4:pedidoServico>
                        <ns4:servico>
                            <ns4:sqitem>2</ns4:sqitem>
                            <ns4:tipoTabela>0</ns4:tipoTabela>
                            <ns4:codigoServico>40103099</ns4:codigoServico>
                        </ns4:servico>
                        <ns4:quantidadeServico>1</ns4:quantidadeServico>
                        <ns4:tpAnexo>9</ns4:tpAnexo>
                        <ns4:idPacote>N</ns4:idPacote>
                    </ns4:pedidoServico>
                    <ns4:pedidoServico>
                        <ns4:servico>
                            <ns4:sqitem>3</ns4:sqitem>
                            <ns4:tipoTabela>0</ns4:tipoTabela>
                            <ns4:codigoServico>40103102</ns4:codigoServico>
                        </ns4:servico>
                        <ns4:quantidadeServico>1</ns4:quantidadeServico>
                        <ns4:tpAnexo>9</ns4:tpAnexo>
                        <ns4:idPacote>N</ns4:idPacote>
                    </ns4:pedidoServico>
                    <ns4:pedidoServico>
                        <ns4:servico>
                            <ns4:sqitem>4</ns4:sqitem>
                            <ns4:tipoTabela>0</ns4:tipoTabela>
                            <ns4:codigoServico>40103439</ns4:codigoServico>
                        </ns4:servico>
                        <ns4:quantidadeServico>1</ns4:quantidadeServico>
                        <ns4:tpAnexo>9</ns4:tpAnexo>
                        <ns4:idPacote>N</ns4:idPacote>
                    </ns4:pedidoServico>
                </ns4:blocoServicoPedido>
            </ns4:pedidoAutorizacao>
            <ns4:hash>956321894b96f898954fee6e41456e30</ns4:hash>
        </ns4:pedidoAutorizacaoWS>
    </ns3:Body>
</ns3:Envelope>'

$certificate = Get-PfxCertificate 'C:\temp\UNIMEDRIO PRD.p12'

$URI = "https://wsd.unimed.coop.br/wsdintercambio/intercambioservices/ptu_v60_00/PedidoAutorizacao"

$result = Invoke-WebRequest $URI –contentType "text/xml" –method POST -Body $xml -Certificate $certificate

$result.RawContent
