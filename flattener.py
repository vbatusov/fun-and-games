# Intended operation: $ flattener [-f] [-d <dir>]
# finds all filename.ipynb files in <dir>, parses the json, and writes
# filename.py Python file containing just the code.
# Use [-f] to overwrite existing Python files, otherwise noop.

import sys, os, getopt
import json

# Defaults
overwrite = False
directory = "."

try:
    opts, args = getopt.getopt(sys.argv[1:], "fd:")
except getopt.GetoptError:
    print("flattener.py [-f] [-d <ipynb directory>]")
    sys.exit(2)


for opt, arg in opts:
    if opt == '-f':
        overwrite = True
    elif opt == '-d':
        directory = arg

#print("Force={}, Directory={}".format(overwrite, directory))

# Parse
for filename in os.listdir(directory):
    if filename.endswith(".ipynb"):
        # Get code out
        srcfilepath = os.path.join(directory, filename)
        pyfilename = "{}.py".format(os.path.splitext(filename)[0])
        pyfilepath = os.path.join(directory, pyfilename)
        ignore = (os.path.isfile(pyfilepath) and not overwrite)
        if not ignore:
            print("Writing {}".format(pyfilename))
            with open(srcfilepath) as f:
                contents = f.read()
            decoded = json.loads(contents)
            #print(json.loads(contents))

            cellcount = 1
            code = "# Autogenerated from file <{}>\n".format(srcfilepath)
            code += "import sys\n"
            for cell in decoded['cells']:
                code += "\n\n# ========== CELL {} ===========\n\n".format(cellcount)
                code += "print('\\n\\n\x1b[1;33;40m============== Running cell #{} ===============\x1b[0m')\n".format(cellcount)
                # each cell is a dict
                if cell["cell_type"] == "code":
                    tmp = [line if line[0] != "%" else "#{}".format(line) for line in cell['source']]
                    code += "".join(tmp)
                else:
                    #print("--- Not a code cell, skipping ---")
                    #code += "#{}".format("#".join(cell['source']))
                    code += "\n".join(["print('{}')".format(line.rstrip()) for line in cell['source']])

                cellcount += 1
            # Write to file

            with open(pyfilepath, 'w') as f:
                f.write(code)
