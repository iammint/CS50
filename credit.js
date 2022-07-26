function verify(creditNum) {
  let arr = creditNum.toString().split("");
  const len = arr.length;
  let ans = 0;
  for (let i = 0; i < len; i++) {
    if (i % 2 == 0) {
      ans += arr[i] * 2;
    } else {
      ans += arr[i];
    }
  }
  let result = ans
    .toString()
    .split("")
    .reduce((a, b) => +a + +b, 0);
  console.log(result);
  if (result % 10 === 0) {
    switch (arr[0]) {
      case "3":
        if (arr[1] === 4 || arr[1] === 7) {
          return "American Express";
        }
        break;
      case "5":
        if (arr[1] > 0 && arr[1] < 6) {
          return "MasterCard";
        }
        break;
      case "4":
        return "Visa";
    }
  }
  return "Invalid credit card";
}
console.log(verify(371449635398431));
