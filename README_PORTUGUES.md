# Pacote PL/SQL para Conversão de Conteúdo do CKEditor 5

## Visão Geral

O pacote PL/SQL `PKG_CKEDITOR_05` foi desenvolvido para resolver desafios encontrados ao trabalhar com conteúdo gerado pelo CKEditor 5. Ele oferece funcionalidades para converter conteúdo CKEditor 5 em formato CLOB em HTML e gerenciar conversões de HSL (Matiz, Saturação, Luminosidade) para RGB (Vermelho, Verde, Azul) dentro do conteúdo. Este pacote é particularmente útil ao gerar PDFs a partir de conteúdo CKEditor 5 que inclui estilos CSS personalizados.

## Funções

### `FNC_CSS_CKEDITOR05`

Esta função é responsável por converter conteúdo CKEditor 5 em formato CLOB em HTML e gerenciar estilos CSS. Ela realiza as seguintes tarefas:

- **Entrada:** Aceita um conteúdo CKEditor 5 em formato CLOB.
- **Saída:** Retorna o conteúdo CLOB com estilos CSS aplicados diretamente aos elementos HTML.
- **Utilização:** Ao gerar PDFs a partir do conteúdo CKEditor 5, esta função garante que os estilos CSS sejam aplicados corretamente aos elementos HTML, evitando problemas com ferramentas de geração de PDF que não interpretam variáveis CSS.

### `FNC_PREPARA_HSL_TO_RGB`

Esta função prepara os valores HSL (Matiz, Saturação, Luminosidade) extraídos do conteúdo para a conversão em RGB. Ela realiza as seguintes tarefas:

- **Entrada:** Aceita valores HSL no formato CLOB.
- **Saída:** Retorna os valores HSL preparados para a conversão.
- **Utilização:** Esta função é uma etapa intermediária para extrair e formatar os valores HSL do conteúdo CKEditor 5 antes de convertê-los em RGB. Ela garante que os valores HSL sejam formatados corretamente para o processo de conversão.

### `FNC_HSL_TO_RGB`

Esta função realiza a conversão de valores HSL para RGB. Ela aceita parâmetros HSL e retorna o valor RGB correspondente no formato VARCHAR2. A conversão de HSL para RGB segue os princípios padrão de conversão de modelos de cores.

- **Entrada:** Aceita Matiz (0-360 graus), Saturação (0-100) e Luminosidade (0-100).
- **Saída:** Retorna o valor RGB como uma string VARCHAR2.
- **Utilização:** Esta função é usada internamente para converter valores de cor HSL dentro do conteúdo CKEditor 5 em RGB, garantindo que as cores sejam representadas com precisão ao gerar PDFs.

## Utilização

Para utilizar o pacote `PKG_CKEDITOR_05` em seu banco de dados Oracle, siga estas etapas:

1. Crie ou substitua o pacote em seu banco de dados Oracle.
2. Utilize as funções do pacote em seu código PL/SQL para converter conteúdo CKEditor 5 em HTML e gerenciar conversões de HSL para RGB.
3. Certifique-se de que o conteúdo HTML convertido seja usado conforme necessário em seu aplicativo, especialmente ao gerar PDFs a partir de conteúdo CKEditor 5 com estilos CSS personalizados.

## Exemplo

```sql
-- Exemplo de uso da FNC_CSS_CKEDITOR05
DECLARE
    v_clob_conteudo CLOB := 'Conteúdo do CKEditor 5 em formato CLOB';
    v_html_conteudo CLOB;
BEGIN
    v_html_conteudo := PKG_CKEDITOR_05.FNC_CSS_CKEDITOR05(v_clob_conteudo);
    -- Use v_html_conteudo conforme necessário em seu aplicativo.
END;
