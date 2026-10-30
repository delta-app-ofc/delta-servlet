document.addEventListener('DOMContentLoaded', () => {
    const button = document.getElementById('botaoOlho');
    const password = document.getElementById('senha');
    const eye = document.getElementById('iconeOlho');
    const passwordMessage = document.getElementById('mensagemSenha');
    const form = document.getElementById('form-cadastro');
    const name = document.getElementById('nome');
    const email = document.getElementById('email');
    const contextPath = window.deltaContextPath || '';
    const validation = window.deltaInputValidation;

    button.addEventListener('click', () => {
        const show = password.type === 'password';
        password.type = show ? 'text' : 'password';
        eye.src = contextPath + (show ? '/imagens/olho-aberto.svg' : '/imagens/olho-fechado.svg');
        eye.alt = show ? 'Ocultar senha' : 'Mostrar senha';
        button.setAttribute('aria-pressed', String(show));
    });

    [name, email, password].forEach(input => {
        input.addEventListener('input', () => input.setCustomValidity(''));
    });

    password.addEventListener('input', () => {
        if (!password.value) {
            passwordMessage.textContent = '';
            return;
        }
        const valid = validation.isValidPassword(password.value);
        passwordMessage.textContent = valid
            ? 'Senha válida!'
            : 'Use de 8 a 72 caracteres, com maiúscula, minúscula, número e símbolo, sem espaços.';
        passwordMessage.style.color = valid ? 'green' : 'red';
    });

    form.addEventListener('submit', event => {
        name.setCustomValidity(validation.isValidName(name.value)
            ? ''
            : 'Informe um nome de 2 a 100 letras, começando com maiúscula.');
        email.setCustomValidity(validation.isValidEmail(email.value)
            ? ''
            : 'Informe um e-mail válido.');
        password.setCustomValidity(validation.isValidPassword(password.value)
            ? ''
            : 'A senha precisa ter de 8 a 72 caracteres, maiúscula, minúscula, número e símbolo, sem espaços.');

        if (!form.reportValidity()) event.preventDefault();
    });
});
