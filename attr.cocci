@initialize:python@
@@
import os
import re


dec_name = {}
attr_list = {}
def grep_attrib(fname, attr_list):
	with open(fname) as origin_file:
		for line in origin_file:
			what_line = re.findall(r'What:', line)
			if (what_line):
				line = line[:-1]
				tokens = line.split("/")
				attr_list[tokens[-1]] = line
				
def collect_attrib(dir, attr_list):
	for root, subdirs, files in os.walk(dir):
		for fname in files:
			#ignore .c, .h, .txt 
			if (fname[-2] == '.'):
				continue
			file_name = os.path.join(root, fname)
			grep_attrib(file_name, attr_list)

dir = "/home/haneen/git/kernels/staging"
for root, subdirs, files in os.walk(dir):
	if ("Documentation" in subdirs):
		dir_name = os.path.join(root, "Documentation")
		#print dir_name
		collect_attrib(dir_name, attr_list)

print len(attr_list)
			
@r@
declarer d;
identifier x;
position p;
@@

d@p(x, ...);

@script:python@
x << r.x;
d << r.d;
p << r.p;
@@

if (x in attr_list):
	if (d in dec_name):
		dec_name[d].append(x)
	else:
		dec_name[d] = [x]
else:
	cocci.include_match(False)


@r2@
declarer r.d;
identifier r.x;
position r.p;
@@

*d@p(x, ...);

@finalize:python@
@@


print "DECLARER NAMES LIST:"
for k, v in dec_name.items():
	print k, "-->", v
