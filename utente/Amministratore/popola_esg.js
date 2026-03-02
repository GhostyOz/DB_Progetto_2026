select= document.querySelector('#type_indicatore');
select.addEventListener('change',()=>{
    document.querySelector('#ambientale').classList.add('reserved');
    document.querySelector('#sociale').classList.add('reserved');
    if(select.value == 'Ambientale') {
        document.querySelector('#ambientale').classList.remove('reserved');
    } else if(select.value == 'Sociale') {
        document.querySelector('#sociale').classList.remove('reserved');
    }
});


