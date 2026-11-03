// Documentação do arquivo: controla as interações da página no navegador.
(() => {
    const namePattern = /^(?=.{2,100}$)\p{Lu}[\p{L}]*(?:[ '\-][\p{L}]+)*$/u;
    const emailPattern = /^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$/;
    const phonePattern = /^(?:[0-9]{10,15}|\+[0-9]{10,14})$/;
    const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9_\t\n\v\f\r ])[^\t\n\v\f\r ]{8,72}$/;

    // Função: is Valid Date; agrupa a lógica desta operação da interface.
    function isValidDate(value) {
        if (!/^\d{4}-\d{2}-\d{2}$/.test(value || '')) return false;
        const [year, month, day] = value.split('-').map(Number);
        const date = new Date(0);
        date.setFullYear(year, month - 1, day);
        date.setHours(0, 0, 0, 0);
        return date.getFullYear() === year
            && date.getMonth() === month - 1
            && date.getDate() === day;
    }

    // Função: is Today Or Earlier; agrupa a lógica desta operação da interface.
    function isTodayOrEarlier(value) {
        if (!isValidDate(value)) return false;
        const [year, month, day] = value.split('-').map(Number);
        const date = new Date(0);
        date.setFullYear(year, month - 1, day);
        date.setHours(0, 0, 0, 0);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return date <= today;
    }

    window.deltaInputValidation = Object.freeze({
        isValidName: value => typeof value === 'string' && namePattern.test(value.trim()),
        isValidEmail: value => typeof value === 'string'
            && value.trim().length <= 100
            && emailPattern.test(value.trim()),
        isValidPhone: value => typeof value === 'string' && phonePattern.test(value),
        isValidPassword: value => typeof value === 'string' && passwordPattern.test(value),
        isValidDate,
        isTodayOrEarlier
    });
})();
