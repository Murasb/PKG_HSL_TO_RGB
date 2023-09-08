SET DEFINE OFF;
CREATE OR REPLACE PACKAGE PKG_CKEDITOR_05 AS 
/* PACOTE DESENVOLVIDO PARA RESOLVER OS PROBLEMAS DO CKEDITOR, REALIZANDO AS CONVERSÕES E ATRIBUINDO FORMATAÇÕES HTML*/

  /* Atribui o css, e chama a conversão de HSL para RGB */
  FUNCTION FNC_CSS_CKEDITOR05(P_CONTEUDO CLOB) RETURN CLOB;   

  /* prepara a conversão separando os valores da string, para enviar como parametros */
  FUNCTION FNC_PREPARA_HSL_TO_RGB(HSL_VALUE CLOB) RETURN CLOB;

  /* Recebe os parametros de um HSL e retorna string convertida em RGB */
  FUNCTION FNC_HSL_TO_RGB(P_HUEEMGRAUS IN NUMBER,       
                          P_SATURACAO IN NUMBER,        
                          P_LUMINOSIDADE IN NUMBER ) RETURN VARCHAR2;

END PKG_CKEDITOR_05;
/
CREATE OR REPLACE
PACKAGE BODY PKG_CKEDITOR_05 AS

/* ============================================================================
                            FNC_CSS_CKEDITOR05
============================================================================ */
  FUNCTION FNC_CSS_CKEDITOR05(P_CONTEUDO CLOB) RETURN CLOB IS
      V_RETORNO CLOB;
      L_START_POS NUMBER := 1;
      L_END_POS NUMBER := 0;
      L_HSL_VALUE VARCHAR2(100);
      L_RGB_VALUE VARCHAR2(100);
  
    BEGIN
    /* O css aqui apresentado foi adquirido na documentação do CKeditor05, para o funcionamento ideal,
       as variaveis css precisaram ser removidas.
       Por algum motivo, no momento de gerar o pdf, nossa ferramenta não conseguia ler os valores das variaveis,
       por isso, teve que ser reescrito para, para que cada classe recebesse os valores diretamente */
      V_RETORNO := '<style>                      
                            /* @ckeditor/ckeditor5-table/theme/tablecolumnresize.css */
                            .ck-content .table .ck-table-resized {
                                table-layout: fixed;
                            }
                            /* @ckeditor/ckeditor5-table/theme/tablecolumnresize.css */
                            .ck-content .table table {
                                overflow: hidden;
                            }
                            /* @ckeditor/ckeditor5-table/theme/tablecolumnresize.css */
                            .ck-content .table td,
                            .ck-content .table th {
                                overflow-wrap: break-word;
                                position: relative;
                            }
                            /* @ckeditor/ckeditor5-table/theme/table.css */
                            .ck-content .table {
                                margin: 0.9em auto;
                                display: table;
                            }
                            /* @ckeditor/ckeditor5-table/theme/table.css */
                            .ck-content .table table {
                                border-collapse: collapse;
                                border-spacing: 0;
                                width: 100%;
                                height: 100%;
                                border: 1px double hsl(0, 0%, 70%);
                            }
                            /* @ckeditor/ckeditor5-table/theme/table.css */
                            .ck-content .table table td,
                            .ck-content .table table th {
                                min-width: 2em;
                                padding: .4em;
                                border: 1px solid hsl(0, 0%, 75%);
                            }
                            /* @ckeditor/ckeditor5-table/theme/table.css */
                            .ck-content .table table th {
                                font-weight: bold;
                                background: hsla(0, 0%, 0%, 5%);
                            }
                            /* @ckeditor/ckeditor5-table/theme/table.css */
                            .ck-content[dir="rtl"] .table th {
                                text-align: right;
                            }
                            /* @ckeditor/ckeditor5-table/theme/table.css */
                            .ck-content[dir="ltr"] .table th {
                                text-align: left;
                            }
                            /* @ckeditor/ckeditor5-table/theme/tablecaption.css */
                            .ck-content .table > figcaption {
                                display: table-caption;
                                caption-side: top;
                                word-break: break-word;
                                text-align: center;
                                color: hsl(0, 0%, 20%);
                                background-color: hsl(0, 0%, 97%);
                                padding: .6em;
                                font-size: .75em;
                                outline-offset: -1px;
                            }
                            /* @ckeditor/ckeditor5-page-break/theme/pagebreak.css */
                            .ck-content .page-break {
                                position: relative;
                                clear: both;
                                padding: 5px 0;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                            }
                            /* @ckeditor/ckeditor5-page-break/theme/pagebreak.css */
                            .ck-content .page-break::after {
                                content: '';
                                position: absolute;
                                border-bottom: 2px dashed hsl(0, 0%, 77%);
                                width: 100%;
                            }
                            /* @ckeditor/ckeditor5-page-break/theme/pagebreak.css */
                            .ck-content .page-break__label {
                                position: relative;
                                z-index: 1;
                                padding: .3em .6em;
                                display: block;
                                text-transform: uppercase;
                                border: 1px solid hsl(0, 0%, 77%);
                                border-radius: 2px;
                                font-family: Helvetica, Arial, Tahoma, Verdana, Sans-Serif;
                                font-size: 0.75em;
                                font-weight: bold;
                                color: hsl(0, 0%, 20%);
                                background: hsl(0, 0%, 100%);
                                box-shadow: 2px 2px 1px hsla(0, 0%, 0%, 0.15);
                                -webkit-user-select: none;
                                -moz-user-select: none;
                                -ms-user-select: none;
                                user-select: none;
                            }
                            /* @ckeditor/ckeditor5-media-embed/theme/mediaembed.css */
                            .ck-content .media {
                                clear: both;
                                margin: 0.9em 0;
                                display: block;
                                min-width: 15em;
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list {
                                list-style: none;
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list li {
                                margin-bottom: 5px;
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list li .todo-list {
                                margin-top: 5px;
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list .todo-list__label > input {
                                -webkit-appearance: none;
                                display: inline-block;
                                position: relative;
                                width: 6px;
                                height: 6px;
                                vertical-align: middle;
                                border: 0;
                                left: -25px;
                                margin-right: -15px;
                                right: 0;
                                margin-left: 0;
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list .todo-list__label > input::before {
                                display: block;
                                position: absolute;
                                box-sizing: border-box;
                                content: '';
                                width: 100%;
                                height: 100%;
                                border: 1px solid hsl(0, 0%, 20%);
                                border-radius: 2px;
                                transition: 250ms ease-in-out box-shadow, 250ms ease-in-out background, 250ms ease-in-out border;
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list .todo-list__label > input::after {
                                display: block;
                                position: absolute;
                                box-sizing: content-box;
                                pointer-events: none;
                                content: '';
                                left: calc( 6px / 3 );
                                top: calc( 6px / 5.3 );
                                width: calc( 6px / 5.3 );
                                height: calc( 6px / 2.6 );
                                border-style: solid;
                                border-color: transparent;
                                border-width: 0 calc( 6px / 8 ) calc( 6px / 8 ) 0;
                                transform: rotate(45deg);
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list .todo-list__label > input[checked]::before {
                                background: hsl(126, 64%, 41%);
                                border-color: hsl(126, 64%, 41%);
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list .todo-list__label > input[checked]::after {
                                border-color: hsl(0, 0%, 100%);
                            }
                            /* @ckeditor/ckeditor5-list/theme/todolist.css */
                            .ck-content .todo-list .todo-list__label .todo-list__label__description {
                                vertical-align: middle;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imageresize.css */
                            .ck-content .image.image_resized {
                                max-width: 100%;
                                display: block;
                                box-sizing: border-box;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imageresize.css */
                            .ck-content .image.image_resized img {
                                width: 100%;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imageresize.css */
                            .ck-content .image.image_resized > figcaption {
                                display: block;
                            }
                            /* @ckeditor/ckeditor5-image/theme/image.css */
                            .ck-content .image {
                                display: table;
                                clear: both;
                                text-align: center;
                                margin: 0.9em auto;
                                min-width: 50px;
                            }
                            /* @ckeditor/ckeditor5-image/theme/image.css */
                            .ck-content .image img {
                                display: block;
                                margin: 0 auto;
                                max-width: 100%;
                                min-width: 100%;
                            }
                            /* @ckeditor/ckeditor5-image/theme/image.css */
                            .ck-content .image-inline {
                                /*
                                 * Normally, the .image-inline would have "display: inline-block" and "img { width: 100% }" (to follow the wrapper while resizing).;
                                 * Unfortunately, together with "srcset", it gets automatically stretched up to the width of the editing root.
                                 * This strange behavior does not happen with inline-flex.
                                 */
                                display: inline-flex;
                                max-width: 100%;
                                align-items: flex-start;
                            }
                            /* @ckeditor/ckeditor5-image/theme/image.css */
                            .ck-content .image-inline picture {
                                display: flex;
                            }
                            /* @ckeditor/ckeditor5-image/theme/image.css */
                            .ck-content .image-inline picture,
                            .ck-content .image-inline img {
                                flex-grow: 1;
                                flex-shrink: 1;
                                max-width: 100%;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagecaption.css */
                            .ck-content .image > figcaption {
                                display: table-caption;
                                caption-side: bottom;
                                word-break: break-word;
                                color: hsl(0, 0%, 20%);
                                background-color: hsl(0, 0%, 97%);
                                padding: .6em;
                                font-size: .75em;
                                outline-offset: -1px;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ol {
                                list-style-type: decimal;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ol ol {
                                list-style-type: lower-latin;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ol ol ol {
                                list-style-type: lower-roman;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ol ol ol ol {
                                list-style-type: upper-latin;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ol ol ol ol ol {
                                list-style-type: upper-roman;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ul {
                                list-style-type: disc;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ul ul {
                                list-style-type: circle;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ul ul ul {
                                list-style-type: square;
                            }
                            /* @ckeditor/ckeditor5-list/theme/list.css */
                            .ck-content ul ul ul ul {
                                list-style-type: square;
                            }
                            /* @ckeditor/ckeditor5-highlight/theme/highlight.css */
                            .ck-content .marker-yellow {
                                background-color: hsl(60, 97%, 73%);
                            }
                            /* @ckeditor/ckeditor5-highlight/theme/highlight.css */
                            .ck-content .marker-green {
                                background-color: hsl(120, 93%, 68%);
                            }
                            /* @ckeditor/ckeditor5-highlight/theme/highlight.css */
                            .ck-content .marker-pink {
                                background-color: hsl(345, 96%, 73%);
                            }
                            /* @ckeditor/ckeditor5-highlight/theme/highlight.css */
                            .ck-content .marker-blue {
                                background-color: hsl(201, 97%, 72%);
                            }
                            /* @ckeditor/ckeditor5-highlight/theme/highlight.css */
                            .ck-content .pen-red {
                                color: hsl(0, 85%, 49%);
                                background-color: transparent;
                            }
                            /* @ckeditor/ckeditor5-highlight/theme/highlight.css */
                            .ck-content .pen-green {
                                color: hsl(112, 100%, 27%);
                                background-color: transparent;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-block-align-left,
                            .ck-content .image-style-block-align-right {
                                max-width: calc(100% - 1.5em);
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-align-left,
                            .ck-content .image-style-align-right {
                                clear: none;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-side {
                                float: right;
                                margin-left: 1.5em;
                                max-width: 50%;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-align-left {
                                float: left;
                                margin-right: 1.5em;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-align-center {
                                margin-left: auto;
                                margin-right: auto;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-align-right {
                                float: right;
                                margin-left: 1.5em;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-block-align-right {
                                margin-right: 0;
                                margin-left: auto;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-style-block-align-left {
                                margin-left: 0;
                                margin-right: auto;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content p + .image-style-align-left,
                            .ck-content p + .image-style-align-right,
                            .ck-content p + .image-style-side {
                                margin-top: 0;
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-inline.image-style-align-left,
                            .ck-content .image-inline.image-style-align-right {
                                margin-top: calc(1.5em / 2);
                                margin-bottom: calc(1.5em / 2);
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-inline.image-style-align-left {
                                margin-right: calc(1.5em / 2);
                            }
                            /* @ckeditor/ckeditor5-image/theme/imagestyle.css */
                            .ck-content .image-inline.image-style-align-right {
                                margin-left: calc(1.5em / 2);
                            }
                            /* @ckeditor/ckeditor5-block-quote/theme/blockquote.css */
                            .ck-content blockquote {
                                overflow: hidden;
                                padding-right: 1.5em;
                                padding-left: 1.5em;
                                margin-left: 0;
                                margin-right: 0;
                                font-style: italic;
                                border-left: solid 5px hsl(0, 0%, 80%);
                            }
                            /* @ckeditor/ckeditor5-block-quote/theme/blockquote.css */
                            .ck-content[dir="rtl"] blockquote {
                                border-left: 0;
                                border-right: solid 5px hsl(0, 0%, 80%);
                            }
                            /* @ckeditor/ckeditor5-basic-styles/theme/code.css */
                            .ck-content code {
                                background-color: hsla(0, 0%, 78%, 0.3);
                                padding: .15em;
                                border-radius: 2px;
                            }
                            /* @ckeditor/ckeditor5-font/theme/fontsize.css */
                            .ck-content .text-tiny {
                                font-size: .7em;
                            }
                            /* @ckeditor/ckeditor5-font/theme/fontsize.css */
                            .ck-content .text-small {
                                font-size: .85em;
                            }
                            /* @ckeditor/ckeditor5-font/theme/fontsize.css */
                            .ck-content .text-big {
                                font-size: 1.4em;
                            }
                            /* @ckeditor/ckeditor5-font/theme/fontsize.css */
                            .ck-content .text-huge {
                                font-size: 1.8em;
                            }
                            /* @ckeditor/ckeditor5-mention/theme/mention.css */
                            .ck-content .mention {
                                background: hsla(341, 100%, 30%, 0.1);
                                color: hsl(341, 100%, 30%);
                            }
                            /* @ckeditor/ckeditor5-horizontal-line/theme/horizontalline.css */
                            .ck-content hr {
                                margin: 15px 0;
                                height: 4px;
                                background: hsl(0, 0%, 87%);
                                border: 0;
                            }
                            /* @ckeditor/ckeditor5-code-block/theme/codeblock.css */
                            .ck-content pre {
                                padding: 1em;
                                color: hsl(0, 0%, 20.8%);
                                background: hsla(0, 0%, 78%, 0.3);
                                border: 1px solid hsl(0, 0%, 77%);
                                border-radius: 2px;
                                text-align: left;
                                direction: ltr;
                                tab-size: 4;
                                white-space: pre-wrap;
                                font-style: normal;
                                min-width: 200px;
                            }
                            /* @ckeditor/ckeditor5-code-block/theme/codeblock.css */
                            .ck-content pre code {
                                background: unset;
                                padding: 0;
                                border-radius: 0;
                            }
                            </style>'||P_CONTEUDO;
    
      /*A TAG <hr> é utilizada para criar uma linha no ckEditor, no entanto a mesma precisa ser substituida para não gerar a quebra no pdf gerado */
      V_RETORNO := REPLACE(V_RETORNO,'<hr>','<br/>');
    
          WHILE INSTR(V_RETORNO, 'hsl(', L_START_POS) > 0 LOOP
            L_START_POS := INSTR(V_RETORNO, 'hsl(', L_START_POS);
            L_END_POS := INSTR(V_RETORNO, ')', L_START_POS);
        
            -- Extrai o valor HSL entre parênteses
            L_HSL_VALUE := SUBSTR(V_RETORNO, L_START_POS, L_END_POS - L_START_POS + 1);
        
            -- Converte HSL em RGB
            L_RGB_VALUE := FNC_PREPARA_HSL_TO_RGB(TO_CLOB(L_HSL_VALUE));
        
            -- Substitui o valor HSL pelo valor RGB
            V_RETORNO := REPLACE(V_RETORNO, SUBSTR(V_RETORNO, L_START_POS, L_END_POS - L_START_POS + 1), L_RGB_VALUE);
        
            -- Atualiza a posição de início para procurar a próxima ocorrência
            L_START_POS := L_END_POS + 1;
          END LOOP;
    
      RETURN V_RETORNO;
  END FNC_CSS_CKEDITOR05;
/* ============================================================================
                            FNC_PREPARA_HSL_TO_RGB
============================================================================ */
  FUNCTION FNC_PREPARA_HSL_TO_RGB(HSL_VALUE CLOB) RETURN CLOB IS
    V_HUE NUMBER;
    V_SATURACAO NUMBER;
    V_LUMINOSIDADE NUMBER;
  BEGIN      
      -- EXTRAI OS VALORES DAS STRINGS PARA SUBSTITUIÇÃO
      -- FORMATO "HSL(HUE, SATURACAO%, LUMINOSIDADE%)"
      SELECT
        TO_NUMBER(REPLACE((REGEXP_SUBSTR(HSL_VALUE, '(\d+(\.\d*)?)', 1, 1)),'.',',')) INTO V_HUE FROM DUAL;
      SELECT
        TO_NUMBER(REPLACE((REGEXP_SUBSTR(HSL_VALUE, '(\d+(\.\d*)?)', 1, 2)),'.',',')) INTO V_SATURACAO FROM DUAL;
      SELECT
        TO_NUMBER(REPLACE((REGEXP_SUBSTR(HSL_VALUE, '(\d+(\.\d*)?)', 1, 3)),'.',',')) INTO V_LUMINOSIDADE FROM DUAL;
    
      -- CALCULAR A CONVERSÃO HSL PARA RGB USANDO A FNC => FNC_HSL_TO_RGB
      RETURN FNC_HSL_TO_RGB(ROUND(V_HUE, 0), ROUND(V_SATURACAO, 0), ROUND(V_LUMINOSIDADE, 0));
  END FNC_PREPARA_HSL_TO_RGB;

/* ============================================================================
                            FNC_HSL_TO_RGB
============================================================================ */

  FUNCTION FNC_HSL_TO_RGB(P_HUEEMGRAUS IN NUMBER,        /* Matiz em graus (0-360), ESSE CARA É A ESCALA CROMÁTICA PRO RGB, DO 0-120 É O VERMELHO, DO 120-240 É O VERDE, E 240-360 É O AZUL */
                          P_SATURACAO IN NUMBER,        -- Saturação (0-100)
                          P_LUMINOSIDADE IN NUMBER      -- Luminosidade (0-100)
                         ) RETURN VARCHAR2 IS

    V_HUE_NORMALIZADO NUMBER := MOD(P_HUEEMGRAUS, 360) / 360;
    V_SATURACAO_NORMALIZADA NUMBER := GREATEST(0, LEAST(1, P_SATURACAO / 100));/* DIVISÃO POR 100, POIS O PARAMETRO VEM COMO PORCENTAGEM */
    V_LUMINOSIDADE_NORMALIZADA NUMBER := GREATEST(0, LEAST(1, P_LUMINOSIDADE / 100));/* DIVISÃO POR 100, POIS O PARAMETRO VEM COMO PORCENTAGEM */
    
    V_CROMINANCIA NUMBER := (1 - ABS(2 * V_LUMINOSIDADE_NORMALIZADA - 1)) * V_SATURACAO_NORMALIZADA; /* C = (1 - |2L - 1|) × S */
    V_X NUMBER := V_CROMINANCIA * (1 - ABS(MOD(V_HUE_NORMALIZADO * 6, 2) - 1));                      /* X = C × (1 - |(H / 60°) mod 2 - 1|) */
    V_LUMINOSIDADE_ADAPTADA NUMBER := V_LUMINOSIDADE_NORMALIZADA - V_CROMINANCIA / 2;                /* m = L - C/2 */
    
    V_RED NUMBER := 0;
    V_GREEN NUMBER := 0;
    V_BLUE NUMBER := 0;

    BEGIN
      /* DETERMINA O SETOR DA ESCALA CROMÁTICA */
      IF V_HUE_NORMALIZADO >= 0 AND V_HUE_NORMALIZADO < 1/6 THEN
        V_RED := V_CROMINANCIA;
        V_GREEN := V_X;
      ELSIF V_HUE_NORMALIZADO >= 1/6 AND V_HUE_NORMALIZADO < 2/6 THEN
        V_RED := V_X;
        V_GREEN := V_CROMINANCIA;
      ELSIF V_HUE_NORMALIZADO >= 2/6 AND V_HUE_NORMALIZADO < 3/6 THEN
        V_GREEN := V_CROMINANCIA;
        V_BLUE := V_X;
      ELSIF V_HUE_NORMALIZADO >= 3/6 AND V_HUE_NORMALIZADO < 4/6 THEN
        V_GREEN := V_X;
        V_BLUE := V_CROMINANCIA;
      ELSIF V_HUE_NORMALIZADO >= 4/6 AND V_HUE_NORMALIZADO < 5/6 THEN
        V_RED := V_X;
        V_BLUE := V_CROMINANCIA;
      ELSE
        V_RED := V_CROMINANCIA;
        V_BLUE := V_X;
      END IF;
    
      -- Ajusta o RGB para combinar com a luminosidade
      V_RED := V_RED + V_LUMINOSIDADE_ADAPTADA;
      V_GREEN := V_GREEN + V_LUMINOSIDADE_ADAPTADA;
      V_BLUE := V_BLUE + V_LUMINOSIDADE_ADAPTADA;
    
      -- Limita os valores RGB entre: [0, 1]
      V_RED := GREATEST(0, LEAST(1, V_RED));
      V_GREEN := GREATEST(0, LEAST(1, V_GREEN));
      V_BLUE := GREATEST(0, LEAST(1, V_BLUE));
    
      -- CONVERTE OS VALORES RGB PARA O INTERVALO [0, 255] E RETORNA A STRING RGB
      RETURN 'rgb(' || TO_CHAR(ROUND(V_RED * 255)) || ',' || TO_CHAR(ROUND(V_GREEN * 255)) || ',' || TO_CHAR(ROUND(V_BLUE * 255)) || ')';
  
  END FNC_HSL_TO_RGB;

END PKG_CKEDITOR_05;
/