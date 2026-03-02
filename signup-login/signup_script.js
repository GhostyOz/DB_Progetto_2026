select_utente = document.querySelector('#tipoutente');
var form_plate = document.querySelector('#personalized_signup');
select_utente.addEventListener('change',()=>{
    form_plate.classList.add('wait');
    if(select_utente.value =='Responsabile'){
        var cv_label = document.createElement('label');
        cv_label.textContent = 'Scegli il file che contiene CV. Deve essere un PDF!!'
        var cv_in = document.createElement('input');
        cv_in.type='file';
        cv_in.name = 'cv';
        cv_in.accept = '.pdf';
        form_plate.appendChild(cv_label);
        form_plate.appendChild(cv_in);
    }
    form_plate.classList.remove('wait');
});

new_mail_btn = document.querySelector('#nuovo_mail');
new_mail_btn.addEventListener('click',()=>{
    new_mail_btn.remove();
    nuovo_campo = document.createElement('input');
    nuovo_campo.setAttribute('type','email');
    nuovo_campo.setAttribute('name','mail[]');
    var email_text = document.querySelector('#mail_label');
    email_text.textContent = 'Scrivi altro email nel campo apparso';
    form_plate.appendChild(nuovo_campo);
    form_plate.appendChild(new_mail_btn);

})

