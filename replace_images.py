import os
import re

dir_path = r'c:\Flutter\Flutter Project\astrology_app\lib\views\pages\generateChart\details_chart'

import_stmt = "import 'package:astrology_app/views/pages/generateChart/details_chart/widgets/zoomable_chart_image.dart';\n"

for file in os.listdir(dir_path):
    if not file.endswith('.dart'):
        continue
    filepath = os.path.join(dir_path, file)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # Regex logic: 
    # Match: Center( child: SizedBox( height: ResponsiveHelper.height(\d+), width: MediaQuery.of(context).size.width, child: (\w+)\.isNotEmpty ? Image.network(... ) : Image.asset(...) , ), )
    
    # Let's write a pattern that's more robust
    pattern = re.compile(
        r'Center\(\s*child:\s*SizedBox\(\s*height:\s*ResponsiveHelper\.height\((\d+)\),\s*'
        r'width:\s*MediaQuery\.of\(context\)\.size\.width,\s*'
        r'child:\s*([a-zA-Z0-9_\.]+)\.isNotEmpty\s*'
        r'\?\s*Image\.network\([\s\S]*?Image\.asset\([\s\S]*?\),\s*\),\s*\)',
        re.MULTILINE
    )

    def repl(m):
        height = m.group(1)
        var_name = m.group(2)
        return f"ZoomableChartImage(imageUrl: {var_name}, height: ResponsiveHelper.height({height}))"
    
    new_content, count = pattern.subn(repl, content)
    
    if count > 0:
        if import_stmt not in new_content:
            last_import_idx = new_content.rfind('import ')
            if last_import_idx != -1:
                end_idx = new_content.find('\n', last_import_idx) + 1
                new_content = new_content[:end_idx] + import_stmt + new_content[end_idx:]
            else:
                new_content = import_stmt + new_content

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Replaced {count} occurrences in {file}")

