require('./main.css');
var logoPath = require('./logo.svg');
var Elm = require('./Main.elm');

var root = document.getElementById('root');

Elm.Main.embed(root, logoPath);


// The vanilla JS solution to Interview Cake's Product of Others problem

function listProduct(arr) {
  return arr.reduce((acc, val) => acc * val);
}

function getProductOfOthers(arr) {
  const result = []  
  for (let i = 0; i < arr.length; i++) {
    const others = arr.filter((elm, idx, _) => idx !== i);
    result.push(listProduct(others))    
  }

  return result;
}

console.log(getProductOfOthers([1, 7, 3, 4]));