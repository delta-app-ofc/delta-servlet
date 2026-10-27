document.addEventListener('DOMContentLoaded', () => {
    const botaoOlho = document.getElementById('botaoOlho');
    const inputSenha = document.getElementById('senha');
    const iconeOlho = document.getElementById('iconeOlho');
    const mensagemSenha = document.getElementById('mensagemSenha');
    const formCadastro = document.getElementById('form-cadastro');

    if (!botaoOlho || !inputSenha || !iconeOlho || !mensagemSenha || !formCadastro) return;

    botaoOlho.addEventListener('click',()=>{
        if(inputSenha.type === 'password'){
            inputSenha.type = 'text';
            iconeOlho.src = `${window.deltaContextPath}/imagens/olho-aberto.svg`;
            iconeOlho.alt = 'Ocultar senha';
        }else{
            inputSenha.type = 'password';
            iconeOlho.src = `${window.deltaContextPath}/imagens/olho-fechado.svg`;
            iconeOlho.alt = 'Mostrar senha';
        }
    })
    
 
    const regexSenha =  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s])\S{8,72}$/
 
    inputSenha.addEventListener('input', () => {
 
        const senha = inputSenha.value;
 
        if (senha === '') {
 
            mensagemSenha.textContent = '';
 
        } else if (regexSenha.test(senha)) {
 
            mensagemSenha.textContent = 'Senha válida!';
            mensagemSenha.style.color = 'green';
 
        } else {
 
            mensagemSenha.textContent =
                'Mínimo de 8 caracteres, 1 letra maiúscula, 1 letra minúscula, 1 número e 1 caractere especial.';
        }
    });
 
    formCadastro.addEventListener('submit', (event) => {
 
        const senha = inputSenha.value;
 
        if (!regexSenha.test(senha)) {
 
            event.preventDefault();
 
            mensagemSenha.textContent =
                'Senha inválida. Verifique os requisitos';
 
            mensagemSenha.style.color = 'red';
            inputSenha.focus();
 
            return;
        }
        console.log('Senha válida! Cadastro permitido.');
    });
});
