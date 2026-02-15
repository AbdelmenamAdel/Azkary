import re

with open('lib/features/Azkar/manager/model/allah_names_model.dart', 'r') as f:
    content = f.read()

# Extract items
pattern = r'AllahNamesModel\((?:.|\n)*?\s*\),'
items = re.findall(pattern, content)

# Reverse the list of items
reversed_items = items[::-1]

# Header and footer
header = """class AllahNamesModel {
  String name;
  String description;
  AllahNamesModel({
    required this.name,
    required this.description,
  });

  static List<AllahNamesModel> allahNames = [
"""
footer = """  ];
}
"""

with open('lib/features/Azkar/manager/model/allah_names_model.dart', 'w') as f:
    f.write(header)
    for item in reversed_items:
        f.write("    " + item.strip() + "\n")
    f.write(footer)

print("Done reversing names")
