

function confirmation(question, url) { 
   var answer = confirm(question) 
   if (answer){ 
      //alert("The answer is OK!"); 
      window.location = url;
   } else { 
      //alert("The answer is CANCEL!") 
   } 
} 

