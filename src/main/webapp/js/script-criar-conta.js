// Start fresh visits with both consent options unchecked; preserve state on browser Back.
window.addEventListener('pageshow', (event) => {
    if (event.persisted) return;
    document.querySelectorAll('#lembrar-mim, #aceita-termos').forEach((checkbox) => {
        checkbox.checked = false;
    });
});

document.addEventListener('DOMContentLoaded', () => {
    // Set up the password visibility control and live strength feedback.
    const botaoOlho = document.getElementById('botaoOlho');
    const inputSenha = document.getElementById('senha');
    const iconeOlho = document.getElementById('iconeOlho');

    botaoOlho?.addEventListener('click', () => {
        const mostrar = inputSenha.type === 'password';
        inputSenha.type = mostrar ? 'text' : 'password';
        const contexto = window.deltaContextPath || '';
        iconeOlho.src = `${contexto}/imagens/${mostrar ? 'olho-aberto.svg' : 'olho-fechado.svg'}`;
        // The button already has an accessible name; keep the decorative image silent.
        iconeOlho.alt = '';
    });

    if (!inputSenha) return;

    const regrasSenha = {
        tamanho: (valor) => valor.length >= 8,
        letras: (valor) => /[a-z]/.test(valor) && /[A-Z]/.test(valor),
        'numero-simbolo': (valor) => /\d/.test(valor) && /[^A-Za-z\d]/.test(valor)
    };

    function atualizarRegrasSenha() {
        document.querySelectorAll('.regras-senha [data-regra]').forEach((item) => {
            const regra = regrasSenha[item.dataset.regra];
            const atendida = Boolean(inputSenha.value && regra && regra(inputSenha.value));
            item.classList.toggle('atendido', atendida);
            item.setAttribute('aria-checked', String(atendida));
        });
    }

    inputSenha.addEventListener('input', atualizarRegrasSenha);
    atualizarRegrasSenha();

});
