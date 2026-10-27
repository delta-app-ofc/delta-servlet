document.addEventListener('DOMContentLoaded', () => {
    const senha = document.getElementById('senha-nova');
    const confirmarSenha = document.getElementById('confirmar-senha');
    const regraSenha = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s])\S{8,72}$/;

    [
        { botao: document.getElementById('botaoOlho1'), campo: senha, icone: document.getElementById('iconeOlho1') },
        { botao: document.getElementById('botaoOlho2'), campo: confirmarSenha, icone: document.getElementById('iconeOlho2') }
    ].forEach(({ botao, campo, icone }) => {
        if (!botao || !campo || !icone) return;
        botao.addEventListener('click', () => {
            const mostrar = campo.type === 'password';
            campo.type = mostrar ? 'text' : 'password';
            icone.src = `${window.deltaContextPath}/imagens/${mostrar ? 'olho-aberto' : 'olho-fechado'}.svg`;
            botao.setAttribute('aria-label', mostrar ? 'Ocultar senha' : 'Mostrar senha');
        });
    });

    if (!senha || !confirmarSenha) return;

    const validarCampos = () => {
        senha.setCustomValidity(senha.value && !regraSenha.test(senha.value)
            ? 'Use de 8 a 72 caracteres, com letra maiúscula, minúscula, número e símbolo, sem espaços.'
            : '');
        confirmarSenha.setCustomValidity(confirmarSenha.value && confirmarSenha.value !== senha.value
            ? 'As senhas não coincidem.'
            : '');
    };

    senha.addEventListener('input', validarCampos);
    confirmarSenha.addEventListener('input', validarCampos);
});
