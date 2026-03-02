let user_type = document.querySelector('h6').textContent.trim();


let id_str = `operazioni_${user_type}`;
let other_ops = document.querySelector(`#${id_str}`);
other_ops.classList.remove('reserved');
let listen_valid = true;

if(listen_valid){
   let ops_btns = document.querySelectorAll('button');
   ops_btns.forEach(btn =>{
    btn.addEventListener('click',()=>{
        let op_name =btn.getAttribute('id');
        if(op_name =='Viste'){
            location.replace('viste.php');
        }
        location.replace(`${user_type}/${op_name}.php`);
    })

   })
}
