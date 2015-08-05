options(stringsAsFactors=FALSE)

# to plot horizontal histogram bars
hhist = function(x, y, col, ...) {
  for (i in 1:length(x)) {
    segments(x0=1,x1=x[i],y0=y[i],y1=y[i],col=col[i], ... )
  }
}

# show the first n non-NA items of a vector
rhead = function(a_vector,n=10) {
  return (head(a_vector[!is.na(a_vector)],n=n))
}

# format a number like a percentage
percent = function(proportion,digits=2) {
  return ( paste(formatC(proportion*100, digits=digits, format='fg'),"%",sep="") )
}

# make nice column names - all lowercase, all word characters, 
fix_colnames = function(variable) {
  if (class(variable)=='data.frame') { # if they passed you the whole data frame
    colnames = colnames(variable)
  } else if (class(variable) == 'character') { # if they just passed the colnames
    colnames = variable
  } else {
    stop(paste('You passed fix_colnames a variable of type: ',class(variable),'\n',sep=''))
  }
  new_colnames = colnames
  # if colname was "123" in source file, R makes it "X123", now make it "_123"
  starts_with_number = grep('^X[0-9]',new_colnames)
  new_colnames[starts_with_number] = gsub("^X","_",new_colnames[starts_with_number])
  # to lowercase & all non-word chars converted to _
  new_colnames = gsub("[^A-Za-z0-9_]","_",tolower(new_colnames)) 
  return (new_colnames)
}