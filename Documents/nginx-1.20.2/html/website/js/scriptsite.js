function Enviarcor(){
var node = "<strong>¡Su correo ha sido enviado con exito!!</strong><button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>";
//document.getElementById("myList1").appendChild(node);

var url = 'https://api.paguetodo.com/demo/deeglev2/ccr_website_email';
if (document.getElementById('name') != null) {var nombre = document.getElementById('name').value;}
if (document.getElementById('mail') != null) {var email = document.getElementById('mail').value;}
if (document.getElementById('subject') != null) {var asunto = document.getElementById('subject').value;}
if (document.getElementById('message') != null) {var mensaje = document.getElementById('message').value;}
var data = {
	 nombre : nombre,
     email : email,
     asunto : asunto,
     mensaje : mensaje };

fetch(url, {
  method: 'POST', // or 'PUT'
  body: JSON.stringify(data), // data can be `string` or {object}!
  headers:{
    'Content-Type': 'application/json'
  }
}).then(alert("aqi"))
.catch(document.getElementById('eerror').style.display = 'block');
}