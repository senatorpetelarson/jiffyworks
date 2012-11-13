var nonNumbers = "abcdefghijklmnopqrstuvwxyz:<>,.$!@#%^&*()-=+}{|':;~`?"
function formatCurrency(num,showDecimals) {
if(num=="") return "";
num = stripCharsNotInBag(num, "$1234567890,.")
if(!showDecimals) showDecimals = true;
num = num.toString().replace(/\$|\,/g, '');
if (isNaN(num)) num = "0";
sign = (num == (num = Math.abs(num)));
num = Math.floor(num * 100 + 0.50000000001);
cents = num % 100;
num = Math.floor(num / 100).toString();
if (cents < 10) cents = "0" + cents;
for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
num = num.substring(0, num.length - (4 * i + 3)) + ',' + num.substring(num.length - (4 * i + 3));
if(showDecimals) {
  return (((sign) ? '' : '-') + '$' + num);
} else {
  return (((sign) ? '' : '-') + '$' + num + '.' + cents);
}
}

function formatPercent(num) {
	if(num <= 1) {
		num = Math.round(num*100);
	}
	return num + "%";
}

function formatValue(num,type,showDecimals) {
	if(type=="currency") {
		return formatCurrency(num,showDecimals);
	} else if(type=="percent") {
		return formatPercent(num);
	} else {
		return num;
	}
}

function cleanNumber(value) {
  return stripCharsNotInBag(value, '0123456789');
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