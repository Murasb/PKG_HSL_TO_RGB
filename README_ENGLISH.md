# PKG_HSL_TO_RGB
# PL/SQL Package for CKEditor 5 CLOB Conversion

## Overview

The `PKG_CKEDITOR_05` PL/SQL package is designed to address challenges encountered when working with CKEditor 5-generated content. It offers functionalities for converting CKEditor 5 CLOB content into HTML and managing HSL to RGB conversions within the content. This package is particularly useful when generating PDFs from CKEditor 5 content that includes custom CSS styles.

## Functions

### `FNC_CSS_CKEDITOR05`

This function is responsible for converting CKEditor 5 CLOB content into HTML and managing CSS styles. It performs the following tasks:

- **Input:** Accepts a CKEditor 5 CLOB content.
- **Output:** Returns CLOB content with CSS styles applied directly to HTML elements.
- **Usage:** When generating PDFs from CKEditor 5 content, this function ensures that CSS styles are properly applied to HTML elements, which may otherwise cause issues with PDF generation tools that do not interpret CSS variables.

### `FNC_PREPARA_HSL_TO_RGB`

This function prepares HSL (Hue, Saturation, Luminosity) values extracted from the content for conversion to RGB (Red, Green, Blue). It performs the following tasks:

- **Input:** Accepts HSL values in CLOB format.
- **Output:** Returns prepared HSL values for conversion.
- **Usage:** This function is an intermediary step to extract and format HSL values from CKEditor 5 content before converting them to RGB. It ensures that HSL values are correctly formatted for the conversion process.

### `FNC_HSL_TO_RGB`

This function performs the conversion of HSL values to RGB. It accepts HSL parameters and returns the corresponding RGB value in VARCHAR2 format. The HSL-to-RGB conversion follows the standard color model conversion principles.

- **Input:** Accepts Hue (0-360 degrees), Saturation (0-100), and Luminosity (0-100).
- **Output:** Returns the RGB value as a VARCHAR2 string.
- **Usage:** This function is used internally to convert HSL color values within the CKEditor 5 content to RGB, ensuring that colors are accurately represented when generating PDFs.

## Usage

To use the `PKG_CKEDITOR_05` package in your Oracle database, follow these steps:

1. Create or replace the package in your Oracle database.
2. Utilize the package's functions within your PL/SQL code to convert CKEditor 5 CLOB content to HTML and manage HSL to RGB conversions.
3. Ensure that the converted HTML content is used as intended, especially when generating PDFs from CKEditor 5 content with custom CSS styles.

## Example

```sql
-- Example usage of FNC_CSS_CKEDITOR05
DECLARE
    v_clob_content CLOB := 'CKEditor 5 content in CLOB format';
    v_html_content CLOB;
BEGIN
    v_html_content := PKG_CKEDITOR_05.FNC_CSS_CKEDITOR05(v_clob_content);
    -- Use v_html_content as needed in your application.
END;
