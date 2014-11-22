#!/broad/software/free/Linux/redhat_5_x86_64/pkgs/r_3.0.2/bin/Rscript

suppressPackageStartupMessages(require(optparse))
options(stringsAsFactors=FALSE)

option_list = list(
  make_option(c("-f", "--filename"), action="store", default='', 
              type='character', help="Path to data file"),
  make_option(c("-t", "--tablename"), action="store", default='',
              type='character', help="MySQL table name"),
  make_option(c("-d", "--delimiter"), action="store", default='\t',
              type='character', help="Delimiter in table"),
  make_option(c("-q", "--quotechar"), action="store", default='',
              type='character', help="Quoting character"),
  make_option(c("-c", "--commentchar"), action="store", default='',
              type='character', help="Commenting character"),
  make_option(c("-s", "--skip"), action="store", default=0,
              type='integer', help="Lines to skip before header")
)
opt = parse_args(OptionParser(option_list=option_list))

# read data
tbl = read.table(opt$filename,header=TRUE,quote=opt$quotechar,comment.char=opt$commentchar,sep=opt$delimiter,skip=opt$skip)

# get a list of column data types
types = paste((lapply(tbl,class)),sep='')

# replace R types with MySQL types
types = gsub("integer","int",types)
types = gsub("character","text",types)
types = gsub("numeric","float",types)

# get column names
names = colnames(tbl)
safe_names = gsub("[^A-Za-z0-9_]","_",names) # replace non-word characters with _

# make a create table statement
header = paste("drop table if exists ",opt$tablename,";\ncreate table ",opt$tablename,"(\n",sep="")
body = paste(safe_names," ",types,sep="",collapse=",\n")
tail = "\n);\n"
sql = paste(header,body,tail,sep="")

# output to user
cat(sql)

