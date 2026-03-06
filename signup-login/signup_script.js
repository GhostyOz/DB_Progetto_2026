let form_plate;

function cambiaForm(utent_tipo) {
    // Remove CV fields if they exist
    let cv_existing = document.querySelector('#cv_input');
    let cv_label_existing = document.querySelector('#cv_label');
    if (cv_existing) cv_existing.remove();
    if (cv_label_existing) cv_label_existing.remove();

    if (utent_tipo === 'sel') {
        form_plate.classList.add('wait');
        return;
    }

    form_plate.classList.remove('wait');

    if (utent_tipo === 'Responsabile') {
        const sign_btn = document.querySelector('#sign');

        const cv_label = document.createElement('label');
        cv_label.textContent = 'Scegli il file che contiene CV. Deve essere un PDF!!';
        cv_label.setAttribute("id", "cv_label");

        const cv_in = document.createElement('input');
        cv_in.setAttribute('type', 'file');
        cv_in.setAttribute('id', 'cv_input');
        cv_in.setAttribute('name', 'cv');
        cv_in.setAttribute('accept', '.pdf');

        // Insert before the submit button, not at the end
        form_plate.insertBefore(cv_label, sign_btn);
        form_plate.insertBefore(cv_in, sign_btn);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    form_plate = document.querySelector('#personalized_signup');

    const new_mail_btn = document.querySelector('#nuovo_mail');
    new_mail_btn.addEventListener('click', () => {
        new_mail_btn.remove();
        const nuovo_campo = document.createElement('input');
        nuovo_campo.setAttribute('type', 'email');
        nuovo_campo.setAttribute('name', 'mail[]');
        const email_text = document.querySelector('#mail_label');
        email_text.textContent = 'Scrivi altro email nel campo apparso';
        form_plate.appendChild(nuovo_campo);
        form_plate.appendChild(new_mail_btn);
    });
});
