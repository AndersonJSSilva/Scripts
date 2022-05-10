function Remove-Acentos {
param ([String]$src = [String]::Empty)
  $normalized = $src.Normalize( [Text.NormalizationForm]::FormD )
  $sb = new-object Text.StringBuilder
  $normalized.ToCharArray() | % { 
    if( [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
      [void]$sb.Append($_)
    }
  }
  $sb.ToString()
}


Remove-Acentos "Área de tecnlogia da Informação e Autorizações Médicas IIII"


function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    ([Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))).ToLower()
}

Remove-StringLatinCharacters "Área de tecnlogia da Informação e Autorizações Médicas IIII"
