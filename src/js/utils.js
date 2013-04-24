var nonNumbers = "abcdefghijklmnopqrstuvwxyz:<>,.$!@#%^&*()-=+}{|':;~`?"
function formatCurrency(num,showDecimals) {
	if(num) {
		return "$" + parseFloat(num).toFixed(2).toString()
	} else {
		return "$0.00"
	}
	// if(num=="") return "";
	// num = stripCharsNotInBag(num, "$1234567890,.")
	// if(!showDecimals) showDecimals = true;
	// num = num.toString().replace(/\$|\,/g, '');
	// if (isNaN(num)) num = "0";
	// sign = (num == (num = Math.abs(num)));
	// num = Math.floor(num * 100 + 0.50000000001);
	// cents = num % 100;
	// num = Math.floor(num / 100).toString();
	// if (cents < 10) cents = "0" + cents;
	// for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
	// num = num.substring(0, num.length - (4 * i + 3)) + ',' + num.substring(num.length - (4 * i + 3));
	// if(showDecimals) {
	//   return (((sign) ? '' : '-') + '$' + num);
	// } else {
	//   return (((sign) ? '' : '-') + '$' + num + '.' + cents);
	// }
}

function formatPercent(num) {
	num = num.toString().replace("%","");
	num = Math.round((num*100)*10)/10;
	num = num.toString() + "%"
	return num
}

function formatRatio(num) {
	// return Math.round( num * 100 ) / 100;
	return parseFloat(num).toFixed(2)
}

function percentToPixels(percentage,total) {
	return Math.round(total*(String(percentage).replace("%","")/100))
}

function pixelsToPercent(pixelsValue,total) {
	return ((pixelsValue/total)*100)+"%"
}

function formatValue(num,type,showDecimals) {
	if(type=="currency") {
		return formatCurrency(num,showDecimals)
	} else if(type=="percent") {
		return formatPercent(num)
	} else {
		return formatRatio(num)
	}
}

/* Improves JavaScript's substring method
	 by allowing a negative index to go from
	 the end of the string backwards */
function substring(str,index,length) {
	str = str.toString()
	if(index < 0) {
		return str.substr(str.length + index, length);
	} else {
		return str.substr(index,length);
	}
}

function formatNumberString(num) {
  if(substring(num,-1,1) == '0') {
    if(num.length > 1) {
       formatted_number = num.toString() + "th";
    } else {
      formatted_number = "0";
    }
  } else if(substring(num,-1,1) == '1') {
    if((substring(num,-2,2) >= 10) && (substring(num,-2,2) < 20)) {
      formatted_number = num.toString() + "th";
    } else {
      formatted_number = num.toString() + "st";
    }
  } else if(substring(num,-1,1) == '2') {
    formatted_number = num.toString() + "nd";
  } else if(substring(num,-1,1) == '3') {
    formatted_number = num.toString() + "rd";
  } else {
    formatted_number = num.toString() + "th";
  }

  return formatted_number;
}

function formatAbbrevNumberText(num_to_abbrev,units) {
	if(units == null) {
		units = "millions";
	}
	num = parseFloat(cleanNumber(num_to_abbrev))
	extension = "";
	try {
		if(num_to_abbrev.indexOf("%")>-1) {
			extension = "%";
		}
	} catch(err) {}
	sign = ""
	try {
		if(num_to_abbrev.indexOf("-") > -1) {
			sign = "-"
		}
	} catch(err) {}
	prefix = ""
	try {
		if(num_to_abbrev.indexOf("$") > 0) {
			prefix = "$"
		}
	} catch(err) {}
	try {
		if(num > 999999) {
			rounded = (Math.round(num / 1000000));
			return sign + prefix + rounded.to_s + "M" + extension;
		} else if((num > 9999) && (units == "thousands" || (num % 1) != 0)) {
			rounded = (Math.round(num / 10000));
			return sign + prefix + rounded + "K" + extension;
		} else {
			return num_to_abbrev;
		}
	} catch(err) {
		debug(num_to_abbrev);
		debug(err);
		return;
	}
}

function reformat (s){
    var arg;
    var sPos = 0;
    var resultString = "";
    for (var i = 1; i < reformat.arguments.length; i++) {
       arg = reformat.arguments[i];
       if (i % 2 == 1) resultString += arg;
       else {
           resultString += s.substring(sPos, sPos + arg);
           sPos += arg;
       }
    }
    return resultString;
}

function reformatUSPhone(USPhone)
{   
	if (USPhone.length < 10) { return USPhone; }
	USPhone = stripCharsNotInBag (USPhone, "1234567890");
	return (reformat (USPhone, "(", 3, ") ", 3, "-", 4));
}

function reformatZIPCode (ZIPString){
    if (ZIPString.length == 5) return ZIPString;
    else return (reformat (ZIPString, "", 5, "-", 4));
}

function cleanNumber(value) {
  return stripCharsNotInBag(value, '0123456789.');
}

function stripCharsNotInBag (s, bag) { var i;
	var returnString = "";
	for (i = 0; i < s.length; i++) { 
		// Check that current character isn't whitespace.
		var c = s.charAt(i);
		if (bag.indexOf(c) != -1) returnString += c;
	}
	return returnString;
}
function px(number) {
	return number.toString() + "px";
}
function pxValue(pixelString) {
	return parseFloat(pixelString.replace("px",""));
}