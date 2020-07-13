def clean(inventory_path, out_path):
    with open(inventory_path) as lines, open(out_path, "w") as writer:
        for line in lines:
            fields = line.strip().split("\t")
            if len(fields) < 2:
                continue
            lexeme = fields[0]
            lemma = fields[0].split("#")[0].replace(" ", "_")
            pos = fields[0].split("#")[1].upper()
            lexeme = lemma + "#" + pos
            bns = set(map(lambda bnsource: bnsource.split("#")[0], fields[1:]))
            writer.write(lexeme + "\t" + "\t".join(bns) + "\n")
    os.remove(inventory_path)


import argparse
import os

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--langs", nargs="+", required=True)
    parser.add_argument("--inventory_folder", required=True, type=str)
    args = parser.parse_args()
    langs = args.langs
    inventory_dir = args.inventory_folder
    for lang in langs:
        print(lang)
        clean(os.path.join(inventory_dir, lang, f"inventory.{lang}.reliable_sources+gold.txt"),
              os.path.join(inventory_dir, lang, f"inventory.{lang}.withgold.txt"))
