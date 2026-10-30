document.addEventListener('DOMContentLoaded', () => {
    const contextPath = window.deltaContextPath || '';
    [
        ['botaoOlho1', 'senha-nova', 'iconeOlho1'],
        ['botaoOlho2', 'confirmar-senha', 'iconeOlho2']
    ].forEach(([botaoId, senhaId, iconeId]) => {
        const botao = document.getElementById(botaoId);
        const senha = document.getElementById(senhaId);
        const icone = document.getElementById(iconeId);

        botao.addEventListener('click', () => {
            const mostrar = senha.type === 'password';
            senha.type = mostrar ? 'text' : 'password';
            icone.src = contextPath + (mostrar
                ? '/imagens/olho-aberto.svg'
                : '/imagens/olho-fechado.svg');
            icone.alt = mostrar ? 'Ocultar senha' : 'Mostrar senha';
        });
    });

    const form = document.getElementById('form-redefinir-senha');
    if (form) {
        const password = document.getElementById('senha-nova');
        const confirmation = document.getElementById('confirmar-senha');
        const validation = window.deltaInputValidation;

        [password, confirmation].forEach(input => {
            input.addEventListener('input', () => input.setCustomValidity(''));
        });

        form.addEventListener('submit', event => {
            password.setCustomValidity(validation.isValidPassword(password.value)
                ? ''
                : 'Use de 8 a 72 caracteres, com maiúscula, minúscula, número e símbolo, sem espaços.');
            confirmation.setCustomValidity(password.value === confirmation.value
                ? ''
                : 'As senhas não coincidem.');
            if (!form.reportValidity()) event.preventDefault();
        });
    }
});
